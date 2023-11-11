import 'package:csci361_vms_frontend/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageNotifier extends StateNotifier<Widget> {
  PageNotifier() : super(LoginPage());

  void setPage(Widget page) {
    state = page;
  }
}

final pageProvider =
    StateNotifierProvider<PageNotifier, Widget>((ref) => PageNotifier());
