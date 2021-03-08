from PIL import Image
import pytesseract
import cv2
import os
from flask import jsonify

def converseOCR(gray,filename):
	# Ghi tạm ảnh xuống ổ cứng để sau đó apply OCR
	# filename = "{}.png".format(os.getpid())
	cv2.imwrite(filename, gray)

	# Load ảnh và apply nhận dạng bằng Tesseract OCR
	text = pytesseract.image_to_string(Image.open(filename), lang='vie')

	# # Xóa ảnh tạm sau khi nhận dạng
	# os.remove(filename)
	print(text)

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

	listStr=list(filter(str.strip, strSymptom.split(': ')))
	if len(listStr)>2:
		symptom = listStr[1].replace("'","")
		return jsonify({"title": title, "symptom": symptom})
	else:
		return jsonify({"title":title})