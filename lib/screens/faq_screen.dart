import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/faq_controller.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:training_apps/reusables/reusables.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});
  var controller = Get.find<FaqController>();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Obx(
                () =>
                    controller.faqs.isEmpty
                        ? SizedBox.shrink()
                        : Row(
                          children: [
                            headingBar(),
                            sizedBoxWidth(8),
                            Text("FAQ's", style: headingStyle()),
                          ],
                        ),
              ),
              sizedBoxHeight(10),
              Obx(
                () =>
                    controller.isLoading.isTrue
                        ? Center(child: CircularProgressIndicator())
                        : controller.faqs.isEmpty
                        ? Center(child: Text('No Data'))
                        : ListView.separated(
                          separatorBuilder:
                              (context, index) => sizedBoxHeight(10),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.faqs.length,
                          itemBuilder: (c, i) {
                            var data = controller.faqs[i];
                            return ExpansionTile(
                              title: Text(data.question),
                              backgroundColor: Colors.white,
                              dense: true,
                              initiallyExpanded: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.white),
                              ),
                              collapsedBackgroundColor: Colors.white,
                              collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              childrenPadding: EdgeInsets.all(20),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              expandedAlignment: Alignment.topLeft,
                              children: [Text(data.answer)],
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
