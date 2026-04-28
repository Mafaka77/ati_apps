import 'package:get/get.dart';
import 'package:training_apps/models/ticket_model.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';

class TicketServices extends GetxService {
  final base = Get.find<BaseService>();
  Future<List<TicketModel>> getTickets(int offset, int limit) async {
    try {
      var response = await base.client.get(
        Routes.GET_TICKETS,
        queryParameters: {'offset': offset, 'limit': limit},
      );
      return TicketModel.fromJsonList(response.data['tickets']);
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future getTicketDetails(String id) async {
    try {
      var response = await base.client.get(Routes.GET_TICKET_DETAILS(id));
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future replyTicket(String id, String message) async {
    try {
      var response = await base.client.post(
        Routes.REPLY_TICKET(id),
        data: {'message': message},
      );
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future submitTicket(var data) async {
    try {
      var response = await base.client.post(Routes.SUBMIT_TICKET, data: data);
      return response;
    } catch (ex) {
      return Future.error(ex);
    }
  }
}
