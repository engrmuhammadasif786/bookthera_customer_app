import 'package:bookthera_customer_1/components/custom_appbar.dart';
import 'package:bookthera_customer_1/components/custom_textfields.dart';
import 'package:bookthera_customer_1/screens/provider/book_session/book_session_provider.dart';
import 'package:bookthera_customer_1/screens/provider/book_session/payment_screen.dart';
import 'package:bookthera_customer_1/screens/provider/book_session/widgets/focus_selection.dart';
import 'package:bookthera_customer_1/screens/provider/book_session/widgets/upload_image.dart';
import 'package:bookthera_customer_1/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_loader.dart';
import '../../../utils/resources/Colors.dart';
import '../widgets/sessions_button.dart';

class BookSessionDetail extends StatefulWidget {
  @override
  State<BookSessionDetail> createState() => _BookSessionDetailState();
}

class _BookSessionDetailState extends State<BookSessionDetail> {
  // const BookSessionDetail({super.key});
  
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {context.read<BookSesstionProvider>().doCallGetFocus();});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    BookSesstionProvider bookSesstionProvider =
        Provider.of<BookSesstionProvider>(context, listen: true);
    SesstionType sesstionType=bookSesstionProvider.sesstionType;
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Session details',
      ),
      body: CustomLoader(
        isLoading: bookSesstionProvider.isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                UploadImage(),
                FocusSelection(),
                Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.only(top: size.height * 0.05,bottom: size.height*0.05),
                  width: double.infinity,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 11.0, top: 8),
                        child: Text('Session Intentions *',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: textColorPrimary)),
                      ),
                      CustomTextField(
                        textEditingController: bookSesstionProvider.intensionsController,
                        maxLines: 8,
                        hint: 'Write text here...',
                        label: '',
                      ),
                      Divider(
                        color: Color(0xffD9D9D9),
                        thickness: 1,
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('Session Type',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: textColorPrimary)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: SessionButton(
                                    color:sesstionType==SesstionType.Video? colorPrimary:null,
                                    isOutlined: sesstionType!=SesstionType.Video,
                                    outlinedBorderColor: sesstionType!=SesstionType.Video?colorPrimary:borderColor,
                                    title: 'Video',
                                    onPressed: () {
                                      context.read<BookSesstionProvider>().setSesstionType(SesstionType.Video);
                                    })),
                            SizedBox(
                              width: 11,
                            ),
                            Expanded(
                                child: SessionButton(
                                    color:sesstionType==SesstionType.Audio? colorPrimary:null,
                                    isOutlined: sesstionType!=SesstionType.Audio,
                                    outlinedBorderColor: sesstionType!=SesstionType.Audio?colorPrimary:borderColor,
                                    title: 'Call Only',
                                    onPressed: () {
                                      context.read<BookSesstionProvider>().setSesstionType(SesstionType.Audio);
                                    })),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: SessionButton(title: 'Book Appointment', onPressed: (){
                            // bool status = context.read<BookSesstionProvider>().bookSessionValidator(context);
                            // if (status) {
                              context.read<BookSesstionProvider>().doCallBookSession(context);
                            // }
                          })),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
