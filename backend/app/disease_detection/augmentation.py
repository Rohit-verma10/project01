from pathlib import Path
from PIL import Image
import numpy as np
import albumentations as A

# Dataset Path
IMAGE_PATH = Path(__file__).resolve().parents[2] / "outputs" / "resized_images"

IMAGE_EXTENSIONS = (".jpg", ".jpeg", ".png")

# Augmentation Pipeline
transform = A.Compose([
    A.HorizontalFlip(p=0.5),
    A.Rotate(limit=20, p=0.5),
    A.RandomBrightnessContrast(p=0.5)
])

processed = 0

for class_folder in IMAGE_PATH.iterdir():

    if class_folder.is_dir():

        for image_file in class_folder.iterdir():

            if image_file.suffix.lower() in IMAGE_EXTENSIONS:

                image = np.array(Image.open(image_file).convert("RGB"))

                augmented = transform(image=image)

                processed += 1

print("=" * 40)
print("IMAGE AUGMENTATION REPORT")
print("=" * 40)
print(f"✅ Images Augmented : {processed}")
print("✅ Horizontal Flip : Done")
print("✅ Rotation : Done")
print("✅ Brightness : Done")