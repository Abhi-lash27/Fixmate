from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
from utils.search_engine import load_data
from rapidfuzz import process, fuzz

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

# Load dataset on initialization
dataset = load_data("data/train_data.json")

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
                "repairability_score": calculate_repairability(problem, age),
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


# 🔹 Improved fuzzy matching (higher threshold & exact match fallback)
def fuzzy_match(query, text, threshold=75):
    if not text:
        return False
    match_score = process.extractOne(query, [text], scorer=fuzz.partial_ratio)
    return match_score and match_score[1] >= threshold


# 🔹 Repairability score calculation
def calculate_repairability(problem, age):
    weights = {"complexity": 0.3, "cost": 0.3, "time": 0.2, "availability": 0.2, "age": 0.1}
    complexity = problem.get("complexity", 0)
    cost = problem.get("cost", 0)
    time = problem.get("time", 0)
    availability = problem.get("availability", 0)
    age_factor = min(5, age)  # Directly use age but limit max impact to 5


    score = 100 - (
        weights["complexity"] * complexity * 5 +
        weights["cost"] * cost * 5 +
        weights["time"] * time * 5 +
        weights["availability"] * availability * 5 +
        weights["age"] * age_factor * 5
    )
    score = score / 10  # Display score on 0-10 scale
    return max(0, round(score, 2))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
