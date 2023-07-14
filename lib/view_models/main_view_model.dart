import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:randomuser/models/api/api_status.dart';
import 'package:randomuser/models/db/users_database.dart';
import 'package:randomuser/models/schemas/user.dart';
import 'package:randomuser/models/services/main_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainViewModel with ChangeNotifier {
  bool loading = false;
  bool isSearching = false;
  bool profileLoading = false;

  UserDatabase db = UserDatabase.instance;

  // user profile
  User profile = User(
    firstName: '',
    lastName: '',
    username: '',
    email: '',
    gender: '',
    phone: '',
    registerDate: DateTime.now(),
    city: '',
    country: '',
    dateOfBirth: DateTime.now(),
    picture: '',
  );

  List<User> users = [];
  List<User> following = [];
  List<User> followers = [];
  List<User> filteredUsers = [];

  MainViewModel() {
    init();
  }

  Future init() async {
    // clearDB();
    await getUserProfile();
    await fetchUsers();
    filteredUsers = users;
  }

  // clear the database
  Future clearDB() async {
    loading = true;
    notifyListeners();

    await db.deleteAll();
    users.clear();

    loading = false;
    notifyListeners();
  }

  // check if the device has internet connection
  Future hasInternetConnection() async {
    final internetConnection = await MainService().checkInternetConnection();
    return internetConnection;
  }

  // fetch users from the database or the API
  Future fetchUsers() async {
    final hasInternetConnection = await this.hasInternetConnection();

    if (!hasInternetConnection) {
      await fetchUsersFromDB();
    }
    await fetchUsersFromAPI();
  }

  // fetch users from the database
  Future fetchUsersFromDB() async {
    loading = true;
    notifyListeners();

    users.clear(); // ensure that the list is empty before adding new users
    users = await db.getAllUsers();

    dispatchUsers();

    loading = false;
    notifyListeners();
  }

  // fetch users from the API
  Future fetchUsersFromAPI() async {
    loading = true;
    notifyListeners();

    final response = await MainService().getUsersFromAPI();

    if (response is Success) {
      final data =
          json.decode(response.response as String) as Map<String, dynamic>;

      users.clear(); // ensure that the list is empty before adding new users
      db.deleteAll(); // ensure that the database is empty before adding new users
      for (final user in data['results']) {
        users.add(User.fromAPIJson(user));
        await db.create(User.fromAPIJson(user));
      }

      users.sort((a, b) => a.username.compareTo(b.firstName));

      dispatchUsers();
    } else {
      print((response as Failure).errorResponse);
    }

    loading = false;
    notifyListeners();
  }

  // dispatch users to the following and followers lists
  Future dispatchUsers() async {
    loading = true;
    notifyListeners();

    following.clear();
    followers.clear();

    // get a random number between 1 and 100 for the number of following and followers
    final followingCount = 1 + Random().nextInt(100);
    final followersCount = 1 + Random().nextInt(100);

    // get a random indexes for the following and followers
    final followingIndexes = List.generate(followingCount, (index) {
      return Random().nextInt(users.length);
    });
    final followersIndexes = List.generate(followersCount, (index) {
      return Random().nextInt(users.length);
    });

    // get the following and followers from the users list
    for (final index in followingIndexes) {
      following.add(users[index]);
    }

    for (final index in followersIndexes) {
      followers.add(users[index]);
    }

    loading = false;
    notifyListeners();
  }

  // get a random user from the database or the API
  Future getRandomUser() async {
    profileLoading = true;
    notifyListeners();

    final response = await MainService().getUsersFromAPI(limit: 1);

    if (response is Success) {
      final data =
          json.decode(response.response as String) as Map<String, dynamic>;

      profile = User.fromAPIJson(data['results'][0]);
      await saveUserProfile(profile);
    } else {
      print((response as Failure).errorResponse);
    }

    profileLoading = false;
    notifyListeners();
  }

  // get user profile from the shared preferences
  Future getUserProfile() async {
    profileLoading = true;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? profileString = prefs.getString('profile');

    if (profileString != null) {
      profile =
          User.fromJson(json.decode(profileString) as Map<String, dynamic>);
    } else {
      await getRandomUser();
    }

    profileLoading = false;
    notifyListeners();
  }

  Future saveUserProfile(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile', json.encode(profile.toJson()));

    profile = user;
  }

  // search users
  Future searchUsers(String query) async {
    isSearching = true;
    notifyListeners();

    filteredUsers = users;

    if (query.isNotEmpty) {
      filteredUsers = users
          .where((user) =>
              user.firstName.toLowerCase().contains(query.toLowerCase()) ||
              user.lastName.toLowerCase().contains(query.toLowerCase()) ||
              user.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    isSearching = false;
    notifyListeners();
  }
}
