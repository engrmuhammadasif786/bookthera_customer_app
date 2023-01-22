class FocusModel {
  String? sId;
  String? title;
  bool isSelected=false;

  FocusModel({this.sId, this.title,this.isSelected=false});

  FocusModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    return data;
  }
}
