class User {
  int id;
  String balance;
  String firstName;
  String lastName;
  String phone;
  DateTime birthDate;

  User(
      {required this.firstName,
      required this.lastName,
      required this.phone,
      required this.balance,
      required this.birthDate,
      required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name']??'',
      lastName: json['last_Name']??'',
      phone: json['phone']??'',
      birthDate: DateTime.parse(json['birth_day'])??DateTime.now(),
      // Corrected type conversion
      id: json['id']??0,
      balance: json['balance']??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'birth_day': birthDate.toIso8601String(),
    };
  }
}
