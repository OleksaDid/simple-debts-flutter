import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/providers/auth_provider.dart';
import 'package:simpledebts/providers/currency_provider.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/providers/operations_provider.dart';
import 'package:simpledebts/providers/users_provider.dart';
import 'package:simpledebts/screens/auth_screen.dart';
import 'package:simpledebts/screens/debt_screen.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';
import 'package:simpledebts/screens/profile_screen.dart';
import 'package:simpledebts/screens/splash_screen.dart';

Future<void> main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UsersProvider>(
          create: (_) => UsersProvider(),
          update: (context, auth, provider) => provider
            ..setupAuthHeader(auth.authHeaders),
        ),
        ChangeNotifierProxyProvider<AuthProvider, DebtsProvider>(
          create: (_) => DebtsProvider(),
          update: (context, auth, provider) => provider
            ..setupAuthHeader(auth.authHeaders),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OperationsProvider>(
          create: (_) => OperationsProvider(),
          update: (context, auth, provider) => provider
            ..setupAuthHeader(auth.authHeaders),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CurrencyProvider>(
          create: (_) => CurrencyProvider(),
          update: (context, auth, provider) => provider
            ..setupAuthHeader(auth.authHeaders),
        ),
      ],
      child: MyAppBody()
    );
  }
}

// TODO: route animations
class MyAppBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Provider.of<AuthProvider>(context, listen: false).autoLogin(),
      builder: (context, snapshot) {
        Widget startScreen;
        if(snapshot.connectionState == ConnectionState.waiting) {
          startScreen = SplashScreen();
        } else {
          startScreen = snapshot.data == true ? DebtsListScreen() : AuthScreen();
        }
        return MaterialApp(
          title: 'Simple Dets',
          theme: ThemeData(
            primaryColor: Colors.redAccent,
            accentColor: Colors.orangeAccent,
            colorScheme: const ColorScheme.light(
              primary: const Color.fromRGBO(88, 210, 125, 1),
              primaryVariant: const Color.fromRGBO(199, 239, 209, 1),
              secondary: const Color.fromRGBO(251, 74, 101, 1),
              secondaryVariant: const Color.fromRGBO(253, 196, 200, 1),
            ),
            fontFamily: 'Roboto',
            textTheme: Theme.of(context).textTheme
              .copyWith(
                headline1: const TextStyle(fontFamily: 'Montserrat'),
                headline2: const TextStyle(fontFamily: 'Montserrat'),
                headline3: const TextStyle(fontFamily: 'Montserrat'),
                headline4: const TextStyle(fontFamily: 'Montserrat'),
                headline5: const TextStyle(fontFamily: 'Montserrat'),
                headline6: const TextStyle(fontFamily: 'Montserrat'),
              )
              .apply(
                bodyColor: const Color.fromRGBO(71, 82, 94, 1),
                displayColor: const Color.fromRGBO(71, 82, 94, 1)
              ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: startScreen,
          routes: {
            AuthScreen.routeName: (_) => AuthScreen(),
            DebtsListScreen.routeName: (_) => DebtsListScreen(),
            ProfileScreen.routeName: (_) => ProfileScreen(),
            DebtScreen.routeName: (_) => DebtScreen(),
          },
        );
      },
    );
  }
}
