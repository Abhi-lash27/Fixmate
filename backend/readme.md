# Keyword Based Searching

Keyword-based searching identifies relevant data by matching input keywords with pre-defined keywords in the dataset, enabling quick and efficient retrieval of related information.

## Dependencies
- Flask
- Flask-CORS
- SequenceMatcher

## Install Dependencies
```
pip install flask flask-cors 
```

## Run Script
```
python api/app.py
```
## API Endpoint
- Method: POST - /api/search

## API Body: 
Pass the keywords in the req.body
```json
{
  "query": "ipc"
}
```
