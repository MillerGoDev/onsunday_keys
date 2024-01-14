import 'package:flutter/material.dart';

class KeyExampleScreen extends StatefulWidget {
  const KeyExampleScreen({super.key});

  @override
  State<KeyExampleScreen> createState() => _KeyExampleScreenState();
}

final globalKey = GlobalKey<_NestedStatefulWidgetState>();

class _KeyExampleScreenState extends State<KeyExampleScreen> {
  final widgets = [
    NestedStatefulWidget(
      text: 'I want a bread',
      // key: UniqueKey(),
      // key: Key('1'),
      // key: ValueKey('1'),
      // key: globalKey,
    ),
    NestedStatefulWidget(
      text: 'I want an ice cream',
      // key: UniqueKey(),
      // key: Key('1'),
      // key: ValueKey('2'),
      // key: globalKey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('setState');
          setState(() {
            final temp = widgets[0];
            widgets[0] = widgets[1];
            widgets[1] = temp;
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: widgets,
        ),
      ),
    );
  }
}

class NestedStatefulWidget extends StatefulWidget {
  const NestedStatefulWidget({super.key, required this.text});

  final String text;

  @override
  State<NestedStatefulWidget> createState() => _NestedStatefulWidgetState();
}

class _NestedStatefulWidgetState extends State<NestedStatefulWidget> {
  bool checked = false;

  @override
  void initState() {
    super.initState();
    print('initState NestedStatefulWidget');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.text),
        Checkbox(
          value: checked,
          onChanged: (value) {
            setState(() {
              checked = value!;
            });
          },
        ),
      ],
    );
  }

  // @override
  // void didUpdateWidget(covariant NestedStatefulWidget oldWidget) {
  //   print('didUpdateWidget NestedStatefulWidget');
  //   super.didUpdateWidget(oldWidget);
  // }
}
