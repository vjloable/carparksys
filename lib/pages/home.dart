import 'dart:async';

import 'package:carparksys/assets/swatches/custom_colors.dart';
import 'package:carparksys/controllers/firebase_db.dart';
import 'package:carparksys/pages/lots.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../components/appbar.dart';
import '../components/drawer.dart';
import '../components/ticket.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late String _statsAvailable = '-';
  late String _statsOccupied = '-';
  late String _statsReserved = '-';
  DBController dbc = DBController();
  late Stream<Iterable<DataSnapshot>> dbStream = dbc.dbStreamController.stream;
  late StreamSubscription<Iterable<DataSnapshot>> dbStreamSubscription;

  @override
  void initState() {
    super.initState();
    dbc.activateListenersStats();
    subDBStreamListener();
  }

  void subDBStreamListener() {
    dbStreamSubscription = dbStream.listen((event) {
      setState(() {
        _statsAvailable = event.elementAt(0).value.toString();
        _statsOccupied = event.elementAt(1).value.toString();
        _statsReserved = event.elementAt(2).value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: MyAppbar().myAppbar(_key, context) as PreferredSizeWidget,
      drawer: Drawer(
        child: drawerItems(context, 2),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(30)
                        ),
                        color: Swatch.buttonsAccent.shade100,
                      ),
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Ticket Status:',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Swatch.buttons.shade300
                                )
                              ),
                              Text(
                                  'No Reservation',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Swatch.buttons.shade300
                                  )
                              ),
                            ],
                          )
                      )
                  ),
                  const SizedBox(height: 10, width: 1),
                  Material(
                    elevation: 10,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                    ),
                    color: Theme.of(context).colorScheme.background,
                    child: SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text('Suggested Parking Space:', style: TextStyle(fontSize: 16)),
                            const SizedBox(
                              height: 150,
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: SizedBox(
                                    width: 300,
                                    child: Text(
                                      '5W',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 100
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            const SizedBox(width: 250, child: Divider(color: Swatch.prime, thickness: 1)),
                            const SizedBox(height: 1, width: 15),
                            FittedBox(
                                child: Row(
                                  children: [
                                    Container(
                                        height: 60,
                                        width: 200,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)
                                          ),
                                          color: Swatch.prime,
                                        ),
                                        child: ElevatedButton(
                                           style: ButtonStyle(
                                             elevation: MaterialStateProperty.all<double>(5),
                                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                 RoundedRectangleBorder(
                                                     borderRadius: BorderRadius.circular(18.0)
                                                 )
                                             )
                                           ),
                                            onPressed: (){},
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.confirmation_number_outlined, size: 24, color: Swatch.buttons.shade800),
                                                Text(
                                                  '  RESERVE',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Arial',
                                                    color: Swatch.buttons.shade800
                                                  ),
                                                ),
                                              ],
                                            )
                                        )
                                    ),
                                    const SizedBox(height: 1, width: 15),
                                    Container(
                                        height: 60,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)
                                          ),
                                          color: Swatch.buttons.shade400,
                                        ),
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                elevation: MaterialStateProperty.all<double>(5),
                                                backgroundColor: MaterialStateProperty.all<Color>(Swatch.buttons.shade400),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(18.0)
                                                    )
                                                )
                                            ),
                                            onPressed: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const LotsPage()),
                                              );
                                            },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.space_dashboard_outlined,
                                                  size: 24,
                                                  color: Swatch.prime,
                                                ),
                                                Text(
                                                  '  LOTS',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Arial',
                                                    color: Swatch.prime
                                                  ),
                                                ),
                                              ],
                                            )
                                        )
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40, width: double.infinity),
                  Material(
                    elevation: 10,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Theme.of(context).colorScheme.background,
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Parking Space Statistics:', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 250, child: Divider(color: Swatch.prime, thickness: 1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(height: 10, width: 1),
                                    const CircleAvatar(
                                        radius: 4,
                                        backgroundColor: SigCol.red ///Colors.red
                                    ),
                                    const SizedBox(height: 10, width: 1),
                                    Text(
                                        _statsOccupied,
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                        )
                                    ),
                                    const Text(
                                        'OCCUPIED',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(height: 10, width: 1),
                                    const CircleAvatar(
                                        radius: 4,
                                        backgroundColor: SigCol.green ///Colors.green
                                    ),
                                    const SizedBox(height: 10, width: 1),
                                    Text(
                                        _statsAvailable,
                                        style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                        )
                                    ),
                                    const Text(
                                        'AVAILABLE',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(height: 10, width: 1),
                                    const CircleAvatar(
                                        radius: 4,
                                        backgroundColor: SigCol.orange ///Colors.orange
                                    ),
                                    const SizedBox(height: 10, width: 1),
                                    Text(
                                        _statsReserved,
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                        )
                                    ),
                                    const Text(
                                        'RESERVED',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]
                      )
                    ),
                  ),
                  const SizedBox(height: 10, width: double.infinity),
                ],
              ),
            ),
          )
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child:
          BottomAppBar(
              elevation: 10,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.home),
                          iconSize: 28,
                          color: Swatch.buttonsAccent.shade400,
                          splashRadius: 30,
                          onPressed: () {}
                      ),
                      const Text('HOME', style: TextStyle(color: Colors.orange))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(width: 60, height: 30),
                      Text('TICKET')
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.space_dashboard_rounded),
                          iconSize: 28,
                          splashRadius: 30,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LotsPage()),
                            );
                          }
                      ),
                      const Text('LOTS')
                    ],
                  ),
                ],
              )
          )
      ),
      floatingActionButton: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            elevation: 10,
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return showTicket(context);
                  }
              );
            },
            child:
                  Icon(Icons.confirmation_num, size: 32, color: Swatch.buttons.shade500),
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void deactivate(){
    dbStreamSubscription.cancel();
    super.deactivate();
  }
}