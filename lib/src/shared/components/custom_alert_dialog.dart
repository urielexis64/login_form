import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Function onConfirmed;
  final Function onDismissed;
  final String title;
  final List<Widget> contentWidgets;

  final bool actions;

  const CustomAlertDialog(
      {@required this.title,
      @required this.contentWidgets,
      this.onConfirmed,
      this.onDismissed,
      this.actions = true});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: contentWidgets,
        ),
      ),
      actions: actions
          ? <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: onDismissed ??
                    () {
                      Navigator.pop(context);
                    },
              ),
              TextButton(child: Text('Yes'), onPressed: onConfirmed),
            ]
          : null,
    );
  }
}
