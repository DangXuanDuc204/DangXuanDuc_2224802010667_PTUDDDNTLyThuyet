import 'package:flutter_test/flutter_test.dart';
import 'package:food_order_restaurant_app/main.dart';

void main() {
  testWidgets('Ứng dụng đặt món mở màn hình đăng nhập', (tester) async {
    await tester.pumpWidget(const RestaurantApp());

    expect(find.text('Ứng dụng đặt món'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Đăng ký'), findsOneWidget);
    expect(find.text('Tài khoản demo: test@gmail.com / 123456'), findsOneWidget);
  });
}
