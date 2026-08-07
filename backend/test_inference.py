from app.disease_detection.inference import predict_disease

result = predict_disease(
    "datasets/PlantVillage/train/Pepper__bell___healthy/00100ffa-095e-4881-aebf-61fe5af7226e___JR_HL 7886.JPG"
)

print(result)