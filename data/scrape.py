import subprocess
import glob
import os

tattoo_accounts = {
    # "traditional": [
    #     "lacroixtat2",
    #     "chrisastrologo",
    #     "xpiranhaxyz",
    #     "nickstrongtattoos",
    #     "bara_madrid",
    #     "trash.fires",
    #     "klem_diglio",
    #     "franzstefanik",
    #     "benlickspaint",
    #     "dan_gagne",
    #     "danielescafati",
    #     "jordan_war",
    #     "cristianramos_tattoo",
    #     "danielescafati",
    # ],
    # "japanese": [
    #     "henning_royaltattoo",
    #     "zumiism",
    #     "jeon_kyoung_jin_",
    #     "lilb_japan",
    #     "horikyojapan",
    #     "yintattoo1414",
    #     "doryu_san",
    #     "_freddyleo",
    #     "horiken_shibuya",
    #     "yintattoo1414",
    #     "horichiro_",
    #     "nyx_tattoo",
    #     "robadmiraaltattoo",
    #     "urojiya",
    #     "diaozuo",
    #     "80tattoozq",
    # ],
    # "neo_traditional": [
    #     "gc_tats",
    #     "joshwaatattoo",
    #     "kike.esteras",
    #     "levimurphyart",
    #     "tattoosbyalisha",
    #     "kellyc_tattoos",
    #     "ericbrunningtattoos",
    #     "allday_jina",
    #     "matteo_leozappa",
    #     "andres_navaz_",
    #     "veness_tattoo",
    #     "ickabrams",
    #     "defaze",
    #     "benoztattoos",
    #     "jayb_tattoo",
    #     "alliealreadytattoo",
    # ],
    # "new_school": [
    #     "klark_tattoo",
    #     "lehelperspektiv",
    #     "benat.gonzalez.tattoo",
    #     "joshhermantattoo",
    #     "matty_roughneck",
    #     "hornet.eds",
    #     "graveyard__ink",
    #     "podorovsky_tattoo",
    #     "seangardnerisawesome",
    #     "allisintattoos",
    #     "amirhusky",
    #     "alex_d_tattoo",
    #     "paolotattoo",
    #     "jamieris",
    #     "gashev_tattoo",
    #     "closetattoo",
    # ],
    # "blackwork": [
    #     "kras_tattoo",
    #     "konradkrajdaart",
    #     "thedansal",
    #     "taesin___",
    #     "delphinmusquet",
    #     "sadgirltattoo",
    #     "luciodizazzo_trevor_ink_tattoo",
    #     "johnnyfleshtattoo",
    #     "snuka.tattoo",
    #     "neo_tattoo",
    #     "thedarkestwork",
    #     "sirvine_tattoo",
    #     "steph.guillotine",
    #     "h0lycrap",
    #     "lauraknoxtattoo",
    #     "blackbunny.ink",
    # ],
    # "engraving": [
    #     "5.5volt_tattoo",
    #     "maic",
    #     "zengertattoo",
    #     "belkina_tattoo",
    #     "joe__murphy__tattoo",
    #     "hypnatic",
    #     "caesarbacchvs_tattoos",
    #     "alixecooper",
    #     "felipecesar.me",
    #     "andrewfoxglovetattoo",
    #     "caesarbacchvs_tattoos",
    #     "abyssicart",
    #     "charly.ttt",
    #     "cesarescanoart",
    #     "seppe_lights",
    # ],
    "cybersigilism": [
        "chainsmaiden",
        "oyasumi.tto",
        "spuskovik.tattoo",
        "firekeep3r",
        "lifeislxxsang",
        "_vohmitatt_",
        "cisne.soluble",
        "inkbyptp",
        "tatt_karma",
        "thirty_nin",
        "ultralightwav",
        "mx_sft_",
        "k.white_tatts",
        "hearts.with.wings",
    ],
    "realism": [
        "ivanmorant_tattoo",
        "ivancasabo",
        "inglourious_hoko",
        "carolinacaosavalle",
        "pol_art",
        "_m4rchi_",
        "mihail_kogut",
        "juandegambintattoo",
        "ezequielsamuraii",
        "harrison_tattoo",
        "thomascarlijarlier",
        "aukextattooer",
        "gody_tattoo",
        "_honart_",
        "maddog_tattoos",
        "castillo.dario",
    ]
}

# os.makedirs("images")
os.chdir("images")

total_num_images = 0
style_num_images = {}

for style in tattoo_accounts.keys():
    os.makedirs(style)
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
