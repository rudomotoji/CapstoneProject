import argparse

from PIL import Image
import pytesseract
import cv2
import os
from flask import jsonify

def converseOCR(gray,filename):
	cv2.imwrite(filename, gray)

	# Load ảnh và apply nhận dạng bằng Tesseract OCR
	text = pytesseract.image_to_string(Image.open(filename), lang='vie')

	# # Xóa ảnh tạm sau khi nhận dạng
	os.remove(filename)

	arrData = list(filter(str.strip, text.split('\n')))
	return getInfo(arrData)

def getInfo(arrData):
	strSymptom=""
	title=""
	for element in arrData:
		if element.find('PHIẾU') != -1:
			title=element
		elif element.find("Triệu chứng") != -1:
			strSymptom += element
		elif strSymptom.find(":") != -1:
			if element.find('-') != -1:
				strSymptom += element
			elif element.find('(') != -1:
				strSymptom += element
		elif element.find('BỆNH ÁN') != -1:
			title = element

	listStr=list(filter(str.strip, strSymptom.split(':')))
	if len(listStr)>1:
		symptom = listStr[1].replace("'","")
		return jsonify({"title": title, "symptom": symptom})
	else:
		return jsonify({"title":title})

def getGrayImage(filename):
	args = argparse.ArgumentParser()
	args.add_argument("-i", "--image", help="Đường dẫn đến ảnh muốn nhận dạng", default=filename)
	args.add_argument("-p", "--preprocess", type=str, default="thresh", help="Bước tiền xử lý ảnh")
	args = vars(args.parse_args())

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

	return converseOCR(gray,filename)
