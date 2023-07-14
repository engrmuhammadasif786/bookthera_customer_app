import 'package:bookthera_customer/network/RestApis.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:nb_utils/nb_utils.dart';

class PaymentService {
  final String tokenizationKey = 'sandbox_bnt4bz5d_y2tknys948fd74tj'; 
  
  Future<dynamic> tokenizeCreditCard(BraintreeCreditCardRequest request) async {
    try {
      log(request.toJson());
      dynamic clientToken = await callBraintreeClientToken();
      if (clientToken==null) {
        return;
      }
      BraintreePaymentMethodNonce? result = await Braintree.tokenizeCreditCard(
        clientToken,
        request,
      );
      if(result==null) return;
      print('Payment Nonce: ${result.nonce}');
      return result.nonce;
      
    } catch (error) {
      print('Failed to tokenize credit card: $error');
    }
  }
}
