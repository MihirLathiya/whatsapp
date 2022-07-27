import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchUserController extends GetxController {
  var isSearch = false.obs;
  isSearched() {
    isSearch.value = true;
  }

  isNotSearched() {
    isSearch.value = false;
  }
}
