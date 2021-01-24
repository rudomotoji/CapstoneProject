class RequestContractDTO {
  String doctorId;
  String patientId;
  String dateStarted;
  String dateFinished;
  String reason;

  RequestContractDTO({
    this.doctorId,
    this.patientId,
    this.dateStarted,
    this.dateFinished,
    this.reason,
  });
}
