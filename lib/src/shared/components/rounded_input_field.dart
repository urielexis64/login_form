import 'package:flutter/material.dart';
import 'package:login_form/constants.dart';

import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String errorText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const RoundedInputField(
      {Key key,
      @required this.labelText,
      this.hintText,
      this.errorText,
      @required this.icon,
      @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Constants.kPrimaryColor,
          ),
          border: InputBorder.none,
          hintText: hintText,
          labelText: labelText,
          errorText: errorText,
          labelStyle: TextStyle(color: Constants.kPrimaryColor)),
    ));
  }
}
