import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/document_controller.dart';
import 'package:training_apps/reusables/colors.dart';

class DocumentScreen extends StatelessWidget {
  DocumentScreen({super.key});
  var controller = Get.find<DocumentController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.home_background,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SingleChildScrollView(child: Column(children: [])),
    );
  }
}
