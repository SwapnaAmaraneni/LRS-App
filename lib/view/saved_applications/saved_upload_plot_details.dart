import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/app_input_textfield.dart';
import 'package:lrsofficer/res/reusable_widgets/checklist_question_tile_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/file_picker_component.dart';
import 'package:lrsofficer/res/reusable_widgets/image_picker_component.dart';
import 'package:lrsofficer/utils/file_path_check_utils.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/view_model/plots_layouts/upload_plot_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/shared_pref_constants.dart';

class SavedUploadPlotDetails extends StatefulWidget {
  const SavedUploadPlotDetails({super.key});

  @override
  State<SavedUploadPlotDetails> createState() => _SavedUploadPlotDetailsState();
}

class _SavedUploadPlotDetailsState extends State<SavedUploadPlotDetails> {
  List gridsData = [
    "plotImg1".tr(),
    "plotImg2".tr(),
    "plotImg3".tr(),
    "masterPlanExtract".tr(),
  ];

  Position? currentPosition;
  // List<dynamic> gisCoordinates = [];
  Uint8List? uint8list;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final uploadPlotDetailsProvider =
          Provider.of<UploadPlotDetailsViewModel>(context, listen: false);
      if (uploadPlotDetailsProvider.imagesString.isEmpty) {
        uploadPlotDetailsProvider.imagesString = List.generate(4, (index) => "");
      }
      uploadPlotDetailsProvider.setLoaderVisibleStatus(true);
      final locEnabled =
          await uploadPlotDetailsProvider.handleLocationPermission(context);
      if (locEnabled) {
        final currentPos = await Geolocator.getCurrentPosition(
          locationSettings:
              LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
        );
        bool isAnyDataPresent = uploadPlotDetailsProvider.imagesString.any((element) => element.isNotEmpty) ||
            (uploadPlotDetailsProvider.layoutSelectedDoc?.isNotEmpty ?? false) ||
            (uploadPlotDetailsProvider.ecSelectedDoc?.isNotEmpty ?? false) ||
            (uploadPlotDetailsProvider.ownershipSelectedDoc?.isNotEmpty ?? false) ||
            (uploadPlotDetailsProvider.layoutSelectedAnswer?.isNotEmpty ?? false) ||
            (uploadPlotDetailsProvider.ecDocSelectedAnswer?.isNotEmpty ?? false) ||
            (uploadPlotDetailsProvider.ownershipDocSelectedAnswer?.isNotEmpty ?? false);

        if (!isAnyDataPresent) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          uploadPlotDetailsProvider.layoutSelectedDoc =
              prefs.getString(SharedPrefConstants.layoutSelectedDocKey);
          uploadPlotDetailsProvider.ecSelectedDoc =
              prefs.getString(SharedPrefConstants.ecSelectedDocKey);
          uploadPlotDetailsProvider.ownershipSelectedDoc =
              prefs.getString(SharedPrefConstants.ownershipSelectedDocKey);

          uploadPlotDetailsProvider.imagesString[0] =
              prefs.getString(SharedPrefConstants.plot1Img) ?? "";

          uploadPlotDetailsProvider.imagesString[1] =
              prefs.getString(SharedPrefConstants.plot2Img) ?? "";

          uploadPlotDetailsProvider.imagesString[2] =
              prefs.getString(SharedPrefConstants.plot3Img) ?? "";

          uploadPlotDetailsProvider.imagesString[3] =
              prefs.getString(SharedPrefConstants.plot4ImgMasterPlanExt) ?? "";

          final layoutAns =
              prefs.getString(SharedPrefConstants.layoutDocumentradioVal);
          final ownerDocAns =
              prefs.getString(SharedPrefConstants.ownershipDocumetRadioVal);
          final ecDocAns =
              prefs.getString(SharedPrefConstants.ecDocumentRadioVal);
          if ((uploadPlotDetailsProvider.layoutSelectedDoc != null &&
                  uploadPlotDetailsProvider.layoutSelectedDoc != "") ||
              layoutAns?.toLowerCase() == "y") {
            uploadPlotDetailsProvider.layoutSelectedAnswer = "Y";
          } else if (layoutAns != null &&
              layoutAns != "" &&
              layoutAns.toLowerCase() == "n") {
            uploadPlotDetailsProvider.layoutSelectedAnswer = "N";
          }
          if ((uploadPlotDetailsProvider.ecSelectedDoc != null &&
                  uploadPlotDetailsProvider.ecSelectedDoc != "") ||
              ecDocAns?.toLowerCase() == "y") {
            uploadPlotDetailsProvider.ecDocSelectedAnswer = "Y";
          } else if (ecDocAns != null &&
              ecDocAns != "" &&
              ecDocAns.toLowerCase() == "n") {
            uploadPlotDetailsProvider.ecDocSelectedAnswer = "N";
          }
          if ((uploadPlotDetailsProvider.ownershipSelectedDoc != null &&
                  uploadPlotDetailsProvider.ownershipSelectedDoc != "") ||
              ownerDocAns?.toLowerCase() == "y") {
            uploadPlotDetailsProvider.ownershipDocSelectedAnswer = "Y";
          } else if (ownerDocAns != null &&
              ownerDocAns != "" &&
              ownerDocAns.toLowerCase() == "n") {
            uploadPlotDetailsProvider.ownershipDocSelectedAnswer = "N";
          }
        }
        currentPosition = currentPos;
        uploadPlotDetailsProvider.setLoaderVisibleStatus(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final uploadPlotDetailsProvider =
        Provider.of<UploadPlotDetailsViewModel>(context);
    final imgLoader = Provider.of<ImagePickerLoader>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: "Plot Details Upload",
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.appBg),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          QuestionTile(
                            question: "Do you want to upload Layout Document?",
                            selectedAnswer: uploadPlotDetailsProvider
                                    .layoutSelectedAnswer ??
                                "",
                            onChanged: (answer) {
                              setState(() {
                                uploadPlotDetailsProvider.layoutSelectedAnswer =
                                    answer;
                                // SharedPrefConstants.layoutDocumentradioVal = layoutSelectedAnswer;
                              });
                            },
                          ),
                          uploadPlotDetailsProvider.layoutSelectedAnswer
                                          ?.toLowerCase() ==
                                      "y" ||
                                  uploadPlotDetailsProvider.layoutSelectedAnswer
                                          ?.toLowerCase() ==
                                      "yes"
                              ? Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FilePickerComponent(
                                              filepath: getNormalizedPath(
                                                  uploadPlotDetailsProvider
                                                      .layoutSelectedDoc),
                                              callbackValue: (File file) {
                                                uploadPlotDetailsProvider
                                                        .layoutSelectedDoc =
                                                    file.path;
                                              },
                                            ),
                                            const Text(
                                              "*",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          QuestionTile(
                            question:
                                "Do you want to upload ownership Document?",
                            selectedAnswer: uploadPlotDetailsProvider
                                    .ownershipDocSelectedAnswer ??
                                "",
                            onChanged: (answer) {
                              setState(() {
                                uploadPlotDetailsProvider
                                    .ownershipDocSelectedAnswer = answer;
                              });
                            },
                          ),
                          uploadPlotDetailsProvider.ownershipDocSelectedAnswer
                                          ?.toLowerCase() ==
                                      "y" ||
                                  uploadPlotDetailsProvider
                                          .ownershipDocSelectedAnswer
                                          ?.toLowerCase() ==
                                      "yes"
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FilePickerComponent(
                                          ownershipDocFlag: true,
                                          filepath: getNormalizedPath(
                                              uploadPlotDetailsProvider
                                                  .ownershipSelectedDoc),
                                          callbackValue: (File file) {
                                            uploadPlotDetailsProvider
                                                    .ownershipSelectedDoc =
                                                file.path;
                                          },
                                        ),
                                        const Text(
                                          "*",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          QuestionTile(
                            question: "Do you want to upload EC Document?",
                            selectedAnswer:
                                uploadPlotDetailsProvider.ecDocSelectedAnswer ??
                                    "",
                            onChanged: (answer) {
                              setState(() {
                                uploadPlotDetailsProvider.ecDocSelectedAnswer =
                                    answer;
                              });
                            },
                          ),
                          uploadPlotDetailsProvider.ecDocSelectedAnswer
                                          ?.toLowerCase() ==
                                      "y" ||
                                  uploadPlotDetailsProvider.ecDocSelectedAnswer
                                          ?.toLowerCase() ==
                                      "yes"
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FilePickerComponent(
                                          filepath: getNormalizedPath(
                                              uploadPlotDetailsProvider
                                                  .ecSelectedDoc),
                                          callbackValue: (File file) {
                                            uploadPlotDetailsProvider
                                                .ecSelectedDoc = file.path;
                                          },
                                        ),
                                        const Text(
                                          "*",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    GridView.count(
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      shrinkWrap: true,
                      childAspectRatio: 1.0,
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(gridsData.length, (index) {
                        return Center(
                          child: Card(
                            child: gridItem(gridsData[index], index),
                          ),
                        );
                      }),
                    ),
                    (currentPosition?.latitude != null &&
                            currentPosition?.longitude != null)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AppInputTextfield(
                                      isReadOnly: true,
                                      hintText: "latitude".tr(),
                                      nameController: TextEditingController(
                                          text: "${currentPosition?.latitude}"),
                                      textColor: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Expanded(
                                    child: AppInputTextfield(
                                      isReadOnly: true,
                                      hintText: "longitude".tr(),
                                      nameController: TextEditingController(
                                          text:
                                              "${currentPosition?.longitude}"),
                                      textColor: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    ReusableButton(
                      buttonText: "next".tr(),
                      onPressed: () {
                        uploadPlotDetailsProvider.validationsForPlotDetails(
                            context: context,
                            layoutSelectedAnswer:
                                uploadPlotDetailsProvider.layoutSelectedAnswer,
                            captureLocScreenshot:
                                uploadPlotDetailsProvider.captureLocScreenshot,
                            ecDocSelectedAnswer:
                                uploadPlotDetailsProvider.ecDocSelectedAnswer,
                            ecSelectedDoc:
                                uploadPlotDetailsProvider.ecSelectedDoc,
                            images: uploadPlotDetailsProvider.imagesString,
                            layoutSelectedDoc:
                                uploadPlotDetailsProvider.layoutSelectedDoc,
                            ownershipDocSelectedAnswer:
                                uploadPlotDetailsProvider
                                    .ownershipDocSelectedAnswer,
                            ownershipSelectedDoc:
                                uploadPlotDetailsProvider.ownershipSelectedDoc,
                            latitude: "${currentPosition?.latitude}",
                            longitude: "${currentPosition?.longitude}");
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (uploadPlotDetailsProvider.getLoaderVisibilityStatus ||
            imgLoader.getImageLoader)
          const LoaderComponent()
      ],
    );
  }

  Widget gridItem(
    // IconData? icon,
    String label,
    int index,
  ) {
    final uploadPlotDetailsProvider =
        Provider.of<UploadPlotDetailsViewModel>(context, listen: false);
    if (!kReleaseMode)
      debugPrint(
          "$index Image::: ${uploadPlotDetailsProvider.imagesString[index]}");
    return ImageCaptureComponent(
        networkImg: uploadPlotDetailsProvider.imagesString[index],
        callbackValue: (XFile file) {
          uploadPlotDetailsProvider.imagesString[index] = file.path;
        },
        label: label);
  }
}
