class DoctorDTO {
  String id;
  String userName;
  String password;
  String fullName;
  String workLocation;
  String dateOfBirth;
  int experienceYear;

  DoctorDTO(
      {this.id,
      this.userName,
      this.password,
      this.fullName,
      this.workLocation,
      this.dateOfBirth,
      this.experienceYear});

  DoctorDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    password = json['password'];
    fullName = json['fullName'];
    workLocation = json['workLocation'];
    dateOfBirth = json['dateOfBirth'];
    experienceYear = json['experienceYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['fullName'] = this.fullName;
    data['workLocation'] = this.workLocation;
    data['dateOfBirth'] = this.dateOfBirth;
    data['experienceYear'] = this.experienceYear;
    return data;
  }
}
