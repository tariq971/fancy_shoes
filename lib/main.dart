import 'package:fancy_shoes/auth/login/loginView.dart';
import 'package:fancy_shoes/auth/signup/verify_email_dependency.dart';
import 'package:fancy_shoes/theme/app_theme.dart';
import 'package:fancy_shoes/ui/admin/add_place/add_place.dart';
import 'package:fancy_shoes/ui/admin/add_place/add_place_dependency.dart';
import 'package:fancy_shoes/ui/admin/dashboard/admin_dashboard.dart';
import 'package:fancy_shoes/ui/admin/dashboard/admin_dashboard_dependency.dart';
import 'package:fancy_shoes/ui/consumer/home/consumer_home.dart';
import 'package:fancy_shoes/ui/consumer/home/consumer_home_dependency.dart';
import 'package:fancy_shoes/ui/consumer/place_details/place_details.dart';
import 'package:fancy_shoes/ui/consumer/place_details/place_details_dependency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth/forgot_passwod_view.dart';
import 'auth/signup/signUp_view.dart';
import 'auth/signup/verify_email.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Tour Booking App",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      initialRoute: "/login",
      getPages: [
        // Auth Routes
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/signUp',
          page: () => const SignUpPage(),
          binding: SignUpBinding(),
        ),
        GetPage(
          name: '/verify-email',
          page: () => VerifyEmailPage(),
          binding: VerifyEmailBinding(),
        ),
        GetPage(
          name: '/forgot-password',
          page: () => const ForgotPasswordPage(),
        ),

        // Consumer Routes
        GetPage(
          name: '/customer_home',
          page: () => ConsumerHomePage(),
          binding: ConsumerHomeBinding(),
        ),
        GetPage(
          name: '/place_details',
          page: () => PlaceDetailsPage(),
          binding: PlaceDetailsBinding(),
        ),

        // Admin Routes
        GetPage(
          name: '/admin_dashboard',
          page: () => AdminDashboardPage(),
          binding: AdminDashboardBinding(),
        ),
        GetPage(
          name: '/add_place',
          page: () => AddPlacePage(),
          binding: AddPlaceBinding(),
        ),
      ],
    );
  }
}
