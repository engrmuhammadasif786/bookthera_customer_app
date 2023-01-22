class PaymentCard {
    PaymentCard({
        this.id,
        this.user,
        this.name,
        this.number,
        this.expiryMonth,
        this.expiryYear,
        this.cvv,
        this.isPrimary,
        this.cardType,
        this.lastUsed,
        this.createdAt,
        this.updatedAt,
    });

    String? id;
    String? user;
    String? name;
    String? number;
    String? expiryMonth;
    String? expiryYear;
    String? cvv;
    String? isPrimary;
    String? cardType;
    DateTime? lastUsed;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory PaymentCard.fromJson(Map<String, dynamic> json) => PaymentCard(
        id: json["_id"],
        user: json["user"]??"",
        name: json["name"]??"",
        number: json["number"]??"",
        expiryMonth: json["expiryMonth"]??"",
        expiryYear: json["expiryYear"]??"",
        cvv: json["cvv"]??"",
        isPrimary: json["isPrimary"]??"",
        cardType: json["cardType"]??"",
        lastUsed: json["lastUsed"]==null?null: DateTime.parse(json["lastUsed"]),
        createdAt:json["createdAt"]==null?DateTime.now():  DateTime.parse(json["createdAt"]),
        updatedAt:json["updatedAt"]==null?DateTime.now(): DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "name": name,
        "number": number,
        "expiryMonth": expiryMonth,
        "expiryYear": expiryYear,
        "cvv": cvv,
        "isPrimary": isPrimary,
        "cardType": cardType,
        "lastUsed": lastUsed?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}