import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/feautres/home/view/screens/home_page.dart';

void main() {
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
          page: () => const HomePage(),
        ),
        //GetPage(name: "/Login", page: () => const Login()),
      ]),
    );
  }
}
