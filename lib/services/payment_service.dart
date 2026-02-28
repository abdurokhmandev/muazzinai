import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../config/constants/app_constants.dart';

class PaymentService {
  Future<void> initPaymentSheet(String clientSecret) async {
    try {
      if (kIsWeb) return; // Stripe Payment Sheet not supported on Web this way

      Stripe.publishableKey = AppConstants.stripePublishableKey;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Super Arab tili',
          style: ThemeMode.light,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> presentPaymentSheet() async {
    try {
      if (kIsWeb) return true; // Mock success for web during development
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      if (e is StripeException) {
        return false;
      } else {
        rethrow;
      }
    }
  }

  // In a real app, you would make an HTTP request to your backend to create the PaymentIntent
  // and retrieve the client_secret securely.
  Future<String> fetchMockClientSecret() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'mock_client_secret_xyz'; // Mock fallback
  }
}
