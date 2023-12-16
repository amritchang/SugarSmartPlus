import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

showAlertDialogWithTwoButtons(
  String title,
  String message,
  String? leftButtonTitle,
  String? rightButtonTitle,
  BuildContext context, {
  Function()? onLeftPressed,
  Function()? onRightPressed,
}) {
  // set up the buttons
  Widget leftButton = TextButton(
    child: Text(leftButtonTitle ?? AppLocalizations.of(context)!.cancelButton),
    onPressed: () {
      Navigator.of(context).pop();
      if (onLeftPressed != null) {
        onLeftPressed();
      }
    },
  );
  Widget rightButton = TextButton(
    child: Text(rightButtonTitle ?? AppLocalizations.of(context)!.okButton),
    onPressed: () {
      Navigator.of(context).pop();
      if (onRightPressed != null) {
        onRightPressed();
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      leftButton,
      rightButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialogWithOk(
  String title,
  String message,
  BuildContext context, {
  Function()? onOkPressed,
}) {
  Widget okButton = TextButton(
    child: Text(AppLocalizations.of(context)!.okButton),
    onPressed: () {
      if (onOkPressed != null) {
        Navigator.of(context).pop();
        onOkPressed();
      } else {
        Navigator.of(context).pop();
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
