// To parse this JSON data, do
//
//     final modelCreatePKorupsi = modelCreatePKorupsiFromJson(jsonString);

import 'dart:convert';

ModelCreatePKorupsi modelCreatePKorupsiFromJson(String str) => ModelCreatePKorupsi.fromJson(json.decode(str));

String modelCreatePKorupsiToJson(ModelCreatePKorupsi data) => json.encode(data.toJson());

class ModelCreatePKorupsi {
    bool isSuccess;
    String message;

    ModelCreatePKorupsi({
        required this.isSuccess,
        required this.message,
    });

    factory ModelCreatePKorupsi.fromJson(Map<String, dynamic> json) => ModelCreatePKorupsi(
        isSuccess: json["isSuccess"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
    };
}
