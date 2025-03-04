# FixMate

## Overview
FixMate is a **mobile repair assistant** that leverages **machine learning** to assess device repairability. It provides users with solutions, repairability scores, community discussions, and nearby service center recommendations. The application is built using **Flutter** and integrates APIs to facilitate keyword-based searching and machine learning-based repairability scoring.

## Features
- **Problem Diagnosis**: Users describe the issue, and FixMate provides relevant solutions.
- **Repairability Score**: Machine learning model predicts how easy a repair is based on factors like device age, problem complexity, and spare part availability.
- **Keyword-Based Search**: Finds relevant solutions based on user input.
- **Step-by-Step Repair Guides**: Displays detailed instructions for troubleshooting and fixing the problem.
- **Community Forum**: Users can discuss issues, share solutions, and contribute to repair guides.
- **Nearby Service Center Recommendations**: Integrated maps for locating and recommending service centers.
- **User Registration/Login**: Secure authentication using Firebase.

## Technology Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Flask (Python)
- **Database**: Firestore (for real-time collaboration)
- **Machine Learning Model**: Random Forest & SVM for repairability score prediction
- **Authentication & Cloud Services**: Firebase
- **Maps Integration**: Flutter Maps API
- **Storage**: JSON-based storage for solutions and repairability data

## Installation
### Prerequisites
- Flutter SDK installed
- Dart installed
- Python with Flask and required dependencies
- Firebase setup for authentication and Firestore database

### Steps
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/FixMate.git
   cd FixMate
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

For backend setup:
1. Navigate to the backend folder:
   ```sh
   cd backend
   ```
2. Install Python dependencies:
   ```sh
   pip install -r requirements.txt
   ```
3. Run the Flask server:
   ```sh
   python app.py
   ```

## API Endpoints
| Endpoint        | Method | Description |
|----------------|--------|-------------|
| `/search`      | POST   | Retrieves solutions based on keyword matching |
| `/prdict`       | POST   | Returns the repairability score for a given issue |


## Contribution Guidelines
- Fork the repository and create a feature branch.
- Commit changes with descriptive messages.
- Submit a pull request with details of changes.


## Contact
For queries, feel free to reach out at **babhilash27@gmail.com** or raise an issue in the repository.

---
**FixMate** - Making mobile repair easier and accessible for everyone!

