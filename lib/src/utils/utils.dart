import 'package:flutter/material.dart';
import 'package:login_form/src/shared/components/custom_image_dialog.dart';

bool isNumeric(String value) {
  if (value.isEmpty) return false;

  final n = num.tryParse(value);
  return n != null;
}

Future<void> alertInfo(
    BuildContext context, String title, String subtitle, String imagePath) {
  return showGeneralDialog(
      context: context,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue =
            Curves.easeInOutBack.transform(animation.value) - 1.0;
        return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: animation.value,
              child: CustomImageDialog(
                  title: title, subtitle: subtitle, imagePath: imagePath),
            ));
      },
      transitionDuration: Duration(milliseconds: 250),
      pageBuilder: (context, animation1, animation2) {
        return;
      });
}
