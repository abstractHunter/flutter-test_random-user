import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:randomuser/models/api/api_status.dart';
import 'package:randomuser/models/schemas/user.dart';
import 'package:randomuser/models/services/main_service.dart';

class MainViewModel with ChangeNotifier {
  bool loading = false;
  List<User> users = [];

  MainViewModel() {
    fetchUsersFromAPI();
  }

  Future fetchUsersFromAPI() async {
    loading = true;
    notifyListeners();

    final response = await MainService().getUsersFromAPI();

    if (response is Success) {
      print(response.response);

      final data =
          json.decode(response.response as String) as Map<String, dynamic>;

      users = [];
      for (final user in data['results']) {
        users.add(User.fromJson(user));
      }

      users.sort((a, b) => a.username.compareTo(b.firstName));
    } else {
      print((response as Failure).errorResponse);
    }

    loading = false;
    notifyListeners();
  }
}
