from pathlib import Path
from PIL import Image

# Dataset Path
DATASET_PATH = Path(__file__).resolve().parents[2] / "datasets" / "PlantVillage" / "train"

# Output Folder
OUTPUT_PATH = Path(__file__).resolve().parents[2] / "outputs" / "resized_images"

OUTPUT_PATH.mkdir(parents=True, exist_ok=True)

IMAGE_EXTENSIONS = (".jpg", ".jpeg", ".png")

count = 0

for class_folder in DATASET_PATH.iterdir():

    if class_folder.is_dir():

        output_class = OUTPUT_PATH / class_folder.name
        output_class.mkdir(exist_ok=True)

        for image_file in class_folder.iterdir():

            if image_file.suffix.lower() in IMAGE_EXTENSIONS:

                img = Image.open(image_file)

                img = img.resize((224, 224))

                img.save(output_class / image_file.name)

                count += 1

print("=" * 40)
print("IMAGE RESIZE REPORT")
print("=" * 40)
print(f"✅ Total Resized Images : {count}")
print(f"📂 Saved To : {OUTPUT_PATH}")