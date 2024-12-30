import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class AppAnimations{
   static const String path = "assets/animations/";
  static LottieBuilder lose =
      Lottie.asset("${path}lose.json", repeat: false);
        static LottieBuilder win =
      Lottie.asset("${path}win.json", repeat: false,fit: BoxFit.fill);
       static LottieBuilder done =
      Lottie.asset("${path}done.json", repeat: false,fit: BoxFit.fill);
}