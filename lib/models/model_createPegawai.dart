// To parse this JSON data, do
//
//     final modelCreatePengaduanPegawai = modelCreatePengaduanPegawaiFromJson(jsonString);

import 'dart:convert';

ModelCreatePengaduanPegawai modelCreatePengaduanPegawaiFromJson(String str) => ModelCreatePengaduanPegawai.fromJson(json.decode(str));

String modelCreatePengaduanPegawaiToJson(ModelCreatePengaduanPegawai data) => json.encode(data.toJson());

class ModelCreatePengaduanPegawai {
    bool isSuccess;
    String message;

    ModelCreatePengaduanPegawai({
        required this.isSuccess,
        required this.message,
    });

    factory ModelCreatePengaduanPegawai.fromJson(Map<String, dynamic> json) => ModelCreatePengaduanPegawai(
        isSuccess: json["isSuccess"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
    };
}
