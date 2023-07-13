import 'package:randomuser/models/api/api_status.dart';
import 'package:randomuser/models/services/base_service.dart';
import 'package:http/http.dart' as http;

class MainService extends BaseService {
  Future getUsersFromAPI() async {
    String url = '$baseUrl/?results=20';
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
}
