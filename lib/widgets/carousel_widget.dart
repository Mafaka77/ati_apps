import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/home_controller.dart';
import 'package:training_apps/routes/routes.dart';

class CarouselWidget extends GetView<HomeController> {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FlutterCarousel(
        options: FlutterCarouselOptions(
          height: Get.height * 0.23,
          showIndicator: true,
          slideIndicator: CircularSlideIndicator(),
          disableCenter: true,
          viewportFraction: 1.0,
        ),
        items: controller.carouselData.asMap().entries.map((entry) {
          int index = entry.key;
          print(Routes.IMAGE_URL + entry.value.image_url);
          // final imageUrl =
          //     '${Routes.IMAGE_URL}carousel/${entry.value.image}';
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: double.infinity,
                height: Get.height * 0.23, // Match carousel height
                margin: EdgeInsets.symmetric(horizontal: index == 0 ? 0 : 6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    Routes.IMAGE_URL + (entry.value.image_url ?? ''),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                  // child: CachedNetworkImage(
                  //   imageUrl: Routes.IMAGE_URL + entry.value.image_url,
                  //   placeholder: (context, url) => Image.asset(
                  //     'assets/images/placeholder.png',
                  //     fit: BoxFit.cover,
                  //   ),
                  //   errorWidget: (context, url, error) =>
                  //       const Icon(Icons.error),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
