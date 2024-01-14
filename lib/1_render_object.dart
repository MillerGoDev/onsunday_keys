import 'package:flutter/material.dart';

class RenderObject {
  // 1. Kích thước
  // 2. Vị trí
  void performLayout() {}

  // 3. Vẽ:
  // - Màu sắc
  // - Hình dạng
  // - Đường nét
  // - Vị trí
  // - Kích thước
  void paint() {}

  // Q: Lấy thông tin ở đâu để vẽ?
  // A: Lấy từ các thuộc tính của RenderObject.

  // Ví dụ:
  Color? color;
  double? width;
  double? height;

  RenderObject({
    this.color,
    this.width,
    this.height,
  });

  // Q: Giá trị của những thuộc tính này được lấy từ đâu?
  // A: Từ các thuộc tính của Widget.

  // Q: Vì sao chúng ta không tạo ra RenderObject trực tiếp mà phải thông qua Widget?
  // A: Vì nhiều lí do liên quan đến kiến trúc của Flutter framework.
}
