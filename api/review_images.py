import os
import pygame
from PIL import Image
from scrape import TattooImageFiles
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-s", "--style")
parser.add_argument("-a", "--account")
args = parser.parse_args()

class ImageReviewApp:
    def __init__(self, dataset_path, args=None):
        pygame.init()

        self.dataset_path = dataset_path
        self.images = []
        self.marked_images = []
        self.current_index = -1

        self.screen = pygame.display.set_mode((800, 600))
        pygame.display.set_caption("Image Review App")

        self.clock = pygame.time.Clock()

        self.font = pygame.font.Font(None, 36)
        self.tattoo_image_files = TattooImageFiles(self.dataset_path, args)
        self.load_images()

    def load_images(self):
        self.images = self.tattoo_image_files.get_all_images()

    def show_next_image(self):
        self.current_index += 1
        if self.current_index > len(self.images) - 1:
            print("No more images")
            self.current_index -= 1
        image_path = self.images[self.current_index]
        self.show_image(image_path)

    def show_prev_image(self):
        self.current_index -= 1
        if self.current_index < 0: 
            self.current_index += 1
        image_path = self.images[self.current_index]
        self.show_image(image_path)

    def show_image(self, image_path):
        original_image = Image.open(image_path)

        base_width = 800
        base_height = 600

        width_percent = base_width / float(original_image.size[0])
        height_percent = base_height / float(original_image.size[1])

        if width_percent < height_percent:
            new_width = base_width
            new_height = int(float(original_image.size[1]) * float(width_percent))
        else:
            new_width = int(float(original_image.size[0]) * float(height_percent))
            new_height = base_height

        image = original_image.resize((new_width, new_height))

        x = (base_width - new_width) // 2
        y = (base_height - new_height) // 2

        pygame_image = pygame.image.fromstring(image.tobytes(), image.size, image.mode)
        self.screen.fill((255, 255, 255))
        self.screen.blit(pygame_image, (x, y))
        image_data = self.tattoo_image_files.get_image_data(image_path)
        print(f"""
{"*" + "-" * 15 + "*"}
Style: {image_data["style"]}
Account: {image_data["account"]} [{self.tattoo_image_files.styles_to_accounts[image_data["style"]].index(image_data["account"])+1}/{len(self.tattoo_image_files.styles_to_accounts[image_data["style"]])}]
Image: [{self.tattoo_image_files.accounts_to_images[image_data["account"]].index(image_path.split("/")[-1])+1}/{len(self.tattoo_image_files.accounts_to_images[image_data["account"]])}]
{"MARKED" if image_path in self.marked_images else ""}
""")

    def mark(self):
        if self.images[self.current_index] not in self.marked_images:
            self.marked_images.append(self.images[self.current_index])

    def status(self):
        self.tattoo_image_files.status()

    def main_loop(self):
        running = True
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_RIGHT:
                        self.show_next_image()
                    elif event.key == pygame.K_LEFT:
                        self.show_prev_image()
                    elif event.key == pygame.K_DOWN:
                        self.mark()
                        self.show_next_image()
                    elif event.key == pygame.K_RETURN:
                        self.tattoo_image_files.delete_images(self.marked_images)
                        self.marked_images = []
                    elif event.key == pygame.K_UP:
                        if self.images[self.current_index] in self.marked_images:
                            self.marked_images.remove(self.images[self.current_index])
                        self.show_next_image()
    
            pygame.display.flip()
            self.clock.tick(60)

        pygame.quit()

if __name__ == "__main__":
    app = ImageReviewApp("images", args)
    app.main_loop()

