from fastapi import APIRouter
from backend.app.services.weather_service import get_weather

router = APIRouter()

@router.get("/weather/{city}")
def weather(city: str):
    return get_weather(city)