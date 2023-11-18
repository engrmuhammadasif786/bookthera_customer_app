import 'package:bookthera_customer/components/custom_appbar.dart';
import 'package:bookthera_customer/models/Provider.dart';
import 'package:bookthera_customer/models/time_slot.dart';
import 'package:bookthera_customer/screens/provider/book_session/book_session_detail.dart';
import 'package:bookthera_customer/screens/provider/book_session/book_session_provider.dart';
import 'package:bookthera_customer/screens/provider/book_session/widgets/slotCell.dart';
import 'package:bookthera_customer/screens/provider/widgets/sessions_button.dart';
import 'package:bookthera_customer/utils/helper.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../components/custom_loader.dart';

class BookSessionMain extends StatefulWidget {
  String providerId;
  BookSessionMain({this.providerId = ''});
  @override
  State<BookSessionMain> createState() => _BookSessionMainState();
}

class _BookSessionMainState extends State<BookSessionMain> {
  // const BookSessionMain({super.key});
  DateTime _selectedDay = DateTime.now();

  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<BookSesstionProvider>()
          .doCallGetProviderTimeSlot(widget.providerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    BookSesstionProvider bookSesstionProvider =
        Provider.of<BookSesstionProvider>(context, listen: true);
    return Scaffold(
        appBar: CustomAppbar(
          title: 'Book an Appointment',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if(bookSesstionProvider.isLoading) LinearProgressIndicator(color: colorPrimary,minHeight: 2,),
              Container(
                padding: getPadding(all: 16),
                margin: getPadding(all: 16),
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
                      padding: getPadding(bottom: 22.0, top: 8),
                      child: Text('Select your Session Date',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: getFontSize(15),
                              color: textColorPrimary)),
                    ),
                    TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: DateTime.now(),
                      weekendDays: bookSesstionProvider.weekendDays,
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          for (TimeSlot timeSlot
                              in bookSesstionProvider.customDates) {
                            if (timeSlot.date != null) {
                              DateTime d = timeSlot.date!;
                              if (day.day == d.day &&
                                  day.month == d.month &&
                                  day.year == d.year) {
                                return Container(
                                  // margin: getPadding(all: 3),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: timeSlot.status? colorPrimary.withOpacity(0.34):Colors.white),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${day.day}',
                                    style:  TextStyle(
                                        color:timeSlot.status?Colors.black:grey,fontSize: getFontSize(15),fontWeight: FontWeight.w500),
                                  ),
                                );
                              }
                            }
                          }
                          return null;
                        },
                      ),
                      calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(
                              shape: BoxShape.circle, color: colorPrimary),
                          defaultDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorPrimary.withOpacity(0.34)),
                          todayTextStyle: TextStyle(color: Colors.black),
                          todayDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorPrimary.withOpacity(0.34))),
                      headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          headerPadding: EdgeInsets.zero,
                          headerMargin: EdgeInsets.only(bottom: 30),
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                          titleTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: getSize(18),
                              fontWeight: FontWeight.w600),
                          leftChevronMargin:
                              EdgeInsets.only(left: size.width * 0.13),
                          rightChevronMargin:
                              EdgeInsets.only(right: size.width * 0.13),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: colorPrimary)),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        context.read<BookSesstionProvider>().getDateSlots(selectedDay);
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay =
                              focusedDay; // update `_focusedDay` here as well
                        });
                      },
                    ),
                  ],
                ),
              ),
              SlotCell(dateTime: _selectedDay, onTap: (time) {
                context.read<BookSesstionProvider>().setTime(time);
              },)
            ],
          ),
        ));
  }
}
