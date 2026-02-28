import 'package:flutter/material.dart';
import 'package:newu_health/core/di/service_locator.dart';
import 'package:newu_health/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.instance.init();
  runApp(const NewUApp());
}
