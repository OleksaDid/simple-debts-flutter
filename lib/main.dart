import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/services/currency_service.dart';
import 'package:simpledebts/services/http_auth_service.dart';
import 'package:simpledebts/services/http_service.dart';
import 'package:simpledebts/services/auth_service.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/services/operations_service.dart';
import 'package:simpledebts/services/users_service.dart';
import 'package:simpledebts/screens/auth_screen.dart';
import 'package:simpledebts/screens/debt_screen.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';
import 'package:simpledebts/screens/profile_screen.dart';
import 'package:simpledebts/store/auth_data_store.dart';
import 'package:simpledebts/screens/start_screen.dart';
import 'package:simpledebts/store/currency_store.dart';

Future<void> main() async {
  await DotEnv().load('.env');
  setup();
  runApp(MyApp());
}

void setup() {
  GetIt.I.registerSingleton<HttpService>(HttpService());
  GetIt.I.registerSingleton<AuthService>(AuthService());
  GetIt.I.registerSingleton<AuthDataStore>(AuthDataStore());
  GetIt.I.registerSingleton<HttpAuthService>(HttpAuthService());
  GetIt.I.registerSingleton<CurrencyService>(CurrencyService());
  GetIt.I.registerSingleton<CurrencyStore>(CurrencyStore());
  GetIt.I.registerSingleton<UsersService>(UsersService());
  GetIt.I.registerSingleton<OperationsService>(OperationsService());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DebtsProvider(),
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
