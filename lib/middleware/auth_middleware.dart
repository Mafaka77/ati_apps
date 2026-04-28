import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/auth_controller.dart';
import 'package:training_apps/main.dart';

class AuthMiddleware extends GetMiddleware {
  var token = storage.read('token');

  @override
  RouteSettings? redirect(String? route) {
    Get.put(AuthController());
    final authController = Get.find<AuthController>();
    if (!authController.isUserAuthenticated) {
      return const RouteSettings(name: '/auth');
    }
    return null;
  }
}
