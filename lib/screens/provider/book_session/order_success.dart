import 'package:bookthera_customer_1/components/custom_button.dart';
import 'package:bookthera_customer_1/screens/home/dashboard.dart';
import 'package:bookthera_customer_1/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../home/home_provider.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Image.asset(
              'assets/images/app_logo_signup.png',
              width: 149,
              height: 149,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Session Ordered!',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0),
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Thank You!',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0),
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Your session can be accessed on the\nsessions tab',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.5,
            child: CustomButton(
              borderRadius: 10,
              title: 'View Your Sessions', onPressed: (){
                context.read<HomeProvider>().updateSelectedIndex(1);
              pushReplacement(context,Dashboard());
            }),
          )
        ],),
      ),
    );
  }
}