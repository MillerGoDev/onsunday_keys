import 'package:onsunday_keys/1_render_object.dart';
import 'package:onsunday_keys/2_widget.dart';
import 'package:onsunday_keys/4_key.dart';

class BuildContext {}

class Element extends BuildContext {
  Widget? widget;
  RenderObject? renderObject;

  Element({this.widget});

  // Root element: Trường hợp ngoại lệ, có sẵn root widget và root renderObject khi khởi tạo.

  // Q: Root wiget trông như thế nào?
  // A: Ví dụ:

  // Khi chạy:
  // runApp(MainApp());

  // Flutter framework sẽ tạo ra root widget như sau:
  // RootWidget(
  //    child: MainApp()
  // )

  // MainApp() là widget được viết bởi người dùng. Nó sẽ là widget con của RootWidget.

  // Q: Ngoài Root element, các element bên dưới được tạo ra như thế nào?
  // A: Được tạo ra thông qua widget con.

  Element? _child;
  Element updateChild(Element? child, Widget? newWidget) {
    // Khi cây widget mới được tạo ra, thì element con sẽ chưa được tạo ra.
    // 1. Duyệt qua widget con để tạo ra element con.
    _child = inflateWidget(newWidget);
    return _child!;
  }

  Element? inflateWidget(Widget? newWidget) {
    // 1. Tạo mới element con.
    final newChild = newWidget!.createElement();

    // 2. Chỉ định element cha cho element con và đi xuống element con để tìm element con tiếp theo.
    newChild.mount(parent: this);

    // 3. Trả về element con.
    return newChild;
  }

  // Mỗi class kế thừa từ Element sẽ có 1 hàm mount() khác nhau.
  Element? _parent;
  void mount({Element? parent}) {
    // 1. Lưu lại element cha.
    _parent = parent;

    // Case 1. Nếu đây là RenderObjectElement, thì tạo mới renderObject.
    renderObject = widget!.createRenderObject();

    // Case 2. Nếu đây là ComponentElement, thì chạy hàm build() của widget để tạo ra widget con.
    final childWidget = widget!.build();
    // Sau đó gọi hàm updateChild() để duyệt qua widget con. Đệ quy.
    updateChild(null, childWidget);
  }

  // Tìm hiểu tiếp bên dưới
  void update(Widget? newWidget) {
    widget = newWidget;
  }
}

// Cuối cùng, chúng ta có thể sẽ thu được 1 cây element tương ứng với cây widget như sau:
// RootElement
//   - ComponentElement
//     - ComponentElement 1
//      - RenderObjectElement
//     - ComponentElement 2
//      - ComponentElement 2.1
//       - RenderObjectElement
//      - ComponentElement 2.2
//       - RenderObjectElement

// Q: Điều gì xảy ra khi gọi hàm setState()?
// A: Flutter framework sẽ gọi hàm update() của element.

class ComponentElement extends Element {
  ComponentElement({Widget? widget}) : super(widget: widget);

  @override
  void update(Widget? newWidget) {
    // 1. Lưu lại widget mới.
    super.update(newWidget);

    // 2. Gọi hàm build() để tạo ra widget con.
    final newChildWidget = widget!.build();

    // 2. Gọi hàm updateChild() để duyệt qua widget con.
    updateChild(_child, newChildWidget);
  }

  @override
  Element updateChild(Element? child, Widget? newWidget) {
    // Lần này, cây element đã có, nên child không null.
    // 1. Gọi hàm update() của element con.
    child!.update(newWidget);
    return child;
  }
}

class RenderObjectElement extends Element {
  RenderObjectElement({Widget? widget}) : super(widget: widget);

  @override
  void update(Widget? newWidget) {
    // 1. Lưu lại widget mới.
    super.update(newWidget);

    // 2. Gọi hàm updateRenderObject() để cập nhật renderObject.
    widget!.updateRenderObject(renderObject!);
  }
}

// Q: Vậy mỗi lần gọi setState() thì Flutter framework sẽ build lại toàn bộ cây widget bên dưới?
// A: Không. Hàm updateChild() sẽ không gọi hàm update() của element con nếu widget con không thay đổi.

// void updateChild(Element? child, Widget? newWidget) {
//   if (child.widget == newWidget) {
//     return;
//   }
//   child!.update(newWidget);
// }

// Như vậy, đây là cách mà Flutter framework sử dụng để tối ưu hiệu năng.
// Bất kể cây widget có bao nhiêu tầng, bao nhiêu node, thì khi gọi setState(), Flutter framework chỉ rebuild
// một số lượng nhỏ các widget cần thiết.

// const MainApp(color: Colors.red) == const MainApp(color: Colors.red) => true;

// ------------------------------
class DemoElement extends Element {
  @override
  Element updateChild(Element? child, Widget? newWidget) {
    if (child!.widget == newWidget) {
      return child;
    }
    // canUpdate:
    // oldWidget.runtimeType == newWidget.runtimeType &&
    //    oldWidget?.key == newWidget?.key
    if (Widget.canUpdate(child.widget, newWidget)) {
      child.update(newWidget);
      return child;
    } else {
      final newChild = child.inflateWidget(newWidget);
      return newChild!;
    }
  }
}

// ------------------------------
class StatefulElement extends ComponentElement {
  StatefulElement({required Widget widget})
      : state = widget.createState(),
        super(widget: widget);

  final State state;
}

class State {
  void initState() {}
}

// ------------------------------
class MultiChildRenderObjectElement extends RenderObjectElement {
  List<Element> children = [];

  @override
  void update(Widget? newWidget) {
    super.update(newWidget);
    children = updateChildren(
      children,
      (newWidget! as MultiChildRenderObjectWidget).children,
    );
  }

  List<Element> updateChildren(
      List<Element> oldChildren, List<Widget> newWidgets) {
    // Old children: [Element 1, Element 2] -> Old widgets: [Widget 1, Widget 2]
    // New widgets: [Widget 2, Widget 1]
    final newChildren = <Element>[];

    // ------------------------------
    // 1. If widgets are not keyed:
    for (var i = 0; i < newWidgets.length; i++) {
      final newWidget = newWidgets[i];
      final oldChild = oldChildren[i];
      final newChild = updateChild(oldChild, newWidget);
      newChildren.add(newChild);
    }
    // newWidget = Widget 2
    // oldChild = Element 1
    // newChild = Element 1 -> newChild.widget = Widget 2
    // newChildren = [Element 1]

    // newWidget = Widget 1
    // oldChild = Element 2
    // newChild = Element 2 -> newChild.widget = Widget 1
    // newChildren = [Element 1, Element 2]

    // return newChildren;

    // ------------------------------
    // 2. If widgets are keyed:
    final Map<Key, Element> oldKeyedChildren = {};
    // oldKeyedChildren: {
    //   Key('1'): Element 1,
    //   Key('2'): Element 2,
    // }

    for (final newWidget in newWidgets) {
      final oldChild = oldKeyedChildren[newWidget.key];
      if (Widget.canUpdate(oldChild!.widget, newWidget)) {
        final newChild = updateChild(oldChild, newWidget);
        newChildren.add(newChild);
      }
    }

    // newWidget = Widget 2 -> newWidget.key = Key('2')
    // oldChild = Element 2 -> oldChild.widget = Widget 2
    // newChild = Element 2 -> newChild.widget = Widget 2
    // newChildren = [Element 2]

    // newWidget = Widget 1 -> newWidget.key = Key('1')
    // oldChild = Element 1 -> oldChild.widget = Widget 1
    // newChild = Element 1 -> newChild.widget = Widget 1
    // newChildren = [Element 2, Element 1]

    return newChildren;
  }
}
