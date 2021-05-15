class AdvertisementDTO {
  String id;
  String adImage;
  String title;
  String description;

  AdvertisementDTO({this.id, this.adImage, this.title, this.description});

  AdvertisementDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adImage = json['adImage'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['adImage'] = this.adImage;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
