class MedicineSchedulingDTO {
  String name;
  String amount;
  int totalDay;
  String unit;
  int unitPerDay;
  int timePerDay;
  String howToUsing;
  bool isMorning;
  bool isNoon;
  bool isNight;

  MedicineSchedulingDTO(
      {this.name,
      this.amount,
      this.totalDay,
      this.unit,
      this.unitPerDay,
      this.howToUsing,
      this.timePerDay,
      this.isMorning,
      this.isNight,
      this.isNoon});
}
