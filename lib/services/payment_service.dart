import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/constants/app_constants.dart';

class PaymentService {
  static const String _cardsKey = 'saved_payment_cards';

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

  // --- Card Persistence Logic ---

  Future<List<Map<String, String>>> getSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final cardsJson = prefs.getStringList(_cardsKey) ?? [];
    return cardsJson
        .map((c) => Map<String, String>.from(json.decode(c)))
        .toList();
  }

  Future<void> saveCard(Map<String, String> card) async {
    final prefs = await SharedPreferences.getInstance();
    final cards = await getSavedCards();
    cards.add(card);
    final cardsJson = cards.map((c) => json.encode(c)).toList();
    await prefs.setStringList(_cardsKey, cardsJson);
  }

  Future<void> deleteCard(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final cards = await getSavedCards();
    if (index >= 0 && index < cards.length) {
      cards.removeAt(index);
      final cardsJson = cards.map((c) => json.encode(c)).toList();
      await prefs.setStringList(_cardsKey, cardsJson);
    }
  }
}
