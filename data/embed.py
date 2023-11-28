from api.app import model, preprocess, device
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

def embed_images(dataset):
    for image, image_path in dataset:
        out = model(image.to(device))
        out = out.reshape(-1).cpu().detach().numpy().tobytes()
        image_fn = image_path.split("/")[-1]
        cursor.execute("INSERT INTO embeddings (image_fn, embedding) VALUES (?, ?)", (image_fn, out))
    conn.commit()
    conn.close()

conn = sqlite3.connect("data/embeddings.db")
cursor = conn.cursor()

data_root = "data/images/cleaned/"
dataset = TattooImageDataset(root=data_root, transform=preprocess)

embed_images(dataset)

