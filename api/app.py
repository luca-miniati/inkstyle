import os
import random
from flask import Flask, jsonify, send_file, request
from io import BytesIO
import sqlite3
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

URL = os.environ.get("SUPABASE_URL")
KEY = os.environ.get("SUPABASE_KEY")
BATCH_SIZE = 10
NUM_SAMPLES = 20


@app.route("/api/images", methods=["GET"])
def get_images():
    conn = sqlite3.connect("images.db")
    cursor = conn.cursor()

    limit = int(request.args.get("limit", default=10))
    offset = int(request.args.get("offset", default=0))

    cursor.execute(
        "SELECT id, image_fn FROM images LIMIT ? OFFSET ?",
        (limit, offset)
    )

    image_data = cursor.fetchall()
    image_data = [
        {"id": id, "image_fn": image_fn} for id, image_fn in image_data
    ]

    conn.close()

    return jsonify({
        "images": image_data,
        "pagination": {
            "limit": limit,
            "offset": offset,
            "total": len(image_data)
        }
    })


@app.route("/api/images/<int:image_id>/data", methods=["GET"])
def get_image_data(image_id):
    conn = sqlite3.connect("images.db")
    cursor = conn.cursor()

    cursor.execute("SELECT image_bytes FROM images WHERE id = ?", (image_id,))
    image = cursor.fetchone()[0]

    conn.close()

    if image:
        return send_file(BytesIO(image), mimetype="image/png")
    else:
        return jsonify({"error": f"Image with id: {image_id} not found"}), 404


@app.route("/api/recommendations", methods=["GET"])
def get_recommendations():
    # this will be a string, still need to split on something
    selected_fns = set(request.get_data("selected_fns"))

    conn = sqlite3.connect("embeddings.db")
    cursor = conn.cursor()

    cursor.execute("SELECT image_fn, embedding FROM embeddings")
    embeddings = cursor.fetchall()

    conn.close()

    selected_embeddings = set(map(
        np.array,
        [
            embedding
            for image_fn, embedding in embeddings
            if image_fn in selected_fns
        ]
    ))
    similarity_scores = {}

    for image_fn, embedding in set(embeddings) - selected_embeddings:
        embedding = np.frombuffer(embedding)
        similarity_score = np.vectorize(cosine_similarity)(
            selected_embeddings, embedding
        ).mean()

        similarity_scores[image_fn] = similarity_score

    sorted_fns = sorted(
        similarity_scores,
        key=lambda x: similarity_scores[x],
        reverse=True
    )

    return jsonify(sorted_fns)[:10]

# # TODO: GET LIMIT FROM SUPABASE SOMEHOW
#     image_embeddings = filter(
#             lambda x: x['name'] in ratings,
#             supabase.storage.get_bucket('image_embeddings')
#             .list('embeddings', {'limit': 5000})
#             )


@app.route("/api/recommendations", methods=["POST"])
def recommendations():
    user_id = request.get_data("user_id")
    ratings = request.get_data("ratings")

    supabase = create_client(URL, KEY)

    # TODO: GET LIMIT FROM SUPABASE SOMEHOW
    # Fetch user embedding bucket, image embedding bucket
    user_bucket = supabase.storage.from_('user_embeddings') \
        .list('embeddings', {'search': user_id, 'limit': 5000})
    if len(user_bucket) > 0:
        user_embedding = user_bucket[0]
    else:
        user_embedding = None

    image_embeddings_bucket = supabase.storage.from_('image_embeddings') \
        .list('embeddings', {'limit': 5000})
    random.shuffle(image_embeddings_bucket)

    # I'll need to check if the new images (and their respective embeddings)
    # have been seen
    user_interactions = supabase.table('user_interactions') \
        .select("image_url") \
        .eq("user_id", user_id) \
        .execute()

    # Embeddings of newly-rated images
    rating_embeddings = set()
    # Ids of images to recommend to user in next batch
    image_urls = set()

    # Iterate through image embedding bucket
    for item in image_embeddings_bucket:
        image_url = item['name']
        # Download blob
        blob = image_embeddings_bucket.download(f'embeddings/{image_url}')
        if image_url in ratings:
            rating_embeddings.add(blob)
        # Otherwise, check if we have enough images
        elif len(image_urls) < BATCH_SIZE:
            # Check if user has seen image. If they have, don't even consider
            # the image
            if image_url not in user_interactions:
                # Remember, the user embedding might be None
                if user_embedding:
                    # DO THE COSINE THING
                    pass
                else:
                    # We don't have an embedding yet, so just yolo the image
                    image_urls.add(item['name'])

    # TODO: If ratings is not empty, update user embedding

    return image_urls


if __name__ == "__main__":
    app.run(debug=True)
