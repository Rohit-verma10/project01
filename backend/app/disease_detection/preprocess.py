from pathlib import Path
from PIL import Image
import numpy as np

# Resized Images Folder
IMAGE_PATH = Path(__file__).resolve().parents[2] / "outputs" / "resized_images"

image_extensions = (".jpg", ".jpeg", ".png")

processed = 0

for class_folder in IMAGE_PATH.iterdir():

    if class_folder.is_dir():

        for image_file in class_folder.iterdir():

            if image_file.suffix.lower() in image_extensions:

                img = Image.open(image_file)

                # RGB Convert
                img = img.convert("RGB")

                # NumPy Array
                img = np.array(img)

                # Normalize (0-255 → 0-1)
                img = img / 255.0

                processed += 1

print("=" * 40)
print("IMAGE PREPROCESS REPORT")
print("=" * 40)
print(f"✅ Images Processed : {processed}")
print("✅ RGB Conversion : Done")
print("✅ Normalization : Done")