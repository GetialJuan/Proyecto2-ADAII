
from PUEnTe.PUEnTe import PUEnTe  # Import the PUEnTe function
from utils.write_dzn import write_json_to_dzn  # Import the write_json_to_dzn function
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/solve_puente', methods=['POST'])
def solve_PUEnTe():
    try:
        body = request.get_json()
        
        data = body['data']
        filename = body['filename']
        file_path = f"./PUEnTe/dzn_files/{filename}.dzn"
        
        write_json_to_dzn(data, file_path)
        
        result = PUEnTe(file_path)
        
        return jsonify({"result":result, "filename":filename}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
