class HistoryVitalSignDTO {
  String dateCreate;
  List<DataDTO> data;

  HistoryVitalSignDTO({this.dateCreate, this.data});

  HistoryVitalSignDTO.fromJson(Map<String, dynamic> json) {
    dateCreate = json['dateCreate'];
    if (json['data'] != null) {
      data = new List<DataDTO>();
      json['data'].forEach((v) {
        data.add(new DataDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateCreate'] = this.dateCreate;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataDTO {
  String time;
  String status;
  String value;

  DataDTO({this.time, this.status, this.value});

  DataDTO.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    status = json['status'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['status'] = this.status;
    data['value'] = this.value;
    return data;
  }
}
