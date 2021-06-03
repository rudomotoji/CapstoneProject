import 'dart:convert';
import 'dart:io';
import 'package:capstone_home_doctor/services/token_helper.dart';
import 'package:http/http.dart' as http;

final TokenHelper _tokenHelper = TokenHelper();

class BaseApiClient {
  String _tokenLogin = '';
  // Future<void> getTokenLogin() async {
  //   // print('TOKEN VALUE IS $_tokenLogin');
  //   await _tokenHelper.getToken().then((value) {
  //     _tokenLogin = "Bearer ${value.split(':" ')[1].split(' "')[0]}";
  //     print("TOKEN LOGIN: ${value.split(':" ')[1].split(' "')[0]}");
  //   });
  // }

  static const baseUrl = 'http://45.76.186.233:8000/api/v1';
  static const postmanUrl =
      'http://a2417dcb-c449-4acb-8b24-ca65657f90b3.mock.pstmn.io';
  static const mockupApi = 'https://605ec4f5e96e5c0017407ba8.mockapi.io/api/v1';
  //static const baseUrl = 'https://5f715f3b64a3720016e6059d.mockapi.io/api/v1';
  Future<http.Response> getApi(String url, String token) async {
    await _tokenHelper.getToken().then((value) {
      _tokenLogin = "Bearer ${value.split(':"')[1].split('"')[0]}";
    });
    //print('TOKEN LOGIN NOW: $_tokenLogin');
    return await http.get(
      baseUrl + url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: _tokenLogin,
      },
    );
  }

  Future<http.Response> getApiPostman(String url, String token) async =>
      http.get(
        postmanUrl + url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader:
              token == null ? null : "Bearer ${token}"
        },
      );
  Future<http.Response> getApiMockup(String url, String token) async =>
      http.get(
        mockupApi + url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader:
              token == null ? null : "Bearer ${token}"
        },
      );

  Future<http.Response> postApi(String url, String token, dynamic body) async {
    await _tokenHelper.getToken().then((value) {
      if (value == null || value == '') {
        _tokenLogin = null;
      } else {
        _tokenLogin = "Bearer ${value.split(':"')[1].split('"')[0]}";
      }
    });
    //
    _removeBodyNullValues(body);
    return await http.post(
      baseUrl + url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: _tokenLogin,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> putApi(String url, String token, dynamic body) async {
    _removeBodyNullValues(body);
    await _tokenHelper.getToken().then((value) {
      _tokenLogin = "Bearer ${value.split(':"')[1].split('"')[0]}";
    });
    return await http.put(
      baseUrl + url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: _tokenLogin,
      },
      body: jsonEncode(body),
    );
  }

  void _removeBodyNullValues(body) {
    if (body is Map<String, dynamic>) {
      body.removeWhere(_isMapValueNull);
    } else if (body is List<Map<String, dynamic>>) {
      body.forEach((element) => element.removeWhere(_isMapValueNull));
    }
  }

  bool _isMapValueNull(String _, dynamic value) =>
      value == null && value is! String;
}
