import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../../models/time_slot.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/resources/Colors.dart';
import '../../widgets/sessions_button.dart';
import '../book_session_detail.dart';
import '../book_session_provider.dart';

class SlotCell extends StatefulWidget {
  SlotCell({this.onTap, required this.dateTime, super.key});
  void Function(String)? onTap;
  DateTime dateTime;

  @override
  State<SlotCell> createState() => _SlotCellState();
}

class _SlotCellState extends State<SlotCell> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<Slots> slots = context.watch<BookSesstionProvider>().slotsList;
    return slots.isEmpty
        ? Container()
        : Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 5,
                      spreadRadius: 2,
                      color: Colors.black.withOpacity(0.1))
                ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 22.0, top: 8),
                  child: Text('Available Slots',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: getFontSize(15),
                          color: textColorPrimary)),
                ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: slots.length,
                    padding: EdgeInsets.only(bottom: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 2.45,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 12),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (widget.onTap != null &&
                              !slots[index]
                                  .bookedDates!
                                  .contains(widget.dateTime.toString())) {
                            setState(() {
                              selectedIndex = index;
                            });
                            widget.onTap!(slots[selectedIndex].time!);
                          }
                        },
                        child: slot(selectedIndex == index, slots[index]),
                      );
                    }),
                SizedBox(
                    width: double.infinity,
                    child: SessionButton(
                        title: 'Select',
                        onPressed: () {
                          if (selectedIndex == -1) {
                            showAlertDialog(context, 'Time slot is required',
                                'Pleae select a time slot to continue', true);
                          } else {
                            push(context, BookSessionDetail());
                          }
                        }))
              ],
            ),
          );
  }

  slot(bool isSelected, Slots timeSlot) {
    String selectedDate = widget.dateTime.toString();
    bool isBooked = false;
    if (timeSlot.bookedDates!.contains(selectedDate)) {
      isBooked = true;
    }
    return Container(
      decoration: BoxDecoration(
          color: isBooked
              ? Color(0xFFF1F1F1)
              : isSelected
                  ? colorPrimary
                  : Color(0xFFFFDDEE),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 5,
                spreadRadius: 2,
                color: Colors.black.withOpacity(0.1))
          ]),
      alignment: Alignment.center,
      child: Text(timeSlot.time!,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.black)),
    );
  }
}
