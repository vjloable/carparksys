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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'WELCOME!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'Menlo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Sign in to your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 40),
              Material(
                elevation: 15,
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.all(
                  Radius.circular(40),
                ),
                child: SizedBox(
                  width: 350,
                  height: 400,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 1),
                        TextField(
                          style: const TextStyle(fontSize: 16),
                          maxLines: 1,
                          minLines: 1,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.alternate_email),
                            prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                            label: const Text('E-Mail'),
                            labelStyle: const TextStyle(fontSize: 18),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.onPrimary, width: 1
                                ),
                                borderRadius: BorderRadius.circular(50)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Swatch.prime, width: 1
                                ),
                                borderRadius: BorderRadius.circular(50)
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                            style: const TextStyle(fontSize: 16),
                            maxLines: 1,
                            minLines: 1,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.key),
                              prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                              label: const Text('Password'),
                              labelStyle: const TextStyle(fontSize: 18),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onPrimary, width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Swatch.prime, width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                            ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onPrimary),
                              elevation: const MaterialStatePropertyAll(5),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const HomePage()),
                              );
                            },
                            child: SizedBox(
                              height: 55,
                              width: double.maxFinite,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'SUBMIT',
                                      style: TextStyle(
                                        fontFamily: 'Menlo',
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
                        const SizedBox(height: 10),
                        Stack(
                            children: [
                              const Divider(thickness: 1, color: Swatch.prime),
                              Center(child: Container(height: 40, width: 40, color: Theme.of(context).colorScheme.background, child: const Text('OR', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)))),
                            ]
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              elevation: const MaterialStatePropertyAll(5),
                              backgroundColor: const MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: SizedBox(
                              height: 55,
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
                                          fontFamily: 'Menlo',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
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
      ),
    );
   }
}
