import 'package:get/get.dart';

class StatusController extends GetxController {
  var isLoading = false.obs;

  isLoaded() {
    isLoading.value = true;
  }

  isNotLoaded() {
    isLoading.value = false;
  }
}
