import 'package:fancy_shoes/auth/login/login_vm.dart';
import 'package:fancy_shoes/data/repositories/auth_repository.dart';
import 'package:fancy_shoes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

  class _LoginPageState extends State<LoginPage> {
  late final AuthRepository authRepo;
  late final LoginVM loginVM;

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    authRepo = Get.find<AuthRepository>();
    loginVM = Get.find<LoginVM>();
    _checkAutoLogin();
  }

  void _checkAutoLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (loginVM.isUserLoggedIn()) {
        final person = loginVM.getLoggedInUser();
        if (person != null) {
          // Check if admin by email
          if (person.email == "yousifkhan.edu.pk@gmail.com") {
            Get.offAllNamed("/admin_dashboard");
          } else {
            Get.offAllNamed("/customer_home");
          }
        } else {
          Get.offAllNamed("/login");
        }
      }
    });
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = emailC.text.trim();
    final password = passC.text;
    loginVM.login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo/Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.tour,
                      size: 60,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: AppTheme.headingLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login to continue your journey',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),

                  // Email Field
                  TextFormField(
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: AppTheme.inputDecoration(
                      label: "Email",
                      hint: "your@email.com",
                      icon: Icons.email_outlined,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter email';
                      if (!GetUtils.isEmail(v.trim())) return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: passC,
                    obscureText: _obscurePassword,
                    decoration:
                        AppTheme.inputDecoration(
                          label: "Password",
                          hint: "Enter password",
                          icon: Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter password';
                      return null;
                    },
                  ),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.toNamed("/forgot-password"),
                      child: const Text("Forgot Password?"),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  Obx(() {
                    return SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: loginVM.isLoading.value
                            ? null
                            : _onLoginPressed,
                        style: AppTheme.primaryButtonStyle,
                        child: loginVM.isLoading.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: AppTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offNamed("/signUp");
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(LoginVM());
  }
}
