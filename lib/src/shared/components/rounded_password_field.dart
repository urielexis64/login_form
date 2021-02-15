import 'package:flutter/material.dart';
import 'package:login_form/constants.dart';

import 'text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({Key key, this.onChanged}) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _obscureText = true;
  IconData _icon = Icons.visibility;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
          hintText: 'Password',
          labelStyle: TextStyle(color: kPrimaryColor),
          icon: Icon(Icons.lock, color: kPrimaryColor),
          suffixIcon: GestureDetector(
            onTap: _hide,
            child: Icon(
              _icon,
              color: kPrimaryColor,
            ),
          ),
          border: InputBorder.none),
    ));
  }

  void _hide() {
    setState(() {
      if (_obscureText) {
        _icon = Icons.visibility_off;
        _obscureText = false;
      } else {
        _icon = Icons.visibility;
        _obscureText = true;
      }
    });
  }
}
