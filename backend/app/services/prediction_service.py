import joblib

from backend.app.database.database import SessionLocal
from backend.app.models.prediction_history import PredictionHistory

model = joblib.load(
    "ai/saved_models/crop_model.pkl"
)

def predict_crop(data):

    values = [[
        data.nitrogen,
        data.phosphorus,
        data.potassium,
        data.temperature,
        data.humidity,
        data.ph,
        data.rainfall
    ]]

    prediction = model.predict(values)

    db = SessionLocal()

    history = PredictionHistory(
        nitrogen=data.nitrogen,
        phosphorus=data.phosphorus,
        potassium=data.potassium,
        temperature=data.temperature,
        humidity=data.humidity,
        ph=data.ph,
        rainfall=data.rainfall,
        predicted_crop=prediction[0]
    )

    db.add(history)
    db.commit()
    db.close()

    return {
    "success": True,
    "message": "Prediction generated successfully",
    "data": {
        "recommended_crop": prediction[0]
    }
}