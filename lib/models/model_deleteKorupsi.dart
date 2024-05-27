// To parse this JSON data, do
//
//     final modelDeleteKorupsi = modelDeleteKorupsiFromJson(jsonString);

import 'dart:convert';

ModelDeleteKorupsi modelDeleteKorupsiFromJson(String str) => ModelDeleteKorupsi.fromJson(json.decode(str));

String modelDeleteKorupsiToJson(ModelDeleteKorupsi data) => json.encode(data.toJson());

class ModelDeleteKorupsi {
    int value;
    String message;

    ModelDeleteKorupsi({
        required this.value,
        required this.message,
    });

    factory ModelDeleteKorupsi.fromJson(Map<String, dynamic> json) => ModelDeleteKorupsi(
        value: json["value"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
    };
}
