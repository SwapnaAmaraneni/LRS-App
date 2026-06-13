import 'package:flutter/material.dart';

import '../res/constants/app_assets.dart';

class LoaderComponent extends StatefulWidget {
  const LoaderComponent({super.key});

  @override
  State<LoaderComponent> createState() => _LoaderComponentState();
}

class _LoaderComponentState extends State<LoaderComponent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          color: Colors.black.withValues(alpha: 0.3),
          child: Image.asset(
            AppAssets.loader,
            height: 50,
            width: 50,
          ),
        ),
      ],
    );
  }
}
