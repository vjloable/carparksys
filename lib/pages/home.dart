import 'package:carparksys/assets/swatches/swatch.dart';
import 'package:carparksys/pages/lots.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasNoTicket = true;

  void _showTicket(){
    setState(() {
      _hasNoTicket = false;
    });
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
              child: Container(
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
      body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(20)
                      ),
                      color: Colors.white,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Suggested Parking Space:'),
                          const SizedBox(
                            height: 150,
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: SizedBox(
                                  width: 300,
                                  child: Text(
                                    'W5',
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
                                            children: const [
                                              Icon(Icons.confirmation_number_outlined, size: 24),
                                              Text(
                                                '  RESERVE',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Arial',
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
                                              backgroundColor: MaterialStateProperty.all<Color>(Swatch.buttons.shade400),
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
                  const SizedBox(height: 40, width: double.infinity),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(30)
                        ),
                        color: Colors.white,
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Parking Space Statistics:'),
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
                                      backgroundColor: Colors.red
                                  ),
                                  const SizedBox(height: 10, width: 1),
                                  Text(
                                      '12',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Swatch.buttons.shade800
                                      )
                                  ),
                                  Text(
                                      'OCCUPIED',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Swatch.buttons.shade800
                                      )
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 10, width: 1),
                                  const CircleAvatar(
                                      radius: 4,
                                      backgroundColor: Colors.green
                                  ),
                                  const SizedBox(height: 10, width: 1),
                                  Text(
                                      '10',
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Swatch.buttons.shade800
                                      )
                                  ),
                                  Text(
                                      'AVAILABLE',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Swatch.buttons.shade800
                                      )
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 10, width: 1),
                                  const CircleAvatar(
                                      radius: 4,
                                      backgroundColor: Colors.orange
                                  ),
                                  const SizedBox(height: 10, width: 1),
                                  Text(
                                      '8',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Swatch.buttons.shade800
                                      )
                                  ),
                                  Text(
                                      'RESERVED',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Swatch.buttons.shade800
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ]
                    )
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
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ///const SizedBox(height: 1, width: 1),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.home),
                          iconSize: 28,
                          color: Swatch.buttonsAccent.shade400,
                          onPressed: () {
                            //Navigator.pushAndRemoveUntil(
                            //  context,
                            //  MaterialPageRoute(builder: (context) => const HomePage()),
                            //      (Route<dynamic> route) => false,
                            //);
                          }
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
                          color: Swatch.buttons.shade700,
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
            elevation: 0,
            onPressed: () {
              /*
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParkingSpace()),
              );
              */
            },
            child:
                  Icon(Icons.confirmation_num, size: 32, color: Swatch.buttons.shade500),
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}