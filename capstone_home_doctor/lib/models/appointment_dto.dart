class AppointmentDTO {
  String date;
  String time;
  String place;

  AppointmentDTO({this.date, this.time, this.place});

  AppointmentDTO.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    place = json['place'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'date': date,
      'time': time,
      'place': place,
    };
    return map;
  }

  AppointmentDTO.fromMap(Map<String, dynamic> map) {
    date = map['date'];
    time = map['time'];
    place = map['place'];
  }
}
