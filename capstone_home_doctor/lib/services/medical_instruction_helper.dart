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
}
