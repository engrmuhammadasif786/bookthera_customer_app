import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';


class CustomLoader extends StatelessWidget {
  Color bgcolor;
  Color loaderColor;
  final bool isLoading;
  final Widget child;
  CustomLoader(
      {required this.child,
      this.isLoading = false,
      this.bgcolor = Colors.black12,
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
                      child: Container(
                        height: width * 0.09,
                        width: width * 0.09,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(width * 0.5),
                        ),
                        child: LoadingIndicator(
                          colors: [colorPrimary],
                          indicatorType: Indicator.ballRotateChase,
                        ),
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
