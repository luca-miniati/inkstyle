import sqlite3

def embed_images(dataset, model, device, conn, cursor):
    for image, image_path in dataset:
        out = model(image.to(device))
        out = out.reshape(-1).cpu().detach().numpy().tobytes()
        image_fn = image_path.split("/")[-1]
        cursor.execute("INSERT INTO embeddings (image_fn, embedding) VALUES (?, ?)", (image_fn, out))
    conn.commit()

def get_embeddings(image_fns, cursor):
    cursor.execute(
        f"""SELECT * FROM embeddings WHERE image_fn IN ({", ".join(["?" for _ in range(len(image_fns))])})""",
        (image_fns)
    ) 
    return cursor.fetchall()

def get_all_embeddings(cursor):
    cursor.execute(
        "SELECT * FROM embeddings"
    ) 
    return cursor.fetchall()

