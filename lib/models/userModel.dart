class UserModel {
    UserModel({
        this.id,
        this.fname,
        this.lname,
        this.email,
        this.uname,
        this.avatar,
        this.followingStatus,
        this.createdAt,
        this.updatedAt,
    });

    String? id;
    String? fname;
    String? lname;
    String? email;
    String? uname;
    UserModelAvatar? avatar;
    String? followingStatus;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        fname: json["fname"]??"",
        lname: json["lname"]??"",
        email: json["email"]??"",
        uname: json["uname"]??"",
        avatar: UserModelAvatar.fromJson(json["avatar"]),
        followingStatus: json["followingStatus"]??"",
        createdAt:json["createdAt"]!=null? DateTime.parse(json["createdAt"]):DateTime.now(),
        updatedAt:json["updatedAt"]!=null?  DateTime.parse(json["updatedAt"]):DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "fname": fname,
        "lname": lname,
        "email": email,
        "uname": uname,
        "avatar": avatar!.toJson(),
        "followingStatus": followingStatus,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}

class UserModelAvatar {
    UserModelAvatar({
        this.publicId,
        this.url,
    });

    String? publicId;
    String? url;

    factory UserModelAvatar.fromJson(Map<String, dynamic> json) => UserModelAvatar(
        publicId: json["public_id"],
        url: json["url"]??"",
    );

    Map<String, dynamic> toJson() => {
        "public_id": publicId,
        "url": url,
    };
}