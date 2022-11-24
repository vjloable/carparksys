import 'dart:async';

import 'package:flutter/material.dart';
import '../assets/swatches/custom_colors.dart';
import '../components/appbar.dart';
import '../components/drawer.dart';
import '../components/reservation.dart';
import '../components/time_runner.dart';
import '../controllers/spaces.dart';

class LotsPage extends StatefulWidget {
  final bool _connection;
  const LotsPage(this._connection, {super.key});

  @override
  State<LotsPage> createState() => _LotsPageState();
}

class _LotsPageState extends State<LotsPage> {
  SpacesController controllerSpaces = SpacesController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late StreamSubscription<List> spacesStreamSubscription;
  late Stream<List> spacesStream = controllerSpaces.spacesStreamController.stream;
  late List<String> _parkingLotsName = [];
  late List<int> _parkingLotsStatus = [];
  late String _time = '';
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _time = TimeRunner().formatterMDY(TimeRunner().now());
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => updateTime());
    controllerSpaces.activateListenersSpaces();
    spacesStreamListener();
  }

  void updateTime() {
    setState(() {
      _time = TimeRunner().formatterMDY(TimeRunner().now());
    });
  }

  void spacesStreamListener() {
    spacesStreamSubscription = spacesStream.listen((event){
      setState(() {
        _parkingLotsName = event[0];
        _parkingLotsStatus = event[1];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        extendBodyBehindAppBar: true,
        appBar: MyAppbar().myAppbar(_key, context) as PreferredSizeWidget,
        drawer: const Drawer(
          child: MyDrawer(3),
        ),
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Visibility(
              visible: !(_parkingLotsName.isEmpty && _parkingLotsStatus.isEmpty),
              replacement: Center(
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
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const SizedBox(width: double.maxFinite, height: 100),
                        ]
                      )
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(40),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 20),
                      delegate: SliverChildListDelegate(
                          List.generate(_parkingLotsName.length, (index) {
                            return Center(
                                child: Column(
                                  children: [
                                    RawMaterialButton(
                                        onPressed: (_parkingLotsStatus[index] == 1) ? () {
                                          showModalBottomSheet(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                              ),
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ReserveLot(_parkingLotsName[index]);
                                              }
                                          );
                                        } : null,
                                        highlightColor: Swatch.prime.shade800,
                                        highlightElevation: 15,
                                        splashColor: Swatch.prime,
                                        elevation: 5.0,
                                        fillColor: (_parkingLotsStatus[index] == 1)
                                            ? Theme.of(context).colorScheme.background
                                            : Theme.of(context).colorScheme.error,
                                        shape: Border(
                                          bottom: BorderSide(
                                              width: 3,
                                              color: (_parkingLotsStatus[index] == 1)
                                                  ? SigCol.green
                                                  : ((_parkingLotsStatus[index] == 2)
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
                                              Text(_parkingLotsName[index].toString(),
                                                  style: TextStyle(
                                                      color: (_parkingLotsStatus[index] == 1)
                                                          ? Theme.of(context).colorScheme.onPrimary
                                                          : Theme.of(context).colorScheme.onError,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold
                                                  )
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                )
                            );
                          })
                      ),
                    ),
                  )
                ],
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
              visible: !widget._connection,
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
            child: BottomAppBar(
                elevation: 15,
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
                              Navigator.pop(context);
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
                            onPressed: () {}
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

  @override
  void deactivate() {
    timer.cancel();
    spacesStreamSubscription.cancel();
    controllerSpaces.deactivateListenerSpaces();
    super.deactivate();
  }
}