// To parse this JSON data, do
//
//     final modelEditJms = modelEditJmsFromJson(jsonString);

import 'dart:convert';

ModelEditJms modelEditJmsFromJson(String str) => ModelEditJms.fromJson(json.decode(str));

String modelEditJmsToJson(ModelEditJms data) => json.encode(data.toJson());

class ModelEditJms {
    bool isSuccess;
    String message;
    Data data;

    ModelEditJms({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelEditJms.fromJson(Map<String, dynamic> json) => ModelEditJms(
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
    String sekolah;
    String nama;
    String status;
    String idUser;

    Data({
        required this.id,
        required this.sekolah,
        required this.nama,
        required this.status,
        required this.idUser,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
