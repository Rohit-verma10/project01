from fastapi import APIRouter, UploadFile, File
from app.disease_detection.inference import predict_disease
from app.disease_detection.disease_info import DISEASE_INFO

import shutil
import os

router = APIRouter()

UPLOAD_DIR = "outputs/uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)


@router.post("/predict")
async def predict(file: UploadFile = File(...)):

    # Save uploaded image
    file_path = os.path.join(
        UPLOAD_DIR,
        file.filename
    )

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(
            file.file,
            buffer
        )

    # Predict disease
    result = predict_disease(file_path)

    disease_name = result["disease"]

    # Get disease information
    info = DISEASE_INFO.get(
        disease_name,
        {
            "symptoms": "Information not available",
            "cause": "Information not available",
            "treatment": "Information not available"
        }
    )

    # Return response
    return {
        "success": True,
        "prediction": {
            "disease": result["disease"],
            "confidence": result["confidence"]
        },
        "disease_info": {
            "symptoms": info["symptoms"],
            "cause": info["cause"],
            "treatment": info["treatment"]
        }
    }