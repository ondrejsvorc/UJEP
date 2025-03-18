import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.api as sm
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error, r2_score
from statsmodels.stats.outliers_influence import variance_inflation_factor

def load_house_data():
    return pd.read_csv("house_data.csv", delimiter=",")

def clean_data(df):
    df = df.dropna()
    df = df.drop_duplicates()
    return df

def remove_high_vif_features(df, threshold=10.0):
    while True:
        vif = calculate_vif(df)
        max_vif = vif["VIF"].max()
        if max_vif < threshold:
            break
        feature_to_remove = vif.loc[vif["VIF"].idxmax(), "Feature"]
        print(f"Removing {feature_to_remove} (VIF={max_vif:.2f})")
        df = df.drop(columns=[feature_to_remove])
    return df

def remove_insignificant_features(X, y, p_value_threshold=0.05):
    while True:
        X_const = sm.add_constant(X)
        model = sm.OLS(y, X_const).fit()
        p_values = model.pvalues[1:]  # Ignorujeme konstantu
        max_p = p_values.max()
        if max_p < p_value_threshold:
            break
        feature_to_remove = p_values.idxmax()
        print(f"Removing {feature_to_remove} (p-value={max_p:.4f})")
        X = X.drop(columns=[feature_to_remove])
    return X

def calculate_vif(df):
    vif = pd.DataFrame()
    vif["Feature"] = df.columns
    vif["VIF"] = [variance_inflation_factor(df.values, i) for i in range(df.shape[1])]
    return vif

def plot_correlation_matrix(df):
    plt.figure(figsize=(12, 8))
    sns.heatmap(df.corr(), annot=True, cmap="coolwarm", fmt=".2f")
    plt.title("Correlation Matrix")
    plt.savefig("2_correlation_matrix")
    plt.show()

def normalize_data(X_train, X_test):
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    return X_train_scaled, X_test_scaled

def split_data(df, target_col="MEDV"):
    X = df.drop(columns=[target_col])
    y = df[target_col]
    return train_test_split(X, y, test_size=0.3, random_state=42)

def train_regression_model(X_train, y_train):
    X_train = sm.add_constant(X_train)
    model = sm.OLS(y_train, X_train).fit()
    return model

def evaluate_model(model, X_test, y_test):
    X_test = sm.add_constant(X_test)
    y_pred = model.predict(X_test)
    rmse = np.sqrt(mean_squared_error(y_test, y_pred))
    r2 = r2_score(y_test, y_pred)
    return rmse, r2, y_pred

def plot_predictions(y_test, y_pred):
    errors = y_test - y_pred
    plt.figure(figsize=(8, 6))
    sc = plt.scatter(y_test, y_pred, c=errors, cmap="coolwarm", alpha=0.7, label="Predicted vs. Actual")
    plt.colorbar(sc, label="Prediction Error")
    plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], color="red", linewidth=2, linestyle="--", label="Perfect Fit")
    plt.xlabel("Skutečná cena")
    plt.ylabel("Predikovaná cena")
    plt.title("Skutečné vs. predikované ceny domů")
    plt.legend()
    plt.grid(True, linestyle="--", alpha=0.7)
    plt.savefig("2_predictions")
    plt.show()

house_data = clean_data(load_house_data())
X_train, X_test, y_train, y_test = split_data(house_data)

print(calculate_vif(X_train))
print(house_data.corr())
plot_correlation_matrix(house_data)

X_train_scaled, X_test_scaled = normalize_data(X_train, X_test)
X_train = remove_high_vif_features(X_train)
X_train = remove_insignificant_features(X_train, y_train)
model = train_regression_model(X_train_scaled, y_train)
print(model.summary())

rmse, r2, y_pred = evaluate_model(model, X_test_scaled, y_test)
print(f"RMSE: {rmse:.2f}")
print(f"R-squared: {r2:.4f}")

plot_predictions(y_test, y_pred)