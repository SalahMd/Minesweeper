import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/core/services/shared_pref.dart';
import 'package:untitled/features/first_page/view/screens/first_page.dart';
import 'package:untitled/features/home/view/screens/home_page.dart';
import 'package:untitled/features/load_board/view/screens/load_board.dart';

void main(List <String> args)  async{
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return ScreenUtilInit(
      designSize: const Size(320, 790),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        getPages: [
          GetPage(
            name: "/",
            page: () => const FirstPage(),
          ),
          GetPage(name: "/LoadBoard", page: () => const LoadBoard()),
          GetPage(name: "/HomePage", page: () => const HomePage()),
        ],
      ),
    );
  }
}
