import 'package:get/get.dart';
import 'package:untitled/core/services/game_services.dart';

injectDependecies(){
    Get.lazyPut(()=>GameServices());
}