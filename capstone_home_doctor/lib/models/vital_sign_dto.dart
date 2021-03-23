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
}
