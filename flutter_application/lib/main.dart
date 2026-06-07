import 'package:flutter/material.dart';
import 'core/storage/database_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseService databaseService = DatabaseService();
  await databaseService.init();
  runApp(App(databaseService: databaseService));
}
