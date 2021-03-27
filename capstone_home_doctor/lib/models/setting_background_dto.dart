class SettingBackgroundDTO {
  int id;
  int backgroundRun;
  int insertLocal;

  SettingBackgroundDTO({this.id, this.backgroundRun, this.insertLocal});

  SettingBackgroundDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    backgroundRun = json['backgroundRun'];
    insertLocal = json['insertLocal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['backgroundRun'] = this.backgroundRun;
    data['insertLocal'] = this.insertLocal;
    return data;
  }
}

class SafeScopeHeartRateDTO {
  String id;
  int minSafeHeartRate;
  int maxSafeHeartRate;
  int dangerousCount;

  SafeScopeHeartRateDTO(
      {this.id,
      this.minSafeHeartRate,
      this.maxSafeHeartRate,
      this.dangerousCount});

  SafeScopeHeartRateDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    minSafeHeartRate = json['minSafeHeartRate'];
    maxSafeHeartRate = json['maxSafeHeartRate'];
    dangerousCount = json['dangerousCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['minSafeHeartRate'] = this.minSafeHeartRate;
    data['maxSafeHeartRate'] = this.maxSafeHeartRate;
    data['dangerousCount'] = this.dangerousCount;
    return data;
  }
}
