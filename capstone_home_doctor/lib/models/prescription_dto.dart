class PrescriptionDTO {
  String doctorName;
  String dateFrom;
  String dateTo;
  List<String> diseases;

  PrescriptionDTO({this.doctorName, this.dateFrom, this.dateTo, this.diseases});
}
