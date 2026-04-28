import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/main.dart';
import 'package:training_apps/services/auth_services.dart';

class AuthController extends GetxController {
  final AuthServices services = Get.find<AuthServices>(tag: 'authService');
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  //LOGIN
  var loginMobileText = TextEditingController();
  var loginPasswordText = TextEditingController();
  var isLoginPasswordHidden = true.obs;

  //OTP
  var otpMobileText = TextEditingController();
  var otpText = TextEditingController();
  var isOtpSent = false.obs;
  //REGISTER
  var fullNameText = TextEditingController();
  var emailText = TextEditingController();
  var dobText = TextEditingController();
  var genderText = ''.obs;
  var mobileText = TextEditingController();
  var districtId = ''.obs;
  var departmentName = TextEditingController();
  var groupId = ''.obs;
  var passwordText = TextEditingController();
  var isPasswordHidden = true.obs;
  var confirmPasswordText = TextEditingController();
  var isConfirmPasswordHidden = true.obs;
  var designationText = TextEditingController();
  var madatoryCompletion = true.obs;
  var isGovtEmployee = true.obs;
  var dateOfEntry = TextEditingController();
  var dateOfSuperannuation = TextEditingController();
  var dateOfEntryToPresentGrade = TextEditingController();
  var recruitmentText = ''.obs;
  var confirmOrNotText = ''.obs;
  var serviceCadreText = TextEditingController();
  var disclaimer = false.obs;
  //MIDDLEWARE
  var isAuthenticated = false.obs;

  void login(Function onLoading, Function onSuccess, Function onError) async {
    onLoading();
    try {
      var response = await services.login(
        loginMobileText.text,
        loginPasswordText.text,
      );
      if (response.statusCode == 200) {
        if (response.data['status'] == 404) {
          onError(response.data['message']);
        } else if (response.data['status'] == 400) {
          onError(response.data['message']);
        } else if (response.data['status'] == 200) {
          var token = response.data['token'];
          await storage.write('token', token);
          isAuthenticated.value = true;
          onSuccess('');
        } else {
          onError(response.data['message']);
        }
      }
    } catch (ex) {
      onError(ex.toString());
    }
  }

  Future sendOtp() async {
    try {
      var response = await services.sendOtp(otpMobileText.text);
      print(response.data);
      if (response.statusCode == 200 && response.data['status'] == 200) {
        isOtpSent.value = true;
        return {'success': true, 'message': response.data['message']};
      }
      return {'success': false, 'message': response.data['message']};
    } catch (ex) {
      return {'success': false, 'message': ex.toString()};
    }
  }

  Future verifyOtp() async {
    try {
      var response = await services.verifyOtp(otpMobileText.text, otpText.text);
      var statusCode =
          response.statusCode == 200 && response.data['status'] == 200;
      if (statusCode) {
        return {'success': true, 'message': response.data['message']};
      }
      return {'success': false, 'message': response.data['message']};
    } catch (ex) {
      return {'success': false, 'message': ex.toString()};
    }
  }

  Future getDistrict(String filter) async {
    try {
      var response = await services.getDistricts(filter);
      return response;
    } catch (ex) {}
  }

  Future getGroup(String filter) async {
    try {
      var response = await services.getGroups(filter);
      return response;
    } catch (ex) {}
  }

  Future getDepartments(String filter) async {
    try {
      var response = await services.getDepartments(filter);
      return response;
    } catch (ex) {}
  }

  bool get isUserAuthenticated {
    var token = storage.read('token');
    if (token != null) {
      isAuthenticated.value = true;
      return true;
    }
    return false;
  }

  Future register() async {
    try {
      Map data = {
        'full_name': fullNameText.text,
        'email': emailText.text,
        'gender': genderText.value,
        'dob': dobText.text,
        'mobile': otpMobileText.text,
        'district': districtId.value,
        'department': departmentName.text,
        'password': passwordText.text,
        'designation': designationText.text,
        'group': groupId.value,
        'is_govt_employee': isGovtEmployee.value,
        'date_of_entry': dateOfEntry.text,
        'date_of_superannuation': dateOfSuperannuation.text,
        'recruitment': recruitmentText.value,
        'confirmation': confirmOrNotText.value,
        'service_cadre': serviceCadreText.text,
        'mandatory_completion': madatoryCompletion.value,
        'date_of_entry_in_present_grade': dateOfEntryToPresentGrade.text,
      };
      var response = await services.register(data);
      var statusCode = response.statusCode == 200 || response.statusCode == 201;
      if (statusCode) {
        return {'success': true, 'message': response.data['message']};
      }
      return {'success': false, 'message': response.data['message']};
    } catch (ex) {
      return {'success': false, 'message': ex.toString()};
    }
  }
}
