import 'package:csci361_vms_frontend/pages/login_page.dart';
import 'package:csci361_vms_frontend/pages/create_assignment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csci361_vms_frontend/pages/profile_page.dart';

class PageNotifier extends StateNotifier<Widget> {
  PageNotifier() : super(const ProfilePage());

  void setPage(Widget page) {
    state = page;
  }
}

final pageProvider =
    StateNotifierProvider<PageNotifier, Widget>((ref) => PageNotifier());
