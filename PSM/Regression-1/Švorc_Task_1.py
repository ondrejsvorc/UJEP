import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split

def load_simplreg():
    path = "datasets/simplreg.txt" if "google.colab" not in sys.modules else "/content/drive/MyDrive/2024_2025/PSM_2024_2025/Regression_1/Datasets/simplreg.txt"
    return pd.read_csv(path, delimiter="\t")

def load_fruitohms():
    path = "datasets/fruitohms.txt" if "google.colab" not in sys.modules else "/content/drive/MyDrive/2024_2025/PSM_2024_2025/Regression_1/Datasets/fruitohms.txt"
    return pd.read_csv(path, delimiter=" ")

# ----------- 1. Task -----------

simplreg = load_simplreg()
fruitohms = load_fruitohms()

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 6))
sns.scatterplot(x=simplreg["X"], y=simplreg["Y"], ax=ax1, label="Data")
ax1.set_xlabel("X", fontsize=14)
ax1.set_ylabel("Y", fontsize=14)
ax1.set_title("Y = F(X)", fontsize=16, fontweight="bold")
ax1.tick_params(axis="x", labelsize=12)
ax1.tick_params(axis="y", labelsize=12)
ax1.grid(True, linestyle="--", alpha=0.5)

sns.scatterplot(x=fruitohms["ohms"], y=fruitohms["juice"], ax=ax2, label="Data")
ax2.set_xlabel("ohms", fontsize=14)
ax2.set_ylabel("juice", fontsize=14)
ax2.set_title("juice = F(ohms)", fontsize=16, fontweight="bold")
ax2.tick_params(axis="x", labelsize=12)
ax2.tick_params(axis="y", labelsize=12)
ax2.grid(True, linestyle="--", alpha=0.5)

plt.savefig("1_1_datasets.png")
plt.show()

# ----------- 2. Task -----------

TRAIN_TEST_SPLIT_RATIO = 0.3
POLYNOMIAL_DEGREES = [2, 3, 4, 5]

def plot_models(X, y, filename):
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=TRAIN_TEST_SPLIT_RATIO, random_state=42)

    degrees_and_colors = {2: "green", 3: "darkblue", 4: "magenta", 5: "grey"}
    _, axs = plt.subplots(2, 2, figsize=(12, 10))
    axs = axs.ravel()

    for idx, (degree, color) in enumerate(degrees_and_colors.items()):
        polynomial_features = PolynomialFeatures(degree)
        X_poly_train = polynomial_features.fit_transform(X_train)
        polynomial_regression = LinearRegression().fit(X_poly_train, y_train)
        X_grid = np.linspace(X.min(), X.max(), 100).reshape(-1, 1)
        y_poly_grid = polynomial_regression.predict(polynomial_features.transform(X_grid))
        y_pred = polynomial_regression.predict(polynomial_features.transform(X_test))

        mse = mean_squared_error(y_test, y_pred)
        rmse = np.sqrt(mse)
        mae = mean_absolute_error(y_test, y_pred)
        r2 = r2_score(y_test, y_pred)

        sns.scatterplot(x=X.ravel(), y=y, ax=axs[idx], label="Data")
        axs[idx].plot(X_grid, y_poly_grid, color=color, linewidth=2, label=f"Regression (degree={degree})")
        axs[idx].set_title(f"Regression (degree={degree})", fontsize=14, fontweight="bold")
        axs[idx].grid(True, linestyle="--", alpha=0.5)
        axs[idx].legend()
        axs[idx].text(
            0.81, 0.69,
            f"MSE: {np.round(mse, 3)}\nRMSE: {np.round(rmse, 3)}\nMAE: {np.round(mae, 3)}\nR²: {np.round(r2, 3)}",
            transform=axs[idx].transAxes, fontsize=10, verticalalignment="bottom",
            horizontalalignment="left",
            bbox=dict(facecolor="white", edgecolor="black", boxstyle="round,pad=0.3")
        )
    plt.tight_layout()
    plt.savefig(filename)
    plt.show()
    print(f"Optimal degree: {get_optimal_degree(X_train, X_test, y_train, y_test)}")

def get_optimal_degree(x_train, x_test, y_train, y_test):
    degrees = [2, 3, 4, 5]
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

X_simplreg = simplreg["X"].values.reshape(-1, 1)
y_simplreg = simplreg["Y"].values
plot_models(X_simplreg, y_simplreg, filename="1_2_simplreg")

X_fruitohms = fruitohms["ohms"].values.reshape(-1, 1)
y_fruitohms = fruitohms["juice"].values
plot_models(X_fruitohms, y_fruitohms, filename="1_2_fruitohms")

# ----------- 3. Task -----------

def plot_best_regression_models(X1, y1, X2, y2, filename = "1_3_overview.png"):
    # --- Dataset 1 ---
    X_train1, X_test1, y_train1, y_test1 = train_test_split(X1, y1, test_size=TRAIN_TEST_SPLIT_RATIO, random_state=42)
    best_degree1 = get_optimal_degree(X_train1, X_test1, y_train1, y_test1)
    poly_feat1 = PolynomialFeatures(best_degree1)
    X_poly_train1 = poly_feat1.fit_transform(X_train1)
    poly_model1 = LinearRegression().fit(X_poly_train1, y_train1)
    lin_model1 = LinearRegression().fit(X_train1, y_train1)
    X_grid1 = np.linspace(X1.min(), X1.max(), 100).reshape(-1, 1)
    y_lin_grid1 = lin_model1.predict(X_grid1)
    y_poly_grid1 = poly_model1.predict(poly_feat1.transform(X_grid1))

    # --- Dataset 2 ---
    X_train2, X_test2, y_train2, y_test2 = train_test_split(X2, y2, test_size=TRAIN_TEST_SPLIT_RATIO, random_state=42)
    best_degree2 = get_optimal_degree(X_train2, X_test2, y_train2, y_test2)
    poly_feat2 = PolynomialFeatures(best_degree2)
    X_poly_train2 = poly_feat2.fit_transform(X_train2)
    poly_model2 = LinearRegression().fit(X_poly_train2, y_train2)
    lin_model2 = LinearRegression().fit(X_train2, y_train2)
    X_grid2 = np.linspace(X2.min(), X2.max(), 100).reshape(-1, 1)
    y_lin_grid2 = lin_model2.predict(X_grid2)
    y_poly_grid2 = poly_model2.predict(poly_feat2.transform(X_grid2))

    # --- Plotting ---
    _, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 6))

    # Subplot for dataset 1
    ax1.scatter(X1, y1, label="Data")
    ax1.plot(X_grid1, y_lin_grid1, color="red", linewidth=2, label="Linear Regression")
    ax1.plot(X_grid1, y_poly_grid1, color="green", linewidth=2,
             label=f"Polynomial Regression (degree={best_degree1})")
    ax1.set_xlabel("X")
    ax1.set_ylabel("Y")
    ax1.set_title("Regression Comparison: Y = f(X)")
    ax1.grid(True, linestyle="--", alpha=0.5)
    ax1.legend()

    # Subplot for dataset 2
    ax2.scatter(X2, y2, label="Data")
    ax2.plot(X_grid2, y_lin_grid2, color="red", linewidth=2, label="Linear Regression")
    ax2.plot(X_grid2, y_poly_grid2, color="green", linewidth=2,
             label=f"Polynomial Regression (degree={best_degree2})")
    ax2.set_xlabel("ohms")
    ax2.set_ylabel("juice")
    ax2.set_title("Regression Comparison: juice = f(ohms)")
    ax2.grid(True, linestyle="--", alpha=0.5)
    ax2.legend()

    plt.tight_layout()
    plt.savefig(filename)
    plt.show()

plot_best_regression_models(X1=X_simplreg, y1=y_simplreg, X2=X_fruitohms, y2=y_fruitohms)