from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
import joblib
import numpy as np
from rapidfuzz import process, fuzz
from utils.search_engine import load_data

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

# ✅ Load Dataset & ML Models
dataset = load_data("data/train_data.json")
rf_model = joblib.load("models/random_forest.pkl")
svm_model = joblib.load("models/svm_model.pkl")
X_scaler = joblib.load("models/X_scaler.pkl")
y_scaler = joblib.load("models/y_scaler.pkl")


@app.route("/api/search", methods=["POST"])
@cross_origin()
def search():
    try:
        data = request.json
        brand = data.get("brand", "").strip().lower()
        model = data.get("model", "").strip().lower()
        problem_query = data.get("problem", "").strip().lower()
        age = int(data.get("age", 0))

        if not all([brand, model, problem_query, age]):
            return jsonify({"error": "Missing required fields: brand, model, age, or problem"}), 400

        # 🔹 Filter matching devices based on brand & model
        matching_devices = [
            device for device in dataset
            if fuzzy_match(brand, device.get("brand", "").lower()) and
               fuzzy_match(model, device.get("model", "").lower())
        ]

        if not matching_devices:
            return jsonify({"error": "No matching devices found for the given brand and model."}), 404

        # 🔹 Extract keywords from query
        query_keywords = set(problem_query.split())

        # 🔹 Find problems that match the most keywords
        ranked_problems = []
        for device in matching_devices:
            for problem in device.get("problems", []):
                problem_keywords = set(problem.get("keywords", []))
                match_count = len(query_keywords.intersection(problem_keywords))

                if match_count > 0:  # Only include problems with at least one match
                    ranked_problems.append((problem, device, match_count))

        if not ranked_problems:
            return jsonify({"error": f"No problems related to '{problem_query}' found for this device."}), 404

        # 🔹 Sort problems by number of matching keywords (higher matches first)
        ranked_problems.sort(key=lambda x: x[2], reverse=True)

        # 🔹 Enrich results with repairability score, steps, and tools
        enriched_results = [
            {
                "brand": device["brand"],
                "model": device["model"],
                "age": device["age"],
                "problem": problem["problem_description"],
                "repairability_score": predict_repairability(problem, age),
                "solutions": problem["solutions"],
                "steps": [step for solution in problem["solutions"] for step in solution["steps"]],
                "tools": [tool for solution in problem["solutions"] for tool in solution.get("tools", [])],
            }
            for problem, device, _ in ranked_problems
        ]

        # 🔹 Pagination logic
        page = int(request.args.get("page", 1))
        per_page = int(request.args.get("per_page", 5))
        total_results = len(enriched_results)
        paginated_results = enriched_results[(page - 1) * per_page: page * per_page]

        return jsonify({
            "query": problem_query,
            "results": paginated_results,
            "page": page,
            "total_pages": (total_results + per_page - 1) // per_page,
            "total_results": total_results,
        }), 200

    except Exception as e:
        return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500


@app.route("/api/predict", methods=["POST"])
def predict_repairability_api():
    """API to predict repairability score."""
    try:
        data = request.json
        complexity = float(data.get("complexity", 0))
        cost = float(data.get("cost", 0))
        time = float(data.get("time", 0))
        availability = float(data.get("availability", 0))
        device_age = float(data.get("device_age", 0))

        score = predict_repairability({
            "complexity": complexity,
            "cost": cost,
            "time": time,
            "availability": availability
        }, device_age)

        return jsonify({"repairability_score": round(score, 2)})

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 🔹 Improved fuzzy matching (higher threshold & exact match fallback)
def fuzzy_match(query, text, threshold=75):
    if not text:
        return False
    match_score = process.extractOne(query, [text], scorer=fuzz.partial_ratio)
    return match_score and match_score[1] >= threshold


# 🔹 Predict Repairability Score using ML Model
def predict_repairability(problem, age):
    try:
        complexity = problem.get("complexity", 0)
        cost = problem.get("cost", 0)
        time = problem.get("time", 0)
        availability = problem.get("availability", 0)
        device_age = min(5, age)  # Limit max impact to 5

        # Prepare input for ML model
        input_data = np.array([[complexity, cost, time, availability, device_age]])
        input_scaled = X_scaler.transform(input_data)

        # Predict using SVM Model
        pred_scaled = svm_model.predict(input_scaled)
        pred_original = y_scaler.inverse_transform([[pred_scaled[0]]])[0][0] / 10  # Scale back to 0-10

        return max(0, round(pred_original, 2))

    except Exception as e:
        print(f"Error in ML prediction: {e}")
        return 0  # Return a default repairability score in case of failure


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
