import 'package:flutter/material.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';

class EmptyListPlaceholder extends StatelessWidget with SpinnerStoreUse {
  final IconData icon;
  final String title;
  final String subtitle;
  final Future<void> Function() onRefresh;

  EmptyListPlaceholder({
    @required this.icon,
    @required this.title,
    @required this.subtitle,
    this.onRefresh
  });

  bool get isRefreshable {
    return onRefresh != null;
  }

  Future<void> _refresh() async {
    showSpinner();
    try {
      await onRefresh();
    } on Failure catch(error) {
      print(error);
    }
    hideSpinner();
  }

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
            if(isRefreshable) SizedBox(height: 20,),
            if(isRefreshable) spinnerContainer(
              spinner: ButtonSpinner(),
              replacement: FlatButton(
                child: Text('REFRESH'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _refresh,
              ),
            )
          ],
        ),
      ),
    );
  }

}