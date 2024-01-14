import 'package:flutter/material.dart';
import 'package:onsunday_keys/key_example_screen.dart';

void main() {
  const widgets = [SizedBox(width: 1), SizedBox(width: 2), SizedBox(width: 3)];
  // // find index of widget that equals to SizedBox(width: 2)
  final index =
      widgets.indexWhere((element) => element == const SizedBox(width: 2));
  print(index);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: KeyExampleScreen(),
    );
  }
}
