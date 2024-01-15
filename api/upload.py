import os
from dotenv import load_dotenv
from supabase import create_client


def get_images(bucket):
    images = []
    # Placeholder for images
    images_temp = [{'name': ''}] * 100
    offset = 0

    # Fetch images until it gets a duplicate image
    while len(images_temp) == 100:
        images_temp = bucket.list('images', {'offset': offset})

        offset += len(images_temp)
        images += images_temp

    return images


def get_images_data(images):
    images_data = []

    for image in images:
        image_url = image['name']
        account = '_'.join(image_url.split('_')[:-1])

        images_data.append({
            'image_url': image_url,
            'account': account,
        })

    return images_data


def upload_images(images_data, table):
    for image_data in images_data:
        if len(table.select("*")
               .eq("image_url", image_data['image_url'])
               .execute()
               .data) == 0:
            table.insert(image_data).execute()


load_dotenv()

url = os.environ.get("SUPABASE_URL")
key = os.environ.get("SUPABASE_KEY")

supabase = create_client(url, key)

images_bucket = supabase.storage.get_bucket('images')
images_table = supabase.table('images')

images = get_images(images_bucket)
images_data = get_images_data(images)
upload_images(images_data, images_table)
