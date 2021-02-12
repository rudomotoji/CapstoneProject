class SymptomDTO {
  int id;
  String code;
  String description;

  SymptomDTO({this.id, this.code, this.description});

  @override
  String toString() {
    return '${description} (${code})';
  }
}
