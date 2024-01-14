// Hiệu năng về UI của Flutter framework như thế nào?
// Flutter dùng cơ chế gì để tối ưu hiệu năng?
// Có vấn đề gì với code bên dưới?
// Tại sao dùng const constructor để tối ưu hiệu năng?

import 'package:flutter/material.dart';

class BadExample extends StatefulWidget {
  const BadExample({super.key});

  @override
  State<BadExample> createState() => _BadExampleState();
}

class _BadExampleState extends State<BadExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
      ),
      body: Column(
        children: List.generate(
          20,
          (index) => Text("@code.on.sunday"),
          // (index) => const ItemWidget(),
        ),
      ),
    );
  }

  Widget _buildChild() {
    print("build child");
    return Text("@code.on.sunday");
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print("build child");
    return const Text("@code.on.sunday");
  }
}
