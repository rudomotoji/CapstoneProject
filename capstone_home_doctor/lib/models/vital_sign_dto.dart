class VitalSignDTO {
  String id;
  int patientId;
  String valueType;
  int value1;
  int value2;
  String dateTime;

  VitalSignDTO(
      {this.id,
      this.patientId,
      this.valueType,
      this.value1,
      this.value2,
      this.dateTime});

  //
  Map<String, dynamic> toMapSQL() {
    var map = <String, dynamic>{
      'id': id,
      'patient_id': patientId,
      'value_type': valueType,
      'value1': value1,
      'value2': value2,
      'date_time': dateTime,
    };
    return map;
  }

  //
  VitalSignDTO.fromMapSQL(Map<String, dynamic> map) {
    id = map['id'];
    patientId = map['patient_id'];
    valueType = map['value_type'];
    value1 = map['value1'];
    value2 = map['value2'];
    dateTime = map['date_time'];
  }

  String toValueString() {
    // TODO: implement toString
    return '$value1,';
  }

  String toDateString() {
    return '${dateTime.split(' ')[1].split(':')[0].toString()}g ${dateTime.split(' ')[1].split(':')[1].toString()}p';
  }

  String toDatePush() {
    return '${dateTime.split(' ')[1].split(':')[0].toString()}:${dateTime.split(' ')[1].split(':')[1].toString()}';
  }

  String toTimeMinString() {
    return '${dateTime.split(' ')[1].split(':')[1].toString()},';
  }
  //:${dateTime.split(' ')[1].split(':')[1].toString()
}
