import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:training_apps/main.dart';
import 'package:training_apps/models/department_model.dart';
import 'package:training_apps/models/district_model.dart';
import 'package:training_apps/models/group_model.dart';
import 'package:training_apps/models/user_model.dart';
import 'package:training_apps/services/profile_services.dart';
import 'package:dio/dio.dart' as dio;

class ProfileController extends GetxController {
  ProfileServices services = Get.find(tag: 'profileServices');
  var user = <UserModel>{}.obs;
  var isLoading = false.obs;
  var fullNameText = TextEditingController();
  var emailText = TextEditingController();
  var mobileText = TextEditingController();
  var departmentText = TextEditingController();
  var genderText = ''.obs;
  final Rxn<DistrictModel> selectedDistrict = Rxn<DistrictModel>();
  var districtId = ''.obs;
  final Rxn<GroupModel> selectedGroup = Rxn<GroupModel>();
  var groupId = ''.obs;
  var designationText = TextEditingController();
  XFile? profile_image = XFile('');
  var profileName = ''.obs;
  var profile_image_url = ''.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    me();
    super.onInit();
  }

  Future me() async {
    isLoading.value = true;
    user.clear();
    try {
      var response = await services.me();
      user.add(response);
      isLoading.value = false;
    } catch (ex) {
      isLoading.value = false;
    }
  }

  Future logout(
    Function onLoading,
    Function onSuccess,
    Function onError,
  ) async {
    onLoading();
    try {
      var response = await services.logout();
      if (response.statusCode == 200) {
        if (response.data['status'] == 400) {
          onError(response.data['message']);
        } else if (response.data['status'] == 200) {
          await storage.erase();
          onSuccess(response.data['message']);
        } else {
          onError(response.data['message']);
        }
      }
    } catch (ex) {
      onError(ex.toString());
    }
  }

  Future getDistrict(String filter) async {
    try {
      var response = await services.getDistricts(filter);
      return response;
    } catch (ex) {}
  }

  Future getUserDetails(
    Function onLoading,
    Function onSuccess,
    Function onError,
  ) async {
    onLoading();
    try {
      var response = await services.getProfile();
      if (response.statusCode == 200) {
        if (response.data['status'] == 200) {
          var data = response.data['user'];
          fullNameText.text = data['full_name'];
          emailText.text = data['email'];
          mobileText.text = data['mobile'];
          genderText.value = data['gender'] ?? '';
          profile_image_url.value = data['profile_picture'] ?? '';
          if (data['district'] != null &&
              data['district'] is Map<String, dynamic>) {
            selectedDistrict.value = DistrictModel.fromMap(data['district']);
          } else {
            selectedDistrict.value = null;
          }
          if (data['group'] != null && data['group'] is Map<String, dynamic>) {
            selectedGroup.value = GroupModel.fromMap(data['group']);
          } else {
            selectedGroup.value = null;
          }
          designationText.text = data['designation'] ?? '';
          departmentText.text = data['department'] ?? '';
          onSuccess();
        } else {
          onError('Error Occured');
        }
      }
    } catch (ex) {
      print(ex);
      onError(ex.toString());
    }
  }

  Future getGroup(String filter) async {
    try {
      var response = await services.getGroups(filter);
      return response;
    } catch (ex) {}
  }

  // build FormData
  Future<dio.FormData> buildProfileFormData(XFile? profileImage) async {
    final Map<String, dynamic> map = {
      'full_name': fullNameText.text,
      'email': emailText.text,
      'mobile': mobileText.text,
      'district': districtId.isEmpty
          ? selectedDistrict.value?.id
          : districtId.value,
      'gender': genderText.value,
      'designation': designationText.text,
      'group': groupId.isEmpty ? selectedGroup.value?.id : groupId.value,
      'department': departmentText.text,
    };

    if (profileImage != null && profileImage.path.isNotEmpty) {
      map['profile'] = await dio.MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.name,
      );
    } else if (profile_image_url.value.isNotEmpty) {
      map['profile'] = profile_image_url.value;
    } else {
      map['profile'] = profile_image_url.value;
    }

    // Remove keys that are null so they are not sent as "null" strings
    map.removeWhere((k, v) => v == null);

    return dio.FormData.fromMap(map);
  }

  Future updateProfile() async {
    try {
      final formData = await buildProfileFormData(profile_image);
      var response = await services.updateProfile(formData);
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
}
