import 'package:empire/core/di/service_locator.dart';

import 'package:empire/feature/category/presentation/views/my_app.dart/my_app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyDDemGBh8yl8FjfnzNDNiVd0sg_jXHxou4",
            authDomain: "empire-8f1e5.firebaseapp.com",
            databaseURL: "https://empire-8f1e5-default-rtdb.firebaseio.com",
            projectId: "empire-8f1e5",
            storageBucket: "empire-8f1e5.firebasestorage.app",
            messagingSenderId: "162817882017",
            appId: "1:162817882017:web:18a87439a2717b9cbdbde0",
          )
        : null,
  );
  await init();
  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return const MyApp();
      },
    ),
  );
}
