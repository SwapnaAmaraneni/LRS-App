import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lrsofficer/data/base_api_client.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/res/CustomAlerts/image_preview_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/utils/address_fetch.dart';
import 'package:lrsofficer/utils/file_path_check_utils.dart';
import 'package:lrsofficer/utils/permission_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart'; // <-- compute()
// ignore: depend_on_referenced_packages

/// -------------------------------
/// Top-level helper for compute()
/// -------------------------------
/// This function decodes, resizes and compresses image bytes.
/// It runs inside a background isolate via compute().
Future<Uint8List> _compressResizeEncode(Uint8List inputBytes) async {
  // Decode using package:image
  final decodedImage = img.decodeImage(inputBytes);
  if (decodedImage == null) {
    // If decoding fails, return original bytes
    return inputBytes;
  }

  // Resize to 700x700 (same as original logic)
  final img.Image resized =
      img.copyResize(decodedImage, width: 700, height: 700);

  // Compress with decreasing quality until under 5 MB or quality exhausted
  List<int> compressed;
  int quality = 85;
  const int maxBytes = 5 * 1024 * 1024;

  do {
    compressed = img.encodeJpg(resized, quality: quality);
    quality -= 5;
  } while (compressed.length > maxBytes && quality > 0);

  return Uint8List.fromList(compressed);
}

class ImageCaptureComponent extends StatefulWidget {
  const ImageCaptureComponent({
    super.key,
    required this.callbackValue,
    this.height,
    this.width,
    required this.label,
    this.networkImg,
  });

  final void Function(
    XFile,
  ) callbackValue;
  final double? height;
  final double? width;
  final String label;
  final String? networkImg;

  @override
  State<ImageCaptureComponent> createState() => _ImageCaptureComponentState();
}

class _ImageCaptureComponentState extends State<ImageCaptureComponent> {
  File? _image;
  String? networkImageFuture;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.networkImg != null && widget.networkImg!.isNotEmpty) {
        setNetworkImage(widget.networkImg);
      }
    });
  }

  @override
  void didUpdateWidget(covariant ImageCaptureComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If parent updates with a different networkImg, reload
    if (oldWidget.networkImg != widget.networkImg) {
      if (widget.networkImg != null &&
          widget.networkImg!.isNotEmpty &&
          widget.networkImg != networkImageFuture) {
        if (widget.networkImg!.startsWith("http")) {
          setState(() {
            networkImageFuture = widget.networkImg;
          });
          return;
        } else {
          setNetworkImage(widget.networkImg);
        }
      }
    }
  }

  Future<void> setNetworkImage(String? networkImg) async {
    if (networkImg != null && networkImg.isNotEmpty) {
      final imgStr = networkImg.trim();

      // Case 1: Local file path
      if (File(imgStr).existsSync()) {
        // No service call needed, handle as local file
        networkImageFuture = null;
      }
      // Case 2: Base64 string (basic check)
      else if (imgStr.startsWith("data:image") || isValidBase64(imgStr)) {
        // Handle base64 decode yourself, no service call
        networkImageFuture = null;
      } else if (isNetworkUrl(imgStr)) {
        networkImageFuture = imgStr;
      }
      // Case 3: Otherwise → call service
      else {
        final response = await BaseApiClient().getFile(imgStr, CancelToken());
        if (response != null && response?.statusCode == 200) {
          final fullUrl = response?.realUri.toString();
          if (!mounted) return;
          setState(() {
            networkImageFuture = fullUrl;
          });
        } else {
          networkImageFuture = widget.networkImg;
        }
      }
    }
  }

  Future<void> getImage(ImageSource type) async {
    final provider = Provider.of<ImagePickerLoader>(context, listen: false);
    provider.setLoaderVisibleStatus(true);

    final XFile? imgFile = await ImagePicker().pickImage(
        source: type,
        imageQuality: 25,
        preferredCameraDevice: CameraDevice.rear);

    if (imgFile == null) {
      provider.setLoaderVisibleStatus(false);
      return;
    }

    try {
      // Load the image file
      final File originalImage = File(imgFile.path);

      // Read the original image as Uint8List (this is small cost)
      final Uint8List imageData = await originalImage.readAsBytes();

      // Debug
      if (!kReleaseMode) {
        debugPrint('Original image size: ${imageData.lengthInBytes} bytes');
      }

      // -----------------------------
      // Heavy work moved to compute()
      // decode -> resize -> compress
      // -----------------------------
      Uint8List compressedBytes;
      try {
        compressedBytes = await compute(_compressResizeEncode, imageData);
      } catch (e) {
        // If compute fails for any reason, fallback to main-thread processing (original behavior)
        AppLogger().logDebug("compute() failed, falling back: $e");
        // Fallback: use same algorithm on main thread (mirrors original)
        final decodedImage = img.decodeImage(imageData);
        if (decodedImage == null) {
          provider.setLoaderVisibleStatus(false);
          return;
        }
        final img.Image resizedImage =
            img.copyResize(decodedImage, width: 700, height: 700);
        int quality = 85;
        List<int> compressed = [];
        do {
          compressed = img.encodeJpg(resizedImage, quality: quality);
          quality -= 5;
        } while (compressed.length > 5 * 1024 * 1024 && quality > 0);
        compressedBytes = Uint8List.fromList(compressed);
      }

      final String tempPath = '${originalImage.path}.temp.jpg';

      // Save the compressed image to a file
      await File(tempPath).writeAsBytes(compressedBytes);

      // Print the compressed image size
      if (!kReleaseMode) {
        debugPrint('Compressed image size: ${compressedBytes.length} bytes');
      }

      // Check if the compressed image size is valid
      bool isValidSize =
          await isImageSizeValid(File(tempPath), 5 * 1024 * 1024); // 5 MB

      if (isValidSize) {
        // Location and address logic remain on main thread (unchanged)
        await Geolocator.requestPermission();
        final currentPosition = await Geolocator.getCurrentPosition(
          locationSettings:
              LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
        );

        final currentAddress = await GetCurrentAddress().getCurrentAddress(
            currentPosition.latitude, currentPosition.longitude);

        // Add text overlay to the compressed image and get a new XFile path
        final XFile? overlayedImage = await addTextOverlayToImage(
            File(tempPath), currentPosition, currentAddress);

        if (!mounted) return;

        setState(() {
          _image = File(overlayedImage!.path);
          widget.callbackValue(overlayedImage);
        });
      } else {
        if (!mounted) return;
        ValidationIoSAlert().showAlert(context,
            description: "Please choose an image smaller than 5 MB.");
      }
    } catch (e) {
      provider.setLoaderVisibleStatus(false);
      if (!kReleaseMode) debugPrint("Error: $e");
    } finally {
      // ensure loader is turned off
      provider.setLoaderVisibleStatus(false);
    }
  }

  Future<XFile?> addTextOverlayToImage(
      File originalImage, Position position, String currentAddress) async {
    final ui.Image image =
        await decodeImageFromList(await originalImage.readAsBytes());

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw the original image
    paintImage(
      canvas: canvas,
      rect:
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      image: image,
    );

    // Calculate the container height (15% of the image height)
    final double containerHeight = image.height * 0.15;
    const double bottomPadding = 50.0;
    final Paint paint = Paint()..color = Colors.black.withValues(alpha: 0.5);

    // Draw black container with padding from the bottom
    canvas.drawRect(
      Rect.fromLTWH(0, image.height - containerHeight - bottomPadding,
          image.width.toDouble(), containerHeight),
      paint,
    );

    // Calculate font size based on container height
    final double fontSize = containerHeight * 0.1;

    // Base vertical offset for the first text
    double currentOffset = image.height - containerHeight - bottomPadding + 10;

    // Helper function to draw text
    void drawText(String text, double reqfontSize) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.white,
            fontSize: reqfontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.left,
        textDirection: ui.TextDirection.ltr,
      );

      textPainter.layout(maxWidth: image.width.toDouble() - 40);
      textPainter.paint(canvas, Offset(20, currentOffset));

      // Increment the currentOffset by the height of the text
      currentOffset += textPainter.height + 10; // 10 for padding between texts
    }

    // Address text
    drawText(currentAddress, fontSize * 1.5); // Replace with actual address

    // Latitude and Longitude text
    drawText('Latitude: ${position.latitude}', fontSize * 1.2);
    drawText('Longitude: ${position.longitude}', fontSize * 1.2);

    // Timestamp text
    final currentTime = DateTime.now();
    final formattedTime =
        DateFormat('dd-MM-yyyy hh:mm:ss a').format(currentTime);
    drawText('Timestamp: $formattedTime', fontSize * 1.2);

    final picture = recorder.endRecording();
    final img = await picture.toImage(image.width, image.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    // Save the image to a file
    final buffer = byteData!.buffer.asUint8List();
    final String tempPath = '${originalImage.path}.temp.jpg';
    await File(tempPath).writeAsBytes(buffer);

    return XFile(tempPath);
  }

  Future<bool> isImageSizeValid(File file, int maxSizeInBytes) async {
    try {
      Uint8List bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(Uint8List.fromList(bytes));

      if (image != null) {
        int imageSizeInBytes = image.length;
        return imageSizeInBytes <= maxSizeInBytes;
      } else {
        return false;
      }
    } on FileSystemException catch (e) {
      AppLogger().logDebug("Error reading file: $e");
      return false;
    } on Exception catch (e) {
      AppLogger().logDebug("Error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Network Image Future: $networkImageFuture");
    return (widget.networkImg != null &&
            widget.networkImg != "" &&
            _image == null)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: GestureDetector(
                onTap: AppConstants.isSavedApplication == "yes"
                    ? () {
                        FocusScope.of(context).unfocus();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ImagePreviewAlert(
                                photoPath: networkImageFuture ?? "");
                          },
                        );
                      }
                    : () async {
                        bool camPermission =
                            await PermissionsUtil.checkCameraPermission();
                        bool storagePermission =
                            await PermissionsUtil.checkStoragePermission();
                        if (camPermission == false ||
                            storagePermission == false) {
                          if (!context.mounted) return;
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return PopScope(
                                canPop: false,
                                child: AlertDialog(
                                  content: Text((storagePermission == false &&
                                          camPermission == false)
                                      ? "camGalleryPermission".tr()
                                      : (!storagePermission)
                                          ? "storagePermission".tr()
                                          : "cameraPermission".tr()),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        Navigator.of(dialogContext).pop();
                                        await openAppSettings();
                                      },
                                      child: Text(
                                        "ok".tr(),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          if (!context.mounted) return;
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text(
                                  "addPhoto".tr(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: CupertinoButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "takePhoto".tr(),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                          Navigator.pop(context);
                                          getImage(ImageSource.camera);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 1, // Divider height
                                      color: CupertinoColors
                                          .separator, // Divider color
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: CupertinoButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "chooseFromGallery".tr(),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                          Navigator.pop(context);
                                          getImage(ImageSource.gallery);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 1, // Divider height
                                      color: CupertinoColors
                                          .separator, // Divider color
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: CupertinoButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "cancel".tr(),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          // 1. Local File Path Check
                          if (File(widget.networkImg!).existsSync()) {
                            return Image.file(
                              File(widget.networkImg!),
                              height: 80,
                              width: 80,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 50);
                              },
                            );
                          }

                          // 2. Base64 Check
                          if (isValidBase64(widget.networkImg)) {
                            return Image.memory(
                              base64Decode(widget.networkImg!),
                              height: 80,
                              width: 80,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 80);
                              },
                            );
                          }

                          // 3. API Check and Load Network Image
                          if (networkImageFuture != null) {
                            return Image.network(
                              networkImageFuture!,
                              height: 80,
                              width: 80,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 50);
                              },
                            );
                          } else {
                            // 4. Invalid Fallback
                            return const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image_not_supported_outlined,
                                    size: 50),
                                Text(
                                  "Invalid image data",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 8),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.themeColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.label,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          )
        : _image != null
            ? GestureDetector(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.file(
                        _image!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.themeColor)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.label,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /* SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Image.file(
                        _image!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.themeColor)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.label,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                 */
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  bool camPermission =
                      await PermissionsUtil.checkCameraPermission();
                  bool storagePermission =
                      await PermissionsUtil.checkStoragePermission();
                  if (camPermission == false || storagePermission == false) {
                    if (!context.mounted) return;
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return PopScope(
                          canPop: false,
                          child: AlertDialog(
                            content: Text((storagePermission == false &&
                                    camPermission == false)
                                ? "camGalleryPermission".tr()
                                : (!storagePermission)
                                    ? "storagePermission".tr()
                                    : "cameraPermission".tr()),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(dialogContext).pop();
                                  await openAppSettings();
                                },
                                child: Text(
                                  "ok".tr(),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    if (!context.mounted) return;
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text(
                            "addPhoto".tr(),
                            style: const TextStyle(color: Colors.black),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: CupertinoButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "takePhoto".tr(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    Navigator.pop(context);
                                    getImage(ImageSource.camera);
                                  },
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 1, // Divider height
                                color:
                                    CupertinoColors.separator, // Divider color
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: CupertinoButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "chooseFromGallery".tr(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    Navigator.pop(context);
                                    getImage(ImageSource.gallery);
                                  },
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 1, // Divider height
                                color:
                                    CupertinoColors.separator, // Divider color
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: CupertinoButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "cancel".tr(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    bool camPermission =
                        await PermissionsUtil.checkCameraPermission();
                    bool storagePermission =
                        await PermissionsUtil.checkStoragePermission();
                    if (camPermission == false || storagePermission == false) {
                      if (!context.mounted) return;
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return PopScope(
                            canPop: false,
                            child: AlertDialog(
                              content: Text((storagePermission == false &&
                                      camPermission == false)
                                  ? "camGalleryPermission".tr()
                                  : (!storagePermission)
                                      ? "storagePermission".tr()
                                      : "cameraPermission".tr()),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    Navigator.of(dialogContext).pop();
                                    await openAppSettings();
                                  },
                                  child: Text(
                                    "ok".tr(),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      if (!context.mounted) return;
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text(
                              "addPhoto".tr(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: CupertinoButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "takePhoto".tr(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      Navigator.pop(context);
                                      getImage(ImageSource.camera);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  height: 1, // Divider height
                                  color: CupertinoColors
                                      .separator, // Divider color
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: CupertinoButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "chooseFromGallery".tr(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      Navigator.pop(context);
                                      getImage(ImageSource.gallery);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  height: 1, // Divider height
                                  color: CupertinoColors
                                      .separator, // Divider color
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: CupertinoButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "cancel".tr(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAssets.cam,
                          height: 55,
                          width: 55,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.themeColor)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.label,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }

  bool isNetworkUrl(String? url) {
    return url != null &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }
}

class ImagePickerLoader with ChangeNotifier {
  bool isLoading = false;
  bool get getImageLoader => isLoading;
  void setLoaderVisibleStatus(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}
