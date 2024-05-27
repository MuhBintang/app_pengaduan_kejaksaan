// To parse this JSON data, do
//
//     final modelgetJms = modelgetJmsFromJson(jsonString);

import 'dart:convert';

ModelgetJms modelgetJmsFromJson(String str) => ModelgetJms.fromJson(json.decode(str));

String modelgetJmsToJson(ModelgetJms data) => json.encode(data.toJson());

class ModelgetJms {
    bool isSuccess;
    String message;
    List<DatumJMS> data;

    ModelgetJms({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelgetJms.fromJson(Map<String, dynamic> json) => ModelgetJms(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<DatumJMS>.from(json["data"].map((x) => DatumJMS.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumJMS {
    int id;
    String sekolah;
    String nama;
    String status;
    int idUser;

    DatumJMS({
        required this.id,
        required this.sekolah,
        required this.nama,
        required this.status,
        required this.idUser,
    });

    factory DatumJMS.fromJson(Map<String, dynamic> json) => DatumJMS(
        id: json["id"],
        sekolah: json["sekolah"],
        nama: json["nama"],
        status: json["status"],
        idUser: json["id_user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sekolah": sekolah,
        "nama": nama,
        "status": status,
        "id_user": idUser,
    };
}
