import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class BaseApiClient {
  static const baseUrl = 'http://45.76.186.233:8000/api/v1';
  //static const baseUrl = 'https://5f715f3b64a3720016e6059d.mockapi.io/api/v1';
  Future<http.Response> getApi(String url, String token) async => http.get(
        baseUrl + url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader:
              token == null ? null : "Bearer ${token}"
        },
      );
  Future<http.Response> postApi(String url, String token, dynamic body) async {
    _removeBodyNullValues(body);
    return http.post(
      baseUrl + url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader:
            token == null ? null : "Bearer ${token}"
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> putApi(String url, String token, dynamic body) async {
    _removeBodyNullValues(body);
    return http.put(
      baseUrl + url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader:
            token == null ? null : "Bearer ${token}"
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
