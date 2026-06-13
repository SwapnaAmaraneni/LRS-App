import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/pdf_view_widget.dart';
import 'package:lrsofficer/utils/file_path_check_utils.dart';
import 'package:lrsofficer/utils/permission_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerComponent extends StatefulWidget {
  const FilePickerComponent({
    super.key,
    required this.callbackValue,
    this.height,
    this.width,
    this.filepath, this.ownershipDocFlag,
  });

  final void Function(
    File,
  ) callbackValue;
  final double? height;
  final double? width;
  final String? filepath;
  final bool? ownershipDocFlag;

  @override
  State<FilePickerComponent> createState() => _FilePickerComponentState();
}

class _FilePickerComponentState extends State<FilePickerComponent> {
  File? _file;
  String? _fileName;

  Future<void> getUploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      withReadStream: true,
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      String fileName = result.files.single.name;
      String extension = fileName.split('.').last.toLowerCase();

      AppLogger().logDebug("extension:: $extension");
      if (extension == 'pdf') {
        final file = result.paths.map((path) => File(path!)).first;
        bool isValidSize = await isFileSizeValid(
            File(file.path),
            widget.ownershipDocFlag == true ? (10 * 1024 * 1024) :
            AppConstants.isLayoutPlot.toLowerCase() == "L".toLowerCase()
                ? (20 * 1024 * 1024) //20MB for Layouts
                : (5 * 1024 * 1024)); // 10 MB
        if (isValidSize) {
          setState(() {
            _file = File(file.path);
            _fileName = fileName;
            widget.callbackValue(File(_file!.path));
          });
        } else {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return CupertinoAlertDialog(
                content: Text(
                  widget.ownershipDocFlag == true
                      ? 'Please choose document smaller than 10 MB.'
                      : AppConstants.isLayoutPlot.toLowerCase() == "L".toLowerCase()
                      ? 'Please choose document smaller than 20 MB.'
                      : 'Please choose document smaller than 5 MB.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      _file = null;
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text("ok".tr()),
                  ),
                ],
              );
            },
          );
        }
      } else {
        getUploadFile();
      }
    }
  }

  Future<bool> isFileSizeValid(File? file, int maxSizeInBytes) async {
    try {
      if (file != null) {
        int fileSize = await file.length();

        if (fileSize <= maxSizeInBytes) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      AppLogger().logDebug("Error picking file: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_file != null || (widget.filepath != null && widget.filepath != ""))
        ? (_file != null && _file?.path != "")
            ? GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.pdfUploaded,
                        height: 55,
                        width: 55,
                      ),
                      Column(
                        children: [
                          if ((_fileName != null && _fileName != ""))
                            BuildDocumentView(
                                title: _fileName ?? "",
                                pdfUrl: _file?.path ?? "")
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  bool storagePermission =
                      await PermissionsUtil.checkStoragePermission();
                  if (storagePermission == false) {
                    if (!context.mounted) return;
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return PopScope(
                          canPop: false,
                          child: AlertDialog(
                            content: Text("camGalleryPermission".tr()),
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
                    getUploadFile();
                  }
                },
              )
            : GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.pdfUploaded,
                        height: 55,
                        width: 55,
                      ),
                      Column(
                        children: [
                          Text(
                            (widget.filepath != null &&
                                    widget.filepath!.isNotEmpty &&
                                    _fileName != null &&
                                    _fileName!.isNotEmpty)
                                ? Uri.parse(widget.filepath!).pathSegments.last
                                : (isValidBase64(widget.filepath ?? "")
                                    ? "file_${DateTime.now().millisecondsSinceEpoch}.pdf"
                                    : _fileName ?? ""),
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),

                          // ✅ Show "View Document" only if filepath is valid
                          if (widget.filepath != null &&
                              widget.filepath!.isNotEmpty)
                            BuildDocumentView(
                              title: (isValidBase64(widget.filepath ?? ""))
                                  ? "file_${DateTime.now().millisecondsSinceEpoch}.pdf"
                                  : Uri.parse(widget.filepath!)
                                      .pathSegments
                                      .last,
                              pdfUrl: widget.filepath!,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  bool storagePermission =
                      await PermissionsUtil.checkStoragePermission();
                  if (storagePermission == false) {
                    if (!context.mounted) return;
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return PopScope(
                          canPop: false,
                          child: AlertDialog(
                            content: Text("camGalleryPermission".tr()),
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
                    getUploadFile();
                  }
                },
              )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                bool storagePermission =
                    await PermissionsUtil.checkStoragePermission();
                if (!storagePermission) {
                  if (!context.mounted) return;
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return PopScope(
                        canPop: false,
                        child: AlertDialog(
                          content: Text("camGalleryPermission".tr()),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                Navigator.of(dialogContext).pop();
                                await openAppSettings();
                              },
                              child: Text("ok".tr()),
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  getUploadFile();
                }
              },
              child: Column(
                children: [
                  Image.asset(
                    AppAssets.fileUpload,
                    height: widget.height ?? 55,
                    width: widget.width ?? 55,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.85,
                      ),
                      child: Text(
                        widget.ownershipDocFlag == true
                            ? "Note: Please upload only .pdf file with sizes ranging from 5kB to 10MB."
                            : AppConstants.isLayoutPlot.toLowerCase() ==
                                    "L".toLowerCase()
                                ? "Note: Please upload only .pdf file with sizes ranging from 5kB to 20MB."
                                : "Note: Please upload only .pdf file with sizes ranging from 5kB to 5MB.",
                        style: TextStyle(color: Colors.blue.shade900),
                        maxLines: 2,
                        softWrap: true,
                        overflow:
                            TextOverflow.visible, // Ensures text wraps properly
                        textAlign: TextAlign.start, // Adjust as needed
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
