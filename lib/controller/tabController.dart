import 'package:get/get.dart';

class TabsController extends GetxController {
  var selectTab = 0.obs;

  selectedTabs(value) {
    selectTab.value = value;
  }
}
