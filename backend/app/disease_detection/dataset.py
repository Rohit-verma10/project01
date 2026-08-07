from pathlib import Path

DATASET_PATH = Path(__file__).resolve().parents[2] / "datasets" / "PlantVillage" / "train"

print(f"Dataset Path: {DATASET_PATH}\n")

if not DATASET_PATH.exists():
    print("❌ Dataset Not Found")
    exit()

classes = [folder for folder in DATASET_PATH.iterdir() if folder.is_dir()]

print(f"✅ Total Classes: {len(classes)}\n")

total_images = 0

for cls in sorted(classes):
    image_count = len(list(cls.glob("*")))
    total_images += image_count
    print(f"{cls.name} : {image_count} images")

print(f"\n📸 Total Images: {total_images}")