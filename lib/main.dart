import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'config/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    Stripe.publishableKey = AppConstants.stripePublishableKey;
  }

  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: true, // Set to false in production
        builder: (context) => const MuazzinApp(),
      ),
    ),
  );
}

class MuazzinApp extends StatelessWidget {
  const MuazzinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Super Arab tili',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
    );
  }
}
