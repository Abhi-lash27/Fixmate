from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
from utils.search_engine import load_data
from rapidfuzz import process

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

# Load the dataset once during app initialization
dataset = load_data("data/train_data.json")

@app.route("/api/search", methods=["POST"])
@cross_origin()
def search():
    try:
        data = request.json
        brand = data.get("brand", "").strip()
        model = data.get("model", "").strip()
        problem = data.get("problem", "").strip()
        age = int(data.get("age", 0))

        if not all([brand, model, problem, age]):
            return jsonify({"error": "Missing required fields: brand, model, age, or problem"}), 400

        # Filter by brand and model with fuzzy matching
        matching_devices = [
            device for device in dataset
            if fuzzy_match(brand, device["brand"]) and fuzzy_match(model, device["model"])
        ]

        if not matching_devices:
            return jsonify({"error": "No matching results found"}), 404

        # Flatten problems for keyword-based ranking
        problems_list = [
            {**problem, "device": device}
            for device in matching_devices
            for problem in device.get("problems", [])
        ]

        # Rank results by problem similarity
        ranked_problems = rank_results_by_problem(problems_list, problem)

        # Add repairability score and include steps/tools
        enriched_results = [
            {
                "brand": problem["device"]["brand"],
                "model": problem["device"]["model"],
                "age": problem["device"]["age"],
                "problem": problem["problem_description"],
                "solutions": problem["solutions"],
                "repairability_score": calculate_repairability(problem, age),
            }
            for problem in ranked_problems
        ]

        # Paginate results
        page = int(request.args.get("page", 1))
        per_page = int(request.args.get("per_page", 5))
        total_results = len(enriched_results)
        paginated_results = enriched_results[(page - 1) * per_page: page * per_page]

        return jsonify({
            "query": problem,
            "results": paginated_results,
            "page": page,
            "total_pages": (total_results + per_page - 1) // per_page,
            "total_results": total_results,
        }), 200

    except Exception as e:
        return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500


def fuzzy_match(query, text, threshold=75):
    match_score = process.extractOne(query, [text])
    return match_score[1] >= threshold if match_score else False


def rank_results_by_problem(problems, problem_query):
    ranked = process.extract(problem_query, [problem["problem_description"] for problem in problems], limit=len(problems))
    ranked_ids = {result[0]: idx for idx, result in enumerate(ranked)}
    return sorted(problems, key=lambda x: ranked_ids.get(x["problem_description"], float('inf')))


def calculate_repairability(problem, age):
    weights = {"complexity": 0.3, "cost": 0.3, "time": 0.2, "availability": 0.2, "age": 0.1}
    complexity = problem.get("complexity", 0)
    cost = problem.get("cost", 0)
    time = problem.get("time", 0)
    availability = problem.get("availability", 0)
    age_factor = max(0, 5 - age)

    score = 100 - (
        weights["complexity"] * complexity * 5
        + weights["cost"] * cost * 5
        + weights["time"] * time * 5
        + weights["availability"] * availability * 5
        + weights["age"] * age_factor * 5
    )
    return max(0, round(score, 2))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)

