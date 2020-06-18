import 'package:flutter/material.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';

class DeleteOperationButton extends StatelessWidget with SpinnerStoreUse {
  final Future<void> Function() onDelete;

  DeleteOperationButton({
    @required this.onDelete
  });

  Future<void> _deleteOperation(BuildContext context) async {
    final deleteOperation = await DialogHelper.showDeleteDialog(context, 'Delete this operation?');
    if(deleteOperation == true) {
      showSpinner();
      try {
        await onDelete();
        Navigator.of(context).pop();
        hideSpinner();
      } on Failure catch(error) {
        hideSpinner();
        ErrorHelper.showErrorDialog(context, error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      alignment: Alignment.centerRight,
      child: spinnerContainer(
        spinner: ButtonSpinner(),
        replacement: FlatButton(
          child: const Text('DELETE'),
          textColor: Theme.of(context).colorScheme.secondary,
          onPressed: () => _deleteOperation(context),
        )
      ),
    );
  }
}