import 'dart:async';
import 'dart:io' as io;
import 'package:capstone_home_doctor/models/heart_rate_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:uuid/uuid.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class SQFLiteHelper {
  static Database _database;
  static const String DATABASE_NAME = 'HDrDB.db';
  static const String HEALTH_RECORD_TABLE = 'HealthRecordTbl';
  static const String MEDICAL_INSTRUCTION_TABLE = 'MedicalInstructionTbl';
  static const String MEDICAL_INSTRUCTION_TYPE_TABLE = 'MedicalInsTypeTbl';

  static const String MEDICAL_RESPONSE_TABLE = 'MedicalResponseTbl';
  static const String MEDICAL_SCHEDULE_TABLE = 'MedicalScheduleTbl';

  //vital sign
  //
  static const String VITAL_SIGN_TABLE = 'VitalSignTbl';
  static const String VITAL_SIGN_SCHEDULE = 'VitalSignScheduleTbl';

  SQFLiteHelper();

  Future<Database> get database async {
    if (null != _database) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DATABASE_NAME);
    print('path DB: $path');
    var database = await openDatabase(path, version: 2, onCreate: _onCreate);
    return database;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE ${HEALTH_RECORD_TABLE} (health_record_id PRIMARYKEY TEXT, disease TEXT, place TEXT, doctor_name TEXT, description TEXT, personal_health_record_id TEXT, date_create TEXT, contract_id TEXT)");
    await db.execute(
        "CREATE TABLE ${MEDICAL_INSTRUCTION_TABLE} (medical_instruction_id PRIMARYKEY TEXT, description TEXT, image TEXT, dianose TEXT, date_start TEXT, date_finish TEXT, medical_instruction_type_id TEXT, health_record_id TEXT)");
    await db.execute(
        'CREATE TABLE ${MEDICAL_RESPONSE_TABLE}(medical_response_id PRIMARYKEY TEXT, date_start TEXT, date_finish TEXT)');
    await db.execute(
        """CREATE TABLE ${MEDICAL_SCHEDULE_TABLE} (medical_schedule_id PRIMARYKEY TEXT, 
        medication_name TEXT, 
        content TEXT, 
        useTime TEXT, 
        unit TEXT, 
        morning INTEGER, 
        noon INTEGER, 
        afterNoon INTEGER, 
        night INTEGER,
        medical_response_id TEXT,
        FOREIGN KEY (medical_response_id) REFERENCES $MEDICAL_RESPONSE_TABLE (medical_response_id) ON DELETE NO ACTION ON UPDATE NO ACTION
        )""");
    await db.execute(
        "CREATE TABLE ${VITAL_SIGN_SCHEDULE} (id PRIMARYKEY TEXT, id_schedule INTEGER,vital_sign_schedule_id INTEGER, vital_sign_type TEXT, number_max INTEGER, number_min INTEGER, minute_danger_interval INTEGER, minute_normal_interval INTEGER, time_start TEXT, minute_again INTEGER)");
    await db.execute(
        "CREATE TABLE ${VITAL_SIGN_TABLE} (id PRIMARYKEY TEXT, patient_id INTEGER, value_type TEXT, value1 INTEGER, value2 INTEGER, date_time TEXT)");
  }

  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }

  Future<bool> cleanDatabase() async {
    // try {
    //   final db = await database;
    //   await db.transaction((txn) async {
    //     var batch = txn.batch();
    //     // batch.delete(MEDICAL_INSTRUCTION_TABLE);
    //     batch.delete(MEDICAL_RESPONSE_TABLE);
    //     batch.delete(MEDICAL_SCHEDULE_TABLE);
    //     await batch.commit();
    //   });
    // } catch (error) {
    //   throw Exception('DbBase.cleanDatabase: ' + error.toString());
    // }
    //
    try {
      var deleteMedSche = await deleteAllMedicalSchedule();
      if (deleteMedSche) {
        var deleteMedRes = await deleteMedicalResponse();
        if (deleteMedRes) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('cleanDatabase: $e');
      return false;
    }
  }

  // Future<bool> deleteDb() async {
  //   bool databaseDeleted = false;

  //   try {
  //     io.Directory documentDirectory = await getApplicationDocumentsDirectory();
  //     String path = join(documentDirectory.path, DATABASE_NAME);
  //     await deleteDatabase(path).whenComplete(() {
  //       databaseDeleted = true;
  //     }).catchError((onError) {
  //       databaseDeleted = false;
  //     });
  //   } on DatabaseException catch (error) {
  //     print(error);
  //   } catch (error) {
  //     print(error);
  //   }

  //   return databaseDeleted;
  // }

  //Medical response
  Future<String> insertMedicalResponse(PrescriptionDTO medicalResponse) async {
    String uuid = Uuid().v1();
    medicalResponse.medicalResponseID = uuid;
    var dbClient = await database;
    await dbClient.insert(MEDICAL_RESPONSE_TABLE, medicalResponse.toMap());
    return uuid;
  }

  Future<List<PrescriptionDTO>> getMedicationsRespone() async {
    var dbClient = await database;
    // PrescriptionDTO medicationsRespone = PrescriptionDTO();
    List<PrescriptionDTO> responseData = [];
    List<Map> maps = await dbClient.query(MEDICAL_RESPONSE_TABLE,
        columns: ['medical_response_id', 'date_start', 'date_finish']);
    if (maps.length > 0) {
      for (var prescription in maps) {
        responseData.add(PrescriptionDTO.fromMap(prescription));
      }
    }
    // medicationsRespone = PrescriptionDTO.fromMap(maps.first);
    return responseData;
  }

  Future<bool> deleteMedicalResponse() async {
    var dbClient = await database;
    try {
      await dbClient.delete(MEDICAL_RESPONSE_TABLE);
      return true;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  Future<void> deleteMedicalResponseByID(String id) async {
    var dbClient = await database;
    await dbClient.rawDelete(
        'DELETE FROM $MEDICAL_RESPONSE_TABLE WHERE medical_response_id = ?',
        [id]);
  }

  //Medical schedule
  Future<bool> insertMedicalSchedule(
      MedicationSchedules medicalScheduleDTO) async {
    var dbClient = await database;
    String uuid = Uuid().v1();
    medicalScheduleDTO.medicalScheduleId = uuid;
    await dbClient.insert(MEDICAL_SCHEDULE_TABLE, medicalScheduleDTO.toMap());
  }

  Future<List<MedicationSchedules>> getAll() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query(
      MEDICAL_SCHEDULE_TABLE,
      columns: [
        'medical_schedule_id',
        'medication_name',
        'content',
        'useTime',
        'unit',
        'morning',
        'noon',
        'afterNoon',
        'night',
        'medical_response_id'
      ],
    );
    List<MedicationSchedules> responseData = [];
    if (maps.length > 0) {
      for (var medicationSchedule in maps) {
        responseData.add(MedicationSchedules.fromMap(medicationSchedule));
      }
    }
    return responseData;
  }

  Future<List<MedicationSchedules>> getAllBy(String session) async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query(MEDICAL_SCHEDULE_TABLE,
        columns: [
          'medical_schedule_id',
          'medication_name',
          'content',
          'useTime',
          'unit',
          'morning',
          'noon',
          'afterNoon',
          'night',
          'medical_response_id'
        ],
        where: '$session > 0');
    List<MedicationSchedules> responseData = [];
    if (maps.length > 0) {
      for (var medicationSchedule in maps) {
        responseData.add(MedicationSchedules.fromMap(medicationSchedule));
      }
    }
    return responseData;
  }

  Future<List<MedicationSchedules>> getAllByMedicalResponseID(
      String medicalResponseID) async {
    var dbClient = await database;
    List<Map> maps = await dbClient.rawQuery(
        'SELECT * FROM $MEDICAL_SCHEDULE_TABLE WHERE medical_response_id = ?',
        [medicalResponseID]);
    List<MedicationSchedules> responseData = [];
    if (maps.length > 0) {
      for (var medicationSchedule in maps) {
        responseData.add(MedicationSchedules.fromMap(medicationSchedule));
      }
    }
    return responseData;
  }

  Future<bool> deleteAllMedicalSchedule() async {
    var dbClient = await database;
    try {
      await dbClient.delete(MEDICAL_SCHEDULE_TABLE);
      return true;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  Future<void> deleteMedicalScheduleByID(String id) async {
    var dbClient = await database;
    await dbClient.rawDelete(
        'DELETE FROM $MEDICAL_SCHEDULE_TABLE WHERE medical_response_id = ?',
        [id]);
  }

  //VITAL_SIGN_TABLE
  Future<void> insertVitalSign(VitalSignDTO dto) async {
    var dbClient = await database;
    try {
      //
      await dbClient.insert(VITAL_SIGN_TABLE, dto.toMapSQL());
      print(
          'Insert Vital Sign type ${dto.valueType} successful at ${DateTime.now()}');
    } catch (e) {
      print('ERROR at Insert Vital Sign ${e}');
    }
  }

  Future<List<VitalSignDTO>> getListVitalSign(
      String value_type, int patient_id) async {
    var dbClient = await database;
    try {
      //
      var maps = await dbClient.rawQuery(
          'SELECT * FROM $VITAL_SIGN_TABLE WHERE value_type = ? AND patient_id = ?',
          [value_type, patient_id]);
      List<VitalSignDTO> listVitalSign = [];
      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          listVitalSign.add(VitalSignDTO.fromMapSQL(maps[i]));
        }
        print(
            'GET LIST Vital Sign type ${value_type} successful at ${DateTime.now()}');
        return listVitalSign;
      }
    } catch (e) {
      print('ERROR at get heart rate list ${e}');
    }
  }

  Future<void> deleteRecordsVitalSign(String valueType, int patientId) async {
    var dbClient = await database;
    try {
      await dbClient.rawQuery(
          'DELETE FROM $VITAL_SIGN_TABLE WHERE value_type = ? AND patient_id = ?',
          [valueType, patientId]);
    } catch (e) {
      print('ERROR at delete heart rate by patientId ${e}');
    }
  }

  //VITAL SIGN SCHEDULE
  Future<void> insertVitalSignSchedule(VitalSigns dto) async {
    //
    var dbClient = await database;
    try {
      //
      await dbClient.insert(VITAL_SIGN_SCHEDULE, dto.toMapSQL());
      print(
          'INSERT VitalSign Schedule ${dto.vitalSignType} Successful at ${DateTime.now()}');
    } catch (e) {
      print('ERROR at insert VitalSign Schedule: $e');
    }
  }

  Future<List<VitalSigns>> getVitalSignScheduleOffline() async {
    var dbClient = await database;
    try {
      List<VitalSigns> list = [];
      //
      var maps = await dbClient.rawQuery('SELECT * FROM $VITAL_SIGN_SCHEDULE');

      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          list.add(VitalSigns.fromMapSQL(maps[i]));
        }
      }
      return list;
    } catch (e) {
      print('Error at getVitalSignScheduleOffline: ${e}');
    }
  }

  Future<bool> deleteVitalSignSchedule() async {
    var dbClient = await database;
    try {
      await dbClient.delete(VITAL_SIGN_SCHEDULE);
      print('DELETE VITAL SIGN SCHEDULE OFFLINE SUCCESSFUL');
      return true;
    } catch (e) {
      print('ERROR at delete heart rate by patientId ${e}');
      return false;
    }
  }
}
