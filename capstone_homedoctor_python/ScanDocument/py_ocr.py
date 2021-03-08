from PIL import Image
import pytesseract
import cv2
import os
import argparse

def converseImageToText():
    # # Load ảnh và apply nhận dạng bằng Tesseract OCR
    # text = pytesseract.image_to_string(Image.open('test.jpg'), lang='vie')

    ap = argparse.ArgumentParser()
    ap.add_argument("-i", "--image", help="Đường dẫn đến ảnh muốn nhận dạng", default="test.jpg")
    ap.add_argument("-p", "--preprocess", type=str, default="thresh", help="Bước tiền xử lý ảnh")
    args = vars(ap.parse_args())

    # Đọc file ảnh và chuyển về ảnh xám
    image = cv2.imread(args["image"])
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Check xem có sử dụng tiền xử lý ảnh không
    # Nếu phân tách đen trắng
    if args["preprocess"] == "thresh":
        gray = cv2.threshold(gray, 0, 255,
                             cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]

    # Nếu làm mờ ảnh
    elif args["preprocess"] == "blur":
        gray = cv2.medianBlur(gray, 3)

    # Ghi tạm ảnh xuống ổ cứng để sau đó apply OCR
    filename = "{}.png".format(os.getpid())
    cv2.imwrite(filename, gray)

    # Load ảnh và apply nhận dạng bằng Tesseract OCR
    text = pytesseract.image_to_string(Image.open(filename), lang='vie')

    # Xóa ảnh tạm sau khi nhận dạng
    os.remove(filename)

    return text