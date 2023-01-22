class TimeSlot {
  String? type;
  bool status=false;
  String? slotsRangeList;
  DateTime? date;
  List<Slots> slots=[];

  TimeSlot({this.date, this.type, this.status=false, this.slotsRangeList, this.slots=const []});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    date = json['date']!=null?DateTime.parse(json['date']):null;
    type = json['type']??"";
    status = json['status']??true;
    slotsRangeList = json['slotsRangeList']??"";
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots.add(new Slots.fromJson(v));
      });
    }
  }
}

class Slots {
  List<String>? bookedDates;
  String? time;

  Slots({this.bookedDates, this.time});

  Slots.fromJson(Map<String, dynamic> json) {
    bookedDates = json['booked_dates'].cast<String>();
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booked_dates'] = this.bookedDates;
    data['time'] = this.time;
    return data;
  }
}
