class ImageScannerDTO {
  String symptom;
  String title;
  double titleCompare;

  ImageScannerDTO({this.symptom, this.title, this.titleCompare});

  ImageScannerDTO.fromJson(Map<String, dynamic> json) {
    symptom = json['symptom'];
    title = json['title'];
    titleCompare = json['titleCompare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symptom'] = this.symptom;
    data['title'] = this.title;
    data['titleCompare'] = this.titleCompare;
    return data;
  }
}
