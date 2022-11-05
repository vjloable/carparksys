import 'package:carparksys/pages/home.dart';
import 'package:flutter/material.dart';

import '../assets/swatches/swatch.dart';

class LotsPage extends StatefulWidget {
  const LotsPage({Key? key}) : super(key: key);

  @override
  State<LotsPage> createState() => _LotsPageState();
}

class _LotsPageState extends State<LotsPage>
    with SingleTickerProviderStateMixin {
  List<String> _parkingLotsName() {
    return [
      '1A', '1B', '1C', '2A', '2B', '2C', '3A', '3B', '3C',
      '4A', '4B', '4C', '5A', '5B', '5C', '6A', '6B', '6C',
    ];
  }
  List<int> _parkingLotsStatus() {
    return [
      1, 1, 1, 3, 3, 2, 3, 1, 3, 2, 1, 2, 1, 3, 2, 1, 1, 1
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
                padding: const EdgeInsets.fromLTRB(0,25,0,10),
                child:
                Container(
                  height: 40,
                  width: double.maxFinite,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.menu_rounded)
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(radius: 4, backgroundColor: Colors.green),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircleAvatar(radius: 4, backgroundColor: Colors.red),
                                SizedBox(width: 1),
                                CircleAvatar(radius: 4, backgroundColor: Colors.orange)
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.dark_mode_outlined)
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
        ),
        body: Container(
          padding: const EdgeInsets.all(0),
          child: GridView.count(
            crossAxisCount: 3,
            padding: const EdgeInsets.all(30),
            children: List.generate(_parkingLotsName().length, (index) {
              return Center(
                  child: RawMaterialButton(
                      onPressed: (_parkingLotsStatus()[index] == 1) ? () {} : null,
                      highlightColor: const Color(0xFFFFD60A),
                      highlightElevation: 15,
                      splashColor: const Color(0x44FFD60A),
                      elevation: 10.0,
                      fillColor: (_parkingLotsStatus()[index] == 1)
                          ? const Color(0xFFFFFFFF)
                          : Swatch.buttons.shade100,
                      //padding: const EdgeInsets.all(20.0),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: SizedBox(
                        width: 50,
                        height: 90,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_parkingLotsName()[index].toString(),
                                style: TextStyle(
                                    color: (_parkingLotsStatus()[index] == 1)
                                        ? Colors.black
                                        : Colors.black12,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: (_parkingLotsStatus()[index] == 1)
                                  ? const Color(0xFF00FF22)
                                  : ((_parkingLotsStatus()[index] == 2)
                                  ? const Color(0xFFFF0000)
                                  : const Color(0xFFFFD60A)),
                            )
                          ],
                        ),
                      )));
            }),
          ),
        ),
        bottomNavigationBar: SizedBox(
            height: 90,
            child: BottomAppBar(
                elevation: 10,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.home),
                            iconSize: 28,
                            color: Swatch.buttons.shade700,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const HomePage()),
                              );
                            }
                        ),
                        const Text('HOME')
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.space_dashboard_rounded),
                            iconSize: 28,
                            color: Swatch.buttonsAccent.shade400,
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LotsPage()),
                                    (Route<dynamic> route) => false,
                              );
                            }
                        ),
                        const Text('LOTS', style: TextStyle(color: Colors.orange))
                      ],
                    ),
                  ],
                )
            )
        )
    );
  }
}