// To parse this JSON data, do
//
//     final modelRating = modelRatingFromJson(jsonString);

import 'dart:convert';

ModelRating modelRatingFromJson(String str) => ModelRating.fromJson(json.decode(str));

String modelRatingToJson(ModelRating data) => json.encode(data.toJson());

class ModelRating {
    bool isSuccess;
    String message;

    ModelRating({
        required this.isSuccess,
        required this.message,
    });

    factory ModelRating.fromJson(Map<String, dynamic> json) => ModelRating(
        isSuccess: json["isSuccess"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
    };
}
