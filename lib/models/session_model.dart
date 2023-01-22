class SesssionModel {
  String? sId;
  String? owner;
  String? name;
  String? description;
  double price = 0.0;
  String? length;
  String? status;
  String? isVideo;
  String? isAudio;
  String? isChat;
  String? isBook;
  String? createdAt;
  String? updatedAt;
  bool isPromotion = false;

  SesssionModel(
      {this.sId,
      this.owner,
      this.name,
      this.description,
      this.price = 0.0,
      this.length,
      this.status,
      this.isVideo,
      this.isAudio,
      this.isChat,
      this.isBook,
      this.createdAt,
      this.updatedAt,
      this.isPromotion = false});

  SesssionModel.fromJson(Map<String, dynamic> json,
      {bool isPromotionTrue = false}) {
    sId = json['_id'];
    owner = json['owner'] ?? "";
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    price = json['price'] == null ? 0.0 : double.parse(json['price']);
    length = json['length'] ?? "";
    status = json['status'] ?? "";
    isVideo = isPromotionTrue?'true': json['isVideo'] ?? "";
    isAudio = isPromotionTrue?'true':json['isAudio'] ?? "";
    isChat = isPromotionTrue?'true':json['isChat'] ?? "";
    isBook = isPromotionTrue?'true':json['isBook'] ?? "";
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    isPromotion = isPromotionTrue;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['owner'] = this.owner;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['length'] = this.length;
    data['status'] = this.status;
    data['isVideo'] = this.isVideo;
    data['isAudio'] = this.isAudio;
    data['isChat'] = this.isChat;
    data['isBook'] = this.isBook;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
