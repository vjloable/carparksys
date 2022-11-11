import 'package:carparksys/assets/swatches/custom_colors.dart';
import 'package:carparksys/pages/home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Swatch.prime,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              elevation: 15,
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              child: SizedBox(
                width: 330,
                height: 380,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'LOGIN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                          'E-mail',
                          style: TextStyle(
                              fontSize: 18,
                          )
                      ),
                      TextField(
                        style: const TextStyle(fontSize: 16),
                        maxLines: 1,
                        minLines: 1,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.onPrimary, width: 3
                              )
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Swatch.prime, width: 3
                              )
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 18,
                        )
                      ),
                      TextField(
                          style: const TextStyle(fontSize: 16),
                          maxLines: 1,
                          minLines: 1,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.onPrimary, width: 3
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Swatch.prime, width: 3
                                )
                            ),
                          ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onPrimary)
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()),
                            );
                          },
                          child: SizedBox(
                            height: 50,
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'SUBMIT',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                      const Divider(thickness: 2),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Swatch.prime.shade100)),
                          onPressed: () {},
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 30,
                                    height: 25,
                                      child: Image(
                                        image: AssetImage('lib/assets/logo/google_logo.png')
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Swatch.buttons.shade400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
            )
          ]
        ),
      ),
    );
   }
}
