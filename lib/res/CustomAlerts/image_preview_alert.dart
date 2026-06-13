import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewAlert extends StatefulWidget {
  const ImagePreviewAlert({
    super.key,
    required this.photoPath,
  });

  final String photoPath;

  @override
  State<ImagePreviewAlert> createState() => _ImagePreviewAlertState();
}

class _ImagePreviewAlertState extends State<ImagePreviewAlert> {
  @override
  void initState() {
    super.initState();
    // openImage(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Builder(
                    builder: (context) {
                      // ✅ Local file
                      if (File(widget.photoPath).existsSync()) {
                        return Image.file(
                          File(widget.photoPath),
                          fit: BoxFit.fill,
                        );
                      }

                      // ✅ Network URL
                      return Image.network(
                        widget.photoPath,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
