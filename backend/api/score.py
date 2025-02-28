import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import matplotlib.pyplot as plt
from sklearn.model_selection import cross_val_score

# Load the CSV file
file_path = 'data/score.csv'  # Replace with the actual path to your file

df = pd.read_csv(file_path)

# Check the first few rows of the dataset
print(df.head())

# Ensure that the dataset contains the necessary columns
# These should be features (complexity, cost, time, availability, age) and the target (repairability_score)
# If the columns have different names, modify them accordingly
if 'repairability_score' not in df.columns:
    raise ValueError("The dataset must contain a 'repairability_score' column.")

# Split the data into features and target variable
X = df.drop('repairability_score', axis=1)  # Drop target variable
y = df['repairability_score']  # Target variable

# Split into training and testing datasets (80% training, 20% testing)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train the model (Linear Regression)
model = LinearRegression()
model.fit(X_train, y_train)

# Predict on the test set
y_pred = model.predict(X_test)

# Calculate evaluation metrics
mae = mean_absolute_error(y_test, y_pred)
mse = mean_squared_error(y_test, y_pred)
rmse = np.sqrt(mse)
r2 = r2_score(y_test, y_pred)

# Print evaluation metrics
print(f"Mean Absolute Error (MAE): {mae}")
print(f"Mean Squared Error (MSE): {mse}")
print(f"Root Mean Squared Error (RMSE): {rmse}")
print(f"R-squared (R²): {r2}")

# Visualizing Actual vs Predicted repairability scores
plt.scatter(y_test, y_pred)
plt.xlabel("Actual Repairability Scores")
plt.ylabel("Predicted Repairability Scores")
plt.title("Actual vs Predicted Repairability Scores")
plt.show()

# Cross-validation to check the model's performance across different subsets of the data
cv_scores = cross_val_score(model, X, y, cv=5, scoring='neg_mean_absolute_error')
print("Cross-Validation MAE:", -cv_scores.mean())

# If you want to save the model for later use
import joblib
joblib.dump(model, 'repairability_model.pkl')

# To load the model later for predictions
# model = joblib.load('repairability_model.pkl')
