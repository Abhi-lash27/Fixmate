import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.svm import SVR
from sklearn.metrics import mean_absolute_error, r2_score
from sklearn.preprocessing import MinMaxScaler

# Load dataset
df = pd.read_csv("/content/repairability_data_scaled.csv")

# Define features and target variable
X = df[['complexity', 'cost', 'time', 'availability', 'device_age']]
y = df['score']

# Scale features and target to range 0-10
X_scaler = MinMaxScaler(feature_range=(0, 10))
y_scaler = MinMaxScaler(feature_range=(0, 10))
X_scaled = X_scaler.fit_transform(X)
y_scaled = y_scaler.fit_transform(y.values.reshape(-1, 1)).flatten()

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y_scaled, test_size=0.2, random_state=42)

# Train Random Forest model
rf_model = RandomForestRegressor(n_estimators=100, random_state=42)
rf_model.fit(X_train, y_train)
rf_predictions = rf_model.predict(X_test)

# Train SVM model
svm_model = SVR(kernel='rbf')
svm_model.fit(X_train, y_train)
svm_predictions = svm_model.predict(X_test)

# Evaluate models
# def evaluate_model(name, y_true, y_pred):
#     mae = mean_absolute_error(y_true, y_pred)
#     r2 = r2_score(y_true, y_pred)
#     print(f"{name} Model Performance:")
#     print(f"Mean Absolute Error: {mae:.2f}")
#     print(f"R-squared Score: {r2:.2f}\n")

# evaluate_model("Random Forest", y_test, rf_predictions)
# evaluate_model("SVM", y_test, svm_predictions)

# Example prediction (scaled input)
example_input = np.array([[1, 2, 2, 2, 3]])  # Example input values in original scale
example_input_scaled = X_scaler.transform(example_input)
svm_pred_example_scaled = svm_model.predict(example_input_scaled)
svm_pred_example = y_scaler.inverse_transform([[svm_pred_example_scaled[0]]])[0][0]
svm_pred_example = svm_pred_example/10
print(f"Predicted Repairability Score (SVM): {svm_pred_example:.2f}")
