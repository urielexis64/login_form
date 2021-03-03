import 'package:flutter/material.dart';
import 'package:login_form/constants.dart';
import 'package:login_form/src/models/product_model.dart';
import 'package:login_form/src/shared/components/text_field_container.dart';

class RoundedFormField extends StatelessWidget {
  const RoundedFormField(
    this.product, {
    this.labelText,
    this.hintText,
    this.errorText,
    this.icon,
    this.validator,
    this.onSaved,
    this.initialValue,
    this.type,
  });

  final ProductModel product;
  final String labelText;
  final String hintText;
  final String errorText;
  final TextInputType type;
  final IconData icon;
  final Function validator;
  final Function onSaved;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: type,
        focusNode: FocusNode(canRequestFocus: false),
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: kPrimaryColor,
            ),
            border: InputBorder.none,
            hintText: hintText,
            labelText: labelText,
            errorText: errorText,
            labelStyle: TextStyle(color: kPrimaryColor)),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
