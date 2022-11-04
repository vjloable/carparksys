import 'package:carparksys/assets/swatches/swatch.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: AppBar(
            title: Container(
              padding: const EdgeInsets.fromLTRB(0,25,0,10),
              child:
                Container(
                  height: 40,
                  width: double.maxFinite,
                  //padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.white),
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
                      height: 220,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)
                        ),
                        color: Colors.white,
                      )
                  ),
                  const SizedBox(height: 20, width: double.infinity),
                  FittedBox(
                    child: Row(
                      children: [
                        Container(
                            height: 120,
                            width: 350,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                              ),
                              color: Swatch.prime,
                            ),
                            child: MaterialButton(
                              onPressed: (){},
                              child: const FittedBox(
                                child: Text(
                                  'RESERVE',
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Arial'
                                  ),
                                ),
                              ),
                            )
                        ),
                        const SizedBox(height: 100, width: 20),
                        Container(
                            height: 120,
                            width: 120,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                              ),
                              color: Swatch.prime,
                            )
                        )
                      ],
                    )
                  ),
                  const SizedBox(height: 40, width: double.infinity),
                  Container(
                    height: 960,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(20)
                        ),
                        color: Colors.white,
                    ),
                    child: const SizedBox(width: 200, height: 200),
                  )
                ],
              ),
            ),
          )
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child:
          BottomAppBar(
              elevation: 50,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.home),
                          iconSize: 28,
                          color: Swatch.buttonsAccent.shade400,
                          onPressed: () {}
                      ),
                      const Text('HOME')
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(width: 50, height: 30),
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
                          onPressed: () {}
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
            tooltip: 'Ticket',
            elevation: 3,
            onPressed: () {
              /*
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParkingSpace()),
              );
              */
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_num, size: 32, color: Swatch.buttons.shade500),
                ]
            ),
          )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}