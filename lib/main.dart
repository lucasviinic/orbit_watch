import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'presenters/home/home.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: const Home(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(32, 30, 57, .7),
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromRGBO(87, 85, 104, 1),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.rocket_launch, size: 33),
              label: 'Launchs',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 33,
                child: SvgPicture.asset(
                  'assets/svg/planet_icon.svg',
                  colorFilter: ColorFilter.mode(
                    currentIndex == 1 ? Colors.white : const Color.fromRGBO(87, 85, 104, 1), 
                    BlendMode.srcIn
                  )
                )),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 33),
              label: 'Profile',
            ),
          ],
        ),
      );
}
