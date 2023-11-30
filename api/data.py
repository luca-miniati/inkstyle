import sqlite3
from torchvision.datasets import ImageFolder
import glob

class TattooImageDataset(ImageFolder):
    def __getitem__(self, index):
        path, target = self.samples[index]
        sample = self.loader(path)
        if self.transform is not None:
            sample = self.transform(sample)
        if self.target_transform is not None:
            target = self.target_transform(target)

        return sample, path

def save_images(root, conn, cursor):
    for fn in glob.glob(f"{root}/*"):
        print("writing: " + fn.split("/")[-1])
        with open(fn, "rb") as f:
            image_bytes = f.read()
        image_fn = fn.split("/")[-1]

        cursor.execute("INSERT INTO images (image_fn, image_bytes) VALUES (?, ?)", (image_fn, image_bytes))
    conn.commit()
