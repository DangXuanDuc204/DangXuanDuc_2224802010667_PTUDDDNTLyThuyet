# Ứng dụng đặt món

Ứng dụng Flutter bán đồ ăn trực tuyến cho nhà hàng. App dùng Provider để quản lý trạng thái, Firebase Auth để đăng nhập/đăng ký/quên mật khẩu và Cloud Firestore để lưu thông tin người dùng.

## Công nghệ sử dụng

- Flutter
- Dart
- Provider / ChangeNotifier
- Firebase Core
- Firebase Auth
- Cloud Firestore

## Chức năng đã làm

- Đăng nhập bằng tài khoản demo local.
- Đăng nhập bằng Firebase Auth nếu đã cấu hình Firebase.
- Đăng ký tài khoản Firebase và lưu thông tin vào Firestore collection `USERS`.
- Quên mật khẩu bằng Firebase Auth.
- Phân loại món ăn theo nền văn hóa ẩm thực.
- Tìm kiếm món ăn ở trang chính.
- Tìm kiếm món ăn trong từng danh mục.
- Danh sách 24 món ăn, mỗi danh mục có ít nhất 4 món.
- Hiển thị giá tiền bằng VNĐ.
- Thêm món vào giỏ hàng, tăng giảm số lượng, xóa món.
- Hóa đơn thanh toán: tổng tiền món ăn, giảm giá, thuế, phí giao hàng, tổng thanh toán.
- Thanh toán thành công.
- Drawer tiếng Việt có Trang chủ, Giỏ hàng, Đăng xuất và thông tin khách hàng.
- Giao diện responsive: web/desktop hiển thị trong khung điện thoại ở giữa màn hình, Android chạy full màn hình.

## Tài khoản demo

```text
test@gmail.com / 123456
```

Ứng dụng vẫn chạy được bằng tài khoản demo local khi Firebase chưa được cấu hình.

## Cách chạy Android

```bash
flutter pub get
flutter run
```

## Cách chạy web

```bash
flutter pub get
flutter run -d chrome
```

## Cấu hình Firebase

Project đã có cấu hình Android với package:

```text
com.example.restaurant_app
```

Nếu muốn dùng tài khoản thật:

1. Bật Authentication Email/Password trong Firebase Console.
2. Bật Cloud Firestore.
3. Đảm bảo `android/app/google-services.json` đúng Firebase project.

## Kịch bản quay video

1. Mở app.
2. Đăng nhập demo bằng `test@gmail.com / 123456`.
3. Mở màn hình đăng ký tài khoản.
4. Mở màn hình quên mật khẩu.
5. Xem banner và phân loại món ăn.
6. Tìm kiếm món ăn ở trang chính.
7. Chọn loại món và tìm kiếm trong danh mục.
8. Thêm món vào giỏ hàng.
9. Tăng/giảm số lượng.
10. Xem hóa đơn thanh toán bằng VNĐ.
11. Tiến hành thanh toán.
12. Xem màn hình thanh toán thành công.
13. Đăng xuất.
