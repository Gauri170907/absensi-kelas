// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String? loginIsActive;
  final String? loginLang;
  final String? employeeNik;
  final String? loginLastlogin;
  final String? uuid;
  final String? name;
  final String? email;
  final String? imei;
  final int? resetImeiCounter;
  final dynamic foto;
  final String? statusKaryawan;
  final String? status;

  User({
    this.loginIsActive,
    this.loginLang,
    this.employeeNik,
    this.loginLastlogin,
    this.uuid,
    this.name,
    this.email,
    this.imei,
    this.resetImeiCounter,
    this.foto,
    this.status,
    this.statusKaryawan,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        loginIsActive: json["login_is_active"],
        loginLang: json["login_lang"],
        employeeNik: json["employee_nik"],
        loginLastlogin: json["login_lastlogin"],
        uuid: json["uuid"],
        name: json["name"],
        email: json["email"],
        imei: json["imei"],
        resetImeiCounter: json["reset_imei_counter"],
        foto: json["foto"],
        status: json["status"],
        statusKaryawan: json["status_karyawan"],
      );

  Map<String, dynamic> toJson() => {
        "login_is_active": loginIsActive,
        "login_lang": loginLang,
        "employee_nik": employeeNik,
        "login_lastlogin": loginLastlogin,
        "uuid": uuid,
        "name": name,
        "email": email,
        "imei": imei,
        "reset_imei_counter": resetImeiCounter,
        "foto": foto,
        "status": status,
        "status_karyawan": statusKaryawan,
      };
}
