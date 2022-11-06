import 'package:carparksys/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'assets/swatches/custom_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Car Parking System App',
        theme: ThemeData(
            primarySwatch: Swatch.prime,
            fontFamily: 'Menlo',
            scaffoldBackgroundColor: const Color(0xFFEAEAEA)
        ),
        home: const HomePage()
    );
  }
}
