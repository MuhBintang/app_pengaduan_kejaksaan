// To parse this JSON data, do
//
//     final modelEditPengaduanPegawai = modelEditPengaduanPegawaiFromJson(jsonString);

import 'dart:convert';

ModelEditPengaduanPegawai modelEditPengaduanPegawaiFromJson(String str) => ModelEditPengaduanPegawai.fromJson(json.decode(str));

String modelEditPengaduanPegawaiToJson(ModelEditPengaduanPegawai data) => json.encode(data.toJson());

class ModelEditPengaduanPegawai {
    bool isSuccess;
    String message;
    Data data;

    ModelEditPengaduanPegawai({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelEditPengaduanPegawai.fromJson(Map<String, dynamic> json) => ModelEditPengaduanPegawai(
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
    String fotoLaporan;
    String laporanPengaduan;
    String kategori;
    String status;
    String idUser;

    Data({
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

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
