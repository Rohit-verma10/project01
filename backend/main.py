from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.disease_api import router as disease_router

app = FastAPI(
    title="AgriVision AI API"
)

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Development ke liye
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Disease Detection Routes
app.include_router(
    disease_router,
    prefix="/disease",
    tags=["Disease Detection"]
)

# Home Route
@app.get("/")
def home():
    return {
        "message": "AgriVision AI API Running"
    }