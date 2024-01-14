import 'package:onsunday_keys/3_element.dart';

import '2_widget.dart';

class Key {
  const Key();
}

class UniqueKey extends Key {
  // Non-constant key. New key every time.
}

class ValueKey extends Key {
  // Has constant constructor.
  const ValueKey(this.value);

  final String value;
}

class GlobalKey extends Key {
  // Don't have constant constructor.
  GlobalKey() : super();

  Element? get _currentElement => globalKeyRegistry[this];

  BuildContext? get currentContext => _currentElement;

  Widget? get currentWidget => _currentElement?.widget;

  State? get currentState => _currentElement is StatefulElement
      ? (_currentElement as StatefulElement).state
      : null;
}

Map<GlobalKey, Element> globalKeyRegistry = {};

// GlobalKey().currentContext?.findRenderObject();
