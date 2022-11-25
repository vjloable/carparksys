import 'package:carparksys/assets/swatches/custom_colors.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MyAppbar {
  Widget myAppbar(GlobalKey<ScaffoldState> key, BuildContext context){
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: AppBar(
        scrolledUnderElevation: 3,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Container(
            padding: const EdgeInsets.fromLTRB(0,25,0,10),
            child: Container(
              height: 40,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Theme.of(context).colorScheme.background
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      splashRadius: 25,
                      onPressed: (){
                        key.currentState!.openDrawer();
                      },
                      icon: Icon(Icons.menu_rounded, color: Theme.of(context).colorScheme.onPrimary)
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(radius: 4, backgroundColor: SigCol.green),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircleAvatar(radius: 4, backgroundColor: SigCol.red),
                            SizedBox(width: 1),
                            CircleAvatar(radius: 4, backgroundColor: SigCol.orange)
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    splashRadius: 25,
                    icon: Icon(color: Theme.of(context).colorScheme.onPrimary,
                        MyApp.themeNotifier.value == ThemeMode.light
                            ? Icons.dark_mode
                            : Icons.light_mode
                    ),
                    onPressed: (){
                      MyApp.themeNotifier.value = MyApp.themeNotifier.value == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    },
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}