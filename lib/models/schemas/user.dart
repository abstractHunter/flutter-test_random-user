const String usersTable = 'users';

class UserFields {
  static final List<String> values = [
    id,
    username,
    gender,
    firstName,
    lastName,
    email,
    phone,
    registerDate,
    city,
    country,
    dateOfBirth,
    picture,
  ];

  static const String id = '_id';
  static const String username = 'username';
  static const String gender = 'gender';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String registerDate = 'registerDate';
  static const String city = 'city';
  static const String country = 'country';
  static const String dateOfBirth = 'dateOfBirth';
  static const String picture = 'picture';
}

class User {
  int? id;
  String username;
  String gender;
  String firstName;
  String lastName;
  String email;
  String phone;
  DateTime registerDate;
  String city;
  String country;
  DateTime dateOfBirth;
  String picture;

  User({
    this.id,
    required this.username,
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.registerDate,
    required this.city,
    required this.country,
    required this.dateOfBirth,
    required this.picture,
  });

  User copy({
    int? id,
    String? username,
    String? gender,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    DateTime? registerDate,
    String? city,
    String? country,
    DateTime? dateOfBirth,
    String? picture,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        gender: gender ?? this.gender,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        registerDate: registerDate ?? this.registerDate,
        city: city ?? this.city,
        country: country ?? this.country,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        picture: picture ?? this.picture,
      );

  User.fromJson(Map<String, dynamic> json)
      : id = json[UserFields.id] as int?,
        gender = json[UserFields.gender] as String,
        username = json[UserFields.username] as String,
        firstName = json[UserFields.firstName] as String,
        lastName = json[UserFields.lastName] as String,
        email = json[UserFields.email] as String,
        phone = json[UserFields.phone] as String,
        registerDate = DateTime.parse(json[UserFields.registerDate] as String),
        city = json[UserFields.city] as String,
        country = json[UserFields.country] as String,
        dateOfBirth = DateTime.parse(json[UserFields.dateOfBirth] as String),
        picture = json[UserFields.picture] as String;

  User.fromAPIJson(Map<String, dynamic> json)
      : id = json[UserFields.id] as int?,
        gender = json[UserFields.gender] as String,
        username = json["login"]![UserFields.username] as String,
        firstName = json["name"]!["first"] as String,
        lastName = json["name"]!["last"] as String,
        email = json[UserFields.email] as String,
        phone = json[UserFields.phone] as String,
        registerDate = DateTime.parse(json["registered"]["date"] as String),
        city = json["location"][UserFields.city] as String,
        country = json["location"][UserFields.country] as String,
        dateOfBirth = DateTime.parse(json["dob"]["date"] as String),
        picture = json[UserFields.picture]["large"] as String;

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.username: username,
        UserFields.gender: gender,
        UserFields.firstName: firstName,
        UserFields.lastName: lastName,
        UserFields.email: email,
        UserFields.phone: phone,
        UserFields.registerDate: registerDate.toIso8601String(),
        UserFields.city: city,
        UserFields.country: country,
        UserFields.dateOfBirth: dateOfBirth.toIso8601String(),
        UserFields.picture: picture,
      };
}
