import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/providers/auth_provider.dart';
import 'package:simpledebts/screens/auth_screen.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';
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
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) => FutureBuilder<bool>(
          future: auth.autoLogin(),
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
                colorScheme: ColorScheme.light(
                  primary: Color.fromRGBO(88, 210, 125, 1),
                  primaryVariant: Color.fromRGBO(199, 239, 209, 1),
                  secondary: Color.fromRGBO(251, 74, 101, 1),
                  secondaryVariant: Color.fromRGBO(253, 196, 200, 1),
                ),
                textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Color.fromRGBO(71, 82, 94, 1),
                    displayColor: Color.fromRGBO(71, 82, 94, 1)
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: startScreen,
              routes: {
                AuthScreen.routeName: (_) => AuthScreen(),
                DebtsListScreen.routeName: (_) => DebtsListScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
