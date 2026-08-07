from pathlib import Path
from PIL import Image

# Dataset Path
DATASET_PATH = Path(__file__).resolve().parents[2] / "datasets" / "PlantVillage" / "train"

# Check if dataset exists
if not DATASET_PATH.exists():
    print("❌ Dataset Not Found!")
    exit()

print(f"📂 Dataset Path: {DATASET_PATH}\n")

total_images = 0
corrupted_images = 0

# Loop through all class folders
for class_folder in sorted(DATASET_PATH.iterdir()):

    if class_folder.is_dir():

        print(f"📁 Checking: {class_folder.name}")

        for image_file in class_folder.iterdir():

            if image_file.is_file():

                try:
                    with Image.open(image_file) as img:
                        img.verify()

                    total_images += 1

                except Exception as e:
                    corrupted_images += 1

                    print("\n❌ Corrupted Image Found")
                    print(f"Path  : {image_file}")
                    print(f"Error : {e}\n")


print("\n===================================")
print("      DATASET VALIDATION REPORT")
print("===================================")

print(f"✅ Total Images Checked : {total_images}")
print(f"❌ Corrupted Images     : {corrupted_images}")

if corrupted_images == 0:
    print("\n🎉 Dataset is Clean!")
else:
    print("\n⚠️ Please remove or replace corrupted images.")