import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A combined shimmer placeholder: top carousel skeleton + horizontal listview hints
class ShimmerCarouselWithHints extends StatelessWidget {
  final int carouselItemCount;
  final int hintItemCount;
  final double carouselHeight;
  final double hintItemWidth;
  final double hintItemHeight;
  final BorderRadiusGeometry borderRadius;

  const ShimmerCarouselWithHints({
    Key? key,
    this.carouselItemCount = 3,
    this.hintItemCount = 6,
    this.carouselHeight = 200,
    this.hintItemWidth = 80,
    this.hintItemHeight = 60,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel skeleton (PageView-style)
          SizedBox(
            height: carouselHeight,
            child: PageView.builder(
              itemCount: carouselItemCount,
              controller: PageController(viewportFraction: 0.9),
              physics:
                  const NeverScrollableScrollPhysics(), // shimmer is static placeholder
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: borderRadius,
                    ),
                    // mimic content inside a card (title, subtitle)
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // top large block (image area)
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // title bar
                          Container(height: 12, width: 140, color: baseColor),
                          const SizedBox(height: 8),
                          // subtitle bar
                          Container(height: 10, width: 100, color: baseColor),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Hints header (optional)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(height: 14, width: 120, color: baseColor),
          ),

          const SizedBox(height: 12),

          // Horizontal hint list skeleton
          SizedBox(
            height: hintItemHeight,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              scrollDirection: Axis.horizontal,
              itemCount: hintItemCount,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Container(
                  width: hintItemWidth,
                  height: hintItemHeight,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // small circular thumbnail placeholder
                      Container(
                        width: hintItemHeight * 0.5,
                        height: hintItemHeight * 0.5,
                        decoration: BoxDecoration(
                          color: baseColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // small text line
                      Container(
                        width: hintItemWidth * 0.6,
                        height: 8,
                        color: baseColor,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Optional list section placeholders (vertical list items)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: List.generate(3, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 12,
                              width: double.infinity,
                              color: baseColor,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: baseColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
