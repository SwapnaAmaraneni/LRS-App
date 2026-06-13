import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class PolygonBottomsheetColumnComponent extends StatefulWidget {
  const PolygonBottomsheetColumnComponent(
      {super.key, this.assetPath, this.title, this.onTap});
  final String? assetPath;
  final String? title;
  final void Function()? onTap;

  @override
  State<PolygonBottomsheetColumnComponent> createState() =>
      _PolygonBottomsheetColumnComponentState();
}

class _PolygonBottomsheetColumnComponentState
    extends State<PolygonBottomsheetColumnComponent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          color: AppColors.appBarColor,
          elevation: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  widget.assetPath ?? "",
                  height: 30,
                  width: 30,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  widget.title ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
