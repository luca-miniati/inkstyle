import os
import pygame
from pygame.locals import QUIT, KEYDOWN, K_RIGHT, K_DOWN
from PIL import Image

class ImageReviewApp:
    def __init__(self):
        pygame.init()

        self.image_folder_path = ""
        self.image_list = []
        self.marked_images = []
        self.current_index = 0

        self.load_images()

        self.screen = pygame.display.set_mode((800, 600))
        pygame.display.set_caption("Image Review App")

        self.clock = pygame.time.Clock()

        self.font = pygame.font.Font(None, 36)
        self.load_images()

    def load_images(self):
        self.image_folder_path = "your_image_folder_path"
        if self.image_folder_path:
            self.image_list = [f for f in os.listdir(self.image_folder_path) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]

    def show_next_image(self):
        if self.image_list:
            image_path = os.path.join(self.image_folder_path, self.image_list[self.current_index])
            original_image = Image.open(image_path)

            # Calculate the scaled size while maintaining aspect ratio
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

            # Resize the image
            image = original_image.resize((new_width, new_height))

            # Calculate the position to center the image on the screen
            x = (base_width - new_width) // 2
            y = (base_height - new_height) // 2

            pygame_image = pygame.image.fromstring(image.tobytes(), image.size, image.mode)
            self.screen.fill((255, 255, 255))  # Fill the screen with white
            self.screen.blit(pygame_image, (x, y))

            self.current_index = (self.current_index + 1) % len(self.image_list)

    def mark(self):
        if self.image_list:
            self.marked_images.append(self.image_list[self.current_index])

    def main_loop(self):
        running = True
        while running:
            for event in pygame.event.get():
                if event.type == QUIT:
                    running = False
                elif event.type == KEYDOWN:
                    if event.key == K_RIGHT:
                        self.show_next_image()
                    elif event.key == K_DOWN:
                        self.mark()

            pygame.display.flip()
            self.clock.tick(60)

        pygame.quit()

if __name__ == "__main__":
    app = ImageReviewApp()
    app.main_loop()
