import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../data/sample_data.dart';
import '../models/cart_item_model.dart';
import '../models/category_model.dart';
import '../models/food_model.dart';
import '../models/user_model.dart';

class AppProvider extends ChangeNotifier {
  UserModel? userLogin;
  String? errorMessage;
  final List<CategoryModel> categories = List.from(SampleData.categories);
  final List<FoodModel> foods = List.from(SampleData.foods);
  final List<CartItemModel> cart = [];

  Future<bool> login(String email, String password) async {
    final normalizedEmail = email.trim();
    if (normalizedEmail == 'test@gmail.com' && password == '123456') {
      userLogin = const UserModel(
        fullName: 'Khách hàng Demo',
        email: 'test@gmail.com',
      );
      errorMessage = null;
      notifyListeners();
      return true;
    }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      final userDoc = await FirebaseFirestore.instance.collection('USERS').doc(normalizedEmail).get();
      final userData = userDoc.data();
      userLogin = UserModel(
        fullName: userData?['fullName'] as String? ?? credential.user?.displayName ?? normalizedEmail,
        email: normalizedEmail,
      );
      errorMessage = null;
      notifyListeners();
      return true;
    } catch (error) {
      debugPrint('Đăng nhập Firebase thất bại: $error');
      errorMessage = 'Email hoặc mật khẩu không đúng. Firebase chưa được cấu hình hoặc chưa kết nối.';
      return false;
    }
  }

  Future<bool> register(String fullName, String email, String password) async {
    final normalizedEmail = email.trim();
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      await credential.user?.updateDisplayName(fullName.trim());
      await FirebaseFirestore.instance.collection('USERS').doc(normalizedEmail).set({
        'fullName': fullName.trim(),
        'email': normalizedEmail,
        'createdAt': FieldValue.serverTimestamp(),
      });
      errorMessage = null;
      return true;
    } catch (error) {
      debugPrint('Đăng ký Firebase thất bại: $error');
      errorMessage = 'Đăng ký thất bại. Vui lòng kiểm tra lại thông tin hoặc cấu hình Firebase.';
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      errorMessage = null;
      return true;
    } catch (error) {
      debugPrint('Gửi email đặt lại mật khẩu thất bại: $error');
      errorMessage = 'Không thể gửi email. Firebase chưa được cấu hình hoặc chưa kết nối.';
      return false;
    }
  }

  void logout() {
    userLogin = null;
    cart.clear();
    try {
      FirebaseAuth.instance.signOut();
    } catch (error) {
      debugPrint('Đăng xuất Firebase thất bại: $error');
    }
    notifyListeners();
  }

  List<FoodModel> getFoodsByCategory(String categoryId) {
    return foods.where((food) => food.categoryId == categoryId).toList();
  }

  void addToCart(FoodModel food) {
    final index = cart.indexWhere((item) => item.food.id == food.id);
    if (index == -1) {
      cart.add(CartItemModel(food: food, quantity: 1));
    } else {
      cart[index].quantity++;
    }
    notifyListeners();
  }

  void increaseQty(String foodId) {
    final index = cart.indexWhere((item) => item.food.id == foodId);
    if (index != -1) {
      cart[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQty(String foodId) {
    final index = cart.indexWhere((item) => item.food.id == foodId);
    if (index != -1) {
      if (cart[index].quantity > 1) {
        cart[index].quantity--;
      } else {
        cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String foodId) {
    cart.removeWhere((item) => item.food.id == foodId);
    notifyListeners();
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  double getItemsTotal() {
    return cart.fold(0, (total, item) => total + item.food.price * item.quantity);
  }

  double getOfferDiscount() {
    return cart.isEmpty ? 0 : 10000;
  }

  double getTaxes() {
    return getItemsTotal() * 0.08;
  }

  double getDeliveryCharges() {
    return cart.isEmpty ? 0 : 15000;
  }

  double getTotalPay() {
    return getItemsTotal() - getOfferDiscount() + getTaxes() + getDeliveryCharges();
  }

  int getCartCount() {
    return cart.fold(0, (total, item) => total + item.quantity);
  }
}
