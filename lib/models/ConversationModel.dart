
class ConversationModel {
  String id;

  String creatorId;
  String lastMessage;

  String name;

  String lastMessageDate;

  ConversationModel({this.id = '', this.creatorId = '', this.lastMessage = '', this.name = '', lastMessageDate})
      : this.lastMessageDate = lastMessageDate ?? '';

  factory ConversationModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConversationModel(
        id: parsedJson['id'] ?? '',
        creatorId: parsedJson['creatorID'] ?? parsedJson['creator_id'] ?? '',
        lastMessage: parsedJson['lastMessage'] ?? '',
        name: parsedJson['name'] ?? '',
        lastMessageDate: parsedJson['lastMessageDate'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'creatorID': this.creatorId,
      'lastMessage': this.lastMessage,
      'name': this.name,
      'lastMessageDate': this.lastMessageDate
    };
  }
}
