import 'package:empire/core/di/service_locator.dart';

import 'package:empire/presentation/views/my_app.dart/my_app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await init();

  runApp(const MyApp());
}
