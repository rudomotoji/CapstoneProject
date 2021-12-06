class MedicalInstructionTypeDTO {
  int medicalInstructionTypeId;
  String name;
  String status;

  MedicalInstructionTypeDTO(
      {this.medicalInstructionTypeId, this.name, this.status});

  MedicalInstructionTypeDTO.fromJson(Map<String, dynamic> json) {
    medicalInstructionTypeId = json['medicalInstructionTypeId'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalInstructionTypeId'] = this.medicalInstructionTypeId;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
