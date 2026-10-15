import joblib
import numpy as np

model = joblib.load("backend/ai/crop_model.pkl")

def predict_crop(
    nitrogen,
    phosphorus,
    potassium,
    temperature,
    humidity,
    ph,
    rainfall
):

    data = np.array([[
        nitrogen,
        phosphorus,
        potassium,
        temperature,
        humidity,
        ph,
        rainfall
    ]])

    prediction = model.predict(data)

    return prediction[0]