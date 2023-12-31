import 'dart:io';

import 'package:randomuser/models/api/api_status.dart';
import 'package:randomuser/models/services/base_service.dart';
import 'package:http/http.dart' as http;

class MainService extends BaseService {
  Future getUsersFromAPI({int limit = 100}) async {
    String url = '$baseUrl/?results=$limit';
    dynamic responseJson;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      responseJson = returnResponse(response);
    } on Exception catch (e) {
      print(e);
      return Failure(
        code: 500,
        errorResponse: e.toString(),
      );
    }

    return responseJson;
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
