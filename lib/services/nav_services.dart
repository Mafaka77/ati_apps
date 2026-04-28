import 'package:get/get.dart';
import 'package:training_apps/models/user_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class NavServices extends GetxService {
  final base = Get.find<BaseService>();
  Future<UserModel> me() async {
    try {
      var response = await base.client.get(Routes.ME);
      return UserModel.fromMap(response.data['user']);
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future registerToken(String token, String? platform) async {
    try {
      var response = await base.client.post(
        Routes.REGISTER_TOKEN,
        data: {'token': token, 'platform': platform},
      );
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }
}
