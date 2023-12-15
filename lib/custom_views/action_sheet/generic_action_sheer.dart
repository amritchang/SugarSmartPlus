import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenericActionSheet<T> {
  final BuildContext context;
  final List<T> options;
  final Widget Function(T) itemBuilder;
  final void Function(T) onSelected;
  final String? title;

  GenericActionSheet({
    this.title,
    required this.context,
    required this.options,
    required this.itemBuilder,
    required this.onSelected,
  });

  void show() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: title != null ? Text(title!) : null,
        actions: _buildActions(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancelButton),
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return options.map((option) {
      return CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
          onSelected(option);
        },
        child: itemBuilder(option),
      );
    }).toList();
  }
}
