from PIL import Image
import pytesseract
import cv2
import os

def converseOCR(gray):
	# Ghi tạm ảnh xuống ổ cứng để sau đó apply OCR
	filename = "{}.png".format(os.getpid())
	cv2.imwrite(filename, gray)

	# Load ảnh và apply nhận dạng bằng Tesseract OCR
	text = pytesseract.image_to_string(Image.open(filename), lang='vie')

	# Xóa ảnh tạm sau khi nhận dạng
	os.remove(filename)
    os.remove('test.jpg')

	arrData = list(filter(str.strip, text.split('\n')))
	print(arrData)

	return text