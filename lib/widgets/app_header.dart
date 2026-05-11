import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../screens/cart_screen.dart';
import '../screens/cuisine_screen.dart';
import '../screens/login_screen.dart';
import '../utils/app_colors.dart';

class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final count = provider.getCartCount();
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              tooltip: 'Giỏ hàng',
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
            if (count > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final user = provider.userLogin;
          return Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: AppColors.primary),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: AppColors.primary, size: 32),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Xin chào',
                              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.fullName ?? user?.email ?? 'Khách hàng',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Trang chủ'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const CuisineScreen()),
                    (route) => false,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: const Text('Giỏ hàng'),
                trailing: Text('${provider.getCartCount()}'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              const Spacer(),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.danger),
                title: const Text('Đăng xuất'),
                onTap: () {
                  provider.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
