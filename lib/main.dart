import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/router.dart';
import 'package:training_apps/screens/home_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:training_apps/services/auth_services.dart';
import 'package:training_apps/services/base_service.dart';
import 'package:training_apps/services/document_services.dart';
import 'package:training_apps/services/enrollment_detail_services.dart';
import 'package:training_apps/services/evaluation_services.dart';
import 'package:training_apps/services/faq_services.dart';
import 'package:training_apps/services/home_services.dart';
import 'package:training_apps/services/my_training_services.dart';
import 'package:training_apps/services/nav_services.dart';
import 'package:training_apps/services/profile_services.dart';
import 'package:training_apps/services/ticket_services.dart';
import 'package:training_apps/services/training_detail_services.dart';
import 'package:training_apps/services/training_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:training_apps/setup_fcm.dart';
import 'firebase_options.dart';

final storage = GetStorage();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupFcm();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put(BaseService(), permanent: true);
  Get.put(AuthServices(), tag: 'authService');
  Get.put(NavServices(), tag: 'navSercices');
  Get.put(HomeServices(), tag: 'homeServices', permanent: true);
  Get.put(TrainingServices(), tag: 'trainingServices');
  Get.put(
    TrainingDetailServices(),
    tag: 'trainingDetailServices',
    permanent: true,
  );
  Get.put(MyTrainingServices(), tag: 'myTrainingServices', permanent: true);
  Get.put(
    EnrollmentDetailServices(),
    tag: 'enrollmentDetailServices',
    permanent: true,
  );
  Get.put(FaqServices(), tag: 'faqServices');
  Get.put(DocumentServices(), tag: 'documentServices');
  Get.put(TicketServices(), tag: 'ticketServices');
  Get.put(ProfileServices(), tag: 'profileServices', permanent: true);
  Get.put(EvaluationServices(), tag: 'evaluationServices', permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ATI',
      theme: _buildTheme(),
      initialRoute: '/',
      getPages: getPages,
    );
  }

  ThemeData _buildTheme() {
    var baseTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: 'SN Pro',
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: MyColors.home_background,
      primaryColor: const Color(0xFF2563EB),

      textTheme: baseTheme.textTheme.copyWith(
        displayLarge: const TextStyle(
          fontFamily: 'SN Pro',
          color: Color(0xFF111827),
          fontWeight: FontWeight.w700,
          fontSize: 32,
          letterSpacing: -0.5,
        ),

        bodyLarge: const TextStyle(
          fontFamily: 'SN Pro',
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),

        bodyMedium: const TextStyle(
          fontFamily: 'SN Pro',
          color: Color(0xFF4B5563),
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: 0.1,
        ),
        labelLarge: const TextStyle(
          fontFamily: 'SN Pro',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFEFF6FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
      ),
    );
  }
}
