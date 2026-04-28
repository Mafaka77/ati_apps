import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:training_apps/models/user_model.dart';
import 'package:training_apps/screens/home_screen.dart';
import 'package:training_apps/screens/my_training_screen.dart';
import 'package:training_apps/screens/profile_screen.dart';
import 'package:training_apps/services/nav_services.dart';

class NavController extends GetxController {
  NavServices services = Get.find(tag: 'navSercices');
  var selectedIndex = 0.obs;
  final navBarList = [
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/images/home.svg', height: 20),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/images/list.svg', height: 20),
      label: 'My Trainings',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/images/profile.svg', height: 20),
      label: 'Profile',
    ),
  ];
  final List<Widget> widgetOptions = <Widget>[
    const HomeScreen(),
    const MyTrainingScreen(),
    ProfileScreen(),
  ];
  var user = <UserModel>{}.obs;
  var isUserLoading = false.obs;

  final messaging = FirebaseMessaging.instance;
  @override
  void onInit() {
    // TODO: implement onInit
    me();
    registerToken();
    super.onInit();
  }

  Future registerToken() async {
    try {
      var token = await messaging.getToken();
      var platform = Platform.isAndroid ? 'android' : 'ios';
      var response = await services.registerToken(token.toString(), platform);
      if (response.statusCode == 200) {
        print('FCM token registered');
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future me() async {
    isUserLoading.value = true;
    try {
      var response = await services.me();
      user.add(response);
      isUserLoading.value = false;
    } catch (ex) {
      isUserLoading.value = false;
    }
  }
}
