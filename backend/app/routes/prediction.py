from fastapi import APIRouter
from sqlalchemy import func

from backend.app.schemas.prediction import CropPredictionRequest
from backend.app.services.prediction_service import predict_crop

from backend.app.database.database import SessionLocal
from backend.app.models.prediction_history import PredictionHistory

router = APIRouter()


@router.get("/test-ai")
def test_ai():
    return {
        "message": "AI Route Working"
    }


@router.post("/predict-crop")
def crop_prediction(request: CropPredictionRequest):
    return predict_crop(request)


@router.get("/history")
def prediction_history():

    db = SessionLocal()

    history = db.query(
        PredictionHistory
    ).all()

    db.close()

    return history


@router.get("/stats/total-predictions")
def total_predictions():

    db = SessionLocal()

    count = db.query(
        PredictionHistory
    ).count()

    db.close()

    return {
        "total_predictions": count
    }


@router.get("/stats/recent")
def recent_predictions():

    db = SessionLocal()

    data = db.query(
        PredictionHistory
    ).order_by(
        PredictionHistory.id.desc()
    ).limit(5).all()

    db.close()

    return data


@router.get("/stats/most-predicted-crop")
def most_predicted_crop():

    db = SessionLocal()

    result = (
        db.query(
            PredictionHistory.predicted_crop,
            func.count(PredictionHistory.predicted_crop)
        )
        .group_by(
            PredictionHistory.predicted_crop
        )
        .order_by(
            func.count(PredictionHistory.predicted_crop).desc()
        )
        .first()
    )

    db.close()

    if result:
        return {
            "crop": result[0],
            "count": result[1]
        }

    return {
        "message": "No prediction data found"
    }


@router.get("/stats/dashboard")
def dashboard_stats():

    db = SessionLocal()

    total_predictions = db.query(
        PredictionHistory
    ).count()

    most_crop = (
        db.query(
            PredictionHistory.predicted_crop,
            func.count(PredictionHistory.predicted_crop)
        )
        .group_by(
            PredictionHistory.predicted_crop
        )
        .order_by(
            func.count(PredictionHistory.predicted_crop).desc()
        )
        .first()
    )

    recent_predictions = (
        db.query(
            PredictionHistory
        )
        .order_by(
            PredictionHistory.id.desc()
        )
        .limit(5)
        .all()
    )

    db.close()

    return {
        "total_predictions": total_predictions,
        "most_predicted_crop": most_crop[0] if most_crop else None,
        "most_predicted_count": most_crop[1] if most_crop else 0,
        "recent_predictions": recent_predictions
    }