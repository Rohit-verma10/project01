from fastapi import APIRouter
import requests

router = APIRouter()

API_KEY = "5a4914234debaa93b57576be13d3f181"


@router.get("/{city}")
def get_weather(city: str):

    url = (
        f"https://api.openweathermap.org/data/2.5/weather"
        f"?q={city}&appid={API_KEY}&units=metric"
    )

    response = requests.get(url)

    if response.status_code != 200:
        return {"error": "City not found"}

    data = response.json()

    return {
        "city": city,
        "temperature": data["main"]["temp"],
        "humidity": data["main"]["humidity"],
        "condition": data["weather"][0]["description"]
    }