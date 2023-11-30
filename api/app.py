from flask import Flask, jsonify
import torch
from torchvision.models import vgg16 
from torchvision.models import VGG16_Weights
import sqlite3
from data import TattooImageDataset, save_images
# from embed import get_images, get_all_images

app = Flask(__name__)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

weights = VGG16_Weights.IMAGENET1K_FEATURES
preprocess = weights.transforms()

model = vgg16(weights=weights).features.to(device)
model = torch.nn.Sequential(model, torch.nn.Flatten())
model.eval()

conn = sqlite3.connect("images.db")
cursor = conn.cursor()

save_images("images/cleaned/_", conn, cursor)
# @app.route("/api/hello", methods=["GET"])
# def hello():
#     return jsonify(message="Hello, welcome to your Flask API!")
#
# if __name__ == "__main__":
#     app.run(debug=True)
