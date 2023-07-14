import 'package:bookthera_customer/models/userModel.dart';

class MessageModel {
    MessageModel({
        this.id,
        this.senderId,
        this.receiverId,
        this.message,
        this.mediaFile,
        this.sender,
        this.receiver,
        this.sent,
        this.sentAt,
        this.delivered,
        this.deliveredAt,
        this.seen,
        this.createdAt,
        this.updatedAt,
        this.isUserOnline=false,
        this.bugSuggestionType=''
    });

    String? id;
    String? senderId;
    String? receiverId;
    String? message;
    MediaFile? mediaFile;
    UserModel? sender;
    UserModel? receiver;
    bool? sent;
    DateTime? sentAt;
    bool? delivered;
    DateTime? deliveredAt;
    bool? seen;
    DateTime? createdAt;
    DateTime? updatedAt;
    bool isUserOnline=false;
    String bugSuggestionType;

    factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["_id"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        message: json["message"]??'',
        mediaFile: MediaFile.fromJson(json["mediaFile"]),
        sender: UserModel.fromJson(json["sender"]),
        receiver: json["receiver"]!=null? UserModel.fromJson(json["receiver"]):null,
        sent: json["sent"]??true,
        sentAt:json["sentAt"]!=null? DateTime.parse(json["sentAt"]):DateTime.now(),
        delivered: json["delivered"]??false,
        deliveredAt:json["deliveredAt"]!=null? DateTime.parse(json["deliveredAt"]):DateTime.now(),
        seen: json["seen"]??false,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        bugSuggestionType: json['bugSuggestionType']??'normal'
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "senderId": senderId,
        "receiverId": receiverId,
        "message": message,
        "mediaFile": mediaFile!.toJson(),
        "sender": sender!.toJson(),
        "receiver": receiver!.toJson(),
        "sent": sent,
        "sentAt": sentAt?.toIso8601String(),
        "delivered": delivered,
        "deliveredAt": deliveredAt?.toIso8601String(),
        "seen": seen,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}

class MediaFile {
    MediaFile({
        this.publicId,
        this.url,
        this.mediaType,
        this.id,
        this.thumbnail
    });

    String? publicId;
    String? url;
    String? mediaType;
    String? id;
    MediaFile? thumbnail;

    factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        publicId: json["public_id"],
        url: json["url"]??'',
        mediaType: json["mediaType"]??"",
        id: json["_id"],
        thumbnail: json['thumbnail']!=null?MediaFile.fromJson(json['thumbnail']):null
    );

    Map<String, dynamic> toJson() => {
        "public_id": publicId,
        "url": url,
        "mediaType": mediaType,
        "_id": id,
    };
}