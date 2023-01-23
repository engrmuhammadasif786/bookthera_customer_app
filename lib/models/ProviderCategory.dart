import 'package:bookthera_customer/models/Provider.dart';

class ProviderCategory {
  String? sId;
  String? title;
  List<ProviderModel> data=[];

  ProviderCategory({this.sId, this.title, this.data=const []});

  ProviderCategory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title']??"";
    if (json['data'] != null) {
      data = <ProviderModel>[];
      json['data'].forEach((v) {
        data.add(new ProviderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}