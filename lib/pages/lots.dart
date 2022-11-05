import 'package:carparksys/pages/components/appbar.dart';
import 'package:carparksys/pages/components/reservation.dart';
import 'package:carparksys/pages/home.dart';
import 'package:flutter/material.dart';

import '../assets/swatches/custom_colors.dart';

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
      1, 1, 1, 1, 3, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppbar().myAppbar() as PreferredSizeWidget,
        body: GridView.count(
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          crossAxisCount: 3,
          padding: const EdgeInsets.all(40),
          children: List.generate(_parkingLotsName().length, (index) {
            return Center(
                child: RawMaterialButton(
                    onPressed: (_parkingLotsStatus()[index] == 1) ? () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return showReserveLot(context, _parkingLotsName()[index]);
                          }
                      );
                    } : null,
                    highlightColor: Swatch.prime.shade800,
                    highlightElevation: 15,
                    splashColor: Swatch.prime,
                    elevation: 5.0,
                    fillColor: (_parkingLotsStatus()[index] == 1)
                        ? Colors.white
                        : Swatch.buttons.shade100,
                    shape: Border(
                      bottom: BorderSide(
                          width: 5,
                          color: (_parkingLotsStatus()[index] == 1)
                              ? SigCol.green
                              : ((_parkingLotsStatus()[index] == 2)
                              ? SigCol.red
                              : SigCol.orange)
                      ),
                    ),
                    child: SizedBox(
                      width: 40,
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /*
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: (_parkingLotsStatus()[index] == 1)
                                ? SigCol.green
                                : ((_parkingLotsStatus()[index] == 2)
                                ? SigCol.red
                                : SigCol.orange),
                          ),
                          */
                          Text(_parkingLotsName()[index].toString(),
                              style: TextStyle(
                                  color: (_parkingLotsStatus()[index] == 1)
                                      ? Colors.black
                                      : Colors.black12,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          /*
                          Divider(thickness: 3, color: (_parkingLotsStatus()[index] == 1)
                              ? SigCol.green
                              : ((_parkingLotsStatus()[index] == 2)
                              ? SigCol.red
                              : SigCol.orange)
                          )*/
                        ],
                      ),
                    )
                )
            );
          }),
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
                            splashRadius: 30,
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
                            splashRadius: 30,
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