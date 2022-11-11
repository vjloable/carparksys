import 'package:flutter/material.dart';
import 'package:carparksys/pages/home.dart';
import '../assets/swatches/custom_colors.dart';
import '../components/appbar.dart';
import '../components/reservation.dart';
import '../components/drawer.dart';

class LotsPage extends StatefulWidget {
  const LotsPage({Key? key}) : super(key: key);

  @override
  State<LotsPage> createState() => _LotsPageState();
}

class _LotsPageState extends State<LotsPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<String> _parkingLotsName() {
    return [
      '1A', '1B', '1C', '2A', '2B', '2C', '3A', '3B', '3C',
      '4A', '4B', '4C', '5A', '5B', '5C', '6A', '6B', '6C',
    ];
  }
  List<int> _parkingLotsStatus() {
    return [
      1, 1, 2, 1, 3, 2, 1, 2, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: MyAppbar().myAppbar(_key, context) as PreferredSizeWidget,
        drawer: Drawer(
          ///backgroundColor: Swatch.prime,
          child: drawerItems(context, 3),
        ),
        body: GridView.count(
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          crossAxisCount: 3,
          padding: const EdgeInsets.all(60),
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
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.error,
                    shape: Border(
                      bottom: BorderSide(
                          width: 3,
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
                          Text(_parkingLotsName()[index].toString(),
                              style: TextStyle(
                                  color: (_parkingLotsStatus()[index] == 1)
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onError,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              )
                          ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.home),
                            iconSize: 28,
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