from pydantic import BaseModel, Field


class CropPredictionRequest(BaseModel):

    nitrogen: float = Field(
        ...,
        gt=0,
        description="Nitrogen value must be greater than 0"
    )

    phosphorus: float = Field(
        ...,
        gt=0,
        description="Phosphorus value must be greater than 0"
    )

    potassium: float = Field(
        ...,
        gt=0,
        description="Potassium value must be greater than 0"
    )

    temperature: float = Field(
        ...,
        gt=-20,
        lt=60,
        description="Temperature should be between -20 and 60"
    )

    humidity: float = Field(
        ...,
        ge=0,
        le=100,
        description="Humidity should be between 0 and 100"
    )

    ph: float = Field(
        ...,
        ge=0,
        le=14,
        description="pH should be between 0 and 14"
    )

    rainfall: float = Field(
        ...,
        ge=0,
        description="Rainfall cannot be negative"
    )