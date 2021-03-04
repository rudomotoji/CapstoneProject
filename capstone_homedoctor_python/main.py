from flask import Flask, jsonify, request
from ScanDocument import py_ocr
import numpy as np
import cv2
import base64
import os
from werkzeug.utils import secure_filename
from PIL import Image
from io import BytesIO

app = Flask(__name__)

@app.route('/')
def index():
    return 'hi';

@app.route("/scanMedicalInsurance", methods=["POST"])
def parse_image():
    # req_data = request.get_json()
    # imageStr = req_data['medicalInsurance']
    saveimage(request.files['file'])
    # readb64(imageStr)

    data = py_ocr.converseImageToText()
    os.remove('test.jpg')
    return jsonify({'data':data})

def saveimage(image_file):
    data = base64.b64encode(image_file.read())
    im = Image.open(BytesIO(base64.b64decode(data)))
    im.save('test.jpg', 'PNG')

def readb64(base64_string):
    encoded_data = base64_string.split(',')[1]
    # encoded_data = base64_string[23:]
    nparr = np.fromstring(base64.b64decode(encoded_data), np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    cv2.imwrite("test.jpg",img)
    return img

if __name__ == '__main__':
    app.run(host=os.getenv('IP', '0.0.0.0'),
            port=int(os.getenv('PORT', 80)))