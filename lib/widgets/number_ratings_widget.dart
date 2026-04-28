import 'package:flutter/material.dart';

class NumberRatingBar extends StatelessWidget {
  final int selectedRating;
  final ValueChanged<int> onRatingSelected;

  const NumberRatingBar({
    Key? key,
    required this.selectedRating,
    required this.onRatingSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Height of the rating bar
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(10, (index) {
            int rating = index + 1;
            bool isSelected = selectedRating == rating;

            return Expanded(
              child: GestureDetector(
                onTap: () => onRatingSelected(rating),
                behavior: HitTestBehavior
                    .opaque, // Ensures the whole box is clickable
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF073E6C) // Your active blue color
                        : Colors.transparent,
                    // Adds a vertical divider between numbers (except the last one)
                    border: Border(
                      right: index < 9
                          ? BorderSide(color: Colors.grey.shade300, width: 1)
                          : BorderSide.none,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    rating.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
