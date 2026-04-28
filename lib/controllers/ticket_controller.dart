import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:training_apps/models/ticket_model.dart';
import 'package:training_apps/services/ticket_services.dart';

class TicketController extends GetxController {
  TicketServices services = Get.find(tag: 'ticketServices');
  var formState = GlobalKey<FormState>();
  var tickets = <TicketModel>[].obs;
  var ticketDetails = <TicketModel>{}.obs;
  var isLoading = false.obs;
  var offset = 0.obs;
  var limit = 10.obs;
  var replyText = TextEditingController();

  //SUBMIT
  var subjectText = TextEditingController();
  var descriptionText = TextEditingController();
  var categoryText = ''.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    getTickets();
    super.onInit();
  }

  Future getTickets() async {
    tickets.clear();
    isLoading.value = true;
    try {
      var response = await services.getTickets(offset.value, limit.value);
      tickets.assignAll(response);
      isLoading.value = false;
    } catch (ex) {
      isLoading.value = false;
    }
  }

  Future getTicketDetails(
    String id,
    Function onLoading,
    Function onSuccess,
    Function onError,
  ) async {
    ticketDetails.clear();
    onLoading();
    try {
      var response = await services.getTicketDetails(id);
      if (response.statusCode == 200) {
        if (response.data['status'] == 200) {
          var data = TicketModel.fromMap(response.data['ticket']);
          ticketDetails.add(data);
          onSuccess();
        } else {
          onError(response.data['message']);
        }
      } else {
        onError('Error Occured');
      }
    } catch (ex) {
      print(ex);
      onError('Error Occured');
    }
  }

  Future replyTicket(
    String id,
    Function onLoading,
    Function onSuccess,
    Function onError,
  ) async {
    onLoading();
    try {
      var response = await services.replyTicket(id, replyText.text);
      if (response.statusCode == 200) {
        if (response.data['status'] == 400) {
          onError(response.data['message']);
        } else if (response.data['status'] == 404) {
          onError(response.data['message']);
        } else if (response.data['status'] == 200) {
          onSuccess(response.data['message']);
        } else {
          onError(response.data['message']);
        }
      }
    } catch (ex) {
      onError(ex.toString());
    }
  }

  Future submitTicket(
    Function onLoading,
    Function onSuccess,
    Function onError,
  ) async {
    onLoading();
    Map data = {
      'subject': subjectText.text,
      'description': descriptionText.text,
      'category': categoryText.value,
    };
    try {
      var response = await services.submitTicket(data);
      if (response.statusCode == 200) {
        if (response.data['status'] == 400) {
          onError(response.data['message']);
        } else if (response.data['status'] == 201) {
          onSuccess(response.data['message']);
        } else {
          onError(response.data['message']);
        }
      }
    } catch (ex) {
      onError(ex.toString());
    }
  }
}
