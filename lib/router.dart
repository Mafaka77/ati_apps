import 'package:get/get.dart';
import 'package:training_apps/controllers/app_permission_controller.dart';
import 'package:training_apps/controllers/auth_controller.dart';
import 'package:training_apps/controllers/document_controller.dart';
import 'package:training_apps/controllers/enrollment_detail_controller.dart';
import 'package:training_apps/controllers/evaluation_controller.dart';
import 'package:training_apps/controllers/faq_controller.dart';
import 'package:training_apps/controllers/home_controller.dart';
import 'package:training_apps/controllers/nav_controller.dart';
import 'package:training_apps/controllers/notification_controller.dart';
import 'package:training_apps/controllers/ticket_controller.dart';
import 'package:training_apps/controllers/training_controller.dart';
import 'package:training_apps/controllers/training_detail_controller.dart';
import 'package:training_apps/middleware/auth_middleware.dart';
import 'package:training_apps/screens/all_training_screen.dart';
import 'package:training_apps/screens/app_permission_screen.dart';
import 'package:training_apps/screens/document_screen.dart';
import 'package:training_apps/screens/edit_profile_screen.dart';
import 'package:training_apps/screens/enrollment_detail_screen.dart';
import 'package:training_apps/screens/evaluation_screen.dart';
import 'package:training_apps/screens/faq_screen.dart';
import 'package:training_apps/screens/home_screen.dart';
import 'package:training_apps/screens/login_screen.dart';
import 'package:training_apps/screens/my_training_screen.dart';
import 'package:training_apps/screens/new_ticket_screen.dart';
import 'package:training_apps/screens/notification_screen.dart';
import 'package:training_apps/screens/otp_screen.dart';
import 'package:training_apps/screens/profile_screen.dart';
import 'package:training_apps/screens/register_screen.dart';
import 'package:training_apps/screens/terms_screen.dart';
import 'package:training_apps/screens/ticket_detail_screen.dart';
import 'package:training_apps/screens/ticket_screen.dart';
import 'package:training_apps/screens/training_detail_screen.dart';

import 'screens/nav_screen.dart';

final getPages = [
  GetPage(
    name: '/auth',
    page: () => const LoginScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => AuthController());
    }),
    children: [
      GetPage(name: '/otp', page: () => const OtpScreen()),
      GetPage(name: '/register', page: () => RegisterScreen()),
    ],
  ),

  GetPage(
    name: '/',
    page: () => const NavScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => NavController());
    }),
    middlewares: [AuthMiddleware()],
    children: [
      GetPage(
        name: '/notification',
        binding: BindingsBuilder(() {
          Get.lazyPut(() => NotificationController());
        }),
        page: () => NotificationScreen(),
      ),
      GetPage(
        name: '/trainings',
        binding: BindingsBuilder(() {
          Get.lazyPut(() => TrainingController());
        }),
        page: () => const AllTrainingScreen(),
      ),
      GetPage(
        name: '/training-details/:trainingId',
        binding: BindingsBuilder(() {
          Get.lazyPut(() => TrainingDetailController());
        }),
        page: () => TrainingDetailScreen(),
      ),
      GetPage(
        name: '/enrollment-details/:enrollmentId',

        binding: BindingsBuilder(() {
          Get.lazyPut(() => EnrollmentDetailController());
        }),
        page: () => EnrollmentDetailScreen(),
      ),
      GetPage(
        name: '/faq',
        binding: BindingsBuilder(() {
          Get.lazyPut(() => FaqController());
        }),
        page: () => FaqScreen(),
      ),
      GetPage(
        name: '/document',
        page: () => DocumentScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => DocumentController());
        }),
      ),
      GetPage(
        name: '/ticket',
        page: () => TicketScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => TicketController());
        }),
        children: [
          GetPage(name: '/new-ticket', page: () => NewTicketScreen()),
          GetPage(name: '/details', page: () => TicketDetailScreen()),
        ],
      ),
      GetPage(name: '/terms', page: () => TermsScreen()),
      GetPage(name: '/edit-profile', page: () => EditProfileScreen()),
      GetPage(
        name: '/app-permission',
        page: () => AppPermissionScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => AppPermissionController());
        }),
      ),
      GetPage(
        name: '/evaluation/:trainingId',
        binding: BindingsBuilder(() {
          Get.lazyPut(() => EvaluationController());
        }),
        page: () => EvaluationScreen(),
      ),
    ],
  ),
];
