//MOCKUP API CLASS
// class DoctorDTO {
//   String id;
//   String userName;
//   String password;
//   String fullName;
//   String workLocation;
//   String dateOfBirth;
//   int experienceYear;

//   DoctorDTO(
//       {this.id,
//       this.userName,
//       this.password,
//       this.fullName,
//       this.workLocation,
//       this.dateOfBirth,
//       this.experienceYear});

//   DoctorDTO.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userName = json['userName'];
//     password = json['password'];
//     fullName = json['fullName'];
//     workLocation = json['workLocation'];
//     dateOfBirth = json['dateOfBirth'];
//     experienceYear = json['experienceYear'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['userName'] = this.userName;
//     data['password'] = this.password;
//     data['fullName'] = this.fullName;
//     data['workLocation'] = this.workLocation;
//     data['dateOfBirth'] = this.dateOfBirth;
//     data['experienceYear'] = this.experienceYear;
//     return data;
//   }
// }

//REAL API CLASS
class DoctorDTO {
  int doctorId;
  int accountId;
  String username;
  String fullName;
  String workLocation;
  String experience;
  String specialization;
  String address;
  String details;
  String phone;
  String email;
  String dateOfBirth;

  DoctorDTO(
      {this.doctorId,
      this.accountId,
      this.username,
      this.fullName,
      this.workLocation,
      this.experience,
      this.specialization,
      this.address,
      this.details,
      this.phone,
      this.email,
      this.dateOfBirth});

  DoctorDTO.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    accountId = json['accountId'];
    username = json['username'];
    fullName = json['fullName'];
    workLocation = json['workLocation'];
    experience = json['experience'];
    specialization = json['specialization'];
    address = json['address'];
    details = json['details'];
    phone = json['phone'];
    email = json['email'];
    dateOfBirth = json['dateOfBirth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['accountId'] = this.accountId;
    data['username'] = this.username;
    data['fullName'] = this.fullName;
    data['workLocation'] = this.workLocation;
    data['experience'] = this.experience;
    data['specialization'] = this.specialization;
    data['address'] = this.address;
    data['details'] = this.details;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['dateOfBirth'] = this.dateOfBirth;
    return data;
  }
}
