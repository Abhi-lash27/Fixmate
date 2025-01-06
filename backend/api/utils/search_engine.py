import json
from difflib import SequenceMatcher

def load_data(file_path):
    """
    Load the dataset from a JSON file.
    """
    with open(file_path, "r") as file:
        return json.load(file)

def calculate_repairability(entry):
    """
    Calculate the repairability score for a given problem entry.
    """
    weights = {
        "complexity": 0.3,
        "cost": 0.3,
        "time": 0.2,
        "availability": 0.2
    }
    score = 100 - (
        weights["complexity"] * entry.get("complexity", 0) * 5 +
        weights["cost"] * entry.get("cost", 0) * 5 +
        weights["time"] * entry.get("time", 0) * 5 +
        weights["availability"] * entry.get("availability", 0) * 5
    )
    return round(score, 2)

def search_data(query, dataset):
    """
    Search for matching entries in the dataset based on keywords or question similarity.
    Also calculates repairability score for each match.
    """
    query = query.lower()
    matches = []

    for entry in dataset:
        # Match keywords
        for keyword in entry.get("keywords", []):
            if keyword.lower() in query:
                matches.append(entry)
                break

        # Match question similarity (if applicable)
        if "problem" in entry and SequenceMatcher(None, entry["problem"].lower(), query).ratio() > 0.8:
            matches.append(entry)

    # Remove duplicates
    unique_matches = {entry["id"]: entry for entry in matches}.values()

    # Add repairability score to each match
    results = []
    for entry in unique_matches:
        entry_with_score = entry.copy()
        entry_with_score["repairability_score"] = calculate_repairability(entry)
        results.append(entry_with_score)

    return results
