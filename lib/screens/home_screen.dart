import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/home_controller.dart';
import 'package:training_apps/reusables/reusables.dart';
import 'package:training_apps/reusables/shimmer.dart';
import 'package:training_apps/widgets/app_bar_widget.dart';
import 'package:training_apps/widgets/carousel_widget.dart';
import 'package:training_apps/widgets/faq_widget.dart';
import 'package:training_apps/widgets/upcoming_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.refreshAll, // pull-to-refresh callback
              color: Colors.blue, // refresh spinner color
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // required
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Obx(
                        () =>
                            controller.isLoading.isTrue
                                ? const ShimmerCarouselWithHints()
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CarouselWidget(),
                                    sizedBoxHeight(20),
                                    const UpcomingWidget(),
                                    sizedBoxHeight(20),
                                    const FaqWidget(),
                                    sizedBoxHeight(50),
                                  ],
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
