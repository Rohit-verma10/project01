from fastapi import FastAPI

from backend.app.database.database import engine
from backend.app.user import Base, User
from backend.app.models.prediction_history import PredictionHistory

from backend.app.routes.auth import router as auth_router
from backend.app.routes.prediction import router as prediction_router

app = FastAPI(
    title="AgriVision AI",
    version="1.0.0"
)

# Routers
app.include_router(auth_router, prefix="/auth", tags=["Authentication"])
app.include_router(prediction_router, prefix="/ai", tags=["AI Prediction"])

# Database Tables Create
Base.metadata.create_all(bind=engine)

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
            "Satellite Analysis"
        ]
    }