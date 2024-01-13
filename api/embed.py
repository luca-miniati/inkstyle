import os
import glob
import numpy as np
from supabase import create_client
from dotenv import load_dotenv
import sqlite3

load_dotenv()

URL = os.environ.get("SUPABASE_URL")
KEY = os.environ.get("SUPABASE_KEY")


def embed_images(dataset, model, device, conn, cursor):
    for image, image_path in dataset:
        out = model(image.to(device))
        out = out.reshape(-1).cpu().detach().numpy().tobytes()
        image_fn = image_path.split("/")[-1]
        cursor.execute(
            "INSERT INTO embeddings (image_fn, embedding) VALUES (?, ?)",
            (image_fn, out)
        )
    conn.commit()


def get_embeddings(image_fns, cursor):
    cursor.execute(
        f"""SELECT * FROM embeddings WHERE image_fn IN (
            {", ".join(["?" for _ in range(len(image_fns))])}
        )""",
        (image_fns)
    )
    return cursor.fetchall()


def get_all_embeddings(cursor):
    cursor.execute(
        "SELECT * FROM embeddings"
    )
    return cursor.fetchall()


# conn = sqlite3.connect("embeddings.db")
# cursor = conn.cursor()
#
# data = cursor.execute("SELECT * FROM embeddings")
#
# os.makedirs("embeddings", exist_ok=True)
#
# for embedding_meta in data:
#     _, image_url, embedding = embedding_meta
#
#     embedding_name = image_url[:-4]
#     embedding = np.frombuffer(embedding)
#     np.save(f"embeddings/{embedding_name}", embedding)


supabase = create_client(URL, KEY)

# for filepath in glob.glob("./embeddings/*"):
#     with open(filepath, 'rb') as f:
#         supabase.storage.from_("image_embeddings").upload(
#             file=f,
#             path=filepath,
#         )
