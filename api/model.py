import torch
from torchvision.models import vgg16
from torchvision.models import VGG16_Weights


def get_model(device):
    weights = VGG16_Weights.IMAGENET1K_FEATURES
    preprocess = weights.transforms()
    model = vgg16(weights=weights).features.to(device)
    model = torch.nn.Sequential(model, torch.nn.Flatten())
    model.eval()

    return model, weights, preprocess
