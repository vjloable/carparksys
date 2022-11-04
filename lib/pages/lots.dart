import 'package:flutter/material.dart';

import '../assets/swatches/swatch.dart';

class Lots extends StatefulWidget {
  const Lots({Key? key}) : super(key: key);

  @override
  State<Lots> createState() => _LotsState();
}

class _LotsState extends State<Lots>
    with SingleTickerProviderStateMixin {
  List<String> _parkingLotsName() {
    return [
      '1A',
      '1B',
      '1C',
      '1D',
      '2A',
      '2B',
      '2C',
      '2D',
      '3A',
      '3B',
      '3C',
      '3D',
      '4A',
      '4B',
      '4C',
      '4D',
      '5A',
      '5B',
      '5C',
      '5D',
      '6A',
      '6B',
      '6C',
      '6D'
    ];
  }
  List<int> _parkingLotsStatus() {
    return [
      1,
      1,
      1,
      3,
      3,
      2,
      3,
      1,
      3,
      2,
      1,
      2,
      1,
      3,
      2,
      1,
      1,
      1,
      2,
      2,
      3,
      3,
      1,
      1
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
          padding: const EdgeInsets.all(40),
          child: GridView.count(
            crossAxisCount: 4,
            //padding: const EdgeInsets.all(30),
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
                          : const Color(0xFF4F4F4F),
                      padding: const EdgeInsets.all(14.0),
                      shape: const CircleBorder(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_parkingLotsName()[index].toString(),
                              style: const TextStyle(
                                  color: Color(0xFF383838),
                                  fontSize: 26,
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
                      )));
            }),
          ),
        ),
        bottomNavigationBar: SizedBox(
            height: 80,
            child: BottomAppBar(
                elevation: 10,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.home),
                            iconSize: 28,
                            color: Swatch.buttons.shade700,
                            onPressed: () {}
                        ),
                        const Text('HOME')
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.space_dashboard_rounded),
                            iconSize: 28,
                            color: Swatch.buttonsAccent.shade400,
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const Lots()),
                                    (Route<dynamic> route) => false,
                              );
                            }
                        ),
                        const Text('LOTS')
                      ],
                    ),
                  ],
                )
            )
        )
    );
  }
}