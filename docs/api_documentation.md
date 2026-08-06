# AgriVision AI API Documentation

## Register User

POST /auth/register

Request:

{
    "full_name":"Rishabh",
    "email":"r@gmail.com",
    "phone":"9999999999",
    "password":"123456"
}

---

## Login User

POST /auth/login

Request:

{
    "email":"r@gmail.com",
    "password":"123456"
}

---

## Crop Prediction

POST /ai/predict-crop

Request:

{
    "nitrogen":90,
    "phosphorus":42,
    "potassium":43,
    "temperature":20.8,
    "humidity":82,
    "ph":6.5,
    "rainfall":202.9
}

Response:

{
    "recommended_crop":"rice"
}

---

## Prediction History

GET /ai/history

---

## Dashboard