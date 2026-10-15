import pandas as pd
from sklearn.ensemble import RandomForestClassifier
import joblib

# Dataset Load
data = pd.read_csv("ai/datasets/crop_recommendation.csv")

# Features and Target
X = data.drop("label", axis=1)
y = data["label"]

# Model
model = RandomForestClassifier()

# Training
model.fit(X, y)

# Save Model
joblib.dump(
    model,
    "ai/saved_models/crop_model.pkl"
)

print("Model Saved Successfully")