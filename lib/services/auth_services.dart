import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:training_apps/models/department_model.dart';
import 'package:training_apps/models/district_model.dart';
import 'package:training_apps/models/group_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class AuthServices extends GetxService {
  final base = Get.find<BaseService>();
  Future login(String mobile, String password) async {
    try {
      var response = await base.client.post(
        Routes.LOGIN,
        data: {'mobile': mobile, 'password': password},
      );
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future sendOtp(String mobile) async {
    try {
      var response = await base.client.post(
        '${Routes.BASE_URL}/send-otp',
        data: {'mobile': mobile},
      );
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future verifyOtp(String mobile, String otp) async {
    print(otp);
    try {
      var response = await base.client.post(
        Routes.VERIFY_OTP,
        data: {'mobile': mobile, 'otp': otp},
      );
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
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

  Future<List<DepartmentModel>> getDepartments(String filter) async {
    try {
      var response = await base.client.get(Routes.GET_DEPARTMENTS);

      if (response.statusCode == 200) {
        var data = response.data['departments'] as List<dynamic>;
        return DepartmentModel.fromMapList(data);
      } else {
        return Future.error('Failed to load departments');
      }
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future register(Map data) async {
    try {
      var response = await base.client.post(Routes.REGISTER, data: data);
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }
}
