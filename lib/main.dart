
import 'package:stepback/src/constants/app_dis.dart';
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// I am using the main function to load the settings from the settings service and then pass it to the MyApp widget.

void main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  AppDIs.dependencyInjection();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");  
  runApp(MyApp(settingsController: settingsController));
}

