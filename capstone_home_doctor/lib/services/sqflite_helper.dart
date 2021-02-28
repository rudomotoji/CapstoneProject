import 'dart:async';
import 'dart:io' as io;

import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class SQFLiteHelper {
  static Database _database;
  static const String DATABASE_NAME = 'HDrDB.db';
  static const String HEALTH_RECORD_TABLE = 'HealthRecordTbl';
  static const String MEDICAL_INSTRUCTION_TABLE = 'MedicalInstructionTbl';
  static const String MEDICAL_INSTRUCTION_TYPE_TABLE = 'MedicalInsTypeTbl';

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
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE ${HEALTH_RECORD_TABLE} (health_record_id PRIMARYKEY TEXT, disease TEXT, place TEXT, doctor_name TEXT, description TEXT, personal_health_record_id TEXT, date_create TEXT, contract_id TEXT)");
    await db.execute(
        "CREATE TABLE ${MEDICAL_INSTRUCTION_TABLE} (medical_instruction_id PRIMARYKEY TEXT, description TEXT, image TEXT, dianose TEXT, date_start TEXT, date_finish TEXT, medical_instruction_type_id TEXT, health_record_id TEXT)");
  }

  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }

  // //
  // //HEALTH_RECORD_TABLE
  // Future<void> insertHealthRecord(HealthRecordDTO dto) async {
  //   var dbClient = await database;
  //   await dbClient.insert(HEALTH_RECORD_TABLE, dto.toMapSqflite());
  // }

  // Future<HealthRecordDTO> findHealthRecordById(String healthRecordId) async {
  //   var dbClient = await database;
  //   var maps = await dbClient.query(HEALTH_RECORD_TABLE,
  //       columns: [
  //         'health_record_id',
  //         'disease',
  //         'place',
  //         'doctor_name',
  //         'description',
  //         'personal_health_record_id',
  //         'date_create',
  //         'contract_id',
  //       ],
  //       where: 'health_record_id = ?',
  //       whereArgs: [healthRecordId]);
  //   HealthRecordDTO dto = HealthRecordDTO();
  //   if (maps.length > 0) {
  //     dto = HealthRecordDTO.fromMapSqflite(maps.first);
  //   }
  //   return dto;
  // }

  // Future<List<HealthRecordDTO>> getListHealthRecord(
  //     String personalHealthRecordId) async {
  //   var dbClient = await database;
  //   List<Map> maps = await dbClient.query(HEALTH_RECORD_TABLE,
  //       columns: [
  //         'health_record_id',
  //         'disease',
  //         'place',
  //         'doctor_name',
  //         'description',
  //         'personal_health_record_id',
  //         'date_create',
  //         'contract_id',
  //       ],
  //       where: 'personal_health_record_id = ?',
  //       whereArgs: [personalHealthRecordId]);
  //   List<HealthRecordDTO> listHealthRecord = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       listHealthRecord.add(HealthRecordDTO.fromMapSqflite(maps[i]));
  //     }
  //   }
  //   return listHealthRecord;
  // }

  // Future<void> deleteHealthRecord(String healthRecordId) async {
  //   bool isDeleted = false;
  //   var dbClient = await database;
  //   int check = await dbClient.delete(HEALTH_RECORD_TABLE,
  //       where: 'health_record_id = ?', whereArgs: [healthRecordId]);
  // }

  // //
  // //MEDICAL_INSTRUCTION_TABLE
  // Future<void> insertMedicalIns(MedicalInstructionDTO dto) async {
  //   var dbClient = await database;
  //   await dbClient.insert(MEDICAL_INSTRUCTION_TABLE, dto.toMapSqflite());
  // }

  // Future<List<MedicalInstructionDTO>> getListMedicalIns(
  //     String healthRecordId) async {
  //   var dbClient = await database;
  //   List<Map> maps = await dbClient.query(MEDICAL_INSTRUCTION_TABLE,
  //       columns: [
  //         'medical_instruction_id',
  //         'description',
  //         'image',
  //         'dianose',
  //         'date_start',
  //         'date_finish',
  //         'medical_instruction_type_id',
  //         'health_record_id',
  //       ],
  //       where: 'health_record_id = ?',
  //       whereArgs: [healthRecordId]);
  //   List<MedicalInstructionDTO> listMedicalIns = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       listMedicalIns.add(MedicalInstructionDTO.fromMapSqflite(maps[i]));
  //       listMedicalIns.sort((a, b) => b.dateStarted.compareTo(a.dateStarted));
  //     }
  //   }

  //   return listMedicalIns;
  // }

  // Future<void> deleteMedicalIns(String medicalInsId) async {
  //   bool isDeleted = false;
  //   var dbClient = await database;
  //   int check = await dbClient.delete(MEDICAL_INSTRUCTION_TABLE,
  //       where: 'medical_instruction_id = ?', whereArgs: [medicalInsId]);
  // }

  // //
  // //MEDICAL_INSTRUCTION_TYPE_TABLE
  // Future<MedicalInstructionDTO> insertMedicalInsType(
  //     MedicalInstructionDTO dto) async {
  //   var dbClient = await database;
  //   await dbClient.insert(MEDICAL_INSTRUCTION_TYPE_TABLE, dto.toMapSqflite());
  //   return dto;
  // }

}
