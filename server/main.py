from flask import Flask, request, send_file
import os
import extractor

app = Flask(__name__)

UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return 'No file part', 400
    file = request.files['file']
    if file.filename == '':
        return 'No selected file', 400
    if file and file.filename.endswith('.zip'):
        filename = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(filename)
        extractor.extract_data()
        try:
            import get_info
            get_info.get_info()
        except Exception as e:
            return f'Error while processing info: {str(e)}', 500
        return 'File uploaded successfully', 200
    return 'Invalid file type', 400

@app.route('/download', methods=['GET'])
def download_file():
    filename = 'section.pdf'
    return send_file(filename, as_attachment=True)

if __name__ == '__main__':
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    app.run(host='0.0.0.0', port=5000, debug=True)

    
