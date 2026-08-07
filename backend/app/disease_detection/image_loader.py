from pathlib import Path

# Dataset Path
DATASET_PATH = Path(__file__).resolve().parents[2] / "datasets" / "PlantVillage" / "train"

# Image Extensions
IMAGE_EXTENSIONS = (".jpg", ".jpeg", ".png")

images = []
labels = []

# Read Dataset
for class_folder in sorted(DATASET_PATH.iterdir()):

    if class_folder.is_dir():

        for image_file in class_folder.iterdir():

            if image_file.suffix.lower() in IMAGE_EXTENSIONS:

                images.append(str(image_file))
                labels.append(class_folder.name)

print("=" * 40)
print("IMAGE LOADER REPORT")
print("=" * 40)
print(f"Total Images : {len(images)}")
print(f"Total Classes : {len(set(labels))}")

print("\nFirst 5 Images:\n")

for i in range(5):
    print(images[i])
    print("Label:", labels[i])
    print("-" * 40)