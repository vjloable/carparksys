import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:carparksys/assets/swatches/custom_colors.dart';
import 'package:carparksys/components/cancel_failsafe.dart';
import 'package:carparksys/components/countdown.dart';
import 'package:carparksys/components/time_runner.dart';
import 'package:carparksys/controllers/reserve.dart';
import 'package:carparksys/controllers/statistics.dart';
import 'package:carparksys/controllers/suggestion.dart';
import 'package:carparksys/main.dart';
import 'package:carparksys/pages/lots.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver, TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  StatisticsController controllerStatistics = StatisticsController();
  SuggestionController controllerSuggestion = SuggestionController();
  SpacesController controllerSpaces = SpacesController();
  Reserve controllerReserve = Reserve();
  late String _statsAvailable = '-';
  late String _statsOccupied = '-';
  late String _statsReserved = '-';
  late String _time = '';
  late String _suggestedLot = '...';
  late String _ticketLot = '...';
  late String _startReserved = '__/__/__  -  __:__:__';
  late String _endReserved = '__/__/__  -  __:__:__';
  late String _ytstatus = 'No Reservation';
  late Stream<Iterable<DataSnapshot>> statisticsStream = controllerStatistics.statisticsStreamController.stream;
  late Stream<List<dynamic>> suggestionStream = controllerSuggestion.suggestionStreamController.stream;
  late Stream<List<dynamic>> reserveStream = controllerReserve.reserveStreamController.stream;
  late StreamSubscription<Iterable<DataSnapshot>> statisticsStreamSubscription;
  late StreamSubscription<List<dynamic>> suggestionStreamSubscription;
  late StreamSubscription<List<dynamic>> reserveStreamSubscription;
  late Timer timer;
  late bool _connectionResult = true;
  late bool _hasTicket = false;
  late bool _hasArrived = false;
  late bool showBadgeTicket = false;
  int resetTime = 0;

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       print("app in resumed");
  //       break;
  //     case AppLifecycleState.inactive:
  //       //_signout();
  //       print("app in inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       print("app in paused");
  //       break;
  //     case AppLifecycleState.detached:
  //       print("app in detached");
  //       break;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _time = TimeRunner().formatterMDY(TimeRunner().now());
    timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) => updateTime());
    controllerStatistics.activateListenersStats();
    controllerSuggestion.activateListenersSuggestion();
    controllerSpaces.activateListenersSpaces();
    controllerReserve.activateListenersReserve();
    controllerReserve.eventlistenerArrived();
    statisticsStreamListener();
    suggestionStreamListener();
    reserveStreamListener();
    updateRetention();
    _updateConnectionStatus();
  }

  void badgeHandler(bool show){
    setState(() {
      showBadgeTicket = show;
    });
  }

  void updateRetention() async {
    await _updateConnectionStatus();
    if(_connectionResult){
      List<dynamic> retained = await Reserve().getRetention();
      if(retained.elementAt(0) == true){
        MyApp.eventstreamController.sink.add(['resetTimer', retained.elementAt(1)]);
        MyApp.eventstreamController.sink.add(['startTimer', 0]);
      }else{
        MyApp.eventstreamController.sink.add(['resetTimer', retained.elementAt(1)]);
        MyApp.eventstreamController.sink.add(['stopTimer', 0]);
      }
    }else{
      FirebaseAuth.instance.signOut();
    }
  }

  void updateTime() {
    setState(() {
      _time = TimeRunner().formatterMDY(TimeRunner().now());
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

  void reserveStreamListener() {
    reserveStreamSubscription = reserveStream.listen((event) {
      setState(() {
        _ytstatus = 'No Reservation';
        _ticketLot = event.elementAt(0).toString();
        _hasTicket = event.elementAt(1) as bool;
        _startReserved = TimeRunner().fromEpoch(event.elementAt(2));
        _endReserved = TimeRunner().fromEpoch(event.elementAt(3));
        _hasArrived = event.elementAt(4) as bool;
        if(_hasArrived == true && _hasTicket == true){
          _ytstatus = 'Parked at $_ticketLot';
        }else if(_hasArrived == false && _hasTicket == false){
          _ytstatus = 'No Reservation';
          MyApp.eventstreamController.sink.add(['stopTimer', 0]);
          MyApp.eventstreamController.sink.add(['resetArrived', 0]);
        }else if(_hasArrived == false && _hasTicket == true){
          _ytstatus = 'En Route to $_ticketLot';
        }else if(_hasArrived == true && _hasTicket == false){
          _ytstatus = 'No Reservation';
          MyApp.eventstreamController.sink.add(['stopTimer', 0]);
          MyApp.eventstreamController.sink.add(['resetArrived', 0]);
        }
        // _ytstatus = _hasTicket ? 'En Route to $_ticketLot' : 'No Reservation';
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
      extendBody: true,
      appBar: MyAppbar().myAppbar(_key, context) as PreferredSizeWidget,
      drawer: const Drawer(
        child: MyDrawer(2),
      ), body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const SizedBox(width: 1, height: 110),
                  Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(30)
                        ),
                        color: Swatch.buttonsAccent.shade100,
                      ),
                      child: SizedBox(
                        width: 300,
                        height: 28,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                        'Your Status:',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Swatch.buttons.shade400,
                                          fontSize: 16,
                                        )
                                    ),
                                    const SizedBox(width: 30),
                                    Text(
                                        _ytstatus,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Swatch.buttons.shade400,
                                          fontSize: 16,
                                        )
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 10, width: 1),
                  Material(
                      elevation: 10,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: Theme.of(context).colorScheme.background,
                      child: AnimatedCrossFade(
                        firstChild: SizedBox(
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
                                        fit: BoxFit.fitWidth,
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
                                                          controllerReserve.reserve(_suggestedLot);
                                                          MyApp.eventstreamController.sink.add(['resetTimer', Reserve().getTimeStop()]);
                                                          MyApp.eventstreamController.sink.add(['startTimer', 0]);
                                                          badgeHandler(true);
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              backgroundColor: Theme.of(context).colorScheme.background,
                                                              elevation: 10,
                                                              title: const Icon(Icons.garage, color: Swatch.prime, size: 100),
                                                              content: Container(
                                                                height: 30,
                                                                width: 250,
                                                                padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                                child: FittedBox(
                                                                  fit: BoxFit.fitWidth,
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      const SizedBox(height: 30),
                                                                      Text('RESERVED SUCCESSFULLY!', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 45)),
                                                                      const SizedBox(height: 20),
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
                                                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                                                              title: CircleAvatar(radius: 35, backgroundColor: Swatch.buttons.shade800, child: const Icon(Icons.warning, color: SigCol.orange, size: 30)),
                                                              content: Container(
                                                                height: 30,
                                                                width: 250,
                                                                padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                                child: FittedBox(
                                                                  fit: BoxFit.fitWidth,
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      const SizedBox(height: 30),
                                                                      Text('NO SPACES LEFT!', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontWeight: FontWeight.bold, fontSize: 45)),
                                                                      const SizedBox(height: 20),
                                                                      Text('Kindly wait for a spot in a while,', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontFamily: 'Arial', fontWeight: FontWeight.w300, fontSize: 30)),
                                                                      const SizedBox(height: 10),
                                                                      Text('Thank you for your patience!', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontFamily: 'Arial', fontWeight: FontWeight.w300, fontSize: 26)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: [
                                                                Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                                                            title: CircleAvatar(radius: 35, backgroundColor: Swatch.buttons.shade800, child: const Icon(Icons.wifi_off, color: SigCol.red, size: 30)),
                                                            content: Container(
                                                              height: 30,
                                                              width: 250,
                                                              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                              child: FittedBox(
                                                                fit: BoxFit.fitWidth,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    const SizedBox(height: 30),
                                                                    Text('CONNECTION ERROR!', textAlign: TextAlign.center, style: TextStyle(color: Swatch.buttons.shade800, fontWeight: FontWeight.bold, fontSize: 45)),
                                                                    const SizedBox(height: 20),
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
                                                                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                                                  child: TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                      },
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
                        secondChild:
                            AnimatedCrossFade(
                              firstChild: SizedBox(
                                height: 480,
                                width: double.infinity,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text('Your Parking Reservation', style: TextStyle(fontSize: 16)),
                                      const SizedBox(width: 250, child: Divider(color: Swatch.prime, thickness: 1)),
                                      SizedBox(
                                        width: 300,
                                        height: 400,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                height: 200,
                                                width: 300,
                                                child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(50.0),
                                                      child: Text(
                                                        _ticketLot,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 120,
                                                        ),
                                                      ),
                                                    )
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              SizedBox(
                                                height: 40,
                                                width: 280,
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        width: 120,
                                                        child: Center(
                                                          child: Column(
                                                            children: [
                                                              const Text(
                                                                'FROM\n\n',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 12
                                                                ),
                                                              ),
                                                              Text(
                                                                _startReserved,
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 40, height: 60, child: Icon(Icons.arrow_forward, color: Swatch.prime)),
                                                      SizedBox(
                                                        width: 120,
                                                        child: Center(
                                                          child: Column(
                                                            children: [
                                                              const Text(
                                                                'UNTIL\n\n',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 12
                                                                ),
                                                              ),
                                                              Text(
                                                                _endReserved,
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 50),
                                              SizedBox(
                                                height: 65,
                                                width: 300,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                  child: FittedBox(
                                                      fit: BoxFit.fitWidth,
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      color: Colors.transparent,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(18),
                                                                        child: SizedBox(
                                                                          width: 18,
                                                                          height: 18,
                                                                          child: CircularProgressIndicator(
                                                                            color: Swatch.buttons.shade600,
                                                                            strokeWidth: 2,
                                                                            value: null,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: Container(
                                                                        color: Colors.transparent,
                                                                        child: const Center(
                                                                          child: SizedBox(
                                                                            height: 24,
                                                                            width: 70,
                                                                            child: FittedBox(
                                                                              fit: BoxFit.contain,
                                                                              child: CountdownTimer(),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 24, width: 15),
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
                                                                  onPressed: () async {
                                                                    await _updateConnectionStatus();
                                                                    if(_connectionResult){
                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (context) => AlertDialog(
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(20),
                                                                          ),
                                                                          backgroundColor: Theme.of(context).colorScheme.background,
                                                                          elevation: 10,
                                                                          title: CircleAvatar(radius: 35, backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer, child: const Icon(Icons.warning, color: SigCol.orange, size: 30)),
                                                                          content: Container(
                                                                            height: 20,
                                                                            width: 250,
                                                                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                                            child: FittedBox(
                                                                              fit: BoxFit.fitWidth,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text('CANCEL RESERVATION?', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 65)),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          actions: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                              child: Center(
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    Material(
                                                                                      elevation: 5,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(30.0),
                                                                                      ),
                                                                                      color: Swatch.prime.shade100,
                                                                                      child: TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Icon(Icons.close_outlined, color: Swatch.buttons.shade800, size: 30),
                                                                                      ),
                                                                                    ),
                                                                                    Material(
                                                                                      elevation: 5,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(30.0),
                                                                                      ),
                                                                                      color: Swatch.prime,
                                                                                      child: TextButton(
                                                                                        onPressed: () {
                                                                                          MyApp.eventstreamController.sink.add(['stopTimer', 0]);
                                                                                          badgeHandler(false);
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Icon(Icons.check, color: Swatch.buttons.shade800, size: 30),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }else{
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (context) => const CancelAlert()
                                                                      );
                                                                    }
                                                                  },
                                                                  child: FittedBox(
                                                                    fit: BoxFit.fitWidth,
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
                                                                    ),
                                                                  )
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              secondChild: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text('Your Parking Space:', style: TextStyle(fontSize: 16)),
                                      const SizedBox(width: 250, child: Divider(color: Swatch.prime, thickness: 1)),
                                      SizedBox(
                                        height: 150,
                                        child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: SizedBox(
                                              width: 300,
                                              child: Text(
                                                _ticketLot,
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
                                    ],
                                  ),
                                ),
                              ),
                              crossFadeState: !_hasArrived
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 300),
                            ),
                        crossFadeState: !_hasTicket
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
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
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Parking Space Statistics:', style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 250, child: Divider(color: Swatch.prime, thickness: 1)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    const SizedBox(width: 40, height: 1),
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
                                    const SizedBox(width: 40, height: 1),
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
                          ),
                        ),
                      )
                    ),
                  ),
                  const SizedBox(height: 110, width: double.infinity),
                ],
              ),
            ),
          ),
          Positioned(
            top: 90,
            child: Material(
              color: Theme.of(context).colorScheme.background,
              elevation: 3,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.zero,
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: SizedBox(
                width: 200,
                height: 30,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Center(
                      child: Text(
                        _time,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 50,
                        ),
                      ),
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
                  /*Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(width: 60, height: 30),
                      Text('TICKET')
                    ],
                  ),*/
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
      /*
      floatingActionButton: Badge(
        toAnimate: true,
        badgeContent: const Padding(padding: EdgeInsets.all(1), child: Text('!', style: TextStyle(color: Colors.white))),
        animationType: BadgeAnimationType.slide,
        shape: BadgeShape.circle,
        badgeColor: SigCol.red,
        showBadge: showBadgeTicket,
        elevation: 2,
        position: BadgePosition.topEnd(top: -3, end: -3),
        child: SizedBox(
            height: 70,
            width: 70,
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {
                badgeHandler(false);
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      */
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void deactivate(){
    timer.cancel();
    statisticsStreamSubscription.cancel();
    suggestionStreamSubscription.cancel();
    reserveStreamSubscription.cancel();
    controllerStatistics.deactivateListenerStats();
    controllerSpaces.deactivateListenerSpaces();
    controllerSuggestion.deactivateListenerSuggestion();
    controllerReserve.deactivateListenerReserve();
    super.deactivate();
  }
}