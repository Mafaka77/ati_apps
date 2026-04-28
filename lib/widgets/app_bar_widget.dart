import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_apps/controllers/nav_controller.dart';
import 'package:training_apps/reusables/reusables.dart';

class CustomAppBar extends GetView<NavController>
    implements PreferredSizeWidget {
  CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

        child: Row(
          children: [
            // Profile + Greeting
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(30),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Greeting texts
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hello,',
                        style: textStyle(
                          12,
                          Colors.black,
                          FontWeight.normal,
                          context: context,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          'Lalfakzuala',
                          style: textStyle(
                            16,
                            Colors.black,
                            FontWeight.normal,
                            context: context,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
