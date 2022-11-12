import 'package:carparksys/services/auth.dart';
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
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __){
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
            scaffoldBackgroundColor: const Color(0xFFEEEAEA),
            bottomAppBarColor: Colors.white,
            drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
            bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
            colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Swatch.prime,
              onPrimary: Swatch.buttons.shade800,
              secondary: Swatch.prime,
              onSecondary: Colors.black,
              primaryContainer: Swatch.prime,
              error: Swatch.buttons.shade100,
              onError: Colors.black12,
              background: Colors.white,
              onBackground: Colors.black,
              surface: Swatch.prime,
              onSurface: Colors.black,
            ),
        ),
        darkTheme: ThemeData(
            primarySwatch: Swatch.prime,
            fontFamily: 'Menlo',
            scaffoldBackgroundColor: Swatch.buttons.shade500,
            bottomAppBarColor: Swatch.buttons.shade800,
            drawerTheme: DrawerThemeData(backgroundColor: Swatch.buttons.shade600),
            bottomSheetTheme: BottomSheetThemeData(backgroundColor: Swatch.buttons.shade800),
            colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: Swatch.prime,
              onPrimary: Colors.white,
              secondary: Swatch.prime,
              onSecondary: Colors.black,
              primaryContainer: Swatch.prime,
              error: Swatch.buttons.shade600,
              onError: Swatch.buttons.shade300,
              background: Swatch.buttons.shade800,
              onBackground: Colors.black,
              surface: Swatch.prime,
              onSurface: Colors.black,
            ),
        ),
        themeMode: currentMode,
        home: AuthService().handleAuthState(),
        );
      }
    );
  }
}
