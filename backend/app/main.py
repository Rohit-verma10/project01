from fastapi import FastAPI
<<<<<<< HEAD
from fastapi.middleware.cors import CORSMiddleware

from app.api.disease_api import router as disease_router
from app.api.weather_api import router as weather_router

app = FastAPI(
    title="AgriVision AI"
)

=======

# Database
from backend.app.database.database import engine
from backend.app.database.database import Base

# Models
from backend.app.models.user import User
from backend.app.models.prediction_history import PredictionHistory

# Routes
from backend.app.routes.auth import router as auth_router
from backend.app.routes.prediction import router as prediction_router
from backend.app.routes.disease import router as disease_router

# Weather Service
from backend.app.services.weather_service import get_weather

#upload_router
from backend.app.routes.upload import router as upload_router

app = FastAPI(
    title="AgriVision AI",
    version="1.0.0"
)

# Database Tables Create
Base.metadata.create_all(bind=engine)

# Authentication Routes
app.include_router(
    auth_router,
    prefix="/auth",
    tags=["Authentication"]
)

# AI Prediction Routes
app.include_router(
    prediction_router,
    prefix="/ai",
    tags=["AI Prediction"]
)

# Disease Detection Routes
>>>>>>> 72a2fa1ab1209aab4ae4ed8ba9706ffd0879de41
app.include_router(
    disease_router,
    prefix="/disease",
    tags=["Disease Detection"]
)

<<<<<<< HEAD
app.include_router(
    weather_router,
    tags=["Weather"]
)



@app.get("/")
def home():
    return {
        "message": "AgriVision AI API Running"
    }
=======
#Router include
app.include_router(
    upload_router,
    prefix="/upload",
    tags=["File Upload"]
)

@app.get("/")
def home():
    return {
        "message": "Welcome to AgriVision AI Backend"
    }

@app.get("/health")
def health():
    return {
        "status": "healthy",
        "service": "AgriVision AI Backend"
    }

@app.get("/version")
def version():
    return {
        "version": "1.0.0"
    }

@app.get("/about")
def about():
    return {
        "project": "AgriVision AI",
        "team": "SIH Team",
        "features": [
            "Crop Prediction",
            "Disease Detection",
            "Satellite Analysis",
            "Weather Integration"
        ]
    }

# Weather API
@app.get("/weather/{city}")
def weather(city: str):
    return get_weather(city)
>>>>>>> 72a2fa1ab1209aab4ae4ed8ba9706ffd0879de41
