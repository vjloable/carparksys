import 'dart:async';

import 'package:carparksys/assets/swatches/custom_colors.dart';
import 'package:carparksys/components/time_runner.dart';
import 'package:carparksys/controllers/reserve.dart';
import 'package:carparksys/controllers/statistics.dart';
import 'package:carparksys/controllers/suggestion.dart';
import 'package:carparksys/pages/lots.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../components/appbar.dart';
import '../components/drawer.dart';
import '../components/ticket.dart';
import '../controllers/spaces.dart';


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
  late String _time = '';
  late String _suggestedLot = '...';

  StatisticsController controllerStatistics = StatisticsController();
  SuggestionController controllerSuggestion = SuggestionController();
  SpacesController controllerSpaces = SpacesController();
  late Stream<Iterable<DataSnapshot>> statisticsStream = controllerStatistics.statisticsStreamController.stream;
  late Stream<List<dynamic>> suggestionStream = controllerSuggestion.suggestionStreamController.stream;
  late StreamSubscription<Iterable<DataSnapshot>> statisticsStreamSubscription;
  late StreamSubscription<List<dynamic>> suggestionStreamSubscription;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _time = TimeRunner().now();
    timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) => updateTime());
    controllerStatistics.activateListenersStats();
    controllerSuggestion.activateListenersSuggestion();
    controllerSpaces.activateListenersSpaces();
    statisticsStreamListener();
    suggestionStreamListener();
  }

  void updateTime() {
    setState(() {
      _time = TimeRunner().now();
    });
  }

  void statisticsStreamListener() {
    statisticsStreamSubscription = statisticsStream.listen((event) {
      setState(() {
        _statsAvailable = event.elementAt(0).value.toString();
        _statsOccupied = event.elementAt(1).value.toString();
        _statsReserved = event.elementAt(2).value.toString();
      });
    });
  }

  void suggestionStreamListener() {
    suggestionStreamSubscription = suggestionStream.listen((event) {
      setState(() {
        if(event.isNotEmpty) {
          _suggestedLot = (event..shuffle()).first;
          controllerSuggestion.setPrevSuggestion(_suggestedLot);
        } else {
          _suggestedLot = '...';
        }
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
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
                                    'Your Ticket Status:',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Swatch.buttons.shade400
                                    )
                                  ),
                                  Text(
                                      'No Reservation',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Swatch.buttons.shade400
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
                                const SizedBox(width: 250, child: Divider(color: Swatch.prime, thickness: 1)),
                                SizedBox(
                                  height: 150,
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: SizedBox(
                                        width: 300,
                                        child: Text(
                                          _suggestedLot,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 120
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                                const SizedBox(height: 1, width: 15),
                                FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            height: 60,
                                            width: 200,
                                            child: ElevatedButton(
                                               style: ElevatedButton.styleFrom(
                                                 elevation: 5,
                                                 disabledBackgroundColor: Swatch.prime.shade200,
                                                 backgroundColor: Swatch.prime,
                                                 shape: RoundedRectangleBorder(
                                                     borderRadius: BorderRadius.circular(18.0)
                                                 ),
                                               ),
                                                onPressed: (){
                                                 setState(() {
                                                   !(_suggestedLot == '...') ? Reserve().reserve(_suggestedLot) : null;
                                                 });
                                                },
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
                                        SizedBox(
                                            height: 60,
                                            width: 120,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 5,
                                                    backgroundColor: Swatch.buttons.shade400,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(18.0)
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
          Visibility(
            visible: true,
            child: Positioned(
              top: 0,
              child: Material(
                color: Theme.of(context).colorScheme.background,
                elevation: 5,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: SizedBox(
                  width: 200,
                  height: 25,
                  child: Center(
                    child: Text(
                      _time,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
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
    timer.cancel();
    statisticsStreamSubscription.cancel();
    suggestionStreamSubscription.cancel();
    controllerStatistics.deactivateListenerStats();
    controllerSpaces.deactivateListenerSpaces();
    controllerSuggestion.deactivateListenerSuggestion();
    super.deactivate();
  }
}