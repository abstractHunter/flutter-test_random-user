import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:randomuser/models/api/api_status.dart';
import 'package:randomuser/models/db/users_database.dart';
import 'package:randomuser/models/schemas/user.dart';
import 'package:randomuser/models/services/main_service.dart';

class MainViewModel with ChangeNotifier {
  bool loading = false;

  UserDatabase db = UserDatabase.instance;

  List<User> users = [];

  MainViewModel() {
    // clearDB();
    fetchUsers();
  }

  // check if the device is connected to the internet

  // clear the database
  Future clearDB() async {
    loading = true;
    notifyListeners();

    await db.deleteAll();

    loading = false;
    notifyListeners();
  }

  Future hasInternetConnection() async {
    final internetConnection = await MainService().checkInternetConnection();

    return internetConnection;
  }

  // fetch users from the database or the API
  Future fetchUsers() async {
    loading = true;
    notifyListeners();

    final hasInternetConnection = await this.hasInternetConnection();

    if (!hasInternetConnection) {
      await fetchUsersFromDB();
    }
    await fetchUsersFromAPI();

    loading = false;
    notifyListeners();
  }

  // fetch users from the database
  Future fetchUsersFromDB() async {
    users.clear(); // ensure that the list is empty before adding new users
    users = await db.getAllUsers();
  }

  // fetch users from the API
  Future fetchUsersFromAPI() async {
    final response = await MainService().getUsersFromAPI();

    if (response is Success) {
      print(response.response);

      final data =
          json.decode(response.response as String) as Map<String, dynamic>;

      users.clear(); // ensure that the list is empty before adding new users
      db.deleteAll(); // ensure that the database is empty before adding new users
      for (final user in data['results']) {
        users.add(User.fromAPIJson(user));
        await db.create(User.fromAPIJson(user));
      }

      users.sort((a, b) => a.username.compareTo(b.firstName));
    } else {
      print((response as Failure).errorResponse);
    }
  }
}
