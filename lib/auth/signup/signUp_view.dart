import 'package:fancy_shoes/auth/signup/signUp_vm.dart';
import 'package:fancy_shoes/data/repositories/auth_repository.dart';
import 'package:fancy_shoes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late AuthRepository authRepo;
  late SignUpVM signUpVM;

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController conPassC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    authRepo = Get.find<AuthRepository>();
    signUpVM = Get.find<SignUpVM>();
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    conPassC.dispose();
    nameC.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    signUpVM.signup(
      emailVal: emailC.text.trim(),
      passVal: passC.text,
      nameVal: nameC.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add,
                      size: 50,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: AppTheme.headingLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign up to get started',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: nameC,
                    decoration: AppTheme.inputDecoration(
                      label: "Name",
                      hint: "Your name",
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  TextFormField(
                    controller: passC,
                    obscureText: _obscurePassword,
                    decoration: AppTheme.inputDecoration(
                      label: "Password",
                      hint: "Min 6 characters",
                      icon: Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                      if (v.length < 6) return 'Min 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: conPassC,
                    obscureText: _obscureConfirmPassword,
                    decoration: AppTheme.inputDecoration(
                      label: "Confirm Password",
                      hint: "Re-enter password",
                      icon: Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Confirm password';
                      if (v != passC.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  Obx(() {
                    if (signUpVM.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _onSignUpPressed,
                        style: AppTheme.primaryButtonStyle,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: AppTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => Get.offAllNamed('/login'),
                        child: const Text(
                          'Login',
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

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.lazyPut(() => SignUpVM());
  }
}

