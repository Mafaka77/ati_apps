import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:training_apps/models/department_model.dart';
import 'package:training_apps/models/district_model.dart';
import 'package:training_apps/models/group_model.dart';
import 'package:training_apps/models/user_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class ProfileServices extends GetxService {
  final base = Get.find<BaseService>();
  Future<UserModel> me() async {
    try {
      var response = await base.client.get(Routes.ME);
      return UserModel.fromMap(response.data['user']);
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future logout() async {
    try {
      var response = await base.client.post(Routes.LOGOUT);
      return response;
    } catch (ex) {}
  }

  Future<List<DistrictModel>> getDistricts(String filter) async {
    try {
      var response = await base.client.get(Routes.GET_DISTRICTS);
      if (response.statusCode == 200) {
        var data = response.data['districts'] as List<dynamic>;
        return DistrictModel.fromMapList(data);
      } else {
        return Future.error('Failed to load districts');
      }
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future<List<GroupModel>> getGroups(String filter) async {
    try {
      var response = await base.client.get(Routes.GROUPS);
      if (response.statusCode == 200) {
        var data = response.data['groups'] as List<dynamic>;
        return GroupModel.fromJsonList(data);
      } else {
        return Future.error('Failed to load groups');
      }
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future getProfile() async {
    try {
      var response = await base.client.get(Routes.GET_MY_PROFILE);
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future updateProfile(var data) async {
    try {
      var response = await base.client.patch(
        Routes.UPDATE_PROFILE,
        data: data,
        options: Options(contentType: 'multipart/form-data'),
      );
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }
}
