// To parse this JSON data, do
//
//     final modelDeleteJms = modelDeleteJmsFromJson(jsonString);

import 'dart:convert';

ModelDeleteJms modelDeleteJmsFromJson(String str) => ModelDeleteJms.fromJson(json.decode(str));

String modelDeleteJmsToJson(ModelDeleteJms data) => json.encode(data.toJson());

class ModelDeleteJms {
    int value;
    String message;

    ModelDeleteJms({
        required this.value,
        required this.message,
    });

    factory ModelDeleteJms.fromJson(Map<String, dynamic> json) => ModelDeleteJms(
        value: json["value"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
    };
}
