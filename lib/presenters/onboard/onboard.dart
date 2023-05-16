// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 80),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                  fontFamily: ''
                ),
                children: [
                  TextSpan(
                    text: 'Space',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Element',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: SvgPicture.asset(
              'assets/svg/astronaut.svg',
              semanticsLabel: 'Just a astronaut'
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 30),
            alignment: Alignment.topLeft,
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 32, 
                  color: Colors.black
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Explore',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '\nUniverse'),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
