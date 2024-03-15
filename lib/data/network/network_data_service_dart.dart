import 'dart:convert';
import 'dart:io';

import 'package:flutter_login_taxi/data/network/base_data_service.dart';
import 'package:http/http.dart' as http;

import '../app_exceptions.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future getApi(String url) async {
    dynamic responsejson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 20));
      responsejson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return responsejson;
  }

  @override
  Future postApi(dynamic data, String url) async {
    dynamic responsejson;
    try {
      final response = await http
          .post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 20));
      responsejson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    return responsejson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic respjson = jsonDecode(response.body);
        return respjson;
      case 400:
        dynamic respjson = jsonDecode(response.body);
        return respjson;
      default:
        throw FetchDataException(
            'Error accoured while communicating witch server ' +
                response.statusCode.toString());
    }
  }
}
