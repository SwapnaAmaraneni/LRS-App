import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';

class CustomFooterContainer extends StatelessWidget {
  const CustomFooterContainer({super.key, this.radius});
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      height: MediaQuery.of(context).size.height * 0.062,
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius ?? 20),
          topRight: Radius.circular(radius ?? 20),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: FittedBox(
              child: Text(
                "Designed & Developed by",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Image.asset(
              AppAssets.footerCgg,
            ),
          ),
        ],
      ),
    );
  }
}
