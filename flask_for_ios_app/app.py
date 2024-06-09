from flask import Flask, jsonify, request
from io import StringIO
from contextlib import redirect_stdout

app = Flask(__name__)

@app.route('/', methods= ['POST'])
def execute_code():

    data = request.get_json()
    if 'code' not in data:
        return jsonify({'error': 'Missing "code" parameter'}), 400
        
    python_code = data['code']
    
    # Use StringIO to capture the output
    output = StringIO()

    # Redirect stdout to the StringIO object
    with redirect_stdout(output):
        try:
            exec(python_code)
        except Exception as e:
            return jsonify({'error': str(python_code), 'message': str(e)}), 400

    # Get the captured output
    output_str = output.getvalue()

    return jsonify({'output': output_str})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
