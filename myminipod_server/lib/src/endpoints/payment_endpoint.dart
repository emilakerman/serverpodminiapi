import 'package:dio/dio.dart';
import 'package:myminipod_server/common/constants/stripe_constants.dart';
import 'package:serverpod/serverpod.dart';

class PaymentEndpoint extends Endpoint {
  Future<String?> createPaymentIntent(
    Session session,
    int amount,
    String currency,
  ) async {
    // Conversion to lowest currency denominator such as CENT or ÖRE.
    // From its bigger equivalent such as USD or SEK.
    // Stripe likes CENT/ÖRE, the end user does not.
    final int convertedAmount = (amount * 100);
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": convertedAmount,
        "currency": currency,
      };
      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ${StripeConstants.stripeSecretKey}",
            "Content-Type": "application/x-www-form-urlenconded",
          },
        ),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
    } catch (e) {
      session.log("Could not create payment intent. $e");
      return null;
    }
    return null;
  }
}
