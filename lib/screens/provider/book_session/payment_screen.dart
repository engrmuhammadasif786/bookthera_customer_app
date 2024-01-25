import 'package:bookthera_customer/components/custom_appbar.dart';
import 'package:bookthera_customer/components/custom_button.dart';
import 'package:bookthera_customer/components/custom_loader.dart';
import 'package:bookthera_customer/components/custom_textfields.dart';
import 'package:bookthera_customer/screens/provider/book_session/book_session_provider.dart';
import 'package:bookthera_customer/screens/provider/book_session/order_success.dart';
import 'package:bookthera_customer/utils/Common.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:bookthera_customer/utils/helper.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_textform_field.dart';
import '../../../models/payment_card.dart';
import '../../../utils/resources/Colors.dart';

class PaymentScreen extends StatefulWidget {
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // const PaymentScreen({super.key});
  TextEditingController couponController = TextEditingController();
  GlobalKey<FormState> _formKey=GlobalKey();
  
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BookSesstionProvider>().getTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    BookSesstionProvider provider =
        Provider.of<BookSesstionProvider>(context, listen: true);
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Payment',
      ),
      body: CustomLoader(
        isLoading: provider.isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              sessionDetails(size, context),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: getFontSize(15),
                                  color: Colors.black)),
                          GestureDetector(
                              onTap: () {
                                context
                                    .read<BookSesstionProvider>()
                                    .updateIsShowCardForm();
                              },
                              child: Icon(
                                provider.isShowCardFrom
                                    ? Icons.remove
                                    : Icons.add,
                                color: colorPrimary,
                              ))
                        ],
                      ),
                    ),
                    if (!provider.isShowCardFrom)
                      ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                                color: Color(0xffD9D9D9),
                                thickness: getSize(1),
                                height: getSize(32),
                              ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: provider.paymentCards.length,
                          padding: getPadding(top: 16, bottom: 24),
                          itemBuilder: (context, index) =>
                              cardCell(provider.paymentCards[index], context))
                    else
                      Column(
                        children: [
                          Form(
                            key: _formKey,
                              child: Column(
                            children: [
                              CustomTextFormField(
                                controller:provider.userController,
                                hintText: "Cardholder Name",
                                // validator: validateName,
                                onSaved: (String? val) {
                                  provider.username = val;
                                },
                                prefixWidget: Icon(
                                  Icons.person,
                                  size: getSize(18),
                                  color: colorPrimary,
                                ),
                              ),
                              CustomTextFormField(
                                controller:provider. numController,
                                label: "Card Number",
                                hintText: "xxxx xxxx xxxx xxxx",
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  CardNumberInputFormatter(),
                                  new LengthLimitingTextInputFormatter(19),
                                ],
                                validator: validateCardNumber,
                                onSaved: (String? val) {
                                  provider.cardNum = val;
                                },
                                prefixWidget: Icon(
                                  Icons.credit_card,
                                  size: getSize(18),
                                  color: colorPrimary,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: CustomTextFormField(
                                    controller:provider. expiryController,
                                    label: "Exp Date",
                                    hintText: 'MM/YY',
                                    keyboardType: TextInputType.datetime,
                                    validator: validateExpiryDate,
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(5),
                                      new CardMonthInputFormatter()
                                    ],
                                    onSaved: (String? val) {
                                      provider.expiry = val;
                                    },
                                    prefixWidget: Icon(
                                      Icons.event,
                                      size: getSize(18),
                                      color: colorPrimary,
                                    ),
                                  )),
                                  Expanded(
                                      child: CustomTextFormField(
                                    controller:provider. cvvController,
                                    label: "CVV",
                                    hintText: 'xxx',
                                    keyboardType: TextInputType.number,
                                    obscureText: true,
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(4),
                                    ],
                                    validator: validateCVV,
                                    onSaved: (String? val) {
                                      provider.cvv = val;
                                    },
                                    prefixWidget: Icon(
                                      Icons.lock,
                                      size: getSize(18),
                                      color: colorPrimary,
                                    ),
                                  )),
                                ],
                              )
                            ],
                          )),
                          Row(
                            children: [
                              Switch(
                                value: provider.saveCard,
                                onChanged: (value) {
                                  context
                                      .read<BookSesstionProvider>()
                                      .updateSaveCard();
                                },
                                activeColor: colorAccent,
                                inactiveThumbColor: grey,
                              ),
                              Text(
                                'Save this card for future payment?',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getFontSize(12),
                                    color: textColorPrimary),
                              )
                            ],
                          ),
                        ],
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                          color: colorAccent,
                          borderRadius: 8,
                          title: 'Purchase \$${provider.total}',
                          onPressed: () {
                            if (provider.isShowCardFrom && _formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              context
                                .read<BookSesstionProvider>()
                                .makePaymentStripe(context);
                            }else{
                              context
                                .read<BookSesstionProvider>()
                                .makePaymentStripe(context);
                            }
                          }),
                    ),
                    SizedBox(
                      height: 9,
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

  Container sessionDetails(Size size, BuildContext context) {
    BookSesstionProvider provider = Provider.of<BookSesstionProvider>(context);

    return Container(
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
            child: Text('Session Details',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: getFontSize(15),
                    color: Colors.black)),
          ),
          Padding(
            padding: getPadding(bottom: 8),
            child: Text('Intentions',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: getFontSize(13),
                    color: textColorPrimary)),
          ),
          Padding(
            padding: getPadding(bottom: 8.0),
            child: Text(provider.intensionsController.text,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: getFontSize(13),
                    color: borderColor)),
          ),
          infoCell('Date',
              '${DateFormat(defaultDateFormat).format(provider.selectedDate)}  ${provider.selectedTime.time24To12Format('')} (${provider.selectedSesssion!.length}Mins)'),
          infoCell('Session Type', provider.sesstionType.name),
          infoCell('Session Price',
              '\$${provider.selectedSesssion!.price.toStringAsFixed(2)}'),
          infoCell('Service Fee', '\$${(Datamanager().serviceFee*provider.selectedSesssion!.price).toStringAsFixed(2)}'),
          infoCell('Total', '\$${provider.total.toStringAsFixed(2)}',
              keyFont: FontWeight.w600,
              ValueFont: FontWeight.w700,
              fontSize: getFontSize(15)),
          Padding(
            padding: getPadding(top: 25.0),
            child: Row(
              children: [
                Expanded(
                    child: CustomTextField(
                  hint: 'Enter promo/gift code',
                  textEditingController: couponController,
                  prefixIcon: Icon(Icons.local_offer_outlined),
                )),
                SizedBox(
                  width: 12,
                ),
                SizedBox(
                    width: size.width * 0.25,
                    height: getSize(54),
                    child: CustomButton(
                        borderRadius: getSize(10), title: 'Apply', onPressed: () {}))
              ],
            ),
          )
        ],
      ),
    );
  }

  infoCell(String key, String value,
      {FontWeight keyFont = FontWeight.w500,
      FontWeight ValueFont = FontWeight.w400,
      double fontSize = 13}) {
    return Column(
      children: [
        Divider(
          color: Color(0xffD9D9D9),
          thickness: 1,
          height: 32,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(key,
                style: TextStyle(
                    fontWeight: keyFont,
                    fontSize: getFontSize(fontSize),
                    color: textColorPrimary)),
            Text(value,
                style: TextStyle(
                    fontWeight: ValueFont,
                    fontSize: getFontSize(fontSize),
                    color: textColorPrimary))
          ],
        ),
      ],
    );
  }

  Widget cardCell(PaymentCard paymentCard, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<BookSesstionProvider>().setPrimaryCard(paymentCard);
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
            Padding(
              padding: getPadding(left: 16.0),
              child: Image.asset(
                context
                    .read<BookSesstionProvider>()
                    .getCreditCardIcon(paymentCard),
                height: getSize(34),
                width: getSize(22),
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
    );
  }
}
