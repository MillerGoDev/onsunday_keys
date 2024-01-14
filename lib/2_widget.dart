import 'dart:ui';

import 'package:onsunday_keys/1_render_object.dart';
import 'package:onsunday_keys/3_element.dart';

import '4_key.dart';

class Widget {
  Color? color;
  double? width;
  double? height;

  // Q: Truyền thông tin từ Widget xuống RenderObject như thế nào?
  // A: Có 2 cách:

  // 1. Khi khởi tạo RenderObject.
  RenderObject createRenderObject() {
    return RenderObject(
      color: color,
      width: width,
      height: height,
    );
  }

  // 2. Khi cập nhật RenderObject.
  void updateRenderObject(RenderObject renderObject) {
    renderObject.color = color;
    renderObject.width = width;
    renderObject.height = height;
  }

  // Q: Ai sẽ gọi hàm createRenderObject()? Kết quả trả về sẽ được lưu vào đâu?

  // Q: Ai sẽ gọi hàm updateRenderObject()? Gọi khi nào?

  Element createElement() {
    return Element(widget: this);
  }

  Widget build() {
    return Widget();
  }

  Key? key;
  static bool canUpdate(Widget? oldWidget, Widget? newWidget) {
    return oldWidget.runtimeType == newWidget.runtimeType &&
        oldWidget?.key == newWidget?.key;
  }

  State createState() {
    return State();
  }
}

// ------------------------------
// Row, Column, Stack, ...
class MultiChildRenderObjectWidget extends Widget {
  List<Widget> children = [];
}
