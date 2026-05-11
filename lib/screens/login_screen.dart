import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../utils/app_colors.dart';
import 'cuisine_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Vui lòng nhập email và mật khẩu');
      return;
    }

    setState(() => _loading = true);
    final provider = context.read<AppProvider>();
    final ok = await provider.login(email, password);
    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      _showMessage('Đăng nhập thành công');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CuisineScreen()),
      );
    } else {
      _showMessage(provider.errorMessage ?? 'Email hoặc mật khẩu không đúng');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 38),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Ứng dụng đặt món',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Đăng nhập để đặt món yêu thích của bạn',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted, fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text('Quên mật khẩu?'),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _loading ? null : _login,
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.login),
                    label: const Text('Đăng nhập'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    icon: const Icon(Icons.person_add_alt_1),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                    label: const Text('Đăng ký'),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
