import 'dart:async';
import 'dart:io';

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
  StatisticsController controllerStatistics = StatisticsController();
  SuggestionController controllerSuggestion = SuggestionController();
  SpacesController controllerSpaces = SpacesController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late String _statsAvailable = '-';
  late String _statsOccupied = '-';
  late String _statsReserved = '-';
  late String _time = '';
  late String _suggestedLot = '...';
  late Stream<Iterable<DataSnapshot>> statisticsStream = controllerStatistics.statisticsStreamController.stream;
  late Stream<List<dynamic>> suggestionStream = controllerSuggestion.suggestionStreamController.stream;
  late StreamSubscription<Iterable<DataSnapshot>> statisticsStreamSubscription;
  late StreamSubscription<List<dynamic>> suggestionStreamSubscription;
  late Timer timer;
  late bool _connectionResult = true;

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


  Future<void> _updateConnectionStatus() async {
    var reliabilityCheck = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      final result2 = await InternetAddress.lookup('facebook.com');
      final result3 = await InternetAddress.lookup('microsoft.com');
      if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
          (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
          (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty)) {
        reliabilityCheck = true;
      } else {
        reliabilityCheck = false;
      }
    } on SocketException catch (_) {
      reliabilityCheck = false;
    }

    setState((){
      _connectionResult = reliabilityCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      extendBodyBehindAppBar: true,
      appBar: MyAppbar().myAppbar(_key, context) as PreferredSizeWidget,
      drawer: const Drawer(
        child: MyDrawer(2),
      ),
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: 1000,
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const SizedBox(width: 1, height: 100),
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
                  Visibility(
                    visible: !true,
                    replacement: Material(
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
                              const Text('Reservation', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 250, child: Divider(color: Swatch.prime, thickness: 1)),
                              SizedBox(
                                height: 150,
                                child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: SizedBox(
                                      width: 300,
                                      child: Visibility(
                                        visible: _connectionResult,
                                        replacement: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: CircularProgressIndicator(
                                                    value: null,
                                                    backgroundColor: Theme.of(context).colorScheme.background,
                                                    strokeWidth: 6,
                                                  ),
                                                ),
                                              ),
                                              const Icon(Icons.wifi_off, color: Swatch.prime, size: 50),
                                            ]
                                        ),
                                        child: Text(
                                          _suggestedLot,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 120
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ),
                              const SizedBox(height: 1, width: 15),
                              FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          height: 60,
                                          width: 200,
                                          child: Material(
                                            elevation: 1,
                                            borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(18),
                                                topRight: Radius.circular(0),
                                                bottomLeft: Radius.circular(18),
                                                bottomRight: Radius.circular(0),
                                            ),
                                            color: Swatch.prime.shade200,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircularProgressIndicator(
                                                    color: Swatch.buttons.shade600,
                                                    value: null,
                                                  ),
                                                ),
                                                Text(
                                                  '  CONFIRM',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: 'Arial',
                                                      color: Swatch.buttons.shade800
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                      const SizedBox(height: 1, width: 0),
                                      SizedBox(
                                          height: 60,
                                          width: 135,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 5,
                                                  backgroundColor: Swatch.prime,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(0),
                                                        topRight: Radius.circular(18),
                                                        bottomLeft: Radius.circular(0),
                                                        bottomRight: Radius.circular(18),
                                                      ),
                                                  )
                                              ),
                                              onPressed: (){},
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.cancel_rounded,
                                                    size: 24,
                                                    color: Swatch.buttons.shade800,
                                                  ),
                                                  Text(
                                                    '  CANCEL',
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
                                      )
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    child: Material(
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
                                      child: Visibility(
                                        visible: _connectionResult,
                                        replacement: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: CircularProgressIndicator(
                                                    value: null,
                                                    backgroundColor: Theme.of(context).colorScheme.background,
                                                    strokeWidth: 6,
                                                  ),
                                                ),
                                              ),
                                              const Icon(Icons.wifi_off, color: Swatch.prime, size: 50),
                                            ]
                                        ),
                                        child: Text(
                                          _suggestedLot,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 120
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ),
                              const SizedBox(height: 1, width: 15),
                              FittedBox(
                                fit: BoxFit.fitHeight,
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
                                              onPressed: () async {
                                                await _updateConnectionStatus();
                                                setState(() {
                                                  if(_connectionResult){
                                                    if(_suggestedLot != '...'){
                                                      Reserve().reserve(_suggestedLot);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          backgroundColor: Theme.of(context).colorScheme.background,
                                                          elevation: 10,
                                                          content: Container(
                                                            height: 200,
                                                            width: 330,
                                                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                            child: FittedBox(
                                                              fit: BoxFit.contain,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  const Icon(Icons.garage, color: Swatch.prime, size: 200),
                                                                  const SizedBox(height: 20),
                                                                  Text('RESERVED SUCCESSFULLY!', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 45)),
                                                                  const SizedBox(height: 30),
                                                                  Text('Proceed to LOT $_suggestedLot', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontFamily: 'Arial', fontWeight: FontWeight.w300, fontSize: 40)),
                                                                  const SizedBox(height: 10),
                                                                  Text('Show your ticket in entering the space', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontFamily: 'Arial', fontWeight: FontWeight.w300, fontSize: 26)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          actions: [
                                                            Center(
                                                              child: Padding(
                                                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                                                child: TextButton(
                                                                  onPressed: () {Navigator.of(context).pop();},
                                                                  child: Icon(Icons.close_outlined, color: Theme.of(context).colorScheme.onPrimary, size: 30),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }else{
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          backgroundColor: Swatch.prime,
                                                          elevation: 10,
                                                          content: Container(
                                                            height: 170,
                                                            width: 330,
                                                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                            child: FittedBox(
                                                              fit: BoxFit.contain,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  CircleAvatar(radius: 70, backgroundColor: Swatch.buttons.shade800, child: const Icon(Icons.warning, color: SigCol.orange, size: 60)),
                                                                  const SizedBox(height: 20),
                                                                  Text('NO SPACES LEFT!', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontWeight: FontWeight.bold, fontSize: 45)),
                                                                  const SizedBox(height: 30),
                                                                  Text('Kindly wait for a spot for a while,', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontFamily: 'Arial', fontWeight: FontWeight.w300, fontSize: 30)),
                                                                  const SizedBox(height: 10),
                                                                  Text('Thank you for your patience!', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontFamily: 'Arial', fontWeight: FontWeight.w300, fontSize: 26)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          actions: [
                                                            Center(
                                                              child: Padding(
                                                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                                                child: TextButton(
                                                                  onPressed: () {Navigator.of(context).pop();},
                                                                  child: Icon(Icons.close_outlined, color: Swatch.buttons.shade800, size: 30),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  }else{
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        backgroundColor: Swatch.prime,
                                                        elevation: 10,
                                                        content: Container(
                                                          height: 200,
                                                          width: 330,
                                                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                          child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                CircleAvatar(radius: 70, backgroundColor: Swatch.buttons.shade800, child: const Icon(Icons.wifi_off, color: SigCol.red, size: 60)),
                                                                const SizedBox(height: 20),
                                                                Text('CONNECTION ERROR!', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontWeight: FontWeight.bold, fontSize: 45)),
                                                                const SizedBox(height: 30),
                                                                Text('Slow or no Internet connection.', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontFamily: 'Arial', fontWeight: FontWeight.w300, fontSize: 30)),
                                                                const SizedBox(height: 10),
                                                                Text('Check your connection, then try again', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontFamily: 'Arial', fontWeight: FontWeight.w300, fontSize: 26)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        actions: [
                                                          Center(
                                                            child: Padding(
                                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                                              child: TextButton(
                                                                onPressed: () {Navigator.of(context).pop();},
                                                                child: Icon(Icons.close_outlined, color: Swatch.buttons.shade800, size: 30),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
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
                                                  MaterialPageRoute(builder: (context) => LotsPage(_connectionResult)),
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
                  const SizedBox(height: 40, width: double.infinity),
                ],
              ),
            ),
          ),
          Positioned(
            top: 90,
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
          Visibility(
            visible: !_connectionResult,
            child: const Positioned(
              top: 90,
              left: 85,
              child: SizedBox(
                width: 25,
                height: 25,
                child: Icon(Icons.wifi_off, color: SigCol.red, size: 20)
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
                              MaterialPageRoute(builder: (context) => LotsPage(_connectionResult)),
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
    //connectivitySubscription.cancel();
    controllerStatistics.deactivateListenerStats();
    controllerSpaces.deactivateListenerSpaces();
    controllerSuggestion.deactivateListenerSuggestion();
    super.deactivate();
  }
}