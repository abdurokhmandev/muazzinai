import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'config/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    Stripe.publishableKey = AppConstants.stripePublishableKey;
  }

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'uz',
    supportedLocales: ['uz', 'en', 'ar'],
    basePath: 'assets/i18n/',
  );

  runApp(
    LocalizedApp(
      delegate,
      ProviderScope(
        child: DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => const MuazzinApp(),
        ),
      ),
    ),
  );
}

class MuazzinApp extends StatelessWidget {
  const MuazzinApp({super.key});

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return MaterialApp.router(
      title: 'Super Arab tili',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      locale: localizationDelegate.currentLocale,
      supportedLocales: localizationDelegate.supportedLocales,
      localizationsDelegates: [
        localizationDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: DevicePreview.appBuilder,
    );
  }
}
