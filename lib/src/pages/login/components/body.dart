import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_form/src/bloc/provider.dart';
import 'package:login_form/src/providers/user_provider.dart';
import 'package:login_form/src/shared/animation/infinite_animation.dart';
import 'package:login_form/src/shared/components/already_have_an_account.dart';
import 'package:login_form/src/shared/components/rounded_button.dart';
import 'package:login_form/src/shared/components/rounded_input_field.dart';
import 'package:login_form/src/shared/components/rounded_password_field.dart';
import 'package:login_form/src/utils/utils.dart' as utils;

import 'background.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  InfiniteAnimation infiniteAnimation;
  final userProvider = UserProvider();

  @override
  void initState() {
    infiniteAnimation = InfiniteAnimation(
        provider: this,
        beginValue: -5,
        endValue: 5,
        reverse: true,
        curve: Curves.ease,
        duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    infiniteAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    Size size = MediaQuery.of(context).size;

    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'LOGIN',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          AnimatedBuilder(
            animation: infiniteAnimation.view,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, infiniteAnimation.value),
              child: child,
            ),
            child: SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * .25,
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          StreamBuilder(
            stream: bloc.emailStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return RoundedInputField(
                labelText: 'Email',
                hintText: 'example@email.com',
                errorText: snapshot.error,
                icon: Icons.email,
                onChanged: bloc.changeEmail,
              );
            },
          ),
          StreamBuilder(
            stream: bloc.passwordStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return RoundedPasswordField(
                onChanged: bloc.changePassword,
                errorText: snapshot.error,
              );
            },
          ),
          StreamBuilder(
            stream: bloc.formValidStream,
            builder: (context, AsyncSnapshot snapshot) {
              return RoundedButton(
                text: 'LOGIN',
                press: snapshot.hasData ? () => _login(bloc) : null,
              );
            },
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          AlreadyHaveAnAccountCheck(
            login: true,
            press: () => Navigator.pushReplacementNamed(context, 'signup'),
          )
        ],
      ),
    ));
  }

  _login(LoginBloc bloc) async {
    Map<String, dynamic> response =
        await userProvider.login(bloc.email, bloc.password);

    if (response['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      utils.alertInfo(context, response['message'],
          'Email or password incorrect', 'assets/images/error.gif');
    }
  }
}
