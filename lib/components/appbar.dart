import 'package:carparksys/assets/swatches/custom_colors.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MyAppbar {
  Widget myAppbar(GlobalKey<ScaffoldState> key){
    return PreferredSize(
      preferredSize: const Size.fromHeight(75.0),
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
            padding: const EdgeInsets.fromLTRB(0,25,0,10),
            child: Container(
              height: 40,
              width: double.maxFinite,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: (){
                        key.currentState!.openDrawer();
                      },
                      icon: const Icon(Icons.menu_rounded)
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
                      onPressed: (){

                        MyApp.themeNotifier.value =
                          MyApp.themeNotifier.value == ThemeMode.light
                            ? ThemeMode.dark
                            : ThemeMode.light;
                      },
                      icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode)
                  ),
                ],
              ),
            )
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),
      ),
    );
  }
}