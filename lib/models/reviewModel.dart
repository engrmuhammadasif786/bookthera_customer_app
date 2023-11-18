import 'package:bookthera_customer/models/userModel.dart';

class ReviewModel {
    ReviewModel({
        this.id,
        this.reviewToId,
        this.reviewFromId,
        this.reviewByName,
        this.stars,
        this.publicReview,
        this.privateReview,
        this.createdAt,
        this.v,
        this.reviewToData,
        this.reviewFromData
    });

    String? id;
    String? reviewToId;
    String? reviewFromId;
    String? reviewByName;
    String? stars;
    String? publicReview;
    String? privateReview;
    DateTime? createdAt;
    int? v;
    UserModel? reviewToData;
    UserModel? reviewFromData;

    factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["_id"],
        reviewToId: json["reviewToId"],
        reviewFromId: json["reviewFromId"],
        reviewByName: json["reviewByName"]??'',
        stars: json["stars"]??'',
        publicReview: json["publicReview"]??'',
        privateReview: json["privateReview"]??'',
        createdAt: DateTime.parse(json["createdAt"]),
        reviewToData: json["reviewToData"]!=null? UserModel.fromJson(json["reviewToData"]):null,
        reviewFromData: json["reviewFromData"]!=null? UserModel.fromJson(json["reviewFromData"]):null,
    );
}