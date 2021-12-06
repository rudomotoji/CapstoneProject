class MedicineDTO {
  String medicationName;
  String content;
  String unit;
  String description;
  String useTime;
  int morning;
  int afternoon;
  int noon;
  int night;

  MedicineDTO({
    this.medicationName,
    this.content,
    this.unit,
    this.description,
    this.useTime,
    this.morning,
    this.afternoon,
    this.night,
    this.noon,
  });
}
