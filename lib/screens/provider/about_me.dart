import 'package:bookthera_customer/models/Provider.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../utils/helper.dart';
import '../../utils/size_utils.dart';

class AboutMeTab extends StatelessWidget {
  const AboutMeTab({super.key, required this.providerModel});
  final ProviderModel providerModel;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      children: [
        Text('Offers',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getFontSize(16),
                color: textColorPrimary)),
         SizedBox(
          height: getSize(19),
        ),
        Row(
          children: [
            if(providerModel.isVideoSession!)
            _offer("Video Sessions", Icons.videocam),
            SizedBox(width: 12,),
            if(providerModel.isAudioSession!)
            _offer("Audio Sessions", Icons.mic)
          ],
        ),
        _buildFocusCell(),
        _buildDescriptionCell(),
      ],
    );
  }

  Widget _buildFocusCell() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: getSize(42),
        ),
        Text('Areas of Focus',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getFontSize(16),
                color: textColorPrimary)),
        SizedBox(
          height: getSize(19),
        ),
        Wrap(
            runSpacing: getSize(5),
            spacing: getSize(5),
            children:
                providerModel.focus!.map((e) => _focus(e.title!)).toList())
      ],
    );
  }

  Widget _focus(String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: colorPrimary),
      child: Text(
        '$category',
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: getFontSize(15), color: Colors.white),
      ),
    );
  }

  Widget _offer(String category, IconData iconData) {
    return Expanded(
      child: Container(
        padding: getPadding(left: 12,right: 12,top: 10,bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: colorPrimary),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: getSize(20),
              color: Colors.white,
            ),
            SizedBox(width: 3),
            Text(category,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: getFontSize(14),
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  _buildDescriptionCell() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: getSize(42),
        ),
        Text('About Me',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getFontSize(16),
                color: textColorPrimary)),
        SizedBox(
          height: getSize(19),
        ),
        Text(providerModel.aboutMe!,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: getFontSize(14),
                color: textColorPrimary)),
      ],
    );
  }
}
