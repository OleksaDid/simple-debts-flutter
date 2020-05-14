import 'package:flutter/material.dart';

class EmptyListPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  EmptyListPlaceholder({
    @required this.icon,
    @required this.title,
    @required this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).textTheme.headline1.color,
            ),
            SizedBox(height: 20,),
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 4,),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}