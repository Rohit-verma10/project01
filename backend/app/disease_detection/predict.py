import json
import numpy as np
import tensorflow as tf

from tensorflow.keras.utils import load_img
from tensorflow.keras.utils import img_to_array

# =====================================
# LOAD TRAINED MODEL
# =====================================

model = tf.keras.models.load_model(
    "outputs/plant_disease_model.keras"
)

# =====================================
# LOAD CLASS NAMES
# =====================================

with open("outputs/class_names.json", "r") as f:
    class_names = json.load(f)

# =====================================
# GET IMAGE PATH
# =====================================

image_path = input(
    "Enter image path: "
).strip().replace('"', "")

# =====================================
# LOAD IMAGE
# =====================================

img = load_img(
    image_path,
    target_size=(224, 224)
)

# =====================================
# PREPROCESS IMAGE
# =====================================

img_array = img_to_array(img)

img_array = img_array / 255.0

img_array = np.expand_dims(
    img_array,
    axis=0
)

# =====================================
# PREDICTION
# =====================================

prediction = model.predict(
    img_array,
    verbose=0
)

class_index = np.argmax(
    prediction
)

confidence = np.max(
    prediction
)

# =====================================
# RESULT
# =====================================

print("\n========================")
print("PREDICTION RESULT")
print("========================")

print(
    "Disease :",
    class_names[class_index]
)

print(
    f"Confidence : {confidence * 100:.2f}%"
)

print("========================")