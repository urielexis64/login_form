import 'package:flutter/material.dart';
import 'package:login_form/constants.dart';

import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const RoundedInputField(
      {Key key,
      @required this.hintText,
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
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
          hintText: hintText,
          labelStyle: TextStyle(color: kPrimaryColor)),
    ));
  }
}
