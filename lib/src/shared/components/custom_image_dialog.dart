import 'package:flutter/material.dart';
import 'package:login_form/constants.dart';

class CustomImageDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const CustomImageDialog({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: Constants.avatarRadius + Constants.padding,
            ),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Center(
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Constants.kPrimaryColor)),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              )
            ]),
          ),
          Positioned(
            left: Constants.padding,
            right: Constants.padding,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(imagePath),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
