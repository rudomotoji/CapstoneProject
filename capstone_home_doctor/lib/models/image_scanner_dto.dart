class imageScannerDTO {
  String symptom;
  String title;

  imageScannerDTO({this.symptom, this.title});

  imageScannerDTO.fromJson(Map<String, dynamic> json) {
    symptom = json['symptom'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symptom'] = this.symptom;
    data['title'] = this.title;
    return data;
  }
}
