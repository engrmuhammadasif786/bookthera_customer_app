import 'package:intl/intl.dart';

class BookSession {
  String? providerId;
  String? sessionId;
  String? customerId;
  String? focusId;
  String isPromotion='';
  String? isPayment;
  ProfilePic? profilePic;
  String? date;
  String? time;
  String? intensions;
  String? type;
  String? status;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  ProviderData? providerData;
  SessionData? sessionData;
  String? channelName;
  String? cancellationReasion;
  String? noShowReportBy;
  String? reviewByProvider;

  BookSession(
      {this.providerId,
      this.sessionId,
      this.focusId,
      this.customerId,
      this.isPromotion="false",
      this.isPayment,
      this.profilePic,
      this.date,
      this.time,
      this.intensions,
      this.type,
      this.status,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.providerData,
      this.cancellationReasion,
      this.noShowReportBy,
      this.reviewByProvider,
      this.sessionData,this.channelName=''});

  BookSession.fromJson(Map<String, dynamic> json) {
    providerId = json['providerId'];
    sessionId = json['sessionId'];
    customerId = json['customerId'];
    focusId = json['focusId'];
    isPromotion = json['isPromotion']??"false";
    isPayment = json['isPayment']??"false";
    profilePic = json['profilePic'] != null
        ? new ProfilePic.fromJson(json['profilePic'])
        : null;
    date = json['date']!=null?DateFormat('dd MMM').format(DateTime.parse(json['date'])) :'';
    time = json['time']??"";
    intensions = json['intensions']??"";
    type = json['type']??"";
    status = json['status']??"";
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    providerData = json['providerData'] != null
        ? new ProviderData.fromJson(json['providerData'])
        : null;
    sessionData = json['sessionData'] != null
        ? new SessionData.fromJson(json['sessionData'])
        : null;
    channelName=json['agoraChannel']??'test';
    reviewByProvider=json['reviewByProvider']??'0';
    cancellationReasion=json['cancellationReasion']??'';
    noShowReportBy=json['noShowReportBy'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['providerId'] = this.providerId;
    data['sessionId'] = this.sessionId;
    data['focusId'] = this.focusId;
    data['isPromotion'] = this.isPromotion;
    data['isPayment'] = this.isPayment;
    data['date'] = this.date;
    data['time'] = this.time;
    data['intensions'] = this.intensions;
    data['type'] = this.type;
    return data;
  }
}

class ProfilePic {
  String? publicId;
  String? url;

  ProfilePic({this.publicId, this.url});

  ProfilePic.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'];
    url = json['url']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public_id'] = this.publicId;
    data['url'] = this.url;
    return data;
  }
}

class ProviderData {
  ProfilePic? avatar;
  String? sId;
  String? fname;
  String? lname;
  String? uname;

  ProviderData({this.avatar, this.sId, this.fname, this.lname});

  ProviderData.fromJson(Map<String, dynamic> json) {
    avatar =
        json['avatar'] != null ? new ProfilePic.fromJson(json['avatar']) : null;
    sId = json['_id'];
    fname = json['fname']??'';
    lname = json['lname']??'';
    uname = json['uname']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.avatar != null) {
      data['avatar'] = this.avatar!.toJson();
    }
    data['_id'] = this.sId;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    return data;
  }
}

class SessionData {
  String? sId;
  String? name;
  String? description;
  String? length;
  String? price;

  SessionData({this.sId, this.name, this.description,this.length,this.price});

  SessionData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name']??"";
    description = json['description']??"";
    length = json['length']??"";
    price = json['price']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name??'';
    data['description'] = this.description??'';
    return data;
  }
}
