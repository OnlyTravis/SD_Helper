import 'package:client/page_templates/main_navigation/main_navigation.dart';
import 'package:client/pages/folder_page/folder_page.dart';
import 'package:client/pages/home_page/home_page.dart';
import 'package:client/pages/login_page/login_page.dart';
import 'package:flutter/material.dart';

Widget toPage(Pages page) {
  switch (page) {
    case Pages.LoginPage:
      return const LoginPage();
    case Pages.HomePage:
      return const HomePage();
    case Pages.FolderPage:
      return const FolderPage();
  }
}