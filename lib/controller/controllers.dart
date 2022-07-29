import 'package:get/get.dart';

/// SearchUserselectionController
class SearchPanelController extends GetxController {
  var isSearch = false.obs;

  isSearched() {
    isSearch.value = true;
  }

  isNotSearched() {
    isSearch.value = false;
  }
}

/// SearchUserController
class SearchUserController extends GetxController {
  var isSearch = false.obs;
  isSearched() {
    isSearch.value = true;
  }

  isNotSearched() {
    isSearch.value = false;
  }
}

/// Status Show Controller

class StatusController extends GetxController {
  var isLoading = false.obs;

  isLoaded() {
    isLoading.value = true;
  }

  isNotLoaded() {
    isLoading.value = false;
  }
}

/// TabsController

class TabsController extends GetxController {
  var selectTab = 0.obs;

  selectedTabs(value) {
    selectTab.value = value;
  }
}
