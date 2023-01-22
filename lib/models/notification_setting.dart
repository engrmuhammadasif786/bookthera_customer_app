class NotificationSetting {
    NotificationSetting({
        this.id,
        this.user,
        this.pushJson,
        this.emailJson,
        this.createdAt,
        this.updatedAt,
    });

    String? id;
    String? user;
    Map? pushJson;
    Map? emailJson;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory NotificationSetting.fromJson(Map<String, dynamic> json) => NotificationSetting(
        id: json["_id"],
        user: json["user"],
        pushJson: json["pushJson"],
        emailJson: json["emailJson"],
        createdAt: json["createdAt"]==null?DateTime.now(): DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"]==null?DateTime.now():DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}

