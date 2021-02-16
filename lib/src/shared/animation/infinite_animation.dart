import 'package:flutter/material.dart';

class InfiniteAnimation {
  TickerProvider provider;
  Duration duration = Duration(seconds: 1);
  double beginValue;
  double endValue;
  Curve curve = Curves.ease;
  bool reverse = false;

  Animation<double> animation;
  AnimationController _controller;

  InfiniteAnimation({
    @required this.provider,
    @required this.beginValue,
    @required this.endValue,
    @required this.curve,
    @required this.reverse,
    @required this.duration,
  }) {
    _init();
  }

  void _init() {
    _controller = AnimationController(vsync: provider, duration: duration);

    animation = Tween(begin: beginValue, end: endValue)
        .animate(new CurvedAnimation(parent: _controller, curve: curve));
    _controller.repeat(reverse: reverse);
  }

  void dispose() {
    _controller.dispose();
  }

  get value {
    return animation.value;
  }

  get view {
    return _controller.view;
  }
}
