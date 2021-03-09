from flask import Flask, jsonify, request,send_file
import numpy as np
import cv2
import base64
import os
from PIL import Image
from io import BytesIO
from ScropeImage import scan
from ScanDocument import py_ocr

app = Flask(__name__)

@app.route('/')
def index():
    return 'hi';

@app.route("/scanMedicalInsurance", methods=["POST"])
def parse_image():
    filename=saveimage(request.files['file'])

    scanORCBeforeScrop = py_ocr.getGrayImage(filename)
    if scanORCBeforeScrop.json['title'] == '':
        return scanORCBeforeScrop
    else:
        return scan.scandemo(filename)

def saveimage(image_file):
    data = base64.b64encode(image_file.read())
    im = Image.open(BytesIO(base64.b64decode(data)))

    OUTPUT_DIR = os.path.join(os.getcwd(), "output")
    filename = "{}.png".format(os.getpid())

    if os.path.exists(OUTPUT_DIR):
        im.save(OUTPUT_DIR + '/' + filename, 'PNG')
    else:
        os.mkdir(OUTPUT_DIR)
        im.save(OUTPUT_DIR + '/' + filename, 'PNG')
    return OUTPUT_DIR + '/' + filename

# def readb64(base64_string):
#     encoded_data = base64_string.split(',')[1]
#     # encoded_data = base64_string[23:]
#     nparr = np.fromstring(base64.b64decode(encoded_data), np.uint8)
#     img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
#     cv2.imwrite("test.jpg",img)
#     return img

if __name__ == '__main__':
    app.run(host=os.getenv('IP', '0.0.0.0'),
            port=int(os.getenv('PORT', 80)))