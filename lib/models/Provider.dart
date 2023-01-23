import 'package:bookthera_provider/models/reviewModel.dart';
import 'package:bookthera_provider/models/session_model.dart';
import 'package:path_provider/path_provider.dart';

class ProviderModel {
  VenderProfile? venderProfile;
  String? sId;
  String? owner;
  String? tagLine;
  String? aboutMe;
  List<Focus>? focus = [];
  int? reviewsCount;
  int? reviewsSum;
  int? sessionsCompleted;
  int? totalEarned;
  String? onlineStatus;
  bool? isFavourite;
  bool? isVideoSession;
  bool? isAudioSession;
  bool? introSession;
  List<MediaFiles> mediaFiles = [];
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? venderFirstName;
  String? venderLastName;
  String? venderName;
  bool? isChat;
  bool? isBook;
  String? startFromPrice;
  List<SesssionModel> sessions = [];
  List<SesssionModel> promotions = [];
  List<ReviewModel> reviews = [];
  String introPrice = '';

  ProviderModel(
      {this.venderProfile,
      this.sId,
      this.owner,
      this.tagLine,
      this.aboutMe,
      this.focus,
      this.reviewsCount,
      this.reviewsSum,
      this.sessionsCompleted,
      this.totalEarned,
      this.onlineStatus,
      this.isFavourite,
      this.isVideoSession,
      this.isAudioSession,
      this.introSession,
      this.mediaFiles = const [],
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.venderName,
      this.venderFirstName,
      this.venderLastName,
      this.isChat,
      this.isBook,
      this.introPrice = '',
      this.startFromPrice});

  ProviderModel.fromJson(Map<String, dynamic> json) {
    venderProfile = json['venderProfile'] != null
        ? new VenderProfile.fromJson(json['venderProfile'])
        : null;
    sId = json['_id'];
    owner = json['owner'] ?? "";
    tagLine = json['tagLine'] ?? "";
    aboutMe = json['aboutMe'] ?? "";
    if (json['focus'] != null) {
      focus = <Focus>[];
      json['focus'].forEach((v) {
        focus!.add(new Focus.fromJson(v));
      });
    }
    reviewsCount = json['reviewsCount'] ?? 0;
    reviewsSum = json['reviewsSum'] ?? 0;
    sessionsCompleted = json['sessionsCompleted'] ?? 0;
    totalEarned = json['totalEarned'] ?? 0;
    onlineStatus = json['onlineStatus'] ?? "";
    isFavourite = json['isFavourite'] ?? false;
    isVideoSession = json['isVideoSession'] ?? true;
    isAudioSession = json['isAudioSession'] ?? true;
    introSession = json['introSession'] ?? false;
    introPrice =
        json['introPrice'].toString().isEmpty ? "5" : json['introPrice'];
    if (json['mediaFiles'] != null) {
      mediaFiles = <MediaFiles>[];
      json['mediaFiles'].forEach((v) {
        mediaFiles.add(new MediaFiles.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    venderFirstName = json['venderFirstName'] ?? "";
    venderLastName = json['venderLastName'] ?? "";
    venderName = json['venderName'] ?? "";
    isChat = json['isChat'] ?? true;
    isBook = json['isBook'] ?? true;
    startFromPrice = json['startFromPrice'] ?? "";
    if (json['sessions'] != null) {
      sessions = <SesssionModel>[];
      json['sessions'].forEach((v) {
        sessions.add(new SesssionModel.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <ReviewModel>[];
      json['reviews'].forEach((v) {
        reviews.add(new ReviewModel.fromJson(v));
      });
    }
    if (json['promotions'] != null) {
      promotions = <SesssionModel>[];
      json['promotions'].forEach((v) {
        promotions.add(new SesssionModel.fromJson(v, isPromotionTrue: true));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.venderProfile != null) {
      data['venderProfile'] = this.venderProfile!.toJson();
    }
    data['_id'] = this.sId;
    data['owner'] = this.owner;
    data['tagLine'] = this.tagLine;
    data['aboutMe'] = this.aboutMe;
    if (this.focus != null) {
      data['focus'] = this.focus!.map((v) => v.toJson()).toList();
    }
    data['reviewsCount'] = this.reviewsCount;
    data['reviewsSum'] = this.reviewsSum;
    data['sessionsCompleted'] = this.sessionsCompleted;
    data['totalEarned'] = this.totalEarned;
    data['onlineStatus'] = this.onlineStatus;
    data['isFavourite'] = this.isFavourite;
    data['isVideoSession'] = this.isVideoSession;
    data['isAudioSession'] = this.isAudioSession;
    data['introSession'] = this.introSession;
    if (this.mediaFiles != null) {
      data['mediaFiles'] = this.mediaFiles.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['venderName'] = this.venderName;
    data['isChat'] = this.isChat;
    data['isBook'] = this.isBook;
    data['startFromPrice'] = this.startFromPrice;
    return data;
  }
}

class VenderProfile {
  String? publicId;
  String? url;

  VenderProfile({this.publicId, this.url});

  VenderProfile.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'] ?? "";
    url = json['url'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public_id'] = this.publicId;
    data['url'] = this.url;
    return data;
  }
}

class Focus {
  String? sId;
  String? title;

  Focus({this.sId, this.title});

  Focus.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    return data;
  }
}

class MediaFiles {
  String? publicId;
  String? url;
  String? mediaType;
  String? sId;
  MediaFiles? thumbnail;

  MediaFiles(
      {this.publicId, this.url, this.mediaType, this.sId, this.thumbnail});

  MediaFiles.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'] ?? "";
    url = json['url'] ?? "";
    mediaType = json['mediaType'] ?? "";
    sId = json['_id'];
    thumbnail = json['thumbnail'] != null
        ? MediaFiles.fromJson(json['thumbnail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public_id'] = this.publicId;
    data['url'] = this.url;
    data['mediaType'] = this.mediaType;
    data['_id'] = this.sId;
    return data;
  }
}
