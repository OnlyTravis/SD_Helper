import 'package:client/app.dart';
import 'package:client/code/fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  HttpServer.init();
  runApp(const SDHelperApp());
}