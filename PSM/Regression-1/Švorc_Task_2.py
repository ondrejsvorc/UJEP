import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split

DEGREES = [1, 2, 3, 4, 5, 6, 7, 8, 9]

def load_manufacturing():
    path = "datasets/manufacturing.csv" if "google.colab" not in sys.modules else "/content/drive/MyDrive/2024_2025/PSM_2024_2025/Regression_1/Datasets/manufacturing.csv"
    return pd.read_csv(path, delimiter=",")

def get_optimal_degree(x_train, x_test, y_train, y_test, degrees=DEGREES):
    errors = []

    for degree in degrees:
        poly = PolynomialFeatures(degree)
        X_poly_train = poly.fit_transform(x_train)
        X_poly_test = poly.transform(x_test)

        poly_reg = LinearRegression()
        poly_reg.fit(X_poly_train, y_train)

        y_poly_pred = poly_reg.predict(X_poly_test)
        mse_poly = mean_squared_error(y_test, y_poly_pred)
        errors.append(mse_poly)

    return degrees[np.argmin(errors)]

def train_and_plot_poly_models(X, y, degrees=DEGREES, test_size = 0.3, random_state = 42):
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=test_size, random_state=random_state)

    n_degrees = len(degrees)
    n_cols = 3
    n_rows = int(np.ceil(n_degrees / n_cols))

    fig, axs = plt.subplots(n_rows, n_cols, figsize=(5 * n_cols, 4 * n_rows))
    axs = axs.ravel()

    for idx, degree in enumerate(degrees):
        poly = PolynomialFeatures(degree=degree)
        X_poly_train = poly.fit_transform(X_train)
        X_poly_test = poly.transform(X_test)
        model = LinearRegression().fit(X_poly_train, y_train)
        y_pred = model.predict(X_poly_test)

        mse = mean_squared_error(y_test, y_pred)
        rmse = np.sqrt(mse)
        mae = mean_absolute_error(y_test, y_pred)
        r2 = r2_score(y_test, y_pred)
        print(f"Degree {degree} - MSE: {np.round(mse,3)}, RMSE: {np.round(rmse,3)}, MAE: {np.round(mae,3)}, R2: {np.round(r2,3)}")

        ax = axs[idx]
        sns.scatterplot(x=y_test, y=y_pred, color='blue', alpha=0.6, ax=ax, label="Predicted vs actual")
        ax.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r--', lw=2, label="Ideal fit")
        ax.set_xlabel("Actual Quality Rating")
        ax.set_ylabel("Predicted Quality Rating")
        ax.set_title(f"Degree {degree} (MSE: {mse:.3f})")
        ax.legend()

    # Remove any unused subplots
    for j in range(idx + 1, n_rows * n_cols):
        fig.delaxes(axs[j])

    plt.tight_layout()
    plt.savefig("2_overview.png")
    plt.show()
    print(f"Optimal degree: {get_optimal_degree(X_train, X_test, y_train, y_test)}")

def train_and_evaluate_poly_models(X_col, y, degrees=DEGREES):
    X_train, X_test, y_train, y_test = train_test_split(X_col, y, test_size=0.3, random_state=42)
    errors = []

    for degree in degrees:
        poly = PolynomialFeatures(degree)
        X_poly_train = poly.fit_transform(X_train)
        X_poly_test = poly.transform(X_test)

        model = LinearRegression().fit(X_poly_train, y_train)
        y_pred = model.predict(X_poly_test)

        mse = mean_squared_error(y_test, y_pred)
        r2 = r2_score(y_test, y_pred)
        errors.append((degree, mse, r2))

    return errors


manufacturing = load_manufacturing()
print("Columns in dataset:", manufacturing.columns.tolist())

# Use all columns except "Quality Rating" as predictors.
X = manufacturing.drop(columns=["Quality Rating"])
y = manufacturing["Quality Rating"].values

train_and_plot_poly_models(X, y)

plt.figure(figsize=(10, 8))
sns.heatmap(manufacturing.corr(), annot=True, cmap="coolwarm", fmt=".2f")
plt.title("Correlation matrix")
plt.savefig("2_correlation_matrix.png")
plt.show()

results = {}
for col in X.columns:
    errors = train_and_evaluate_poly_models(X[[col]], y)
    results[col] = errors

best_models = {}
for col, errors in results.items():
    best_degree = sorted(errors, key=lambda x: x[1])[0][0]  # Best according to MSE
    best_models[col] = best_degree
    print(f"Best degree for '{col}': {best_degree}")