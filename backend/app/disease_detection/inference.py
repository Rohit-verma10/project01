import json
import numpy as np
import tensorflow as tf

from tensorflow.keras.utils import load_img
from tensorflow.keras.utils import img_to_array

model = tf.keras.models.load_model(
    "outputs/plant_disease_model.keras"
)

with open("outputs/class_names.json", "r") as f:
    class_names = json.load(f)

def predict_disease(image_path):

    img = load_img(
        image_path,
        target_size=(224, 224)
    )

    img_array = img_to_array(img)
    img_array = img_array / 255.0
    img_array = np.expand_dims(img_array, axis=0)

    prediction = model.predict(
        img_array,
        verbose=0
    )

    class_index = np.argmax(prediction)
    confidence = float(np.max(prediction))

    return {
        "disease": class_names[class_index],
        "confidence": round(confidence * 100, 2)
    }