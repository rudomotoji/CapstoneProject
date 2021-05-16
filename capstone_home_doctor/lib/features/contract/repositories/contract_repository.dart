import 'dart:convert';

import 'package:capstone_home_doctor/commons/http/base_api_client.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/models/contract_detail_dto.dart';
import 'package:capstone_home_doctor/models/contract_full_dto.dart';
import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:capstone_home_doctor/models/contract_update_dto.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final ContractHelper _contractHelper = ContractHelper();
final DateValidator _dateValidator = DateValidator();

class ContractRepository extends BaseApiClient {
  final http.Client httpClient;
  ContractRepository({@required this.httpClient}) : assert(httpClient != null);
  //
  Future<List<ContractListDTO>> getListContract(int patientId) async {
    final String url = '/Contracts?patientId=${patientId}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<ContractListDTO> list = responseData.map((dto) {
          // return ContractListDTO(
          //     contractId: dto['contractId'],
          //     contractCode: dto['contractCode'],
          //     fullNameDoctor: dto['fullNameDoctor'],
          //     daysOfTracking: dto['daysOfTracking'],
          //     status: dto['status'],
          //     dateStarted: dto['dateStarted'],
          //     dateFinished: dto['dateFinished']);
          return ContractListDTO.fromJson(dto);
        }).toList();
        return list;
        // List<ContractListDTO> list =
      } else {
        return List<ContractListDTO>();
      }
    } catch (e) {
      print('ERROR AT GET LIST CONTRACT $e');
    }
  }

  Future<bool> createRequestContract(RequestContractDTO dto) async {
    // final String url = '/contracts';
    final String url = '/Contracts';
    try {
      final request = await postApi(url, null, dto.toJson());
      // print('request body: ${request.request.body.toString()}');

      if (request.statusCode == 400) {
        _contractHelper.updateContractSendStatus(
            false, 'Bạn đang có hợp đồng với bác sĩ này');
        return false;
      } else if (request.statusCode == 201) {
        //
        _contractHelper.updateContractSendStatus(
            true, 'Gửi yêu cầu thành công');
        return true;
      } else {
        createRequestContract(dto);
        _contractHelper.updateContractSendStatus(false, 'Kiểm tra lại kết nối');
        return false;
      }
    } catch (e) {
      print('ERROR AT MAKE REQUEST CONTRACT API: $e');
    }
  }

  Future<int> getIdContractNow(int doctorId, int patientId) async {
    final url =
        '/Contracts?doctorId=${doctorId}&patientId=${patientId}&status=PENDING';
    try {
      //
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        List<ContractDetailDTO> list = responseData.map((dto) {
          return ContractDetailDTO.fromJson(dto);
        }).toList();
        return list[0].contractId;
      }
      return 0;
    } catch (e) {
      print('ERROR AT GET ID CONTRACT NOW API: ${e}');
    }
  }

  Future<ContractFullDTO> getFullContract(int contractId) async {
    final url = '/Contracts/${contractId}';
    try {
      final response = await getApi(url, null);
      if (response.statusCode == 200) {
        ContractFullDTO dto =
            ContractFullDTO.fromJson(jsonDecode(response.body));
        return dto;
      } else {
        return ContractFullDTO();
      }
    } catch (e) {
      print('ERROR AT GET FULL CONTRACT API: ${e}');
    }
  }

  //update status contract
  // Future<bool> changeStatusContract(ContractUpdateDTO dto) async {
  //   //
  //   final url = '/Contracts/${dto.contractId}';
  //   try {
  //     //
  //     print('this is from API: $url');
  //     print('?????????? ${dto.status}');
  //     final request = await putApi(url, null, dto.toJson());
  //     print('${request.body}');
  //     if (request.statusCode == 204) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print('ERROR AT UPDATE STATUS CONTRACT API: ${e}');
  //   }
  // }

  Future<bool> changeStatusContract(String urlRespone, int contractId) async {
    final url = '/Payments/CheckPaymentStatus?contractId=${contractId}';

    // final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['contractId'] = contractId;
    // data['urlRespone'] = urlRespone;

    try {
      final request = await postApi(url, null, urlRespone);
      if (request.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('ERROR AT UPDATE STATUS CONTRACT API: ${e}');
    }
  }

  //check contract to create
  Future<bool> checkContractToCreate(int doctorId, int patientId) async {
    final url =
        '/Contracts/CheckContractToCreate?doctorId=${doctorId}&patientId=${patientId}';
    try {
      //
      final request = await getApi(url, null);
      if (request.statusCode == 204) {
        _contractHelper.updateContractCheckingStatus(true, 'Thành công');
        return true;
      } else if (request.statusCode == 200) {
        // //
        // _contractHelper.updateContractCheckingStatus(
        //     false, 'Bạn đã có hợp đồng với bác sĩ này');
        // return false;
        final response = request.body;
        if (response.contains('PENDING')) {
          _contractHelper.updateContractCheckingStatus(
              false, 'Bạn đang có hợp đồng chờ bác sĩ này xét duyệt.');
        } else if (response.contains('APPROVED')) {
          _contractHelper.updateContractCheckingStatus(
              false, 'Bác sĩ đã xác nhận hợp đồng và chờ bạn chấp thuận.');
        } else if (response == null) {
          _contractHelper.updateContractCheckingStatus(true, 'OK');
        } else if (response == 'CANCELP') {
          _contractHelper.updateContractCheckingStatus(true, 'OK');
        } else if (response == 'CANCELD') {
          _contractHelper.updateContractCheckingStatus(true, 'OK');
        } else {
          _contractHelper.updateContractCheckingStatus(false,
              'Thời gian phù hợp để gửi yêu cầu hợp đồng là sau ngày ${_dateValidator.parseToDateView4(response)}.\nBạn có muốn tiếp tục?');
          _contractHelper.updateAvailableDay(response);
        }
      } else {
        //
        _contractHelper.updateContractCheckingStatus(
            false, 'Kiểm tra lại kết nối mạng');
        return false;
      }
    } catch (e) {
      print('ERROR AT CHECK CONTRACT TO CREATE ${e}');
    }
  }

  //check contract to create
  Future<bool> checkContractToCreate2(
      int doctorId, int patientId, String date) async {
    final url =
        '/Contracts/CheckContractToCreate?doctorId=${doctorId}&patientId=${patientId}&dateStart=${date}';
    try {
      //
      final request = await getApi(url, null);
      print('request this: $request');
      print(
          'go into check contract date. status code is ${request.statusCode}');

      print('go into check contract date. body code is ${request.body}');
      if (request.statusCode == 200) {
        // // //
        // // _contractHelper.updateContractCheckingStatus(
        // //     false, 'Bạn đã có hợp đồng với bác sĩ này');
        // // return false;
        final response = request.body;
        if (response != null || response.isNotEmpty || response != '') {
          DateTime timeReponse = DateTime(
              int.tryParse(response.split('/')[0]),
              int.tryParse(response.split('/')[1]),
              int.tryParse(response.split('/')[2]));
          DateTime timeGet = DateTime(
              int.tryParse(date.split('-')[0]),
              int.tryParse(date.split('-')[1]),
              int.tryParse(date.split('-')[2]));
          if (timeReponse.isBefore(timeGet)) {
            print('GO INTO IS BEFORE?');
            _contractHelper.updateContractCheckingStatus(
                false, 'Vui lòng gửi yêu cầu sau ngày ${response}');
            return false;
          } else {
            _contractHelper.updateContractCheckingStatus(true, 'OK');
            return true;
          }
        } else {
          _contractHelper.updateContractCheckingStatus(true, 'OK');
          return true;
        }
      } else if (request.statusCode == 204) {
        _contractHelper.updateContractCheckingStatus(true, 'OK');
        return true;
      } else {
        //
        _contractHelper.updateContractCheckingStatus(
            false, 'Kiểm tra kết nối mạng');
        return false;
      }
    } catch (e) {
      print('ERROR AT CHECK CONTRACT TO CREATE ${e}');
    }
  }
}
