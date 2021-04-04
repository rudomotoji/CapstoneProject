import 'package:shared_preferences/shared_preferences.dart';

class MedicalInstructionHelper {
  Future<void> initialMedicalInstructionCreate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('MED_INSTRUCTION_CREATE', false);
  }

  Future<void> updateMedicalInstructionCreate(bool isSent) async {
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('MED_INSTRUCTION_CREATE') ||
        prefs.getBool('MED_INSTRUCTION_CREATE') == null) {
      //
      initialMedicalInstructionCreate();
    }

    prefs.setBool('MED_INSTRUCTION_CREATE', isSent);
  }

  Future<bool> getMedicalInsCreate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('MED_INSTRUCTION_CREATE') ||
        prefs.getBool('MED_INSTRUCTION_CREATE') == null) {
      //
      initialMedicalInstructionCreate();
    }

    return prefs.getBool('MED_INSTRUCTION_CREATE');
  }

  ///kiểm tra từ tạo hồ sơ sang chi tiết HAY là từ
  ///danh sách bấm vô chi tiết
  Future<void> initialCheckToCreateOrList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('CHECK_TO_CREATE_OR_LIST', false);
  }

  Future<void> updateCheckToCreateOrList(bool check) async {
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('CHECK_TO_CREATE_OR_LIST') ||
        prefs.getBool('CHECK_TO_CREATE_OR_LIST') == null) {
      //
      initialCheckToCreateOrList();
    }

    prefs.setBool('CHECK_TO_CREATE_OR_LIST', check);
  }

  Future<bool> getCheckToCreateOrList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('CHECK_TO_CREATE_OR_LIST') ||
        prefs.getBool('CHECK_TO_CREATE_OR_LIST') == null) {
      //
      initialCheckToCreateOrList();
    }

    return prefs.getBool('CHECK_TO_CREATE_OR_LIST');
  }
}
