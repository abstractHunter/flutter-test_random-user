import 'package:http/http.dart' as http;
import 'package:randomuser/models/api/api_status.dart';
import 'package:randomuser/utils/constants.dart';

abstract class BaseService {
  final String baseUrl = Constants.apiUrl;

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson =
            Success(code: response.statusCode, response: response.body);
        return responseJson;
      case 201:
        var responseJson =
            Success(code: response.statusCode, response: response.body);
        return responseJson;
      case 400:
        return Failure(code: response.statusCode, errorResponse: response.body);
      case 401:
      case 403:
        return Failure(
            code: response.statusCode, errorResponse: 'Unauthorized');
      case 500:
      default:
        return Failure(
            code: response.statusCode,
            errorResponse:
                'Error while Communication with Server with StatusCode : ${response.request?.url}, ${response.reasonPhrase}, ${response.body}');
    }
  }
}
