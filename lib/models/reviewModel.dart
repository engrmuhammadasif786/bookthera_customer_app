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
    ReviewToData? reviewToData;
    ReviewFromData? reviewFromData;

    factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["_id"],
        reviewToId: json["reviewToId"],
        reviewFromId: json["reviewFromId"],
        reviewByName: json["reviewByName"]??'',
        stars: json["stars"]??'',
        publicReview: json["publicReview"]??'',
        privateReview: json["privateReview"]??'',
        createdAt: DateTime.parse(json["createdAt"]),
        reviewToData: json["reviewToData"]!=null? ReviewToData.fromJson(json["reviewToData"]):null,
        reviewFromData: json["reviewFromData"]!=null? ReviewFromData.fromJson(json["reviewFromData"]):null,
    );
}

class ReviewFromData {
    ReviewFromData({
        this.id,
        this.fname,
        this.lname,
        this.uname,
        this.avatar
    });

    String? id;
    String? fname;
    String? lname;
    String? uname;
    String? avatar;

    factory ReviewFromData.fromJson(Map<String, dynamic> json) => ReviewFromData(
        id: json["_id"],
        fname: json["fname"]??'',
        lname: json["lname"]??'',
        uname: json["uname"]??'',
        avatar: json["avatar"]!=null?json['avatar']['url']:null,
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "fname": fname,
        "lname": lname,
        "uname": uname,
    };
}


class ReviewToData {
    ReviewToData({
        this.venderProfile,
        this.id,
        this.venderFirstName,
        this.venderLastName,
        this.venderName,
    });

    String? venderProfile;
    String? id;
    String? venderFirstName;
    String? venderLastName;
    String? venderName;

    factory ReviewToData.fromJson(Map<String, dynamic> json) => ReviewToData(
        venderProfile: json["venderProfile"]!=null?json["venderProfile"]['url']:'',
        id: json["_id"],
        venderFirstName: json["venderFirstName"]??'',
        venderLastName: json["venderLastName"]??'',
        venderName: json["venderName"]??'',
    );
}
