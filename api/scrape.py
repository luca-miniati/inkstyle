import subprocess
import glob
import os

tattoo_accounts = {
    "engraving": ["sidetattooing", "paraschos_a", "childish_like"],
    "traditional": ["vaclav_tattoo"],
    "neo_traditional": ["artesobscurae", "jonnyg123", "maradentattoo", "hugal.tattooing", "lucky.you.tattoo", "davide.mancini", "calo_____", "jackson.tattoos", "breadloaf___", "dimakorneplod"],
    "cybersigilism": ["ultralightwav"],
}

def scrape_images(tattoo_accounts):
    os.makedirs("images", exist_ok=True)
    os.chdir("images")

    total_num_images = 0
    style_num_images = {}

    for style in tattoo_accounts.keys():
        os.makedirs(style, exist_ok=True)
        os.chdir(style)

        print(style.upper())
        print("-" * len(style))

        style_num_images[style] = 0

        for account in tattoo_accounts[style]:
            instaloader_command = f"conda run -n ink instaloader {account} --no-captions --no-metadata-json --no-profile-pic >/dev/null 2>&1"
            res = os.system(instaloader_command)

            num_images = len(glob.glob(f"{account}/*"))
            style_num_images[style] += num_images
            total_num_images += num_images

            if res == 0:
                print(f"Account: {account}, {num_images} images downloaded")

        os.chdir("..")
    os.chdir("..")
    print("")
    print(
"""
Scrape complete.
Total images downloaded: {}
Images downloaded by style:
{}

""".format(
        total_num_images,
        "\n".join([f"{s}: {n}" for s, n in style_num_images.items()])
    )
    )
