import 'package:bookthera_customer/screens/inbox/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_button.dart';
import '../../utils/resources/Colors.dart';
import '../../utils/size_utils.dart';

// ignore: must_be_immutable
class ChatFilter extends StatefulWidget {
  Function(int)? onApply;
  ChatFilter({this.onApply});
  @override
  State<ChatFilter> createState() => _ChatFilterState();
}

class _ChatFilterState extends State<ChatFilter> {
  TextEditingController searchController = TextEditingController();

  int filter1Index = 0;

  List<String> filter1 = [
    'Date (new - old)',
    'Date (old - new)',
    // 'Price (Low - High)',
    // 'Price (High - Low)',
    // 'Rating (High - Low)',
    // 'Rating (Low - High)'
  ];

  @override
  void initState() {
    super.initState();
    filter1Index=context.read<ChatProvider>().filter1Index;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding:
          EdgeInsets.symmetric(horizontal: 16, vertical: size.height*0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      
      child: Container(
        width: getHorizontalSize(
          396,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.maxFinite,
              child: Container(
                padding: getPadding(
                  left: 18,
                  top: 21,
                  right: 18,
                  bottom: 21,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sorting By",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: getFontSize(15),
                            fontWeight: FontWeight.w500,
                            color: textColorPrimary),
                        ),
                        CloseButton()
                      ],
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filter1.length,
                      padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                      itemBuilder: (context,index)=>CustomButton(
                        isOutlined: filter1Index!=index,
                        borderRadius: getSize(10),
                         onPressed: () {
                          context.read<ChatProvider>().updateFilterIndex(index);
                         setState(() {
                          if (filter1Index == index) {
                            filter1Index = -1;
                          } else {
                            filter1Index = index;
                          }
                        });
                      },
                      width: getHorizontalSize(
                        233,
                      ),
                      title: filter1[index],
                    )),
                    SizedBox(
                      width: size.width*0.9,
                      child: CustomButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (widget.onApply!=null) {
                            widget.onApply!(filter1Index);
                          }else{
                             switch (filter1Index) {
                              case 0:
                                context.read<ChatProvider>().sortMessage(date: '-1');
                                break;
                              case 1:
                                context.read<ChatProvider>().sortMessage(date: '1');
                                break;
                              default:
                          }
                          }
                        },
                        title: "Apply",
                        color: colorAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
