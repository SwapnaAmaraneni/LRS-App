import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_success_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_warning_alert.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class DocumentDownload extends StatefulWidget {
  const DocumentDownload({
    super.key,
    required this.sroEditFlag,
    required this.callbackValue,
  });
  final String sroEditFlag;
  final void Function(
    bool,
  ) callbackValue;

  @override
  State<DocumentDownload> createState() => _DocumentDownloadState();
}

class _DocumentDownloadState extends State<DocumentDownload> {
  String sroCode = "";
  String initialSroCode = "";
  String saleDeedNo = "";
  String saleDeedyear = "";
  String applicationNo = "";
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      /* final documentDownloadProvider =
          Provider.of<DocumentDownloadViewModel>(context, listen: false); */
      documentDownloadProvider.setLoaderVisibleStatus(true);
      final sroCodePrefs = documentDownloadProvider
              .sroCodeController.text.isNotEmpty
          ? documentDownloadProvider.sroCodeController.text
          : await LocalStoreHelper().readTheData(SharedPrefConstants.sroCode);
      final saleDeedNoPrefs =
          await LocalStoreHelper().readTheData(SharedPrefConstants.saleDeedNo);
      final saleDeedyearPrefs = await LocalStoreHelper()
          .readTheData(SharedPrefConstants.saleDeedYear);
      final applicationNoPrefs = await LocalStoreHelper()
          .readTheData(SharedPrefConstants.applicationNo);

      AppLogger().logDebug("Application No: $applicationNoPrefs");
      setState(() {
        sroCode = sroCodePrefs ?? "0";
        initialSroCode = sroCodePrefs ?? "0";
        saleDeedNo = saleDeedNoPrefs ?? "0";
        saleDeedyear = saleDeedyearPrefs ?? "0";
        applicationNo = "$applicationNoPrefs".replaceAll("/", "_");
        documentDownloadProvider.sroCodeController.text =
            sroCode; // Initialize the text field
      });

      AppLogger().logDebug(
          "applicationNo after replace $sroCode, $saleDeedNo, $saleDeedyear");
      documentDownloadProvider.setLoaderVisibleStatus(false);
    });

    // Add a listener to handle changes in sroCode
    documentDownloadProvider.sroCodeController.addListener(() {
      setState(() {
        sroCode = documentDownloadProvider.sroCodeController.text;
      });
      if (initialSroCode != sroCode) {
        isChanged = true;
        widget.callbackValue(isChanged);
      } else {
        isChanged = false;
        widget.callbackValue(isChanged);
      }

      onSroCodeChanged(sroCode);
    });
  }

  // Callback method for sroCode changes
  Future<void> onSroCodeChanged(String newSroCode) async {
    AppLogger().logDebug("SRO Code changed: $newSroCode");
    await LocalStoreHelper().writeData(SharedPrefConstants.sroCode, newSroCode);
  }

  @override
  void dispose() {
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context, listen: false);
    documentDownloadProvider.sroCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode) debugPrint("Edit Flag SRO-Code:: ${widget.sroEditFlag}");
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text(
                      'SRO Code \n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 120,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border: widget.sroEditFlag.toLowerCase() == "true"
                          ? Border.all(color: AppColors.appBarColor)
                          : null,
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLength: 4,
                            readOnly:
                                widget.sroEditFlag.toLowerCase() != "true",
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.numberWithOptions(),
                            controller:
                                documentDownloadProvider.sroCodeController,
                            textAlign: TextAlign.center,
                            onEditingComplete: () {
                              if (widget.sroEditFlag.toLowerCase() == "true" &&
                                  documentDownloadProvider
                                          .sroCodeController.text.length !=
                                      4 &&
                                  initialSroCode != sroCode) {
                                ErrorCustomCupertinoAlert().showAlert(context,
                                    message: "Please enter 4 digit SRO Code");
                              } else {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            decoration: InputDecoration(
                              counterText: "", // Hide the counter text
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            style: const TextStyle(fontSize: 15.0),
                          ),
                        ),
                        if (widget.sroEditFlag.toLowerCase() == "true")
                          Icon(
                            Icons.edit_note_outlined,
                            color: Colors.black54,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text('Sale Deed \nNumber',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    width: 120,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        saleDeedNo,
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text('Sale Deed \nYear',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    width: 120,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        saleDeedyear, // Text to display
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        (sroCode.isNotEmpty &&
                saleDeedNo.isNotEmpty &&
                saleDeedyear.isNotEmpty &&
                (sroCode != "0" || saleDeedNo != "0" || saleDeedyear != "0"))
            ? Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      documentDownloadProvider.setLoaderVisibleStatus(true);
                      if (!mounted) return;
                      if (sroCode.isNotEmpty &&
                          saleDeedNo.isNotEmpty &&
                          saleDeedyear.isNotEmpty &&
                          (sroCode != "0" ||
                              saleDeedNo != "0" ||
                              saleDeedyear != "0")) {
                        if (initialSroCode != sroCode && sroCode.length != 4) {
                          documentDownloadProvider
                              .setLoaderVisibleStatus(false);
                          ErrorCustomCupertinoAlert().showAlert(context,
                              message: "Please Enter valid SRO Code");
                        } else {
                          await documentDownloadProvider.docVM(context,
                              sroCode: sroCode,
                              saleDeedNo: saleDeedNo,
                              saleDeedyear: saleDeedyear);
                          if (documentDownloadProvider.result?.pdfBas64 !=
                                  null &&
                              (documentDownloadProvider.result?.pdfBas64 ?? "")
                                  .isNotEmpty) {
                            _convertBase64ToFile(
                              documentDownloadProvider.result?.pdfBas64
                                  .toString(),
                              'IGRS_$applicationNo.pdf',
                            );
                          }
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Text(
                        "Document Download",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Note: The sale deed document is downloaded from registration department API',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  Future<void> _convertBase64ToFile(
      String? base64String, String fileName) async {
    final documentDownloadProvider =
        Provider.of<DocumentDownloadViewModel>(context, listen: false);
    try {
      Uint8List bytes = base64Decode(base64String!);
      Directory? externalDir;

      if (Platform.isIOS) {
        externalDir = await getApplicationDocumentsDirectory();

        AppLogger()
            .logDebug("External Storage Directory ios: ${externalDir.path}");
      } else {
        externalDir = Directory('/storage/emulated/0/Download');

        AppLogger().logDebug("External Storage Directory: ${externalDir.path}");
      }

      if (Platform.isAndroid) {
        final plugin = DeviceInfoPlugin();
        final android = await plugin.androidInfo;

        AppLogger().logDebug("Android Version: ${android.version.sdkInt}");

        PermissionStatus status = android.version.sdkInt < 33
            ? await Permission.storage.request()
            : PermissionStatus.granted;

        if (status.isGranted) {
          String filePath =
              await _getUniqueFilePath(externalDir.path, fileName);
          await File(filePath).writeAsBytes(bytes);
          if (!mounted) return;
          documentDownloadProvider.setLoaderVisibleStatus(false);
          SuccessCustomCupertinoAlert().showAlert(
              context: context,
              title:
                  "Document downloaded successfully into Storage > Download > $fileName",
              onPressed: () {
                Navigator.pop(context);
              });

          AppLogger().logDebug("File saved to: $filePath");
        } else {
          documentDownloadProvider.setLoaderVisibleStatus(false);
          if (!mounted) return;
          WarningCustomCupertinoAlert().showAlert(context,
              message:
                  "Please allow storage permission to download the document",
              onPressed: () {
            Navigator.pop(context);
          });
        }
      } else {
        PermissionStatus status = await Permission.storage.request();
        if (status.isGranted) {
          String filePath =
              await _getUniqueFilePath(externalDir.path, fileName);
          await File(filePath).writeAsBytes(bytes);
          final params = ShareParams(files: [XFile(filePath)]);
          final result = await SharePlus.instance.share(params);
          if (result.status == ShareResultStatus.success) {
            documentDownloadProvider.setLoaderVisibleStatus(false);
            if (!mounted) return;
            SuccessCustomCupertinoAlert().showAlert(
                context: context,
                title: "Document downloaded successfully",
                onPressed: () {
                  Navigator.pop(context);
                });
          } else {
            documentDownloadProvider.setLoaderVisibleStatus(false);
            if (!mounted) return;
            ErrorCustomCupertinoAlert().showAlert(context,
                message: "Error in sharing/downloading the document",
                onPressed: () {
              Navigator.pop(context);
            });
          }
          if (!mounted) return;

          AppLogger().logDebug("File saved to: $filePath");
        } else {
          documentDownloadProvider.setLoaderVisibleStatus(false);
          if (!mounted) return;
          WarningCustomCupertinoAlert().showAlert(context,
              message:
                  "Please allow storage permission to download the document",
              onPressed: () {
            Navigator.pop(context);
          });
        }
      }
    } catch (e) {
      documentDownloadProvider.setLoaderVisibleStatus(false);
      ErrorCustomCupertinoAlert().showAlert(context,
          message: "Error in downloading the document", onPressed: () {
        Navigator.pop(context);
      });
    }
  }

  Future<String> _getUniqueFilePath(String directory, String fileName) async {
    String filePath = '$directory/$fileName';
    int count = 1;
    while (await File(filePath).exists()) {
      final name = fileName.split('.').first;
      final extension = fileName.split('.').last;
      filePath = '$directory/$name($count).$extension';
      count++;
    }
    return filePath;
  }
}
