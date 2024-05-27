// To parse this JSON data, do
//
//     final modelEditKorupsi = modelEditKorupsiFromJson(jsonString);

import 'dart:convert';

ModelEditKorupsi modelEditKorupsiFromJson(String str) => ModelEditKorupsi.fromJson(json.decode(str));

String modelEditKorupsiToJson(ModelEditKorupsi data) => json.encode(data.toJson());

class ModelEditKorupsi {
    bool isSuccess;
    String message;
    Data data;

    ModelEditKorupsi({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelEditKorupsi.fromJson(Map<String, dynamic> json) => ModelEditKorupsi(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String id;
    String nama;
    String noHp;
    String nik;
    String fotoKtp;
    String uraianLaporan;
    String fotoLaporan;
    String status;
    String idUser;

    Data({
        required this.id,
        required this.nama,
        required this.noHp,
        required this.nik,
        required this.fotoKtp,
        required this.uraianLaporan,
        required this.fotoLaporan,
        required this.status,
        required this.idUser,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        nama: json["nama"],
        noHp: json["no_hp"],
        nik: json["nik"],
        fotoKtp: json["foto_ktp"],
        uraianLaporan: json["uraian_laporan"],
        fotoLaporan: json["foto_laporan"],
        status: json["status"],
        idUser: json["id_user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "no_hp": noHp,
        "nik": nik,
        "foto_ktp": fotoKtp,
        "uraian_laporan": uraianLaporan,
        "foto_laporan": fotoLaporan,
        "status": status,
        "id_user": idUser,
    };
}
