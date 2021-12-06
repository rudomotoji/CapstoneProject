class DateRequestDTO {
  String id;
  int dateAfter;

  DateRequestDTO({this.id, this.dateAfter});

  DateRequestDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateAfter = json['dateAfter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dateAfter'] = this.dateAfter;
    return data;
  }
}
