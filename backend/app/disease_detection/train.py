import os
import tensorflow as tf

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import (
    Input,
    Conv2D,
    MaxPooling2D,
    Flatten,
    Dense,
    Dropout
)
from tensorflow.keras.preprocessing.image import ImageDataGenerator

# =====================================
# PATHS
# =====================================

DATASET_PATH = "datasets/PlantVillage/train"
MODEL_PATH = "outputs/plant_disease_model.keras"

os.makedirs("outputs", exist_ok=True)

# =====================================
# DATA GENERATOR
# =====================================

datagen = ImageDataGenerator(
    rescale=1.0 / 255,
    validation_split=0.20
)

train_data = datagen.flow_from_directory(
    DATASET_PATH,
    target_size=(224, 224),
    batch_size=16,
    class_mode="categorical",
    subset="training",
    shuffle=True
)

val_data = datagen.flow_from_directory(
    DATASET_PATH,
    target_size=(224, 224),
    batch_size=16,
    class_mode="categorical",
    subset="validation",
    shuffle=False
)

print("\n===================================")
print("DATA LOADER REPORT")
print("===================================")
print("Training Images :", train_data.samples)
print("Validation Images :", val_data.samples)
print("Classes :", train_data.num_classes)

# =====================================
# MODEL
# =====================================

model = Sequential([

    Input(shape=(224, 224, 3)),

    Conv2D(
        32,
        (3, 3),
        activation="relu"
    ),

    MaxPooling2D((2, 2)),

    Conv2D(
        64,
        (3, 3),
        activation="relu"
    ),

    MaxPooling2D((2, 2)),

    Conv2D(
        128,
        (3, 3),
        activation="relu"
    ),

    MaxPooling2D((2, 2)),

    Flatten(),

    Dense(
        128,
        activation="relu"
    ),

    Dropout(0.5),

    Dense(
        train_data.num_classes,
        activation="softmax"
    )
])

# =====================================
# COMPILE
# =====================================

model.compile(
    optimizer="adam",
    loss="categorical_crossentropy",
    metrics=["accuracy"]
)

print("\n===================================")
print("MODEL READY FOR TRAINING")
print("===================================")

model.summary()

# =====================================
# CALLBACKS
# =====================================

checkpoint = tf.keras.callbacks.ModelCheckpoint(
    MODEL_PATH,
    monitor="val_accuracy",
    save_best_only=True,
    verbose=1
)

early_stop = tf.keras.callbacks.EarlyStopping(
    monitor="val_loss",
    patience=3,
    restore_best_weights=True
)

# =====================================
# TRAIN
# =====================================

history = model.fit(
    train_data,
    validation_data=val_data,
    epochs=5,
    callbacks=[
        checkpoint,
        early_stop
    ]
)

# =====================================
# SAVE MODEL
# =====================================

model.save(MODEL_PATH)

print("\n===================================")
print("MODEL SAVED SUCCESSFULLY")
print("===================================")
print("Location:", MODEL_PATH)