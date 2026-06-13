import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';

class AppBarReusable extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final String? title;
  final bool? drawerPresent;

  const AppBarReusable({
    super.key,
    this.leading,
    this.actions,
    this.title,
    this.drawerPresent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.appBarColor),
      child: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: (drawerPresent ?? false)
            ? null
            : leading ??
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
        actions: actions,
        title: FittedBox(
          child: Text(
            title ?? "",
            style: const TextStyle(
                color: AppColors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0, // Removes the shadow
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
