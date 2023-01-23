import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomPersentLoader extends StatelessWidget {
  Color bgcolor;
  Color loaderColor;
  final bool isLoading;
  final Widget child;
  double persent;
  CustomPersentLoader(
      {required this.child,
      this.isLoading = false,
      this.bgcolor = Colors.black12,
      this.persent=0,
      this.loaderColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return isLoading
        ? Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: Container(
                  width: width,
                  height: height,
                  child: child,
                ),
              ),
              Positioned(
                child: Align(
                  alignment: FractionalOffset.center,
                  child: Container(
                    width: width,
                    height: height,
                    color: bgcolor,
                    child: Center(
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 10.0,
                        percent: persent,
                        center: new Text((persent*100).toStringAsFixed(0)+' %'),
                        progressColor: colorPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container(
            child: child,
          );
  }
}
