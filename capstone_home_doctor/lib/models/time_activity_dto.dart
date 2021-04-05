class TimeActDTO {
  String month;
  List<int> days;

  TimeActDTO({this.month, this.days});

  TimeActDTO.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    days = json['days'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['days'] = this.days;
    return data;
  }
}
