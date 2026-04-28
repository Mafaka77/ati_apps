import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:training_apps/controllers/home_controller.dart';
import 'package:training_apps/reusables/reusables.dart';

class FaqWidget extends GetView<HomeController> {
  const FaqWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.faqs.isEmpty
              ? Container()
              : controller.isFaqLoading.isTrue
              ? Container()
              : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingWidget(
                      'FAQ',
                      Ionicons.radio_button_off_outline,
                      () => {Get.toNamed('/faq')},
                      context,
                    ),
                    sizedBoxHeight(10),
                    ListView.separated(
                      separatorBuilder: (context, index) => sizedBoxHeight(10),
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
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          expandedAlignment: Alignment.topLeft,
                          children: [Text(data.answer)],
                        );
                      },
                    ),
                    sizedBoxHeight(40),
                  ],
                ),
              ),
    );
  }
}
