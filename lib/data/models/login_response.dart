// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'user.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  final int? code;
  final bool? status;
  final String? message;
  final User? user;
  final String? accessToken;
  final String? tokenType;

  LoginResponse({
    this.code,
    this.status,
    this.message,
    this.user,
    this.accessToken,
    this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        user: json["data"] == null ? null : User.fromJson(json["data"]),
        accessToken: json["access_token"],
        tokenType: json["token_type"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "data": user?.toJson(),
        "access_token": accessToken,
        "token_type": tokenType,
      };
}
