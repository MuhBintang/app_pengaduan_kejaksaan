// To parse this JSON data, do
//
//     final modelDeletPengaduan = modelDeletPengaduanFromJson(jsonString);

import 'dart:convert';

ModelDeletePengaduan modelDeletPengaduanFromJson(String str) => ModelDeletePengaduan.fromJson(json.decode(str));

String modelDeletePengaduanToJson(ModelDeletePengaduan data) => json.encode(data.toJson());

class ModelDeletePengaduan {
    int value;
    String message;

    ModelDeletePengaduan({
        required this.value,
        required this.message,
    });

    factory ModelDeletePengaduan.fromJson(Map<String, dynamic> json) => ModelDeletePengaduan(
        value: json["value"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
    };
}
