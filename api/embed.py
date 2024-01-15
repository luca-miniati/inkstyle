import os
import io
import numpy as np
import torch
from supabase import create_client
from dotenv import load_dotenv
import matplotlib.pyplot as plt
from PIL import Image
from torchvision.models import vgg16
from torchvision.models import VGG16_Weights
from torchvision.transforms import ToTensor
import sqlite3
from model import get_model

load_dotenv()

URL = os.environ.get("SUPABASE_URL")
KEY = os.environ.get("SUPABASE_KEY")
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"


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

# EMBEDDING UPLOAD CODE
# model, _, preprocess = get_model("cuda")
#
# con = sqlite3.connect("images.db")
# cur = con.cursor()
#
# cur.execute("SELECT image_fn, image_bytes from images")
# res = cur.fetchall()
#
# for row in res:
#     image_url = ".".join(row[0].split(".")[:-1])
#     image_bytes = row[1]
#
#     image_buffer = io.BytesIO(image_bytes)
#     image_buffer.seek(0)
#
#     image = Image.open(image_buffer)
#     image_tensor = ToTensor()(image).to("cuda")
#
#     image_tensor = preprocess(image_tensor)
#     out = model(image_tensor)
#
#     out = out.detach().cpu().numpy()
#     out = out.flatten()
#
#     out_buffer = io.BytesIO()
#
#     np.save(out_buffer, arr=out)
#     out_buffer.seek(0)
#     val = out_buffer.getvalue()
#
#     supabase.storage.from_('image_embeddings') \
#             .upload(file=val, path=f'embeddings_v2/{image_url}.npy')

# GET EMBEDDINGS
image_embeddings_list = supabase.storage.from_('image_embeddings') \
        .list('embeddings_v2')

for image_embedding in image_embeddings_list:
    if image_embedding['metadata']['contentLength'] > 0:
        embedding_bytes = supabase.storage.from_('image_embeddings') \
                .download(f'embeddings_v2/{image_embedding["name"]}')
        embedding_buffer = io.BytesIO(embedding_bytes)
        embedding_buffer.seek(0)
        embedding_array = np.load(embedding_buffer)
        break

# embedding = embedding.reshape((112, 112))
# plt.imshow(embedding, cmap='gray')
# plt.show()
#
# for image_embedding in image_embeddings_list:
#     embedding = supabase.storage.from_('image_embeddings') \
#             .download(f'embeddings/{image_embedding["name"]}')
#     embedding = io.BytesIO(embedding)
#     embedding = np.load(embedding)
#     embedding = embedding.reshape((112, 112))
#     plt.imshow(embedding, cmap='gray')
#     plt.show()
#     break
