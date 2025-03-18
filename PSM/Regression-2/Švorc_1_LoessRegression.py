import numpy as np
import pandas as pd
from pyloess import loess
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
import sys

def load_manufacturing():
    return pd.read_csv("manufacturing.csv", delimiter=",")

def apply_loess(x_train, y_train, x_test, frac=0.3):
    x_train, y_train, x_test = np.array(x_train), np.array(y_train), np.array(x_test)
    return loess(x_train, y_train, eval_x=x_test, span=frac)

def apply_polynomial_regression(x_train, y_train, x_test, degree=2):
    poly = PolynomialFeatures(degree)
    X_poly_train = poly.fit_transform(x_train.reshape(-1, 1))
    X_poly_test = poly.transform(x_test.reshape(-1, 1))
    model = LinearRegression().fit(X_poly_train, y_train)
    y_pred = model.predict(X_poly_test)
    return y_pred, model

def evaluate_models(x_train, y_train, x_test, y_test):
    results = {}
    for feature in x_train.columns:
        x_train_feat = x_train[feature].values
        x_test_feat = x_test[feature].values

        y_pred_loess = apply_loess(x_train_feat, y_train, x_test_feat)
        rmse_loess = np.sqrt(mean_squared_error(y_test, y_pred_loess))
        r2_loess = r2_score(y_test, y_pred_loess)

        y_pred_poly, poly_model = apply_polynomial_regression(x_train_feat, y_train, x_test_feat, degree=2)
        rmse_poly = np.sqrt(mean_squared_error(y_test, y_pred_poly))
        r2_poly = r2_score(y_test, y_pred_poly)

        results[feature] = {
            "RMSE_LOESS": rmse_loess,
            "R2_LOESS": r2_loess,
            "RMSE_Poly": rmse_poly,
            "R2_Poly": r2_poly
        }
    return pd.DataFrame(results).T

def get_optimal_degree(x_train, x_test, y_train, y_test):
    degrees = [1, 2, 3, 4, 5]
    errors = []

    for degree in degrees:
        poly = PolynomialFeatures(degree=degree)
        X_poly_train = poly.fit_transform(x_train)
        X_poly_test = poly.transform(x_test)

        poly_reg = LinearRegression()
        poly_reg.fit(X_poly_train, y_train)

        y_poly_pred = poly_reg.predict(X_poly_test)
        mse_poly = mean_squared_error(y_test, y_poly_pred)
        errors.append(mse_poly)

    return degrees[np.argmin(errors)]

def plot_correlation_matrix(manufacturing):
    correlation_matrix = pd.DataFrame.corr(manufacturing)
    plt.figure(figsize=(6, 5))
    sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', fmt=".2f", linewidths=0.5)
    plt.title("Correlation Matrix")
    plt.savefig("1_correlation_matrix")
    plt.show()

def plot_features(x_train, x_test, y_train, y_test, features_to_plot):
    n_features = len(features_to_plot)
    _, axes = plt.subplots(nrows=n_features, ncols=2, figsize=(24, 35))

    for i, feature in enumerate(features_to_plot):
        x_train_feat = x_train[feature].values
        x_test_feat = x_test[feature].values

        degree = get_optimal_degree(x_train_feat.reshape(-1, 1), x_test_feat.reshape(-1, 1), y_train, y_test)
        y_pred_loess = apply_loess(x_train_feat, y_train, x_test_feat)
        y_pred_poly, _ = apply_polynomial_regression(x_train_feat, y_train, x_test_feat, degree=degree)

        ax_loess = axes[i, 0]
        ax_loess.scatter(x_test_feat, y_test, label="Actual", color="black", alpha=0.5)
        ax_loess.scatter(x_test_feat, y_pred_loess, label="LOESS", color="blue", alpha=0.5)
        ax_loess.set_title(f"LOESS for {feature}")
        ax_loess.set_xlabel(feature)
        ax_loess.set_ylabel("Quality Rating")
        ax_loess.legend()

        ax_poly = axes[i, 1]
        ax_poly.scatter(x_test_feat, y_test, label="Actual", color="black", alpha=0.5)
        ax_poly.scatter(x_test_feat, y_pred_poly, label=f"Polynomial (deg={degree})", color="red", alpha=0.5)
        ax_poly.set_title(f"Polynomial for {feature}")
        ax_poly.set_xlabel(feature)
        ax_poly.set_ylabel("Quality Rating")
        ax_poly.legend()

    plt.savefig("1_loess_vs_polynomial")
    plt.tight_layout()
    plt.show()

manufacturing = load_manufacturing()
X = manufacturing.drop(columns=["Quality Rating"])
y = manufacturing["Quality Rating"]
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

print(evaluate_models(x_train=X_train, y_train=y_train, x_test=X_test, y_test=y_test))
plot_correlation_matrix(manufacturing)
plot_features(x_train=X_train, x_test=X_test, y_train=y_train, y_test=y_test, features_to_plot=list(X.columns))