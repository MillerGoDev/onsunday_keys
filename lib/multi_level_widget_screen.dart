import 'package:flutter/material.dart';

class MultiLevelWidgetScreen extends StatefulWidget {
  const MultiLevelWidgetScreen({super.key});

  @override
  State<MultiLevelWidgetScreen> createState() => _MultiLevelWidgetScreenState();
}

class _MultiLevelWidgetScreenState extends State<MultiLevelWidgetScreen> {
  @override
  Widget build(BuildContext context) {
    print("Build ComplexWidgetScreen");
    return Column(
      children: [
        const NestedWidget(
          child: NestedWidget(
            child: NestedWidget(),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: const Text("Rebuild"),
        ),
      ],
    );
  }

  Widget _buildWidget() {
    return const NestedWidget(
      child: NestedWidget(
        child: NestedWidget(),
      ),
    );
  }
}

class NestedWidget extends StatelessWidget {
  const NestedWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    print("Build NestedWidget");
    return child ?? const SizedBox.shrink();
  }
}
