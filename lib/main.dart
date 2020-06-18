import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:simpledebts/helpers/env_helper.dart';
import 'package:simpledebts/services/analytics_service.dart';
import 'package:simpledebts/services/currency_service.dart';
import 'package:simpledebts/services/debts_service.dart';
import 'package:simpledebts/services/http_auth_service.dart';
import 'package:simpledebts/services/http_service.dart';
import 'package:simpledebts/services/auth_service.dart';
import 'package:simpledebts/services/navigation_service.dart';
import 'package:simpledebts/services/operations_service.dart';
import 'package:simpledebts/services/push_notifications_service.dart';
import 'package:simpledebts/services/shared_preferences_service.dart';
import 'package:simpledebts/services/users_service.dart';
import 'package:simpledebts/screens/auth_screen.dart';
import 'package:simpledebts/screens/debt_screen.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';
import 'package:simpledebts/screens/profile_screen.dart';
import 'package:simpledebts/store/auth.store.dart';
import 'package:simpledebts/screens/start_screen.dart';
import 'package:simpledebts/store/currency.store.dart';
import 'package:simpledebts/store/debt_list.store.dart';

Future<void> main() async {
  await EnvHelper.setupEnvironment();
  setupSingletonServices();
  setupCrashlytics();
  _setupStatusBar();
  await _getCachedInfo();
  runApp(MyApp());
}

void setupSingletonServices() {
  final getIt = GetIt.instance;
  getIt.registerSingleton<AnalyticsService>(AnalyticsService());
  getIt.registerSingleton<SharedPreferencesService>(SharedPreferencesService());
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<PushNotificationsService>(PushNotificationsService()..init());
  getIt.registerSingleton<HttpService>(HttpService());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<AuthStore>(AuthStore(getIt<AuthService>()));
  getIt.registerSingleton<HttpAuthService>(HttpAuthService());
  getIt.registerSingleton<UsersService>(UsersService());
  getIt.registerSingleton<CurrencyService>(CurrencyService());
  getIt.registerSingleton<CurrencyStore>(CurrencyStore());
  getIt.registerSingleton<OperationsService>(OperationsService());
  getIt.registerSingleton<DebtsService>(DebtsService());
  getIt.registerSingleton<DebtListStore>(DebtListStore());
}

void setupCrashlytics() {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
}

Future<void> _getCachedInfo() async {
  final getIt = GetIt.instance;
  try {
    await getIt<SharedPreferencesService>().init();
    final authData = await getIt<AuthStore>().autoLogin();
    if(authData != null) {
      await getIt<CurrencyStore>().getCachedCurrencies();
      await getIt<DebtListStore>().getCachedList();
    }
  } catch(error) {
    print('AUTO LOGIN FAILED');
    print(error);
  }
}

void _setupStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Debts',
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
        accentColor: Colors.orangeAccent,
        primaryColorBrightness: Brightness.dark,
        accentColorBrightness: Brightness.dark,
        colorScheme: const ColorScheme.light(
          primary: const Color.fromRGBO(88, 210, 125, 1),
          primaryVariant: const Color.fromRGBO(199, 239, 209, 1),
          secondary: const Color.fromRGBO(251, 74, 101, 1),
          secondaryVariant: const Color.fromRGBO(253, 196, 200, 1),
        ),
        fontFamily: 'Roboto',
        textTheme: Theme.of(context)
            .textTheme
            .copyWith(
              headline1: const TextStyle(fontFamily: 'Montserrat'),
              headline2: const TextStyle(fontFamily: 'Montserrat'),
              headline3: const TextStyle(fontFamily: 'Montserrat'),
              headline4: const TextStyle(fontFamily: 'Montserrat'),
              headline5: const TextStyle(fontFamily: 'Montserrat'),
              headline6: const TextStyle(fontFamily: 'Montserrat'),
            ).apply(
                bodyColor: const Color.fromRGBO(71, 82, 94, 1),
                displayColor: const Color.fromRGBO(71, 82, 94, 1)
            ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: GetIt.instance<AnalyticsService>().analytics
        ),
      ],
      home: StartScreen(),
      routes: {
        AuthScreen.routeName: (_) => AuthScreen(),
        DebtsListScreen.routeName: (_) => DebtsListScreen(),
        ProfileScreen.routeName: (_) => ProfileScreen(),
        DebtScreen.routeName: (_) => DebtScreen(),
      },
    );
  }
}
