// To parse this JSON data, do
//
//     final modelCreateJms = modelCreateJmsFromJson(jsonString);

import 'dart:convert';

ModelCreateJms modelCreateJmsFromJson(String str) => ModelCreateJms.fromJson(json.decode(str));

String modelCreateJmsToJson(ModelCreateJms data) => json.encode(data.toJson());

class ModelCreateJms {
    bool isSuccess;
    String message;

    ModelCreateJms({
        required this.isSuccess,
        required this.message,
    });

    factory ModelCreateJms.fromJson(Map<String, dynamic> json) => ModelCreateJms(
        isSuccess: json["isSuccess"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
    };
}
