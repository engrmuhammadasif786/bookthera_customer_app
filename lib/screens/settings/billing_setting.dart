import 'dart:math';

import 'package:bookthera_customer/components/custom_appbar.dart';
import 'package:bookthera_customer/components/custom_button.dart';
import 'package:bookthera_customer/components/custom_loader.dart';
import 'package:bookthera_customer/models/book_sessoin.dart';
import 'package:bookthera_customer/models/payment_card.dart';
import 'package:bookthera_customer/screens/settings/setting_provider.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../components/custom_textform_field.dart';
import '../../utils/Common.dart';
import '../../utils/Constants.dart';
import '../../utils/helper.dart';

class BillingSetting extends StatefulWidget {
  @override
  State<BillingSetting> createState() => _BillingSettingState();
}

class _BillingSettingState extends State<BillingSetting> {
  // const BillingSetting({super.key});
  TextEditingController userController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {context.read<SettingProvider>().doCallGetBillingsSession();});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SettingProvider settingProvider = context.watch<SettingProvider>();
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Billing',
      ),
      body: CustomLoader(
        isLoading: settingProvider.bookSessions.isEmpty && settingProvider.isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if(settingProvider.bookSessions.isNotEmpty && settingProvider.isLoading) LinearProgressIndicator(color: colorPrimary,minHeight: 2,),
              Container(
                padding: EdgeInsets.all(14),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      padding: getPadding(bottom: 13),
                      child: Text('Payment Methods',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: getFontSize(15),
                              color: Colors.black)),
                    ),
                    if (settingProvider.isShowCardFrom)
                      createCardForm(context)
                    else
                      ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                                color: Color(0xffD9D9D9),
                                thickness: 1,
                                height: 32,
                              ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: settingProvider.paymentCards.length,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          itemBuilder: (context, index) => cardCell(
                              settingProvider.paymentCards[index], context)),
                    if (settingProvider.isShowCardFrom)
                      Row(
                        children: [
                          Expanded(
                              child: CustomButton(
                                  borderRadius: 10,
                                  title: settingProvider.isShowCardFrom
                                      ? 'Save Card'
                                      : 'Add New Card',
                                  onPressed: () {
                                    if (!settingProvider.isShowCardFrom) {
                                      userController.clear();
                                      cvvController.clear();
                                      expiryController.clear();
                                      numController.clear();
                                      context
                                          .read<SettingProvider>()
                                          .setIsShowCardFrom(true);
                                    } else {
                                      context
                                          .read<SettingProvider>()
                                          .doCallCreateCard(context);
                                    }
                                  })),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Expanded(
                              child: CustomButton(
                                  borderRadius: 10,
                                  title: 'Cancel',
                                  color: grey,
                                  onPressed: () {
                                    context
                                        .read<SettingProvider>()
                                        .setIsShowCardFrom(false);
                                  })),
                        ],
                      )
                    else
                      SizedBox(
                          width: size.width * 0.4,
                          child: CustomButton(
                              borderRadius: 10,
                              title: 'Add New Card',
                              onPressed: () {
                                if (!settingProvider.isShowCardFrom) {
                                  context
                                      .read<SettingProvider>()
                                      .setIsShowCardFrom(true);
                                } else {
                                  context
                                      .read<SettingProvider>()
                                      .doCallCreateCard(context);
                                }
                              }))
                  ],
                ),
              ),
              if(settingProvider.bookSessions.isNotEmpty)
              Container(
                padding: EdgeInsets.all(14),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      padding: getPadding(bottom: 13),
                      child: Text('Sessions',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: getFontSize(15),
                              color: Colors.black)),
                    ),
                    ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      separatorBuilder: (context, index) => Divider(
                        color: Color(0xffD9D9D9),
                        thickness: 1,
                        height: 32,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: settingProvider.bookSessions.length,
                      itemBuilder: (context, index) => sessionCell(settingProvider.bookSessions[index]),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget sessionCell(BookSession bookSession) {
    var uname = '';
    var fname = '';
    var lname = '';
    String date='';
    dynamic profile = AssetImage("assets/images/placeholder.jpg");
    String sessionPrice='';
    String sessionDuration='';

    if (bookSession.providerData != null) {
      uname = bookSession.providerData!.uname!;
      fname = bookSession.providerData!.fname!.characters.first + '.';
      lname = bookSession.providerData!.lname!;
      if (bookSession.providerData!.avatar != null) {
        profile = NetworkImage(bookSession.providerData!.avatar!.url!);
      }
    }

    if (bookSession.sessionData != null) {
      sessionDuration = bookSession.sessionData!.length!;
      sessionPrice = bookSession.sessionData!.price!;
      double? priceDouble = double.tryParse(sessionPrice);
      if (priceDouble!=null) {
        sessionPrice=(priceDouble+Datamanager().serviceFee*priceDouble/100).toString();  
      }
    }

    return Row(
      children: [
        Container(
          height: getSize(49),
          width: getSize(49),
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: profile,fit: BoxFit.cover)),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: lname,
                      style: TextStyle(
                          fontSize: getFontSize(14),
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      children: [
                        TextSpan(
                          text: " ($uname)",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: getFontSize(14),
                              color: textColorPrimary),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    "\$$sessionPrice",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorPrimary,
                        fontSize: getFontSize(16)),
                  ),
                ],
              ),
              Padding(
                padding: getPadding(top: 12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.event,
                      size: getSize(16),
                      color: borderColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(bookSession.date!,
                        style: TextStyle(
                            fontSize: getFontSize(12),
                            fontWeight: FontWeight.w500,
                            color: borderColor)),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.schedule,
                      size: getSize(16),
                      color: borderColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(sessionDuration+' Minutes',
                        style: TextStyle(
                            fontSize: getFontSize(12),
                            fontWeight: FontWeight.w500,
                            color: borderColor)),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget createCardForm(BuildContext context) {
    SettingProvider settingProviderFalse = context.read<SettingProvider>();
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Form(
          child: Column(
        children: [
          CustomTextFormField(
            controller: userController,
            hintText: "Cardholder Name",
            validator: validateCardNumber,
            onSaved: (String? val) {
              settingProviderFalse.username = val;
            },
            prefixIcon: Icon(
              Icons.person,
              size: getSize(18),
            ),
          ),
          CustomTextFormField(
            controller: numController,
            label: "Card Number",
            hintText: "xxxx xxxx xxxx xxxx",
            keyboardType: TextInputType.number,
            inputFormatters: [
              CardNumberInputFormatter(),
              new LengthLimitingTextInputFormatter(19),
            ],
            // validator: validateName,
            onSaved: (String? val) {
              settingProviderFalse.cardNum = val;
            },
            prefixIcon: Icon(
              Icons.credit_card,
              size: getSize(18),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: CustomTextFormField(
                controller: expiryController,
                label: "Exp Date",
                hintText: 'MM/YY',
                keyboardType: TextInputType.datetime,
                validator: validateExpiryDate,
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(5),
                  new CardMonthInputFormatter()
                ],
                onSaved: (String? val) {
                  settingProviderFalse.expiry = val;
                },
                prefixIcon: Icon(
                  Icons.event,
                  size: getSize(18),
                ),
              )),
              Expanded(
                  child: CustomTextFormField(
                controller: cvvController,
                label: "CVV",
                hintText: 'xxx',
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(4),
                ],
                validator: validateCVV,
                onSaved: (String? val) {
                  settingProviderFalse.cvv = val;
                },
                prefixIcon: Icon(
                  Icons.lock,
                  size: getSize(18),
                ),
              )),
            ],
          )
        ],
      )),
    );
  }

  Widget cardCell(PaymentCard paymentCard, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<SettingProvider>().setPrimaryCard(paymentCard);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Padding(
              padding: getPadding(right: 8.0),
              child: Icon(
                paymentCard.isPrimary == '1'
                    ? Icons.radio_button_checked_outlined
                    : Icons.radio_button_off,
                color: paymentCard.isPrimary == '1'
                    ? colorAccent
                    : textColorPrimary,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Ending in: ",
                      style: TextStyle(
                        fontSize: getFontSize(16),
                        fontWeight: FontWeight.w400,
                        color: textColorPrimary,
                      ),
                      children: [
                        TextSpan(
                          text:
                              "...${paymentCard.number!.substring(paymentCard.number!.length - 4)}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: getFontSize(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: getPadding(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: borderColor,
                          size: getSize(16),
                        ),
                        if (paymentCard.lastUsed == null)
                          Text(
                            ' Never used',
                            style: TextStyle(
                                fontSize: getFontSize(12),
                                fontWeight: FontWeight.w400,
                                color: borderColor),
                          )
                        else
                          Text(
                            ' Last time used: ${DateFormat(defaultDateFormat).format(paymentCard.lastUsed!)}',
                            style: TextStyle(
                                fontSize: getFontSize(12),
                                fontWeight: FontWeight.w400,
                                color: borderColor),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showConfirmDialog(
                        context, 'Are you sure to delete this card?',
                        onAccept: () {
                      context
                          .read<SettingProvider>()
                          .doCallDeleteCard(paymentCard.id!);
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: colorPrimary,
                    size: getSize(23),
                  ),
                ),
                Padding(
                  padding: getPadding(left: 16.0),
                  child: Image.asset(
                    context
                        .read<SettingProvider>()
                        .getCreditCardIcon(paymentCard),
                    height: getSize(34),
                    width: getSize(22),
                    fit: BoxFit.contain,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
