// To parse this JSON data, do
//
//     final modelLogin = modelLoginFromJson(jsonString);

import 'dart:convert';

ModelLogin modelLoginFromJson(String str) =>
    ModelLogin.fromJson(json.decode(str));

String modelLoginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
  int value;
  String message;
  String username;
  String email;
  String noTlp;
  String id;
  String alamat;
  String nik;
  String isAdmin;

  ModelLogin({
    required this.value,
    required this.message,
    required this.username,
    required this.email,
    required this.noTlp,
    required this.id,
    required this.alamat,
    required this.nik,
    required this.isAdmin,
  });

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
        value: json["value"],
        message: json["message"],
        username: json["username"],
        email: json["email"],
        noTlp: json["no_tlp"],
        id: json["id"],
        alamat: json["alamat"],
        nik: json["nik"],
        isAdmin: json["is_admin"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "username": username,
        "email": email,
        "no_tlp": noTlp,
        "id": id,
        "alamat": alamat,
        "nik": nik,
        "is_admin": isAdmin,
      };
}