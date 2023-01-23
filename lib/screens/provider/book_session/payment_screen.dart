import 'package:bookthera_customer/components/custom_appbar.dart';
import 'package:bookthera_customer/components/custom_button.dart';
import 'package:bookthera_customer/components/custom_loader.dart';
import 'package:bookthera_customer/components/custom_textfields.dart';
import 'package:bookthera_customer/screens/provider/book_session/book_session_provider.dart';
import 'package:bookthera_customer/screens/provider/book_session/order_success.dart';
import 'package:bookthera_customer/utils/Common.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/helper.dart';
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
                      padding: const EdgeInsets.only(bottom: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
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
                                thickness: 1,
                                height: 32,
                              ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: provider.paymentCards.length,
                          padding: EdgeInsets.only(top: 16, bottom: 24),
                          itemBuilder: (context, index) =>
                              cardCell(provider.paymentCards[index], context))
                    else
                      Column(
                        children: [
                          Form(
                              child: Column(
                            children: [
                              CustomTextFormField(
                                controller:provider.userController,
                                hintText: "Cardholder Name",
                                // validator: validateName,
                                onSaved: (String? val) {
                                  provider.username = val;
                                },
                                prefixIcon: Icon(
                                  Icons.person,
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
                                // validator: validateName,
                                onSaved: (String? val) {
                                  provider.cardNum = val;
                                },
                                prefixIcon: Icon(
                                  Icons.credit_card,
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
                                    // validator: validateName,
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(4),
                                      new CardMonthInputFormatter()
                                    ],
                                    onSaved: (String? val) {
                                      provider.expiry = val;
                                    },
                                    prefixIcon: Icon(
                                      Icons.event,
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
                                      new LengthLimitingTextInputFormatter(3),
                                    ],
                                    // validator: validateName,
                                    onSaved: (String? val) {
                                      provider.cvv = val;
                                    },
                                    prefixIcon: Icon(
                                      Icons.lock,
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
                                thumbColor:
                                    MaterialStateProperty.all(colorAccent),
                              ),
                              Text(
                                'Save this card for future paument?',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
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
                          title: provider.isShowCardFrom?'Save Card': 'Purchase \$${provider.total}',
                          onPressed: () {
                            context
                                .read<BookSesstionProvider>()
                                .makePaymentStripe(context);
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
            padding: const EdgeInsets.only(bottom: 13),
            child: Text('Session Details',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Session Intentions *',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: textColorPrimary)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(provider.intensionsController.text,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: borderColor)),
          ),
          infoCell('Date',
              '${DateFormat(defaultDateFormat).format(provider.selectedDate)}  ${provider.selectedTime} (${provider.selectedSesssion!.length}Mins)'),
          infoCell('Session Type', provider.sesstionType.name),
          infoCell('Session Price',
              '\$${provider.selectedSesssion!.price.toStringAsFixed(2)}'),
          infoCell('Service Fee', '\$${serviceFee.toStringAsFixed(2)}'),
          infoCell('Total', '\$${provider.total.toStringAsFixed(2)}',
              keyFont: FontWeight.w600,
              ValueFont: FontWeight.w700,
              fontSize: 15),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
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
                    child: CustomButton(
                        borderRadius: 10, title: 'Apply', onPressed: () {}))
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
                    fontSize: fontSize,
                    color: textColorPrimary)),
            Text(value,
                style: TextStyle(
                    fontWeight: ValueFont,
                    fontSize: fontSize,
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
              padding: const EdgeInsets.only(right: 8.0),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: textColorPrimary,
                      ),
                      children: [
                        TextSpan(
                          text:
                              "...${paymentCard.number!.substring(paymentCard.number!.length - 4)}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: borderColor,
                          size: 16,
                        ),
                        if (paymentCard.lastUsed == null)
                          Text(
                            ' Never used',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: borderColor),
                          )
                        else
                          Text(
                            ' Last time used: ${DateFormat(defaultDateFormat).format(paymentCard.lastUsed!)}',
                            style: TextStyle(
                                fontSize: 12,
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
              padding: const EdgeInsets.only(left: 16.0),
              child: Image.asset(
                context
                    .read<BookSesstionProvider>()
                    .getCreditCardIcon(paymentCard),
                height: 34,
                width: 22,
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
    );
  }
}
