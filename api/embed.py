from app import model, preprocess, device
from torchvision.datasets import ImageFolder
import sqlite3


class TattooImageDataset(ImageFolder):
    def __getitem__(self, index):
        path, target = self.samples[index]
        sample = self.loader(path)
        if self.transform is not None:
            sample = self.transform(sample)
        if self.target_transform is not None:
            target = self.target_transform(target)

        return sample, path

def embed_images(dataset, conn, cursor):
    for image, image_path in dataset:
        out = model(image.to(device))
        out = out.reshape(-1).cpu().detach().numpy().tobytes()
        image_fn = image_path.split("/")[-1]
        cursor.execute("INSERT INTO embeddings (image_fn, embedding) VALUES (?, ?)", (image_fn, out))
    conn.commit()

def decode_images(image_fns, cursor):
    cursor.execute(
        f"""SELECT * FROM embeddings WHERE image_fn IN ({", ".join(["?" for _ in range(len(image_fns))])})"""
    ) 
    return cursor.fetchall()

def decode_all_images(cursor):
    cursor.execute(
        "SELECT * FROM embeddings"
    ) 
    return cursor.fetchall()

# embed_images(dataset)

# image, image_path = dataset[0]
# image_fn = image_path.split("/")[-1]
#
# cursor.execute("SELECT * FROM embeddings WHERE image_fn IS (?)", (image_fn))
# res = cursor.fetchall()

