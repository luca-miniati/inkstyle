import os
import glob

def recursive_dict_len(obj):
    if isinstance(obj, dict):
        return sum(recursive_len(v) for v in obj.values())
    elif isinstance(obj, list):
        return len(obj)
    else:
        raise TypeError("What the hell did you pass for `tattoo_accounts`!? I got something that's not a list or dict")

class TattooImageFiles:
    def __init__(self, dataset_path, args=None):
        self.dataset_path = dataset_path
        if "downloaded" in self.dataset_path:
            if args:
                if hasattr(args, "style"):
                    self.style = args.style 
                else:
                    self.style = None
                if hasattr(args, "account"):
                    self.account = args.account 
                else:
                    self.account = None
            else:
                self.style = None
                self.account = None
            self.configure()
        elif "cleaned" in self.dataset_path:
            self.fns = list(glob.glob("images/cleaned/_/*"))

    def configure(self):
        if self.style:
            self.styles = [self.style]
        else:
            self.styles = list(map(lambda style_fn: style_fn.split("/")[-1], glob.glob(f"{self.dataset_path}/*")))

        if len(self.styles) == 0:
            raise ValueError("`dataset_path` returned no style folders")
        
        self.accounts = set()
        self.styles_to_accounts = dict()

        self.images = list()
        self.accounts_to_images = dict()

        for style in self.styles:
            if self.account:
                accounts = [self.account]
            else:
                accounts = list(map(
                    lambda account_fn: account_fn.split("/")[-1],
                    glob.glob(f"{self.dataset_path}/{style}/*")
                ))

            self.accounts.update(accounts)
            self.styles_to_accounts[style] = accounts

            for account in accounts:
                images = list(map(
                    lambda image_fn: image_fn.split("/")[-1],
                    glob.glob(f"{self.dataset_path}/{style}/{account}/*")
                ))
                self.images.extend(images)
                self.accounts_to_images[account] = images
   
    def status(self):
        format_args = [
            len(self.images),
            "\n".join([
                f"{style}: {sum(len(self.accounts_to_images[account]) for account in accounts)}"
                for style, accounts in self.styles_to_accounts.items()
            ])
        ]
        format_str = """
Tattoo Image Files
------------------

Total Images: {}

Styles 
------
{}

        """

        print(format_str.format(*format_args))

    def add_accounts(self):
        from scrape import tattoo_accounts, scrape_images
        
        _tattoo_accounts = {
            style: list(set(accounts) - self.accounts)
            for style, accounts in tattoo_accounts.items()
        }

        scrape_images(_tattoo_accounts)
        self.configure()
        self.status()

    def clean(self):
        for style in self.styles:
            for account in self.styles_to_accounts[style]: 
                if len(self.accounts_to_images[account]) == 0:
                    print(f"Deleting account {account}")
                    os.rmdir(f"{self.dataset_path}/{style}/{account}")
                for image in self.accounts_to_images[account]:
                    if image.split(".")[-1] not in ["jpg", "png"]:
                        os.remove(f"{self.dataset_path}/{style}/{account}/{image}")
                        print(f"""Deleted "{image}" """)
        self.configure()
        self.status()

    def get_all_images(self):
        images = []
        for style in self.styles:
            for account in self.styles_to_accounts[style]: 
                for image in self.accounts_to_images[account]:
                    images.append(f"{self.dataset_path}/{style}/{account}/{image}")
        return images

    def get_image_data(self, image_fn):
        return {
            "style": image_fn.split("/")[1], 
            "account": image_fn.split("/")[2]
        }
    
    def delete_images(self, images):
        count = 0 
        for image in images:
            os.rename(image, f"""removed/{image.split("/")[-1]}""")
            print(f"""Deleted "{image}" """)
            count += 1

        print(f"Deleted {count} images")

        self.configure()

    def rename_and_move_images(self, to_path):
        # DANGEROUS CODE, PLEASE FIX BEFORE THIS FUNCTION IS EVER CALLED
        accounts_to_counts = {key: 0 for key in self.accounts}
        for image in self.get_all_images():
            os.rename(image, f"""{to_path}/{image.split("/")[-2]}_{accounts_to_counts[image.split("/")[-2]]}""")
            accounts_to_counts[image.split("/")[-2]] += 1

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

if __name__ == "__main__":
    t = TattooImageFiles("images/downloaded")
    t.status()
