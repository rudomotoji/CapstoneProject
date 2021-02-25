// class PrescriptionDTO {
//   String doctorName;
//   String dateFrom;
//   String dateTo;
//   List<String> diseases;

//   PrescriptionDTO({this.doctorName, this.dateFrom, this.dateTo, this.diseases});
// }
import 'package:capstone_home_doctor/models/medicine_scheduling_dto.dart';

class PrescriptionDTO {
  String healthRecordId;
  String diagnose;
  String startDate;
  String endDate;
  List<MedicineDTO> listMedicine;

  PrescriptionDTO(
      {this.healthRecordId,
      this.diagnose,
      this.startDate,
      this.endDate,
      this.listMedicine});
}
