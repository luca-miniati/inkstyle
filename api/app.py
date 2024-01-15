import os
import io
import random
from flask import Flask, request, jsonify
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

URL = os.environ.get("SUPABASE_URL")
KEY = os.environ.get("SUPABASE_KEY")
BATCH_SIZE = 10
MAX_SAMPLES = 20
EMBEDDING_SIZE = 25088
ALPHA = 0.3
BETA = 0.3


@app.route("/api/recommendations", methods=["POST"])
def recommendations():
    user_id = str(request.json.get("user_id"))
    print("GOT USER ID: " + user_id)
    # Ratings is key/value pairs. image_url: liked
    ratings = request.json.get("ratings")
    print(f"GOT RATINGS: {ratings}")
    ratings_image_urls = {*list(ratings.keys())} if ratings else set()

    supabase = create_client(URL, KEY)

    # TODO: GET LIMIT FROM SUPABASE SOMEHOW
    # Fetch user embedding bucket
    try:
        user_embedding_bytes = supabase.storage.from_('user_embeddings') \
            .download(f'embeddings/{user_id}.npy')
        user_embedding_buffer = io.BytesIO(user_embedding_bytes)
        user_embedding_buffer.seek(0)
        user_embedding = np.load(user_embedding_buffer)
    # If there is no user_embedding on supabase, there will be a StorageError
    except Exception as e:
        print(e)
        # Set initial embedding to zeros
        user_embedding = np.random.rand(1, EMBEDDING_SIZE)
        user_embedding_buffer = io.BytesIO()
        np.save(user_embedding_buffer, arr=user_embedding)
        val = user_embedding_buffer.getvalue()

        # Also store a new one right quick
        supabase.storage.from_("user_embeddings") \
                .upload(
                    file=val,
                    path=f"embeddings/{user_id}.npy"
                )

    # Fetch images embedding bucket, shuffle fns
    image_embeddings_bucket = supabase.storage.from_('image_embeddings') \
        .list('embeddings', {'limit': 5000})
    random.shuffle(image_embeddings_bucket)

    # I'll need to check if the new images (and their respective embeddings)
    # have been seen
    user_interactions = supabase.table('user_interactions') \
        .select("image_id, image_url, liked") \
        .eq("user_id", user_id) \
        .execute()

    # Find all seen images
    seen_images = set()
    if len(user_interactions.data) > 0:
        for user_interaction in user_interactions:
            seen_images.add(user_interaction[1])

    # Embeddings of newly-rated images
    rating_embeddings = set()
    # Ids of images to recommend to user in next batch
    recommendation_image_urls = set()

    scores = []
    image_count = 0

    # Iterate through image embedding bucket
    for item in image_embeddings_bucket:
        image_url = '.'.join(item['name'].split('.')[:-1])
        # Check if user has seen image. If they have, don't even consider
        # the image
        if image_url not in seen_images:
            # Download blob
            embedding_bytes = supabase.storage.from_('image_embeddings') \
                    .download(f'embeddings_v2/{image_url}.npy')
            embedding_buffer = io.BytesIO(embedding_bytes)
            embedding_array = np.load(embedding_buffer)[None]
            # If this image is one that the user has rated,
            # grab the url and the blob
            if image_url in ratings_image_urls:
                print("ADDING " + image_url + " TO RATINGS")
                rating_embeddings.add(
                    (image_url, ratings[image_url], embedding_array)
                )
            else:
                # Increment count
                image_count += 1
                if image_count > MAX_SAMPLES:
                    break
                # Otherwise, check if we have enough images
                if len(recommendation_image_urls) < BATCH_SIZE:
                    # Remember, the user embedding might be zeros
                    if np.all(user_embedding == 0):
                        # We don't have an embedding yet,
                        # so just yolo the image
                        print("YOLOING IMAGE: " + item['name'])
                        recommendation_image_urls.add(item['name'])
                    else:
                        # TODO: Calculate cosine similarities,
                        similarity = cosine_similarity(
                                user_embedding, embedding_array
                                ).mean()
                        scores.append((image_url, similarity))

    # If ratings is not empty, update user embedding and interactions
    if ratings:
        for _, liked, blob in rating_embeddings:
            if liked:
                user_embedding = user_embedding + blob * ALPHA
            else:
                user_embedding = user_embedding - blob * ALPHA

        updated_user_embedding_bytes = io.BytesIO()
        np.save(updated_user_embedding_bytes, user_embedding)
        content_bytes = updated_user_embedding_bytes.getvalue()

        supabase.storage.from_("user_embeddings") \
                .update(
                    file=content_bytes,
                    path=f"embeddings/{user_id}.npy"
                )
        interactions = [
            {
                "user_id": user_id,
                "image_url": rating_image_url,
                "liked": liked,
            }
            for rating_image_url, liked, _ in rating_embeddings]
        supabase.table("user_interactions").insert(interactions).execute()

    return jsonify(
        sorted(scores, key=lambda x: x[1], reverse=True)[:BATCH_SIZE]
    )


if __name__ == "__main__":
    app.run(debug=True)
