// To parse this JSON data, do
//
//     final emptyFieldResponse = emptyFieldResponseFromJson(jsonString);

import 'dart:convert';

EmptyFieldResponse emptyFieldResponseFromJson(String str) =>
    EmptyFieldResponse.fromJson(json.decode(str));

String emptyFieldResponseToJson(EmptyFieldResponse data) =>
    json.encode(data.toJson());

class EmptyFieldResponse {
  final int? statusCode;
  final Message? message;

  EmptyFieldResponse({
    this.statusCode,
    this.message,
  });

  factory EmptyFieldResponse.fromJson(Map<String, dynamic> json) =>
      EmptyFieldResponse(
        statusCode: json["status_code"],
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message?.toJson(),
      };
}

class Message {
  final List<String>? imei;

  Message({
    this.imei,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        imei: json["imei"] == null
            ? []
            : List<String>.from(json["imei"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "imei": imei == null ? [] : List<dynamic>.from(imei!.map((x) => x)),
      };
}
