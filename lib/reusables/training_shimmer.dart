import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder that matches the Training Card layout you provided.
class TrainingGridShimmer extends StatelessWidget {
  final int itemCount;
  final double
  cardAspectRatio; // width / height ratio; you used 3 / 1 -> childAspectRatio: 3/1
  final double imageFlex; // left image flex
  final double contentFlex; // right content flex
  final BorderRadiusGeometry cardRadius;

  const TrainingGridShimmer({
    Key? key,
    this.itemCount = 4,
    this.cardAspectRatio = 3 / 1,
    this.imageFlex = 1,
    this.contentFlex = 2,
    this.cardRadius = const BorderRadius.all(Radius.circular(12)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: cardAspectRatio,
          crossAxisSpacing: 22,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: cardRadius),
            child: Row(
              children: [
                // Left: Image placeholder
                Expanded(
                  flex: imageFlex.toInt(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: baseColor),
                        // status chip placeholder (positioned)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SizedBox(width: 40, height: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right: Textual content placeholder
                Expanded(
                  flex: contentFlex.toInt(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Container(
                          height: 14,
                          width: double.infinity,
                          color: baseColor,
                        ),
                        const SizedBox(height: 8),

                        // eligibility row (icon + text)
                        Row(
                          children: [
                            // icon circle placeholder
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: baseColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(height: 12, width: 120, color: baseColor),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // overlapping avatars + seats text
                        Row(
                          children: [
                            // overlapping avatars
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: 0,
                                  child: _avatarPlaceholder(baseColor),
                                ),
                                Positioned(
                                  left: 14,
                                  child: _avatarPlaceholder(
                                    baseColor,
                                    indexOffset: 1,
                                  ),
                                ),
                                Positioned(
                                  left: 28,
                                  child: _avatarPlaceholder(
                                    baseColor,
                                    indexOffset: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 40), // space after avatars
                            Container(height: 12, width: 70, color: baseColor),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // date row (icon + date range placeholder)
                        Row(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: baseColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(height: 12, width: 180, color: baseColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _avatarPlaceholder(Color color, {int indexOffset = 0}) {
    // slight size variation if you want; here constant
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}
