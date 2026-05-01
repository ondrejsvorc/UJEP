import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.optimize import curve_fit

def load_misrala():
    path = "datasets/misrala.txt" if "google.colab" not in sys.modules else "/content/drive/MyDrive/2024_2025/PSM_2024_2025/Regression_1/Datasets/misrala.txt"
    return pd.read_csv(path, delimiter=" ")

def load_boxbod():
    path = "datasets/BoxBOD.txt" if "google.colab" not in sys.modules else "/content/drive/MyDrive/2024_2025/PSM_2024_2025/Regression_1/Datasets/BoxBOD.txt"
    return pd.read_csv(path, delimiter=" ")

def nonlinear_model(x, a, b):
    return a * (1 - np.exp(-b * x))

def fit_nonlinear_regression(x, y):
    initial_guess = [np.max(y), 0.001]
    optimized_parameters, _ = curve_fit(nonlinear_model, x, y, p0=initial_guess)
    return optimized_parameters

def plot_nonlinear_regression(x, y, popt, filename = "3_nonlinear_model.png") -> None:
    x_grid = np.linspace(x.min(), x.max(), 100)
    y_fit = nonlinear_model(x_grid, *popt)
    plt.figure(figsize=(8, 6))
    plt.scatter(x, y, label="Data", color="blue", alpha=0.7)
    plt.plot(x_grid, y_fit, label=f"Model: a={popt[0]:.3f}, b={popt[1]:.3f}", color="red", lw=2)
    plt.xlabel("x")
    plt.ylabel("y")
    plt.title("Non-linear regression model")
    plt.legend()
    plt.tight_layout()
    plt.savefig(filename)
    plt.show()

misrala = load_misrala()
boxbod = load_boxbod()

plt.figure(figsize=(12, 5))
plt.subplot(1, 2, 1)
sns.scatterplot(x=misrala.iloc[:, 0], y=misrala.iloc[:, 1])
plt.xlabel("x")
plt.ylabel("y")
plt.title("Data misrala")
plt.subplot(1, 2, 2)
sns.scatterplot(x=boxbod.iloc[:, 0], y=boxbod.iloc[:, 1])
plt.xlabel("x1")
plt.ylabel("y1")
plt.title("Data BoxBOD")

x_misrala = misrala.iloc[:, 0].values
y_misrala = misrala.iloc[:, 1].values
optimized_parameters_misrala = fit_nonlinear_regression(x_misrala, y_misrala)
print("Optimized parameters misrala [a, b]:", optimized_parameters_misrala)
plot_nonlinear_regression(x_misrala, y_misrala, optimized_parameters_misrala, filename="3_misrala.png")

x_boxbod = boxbod.iloc[:, 0].values
y_boxbod = boxbod.iloc[:, 1].values
optimized_parameters_boxbod = fit_nonlinear_regression(x_boxbod, y_boxbod)
print("Optimized parameters BoxBOD [a, b]:", optimized_parameters_boxbod)
plot_nonlinear_regression(x_boxbod, y_boxbod, optimized_parameters_boxbod, filename="3_boxbod.png")