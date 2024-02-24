// To parse this JSON data, do
//
//     final historyResponse = historyResponseFromJson(jsonString);

import 'dart:convert';

HistoryResponse historyResponseFromJson(String str) =>
    HistoryResponse.fromJson(json.decode(str));

String historyResponseToJson(HistoryResponse data) =>
    json.encode(data.toJson());

class HistoryResponse {
  int? code;
  bool? status;
  String? message;
  List<Datum>? data;

  HistoryResponse({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) =>
      HistoryResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? employeeNik;
  DateTime? attendanceDate;
  Ang? datang;
  Ang? pulang;

  Datum({
    this.employeeNik,
    this.attendanceDate,
    this.datang,
    this.pulang,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        employeeNik: json["employee_nik"],
        attendanceDate: json["attendance_date"] == null
            ? null
            : DateTime.parse(json["attendance_date"]),
        datang: json["datang"] == null ? null : Ang.fromJson(json["datang"]),
        pulang: json["pulang"] == null ? null : Ang.fromJson(json["pulang"]),
      );

  Map<String, dynamic> toJson() => {
        "employee_nik": employeeNik,
        "attendance_date":
            "${attendanceDate!.year.toString().padLeft(4, '0')}-${attendanceDate!.month.toString().padLeft(2, '0')}-${attendanceDate!.day.toString().padLeft(2, '0')}",
        "datang": datang?.toJson(),
        "pulang": pulang?.toJson(),
      };
}

class Ang {
  String? time;
  dynamic picture;
  String? latitude;
  String? longtitude;

  Ang({
    this.time,
    this.picture,
    this.latitude,
    this.longtitude,
  });

  factory Ang.fromJson(Map<String, dynamic> json) => Ang(
        time: json["time"],
        picture: json["picture"],
        latitude: json["latitude"],
        longtitude: json["longtitude"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "picture": picture,
        "latitude": latitude,
        "longtitude": longtitude,
      };
}
