from fastapi import FastAPI
from app.api.disease_api import router as disease_router

app = FastAPI(
    title="AgriVision AI"
)

app.include_router(
    disease_router,
    prefix="/disease",
    tags=["Disease Detection"]
)


@app.get("/")
def home():
    return {
        "message": "AgriVision AI API Running"
    }