// To parse this JSON data, do
//
//     final modelPengaduan = modelPengaduanFromJson(jsonString);

import 'dart:convert';

ModelPengaduan modelPengaduanFromJson(String str) => ModelPengaduan.fromJson(json.decode(str));

String modelPengaduanToJson(ModelPengaduan data) => json.encode(data.toJson());

class ModelPengaduan {
    bool isSuccess;
    String message;
    List<Datum> data;

    ModelPengaduan({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelPengaduan.fromJson(Map<String, dynamic> json) => ModelPengaduan(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    String nama;
    String noHp;
    String nik;
    String fotoKtp;
    String fotoLaporan;
    String laporanPengaduan;
    String kategori;
    String status;
    int idUser;

    Datum({
        required this.id,
        required this.nama,
        required this.noHp,
        required this.nik,
        required this.fotoKtp,
        required this.fotoLaporan,
        required this.laporanPengaduan,
        required this.kategori,
        required this.status,
        required this.idUser,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nama: json["nama"],
        noHp: json["no_hp"],
        nik: json["nik"],
        fotoKtp: json["foto_ktp"],
        fotoLaporan: json["foto_laporan"],
        laporanPengaduan: json["laporan_pengaduan"],
        kategori: json["kategori"],
        status: json["status"],
        idUser: json["id_user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "no_hp": noHp,
        "nik": nik,
        "foto_ktp": fotoKtp,
        "foto_laporan": fotoLaporan,
        "laporan_pengaduan": laporanPengaduan,
        "kategori": kategori,
        "status": status,
        "id_user": idUser,
    };
}
