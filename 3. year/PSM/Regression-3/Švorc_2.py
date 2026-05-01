import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import mean_squared_error, r2_score
import matplotlib.pyplot as plt

def preprocess(file_path, target_col):
    df = pd.read_csv(file_path, delimiter=";")
    df = df.dropna()
    X = df.drop(columns=[target_col])
    y = df[target_col]
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    return X_scaled, y

def train_models(X_train, y_train):
    models = {
        'Decision Tree': DecisionTreeClassifier(),
        'Random Forest': RandomForestClassifier(n_estimators=100)
    }
    for name, model in models.items():
        model.fit(X_train, y_train)
    return models

def evaluate_models(models, X_test, y_test):
    for name, model in models.items():
        y_pred = model.predict(X_test)
        mse = mean_squared_error(y_test, y_pred)
        rmse = np.sqrt(mse)
        r2 = r2_score(y_test, y_pred)
        print(f"{name}: MSE: {mse:.2f}, RMSE: {rmse:.2f}, R²: {r2:.2f}")

def run_pipeline(file_path, target_col):
    X, y = preprocess(file_path, target_col)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)
    models = train_models(X_train, y_train)
    evaluate_models(models, X_test, y_test)

file_path = "winequality-red.csv"
print(f"{file_path}\n")
run_pipeline(file_path, "quality")

# Random Forest je lepší model než Decision Tree, protože má nižší MSE (0.42 vs. 0.61) a RMSE (0.65 vs. 0.78).
# Zároveň má podstatně vyšší R² (0.33 vs. 0.03), což znamená, že dokáže mnohem lépe vysvětlit variabilitu dat.