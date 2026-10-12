import pandas as pd
from sklearn.ensemble import RandomForestClassifier
import joblib

# Dataset Load
df = pd.read_csv("Crop_recommendation.csv")

# Features aur Label
X = df.drop("label", axis=1)
y = df["label"]

# Model
model = RandomForestClassifier(n_estimators=100, random_state=42)

# Training
model.fit(X, y)

# Save Model
joblib.dump(model, "crop_model.pkl")

print("✅ Model Saved Successfully")