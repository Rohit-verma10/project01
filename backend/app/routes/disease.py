from fastapi import APIRouter
from backend.app.services.disease_service import predict_disease

router = APIRouter()

@router.get("/detect-disease")
def detect_disease():
    return predict_disease()