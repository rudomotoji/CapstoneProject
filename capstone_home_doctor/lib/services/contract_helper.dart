import 'package:shared_preferences/shared_preferences.dart';

class ContractHelper {
  //FOR SENT REQUEST CONTRACT
  Future<void> initialContractSendRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('CONTRACT_REQUEST', false);
    prefs.setString('MESSAGE_REQUEST_CONTRACT', '');
  }

  Future<void> updateContractSendStatus(bool isSent, String msg) async {
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('CONTRACT_REQUEST') ||
        prefs.getBool('CONTRACT_REQUEST') == null) {
      //
      initialContractSendRequest();
    }
    if (!prefs.containsKey('MESSAGE_REQUEST_CONTRACT') ||
        prefs.getString('MESSAGE_REQUEST_CONTRACT') == null) {
      //
      initialContractSendRequest();
    }
    prefs.setBool('CONTRACT_REQUEST', isSent);
    prefs.setString('MESSAGE_REQUEST_CONTRACT', msg);
  }

  Future<String> getMsgSendContract() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('MESSAGE_REQUEST_CONTRACT') ||
        prefs.getString('MESSAGE_REQUEST_CONTRACT') == null) {
      //
      initialContractSendRequest();
    }
    return prefs.getString('MESSAGE_REQUEST_CONTRACT');
  }

  Future<bool> isSent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('CONTRACT_REQUEST') ||
        prefs.getBool('CONTRACT_REQUEST') == null) {
      //
      initialContractSendRequest();
    }

    return prefs.getBool('CONTRACT_REQUEST');
  }

  //FOR DOCTOR HELPER
  Future<void> initialDoctorId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('DOCTOR_ID', 0);
  }

  Future<void> updateDoctorId(int id) async {
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('DOCTOR_ID') || prefs.getInt('DOCTOR_ID') == null) {
      initialDoctorId();
    }
    prefs.setInt('DOCTOR_ID', id);
  }

  Future<int> getDoctorId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('DOCTOR_ID') || prefs.getInt('DOCTOR_ID') == null) {
      initialDoctorId();
    }
    return prefs.getInt('DOCTOR_ID');
  }

  //FOR CONTRACT CHECKING
  Future<void> initialContractCheckingRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('CONTRACT_CHECKING', false);
    prefs.setString('MESSAGE_CHECKING_CONTRACT', '');
  }

  Future<void> updateContractCheckingStatus(bool isSent, String msg) async {
    //
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('CONTRACT_CHECKING') ||
        prefs.getBool('CONTRACT_CHECKING') == null) {
      //
      initialContractCheckingRequest();
    }
    if (!prefs.containsKey('MESSAGE_CHECKING_CONTRACT') ||
        prefs.getString('MESSAGE_CHECKING_CONTRACT') == null) {
      //
      initialContractCheckingRequest();
    }
    prefs.setBool('CONTRACT_CHECKING', isSent);
    prefs.setString('MESSAGE_CHECKING_CONTRACT', msg);
  }

  Future<String> getMsgCheckingContract() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('MESSAGE_CHECKING_CONTRACT') ||
        prefs.getString('MESSAGE_CHECKING_CONTRACT') == null) {
      //
      initialContractCheckingRequest();
    }
    return prefs.getString('MESSAGE_CHECKING_CONTRACT');
  }

  Future<bool> isAcceptable() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('CONTRACT_CHECKING') ||
        prefs.getBool('CONTRACT_CHECKING') == null) {
      //
      initialContractCheckingRequest();
    }

    return prefs.getBool('CONTRACT_CHECKING');
  }
}
