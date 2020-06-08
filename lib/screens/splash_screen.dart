import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/icon_transparent.png'),
              SizedBox(height: 100,),
              Text(
                'Simple Debts',
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

}