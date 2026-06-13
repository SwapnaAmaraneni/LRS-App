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
import 'package:lrsofficer/view_model/phase1_view_models/phase1_upload_plot_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/shared_pref_constants.dart';

class Phase1UploadPlotDetails extends StatefulWidget {
  const Phase1UploadPlotDetails({super.key});

  @override
  State<Phase1UploadPlotDetails> createState() =>
      _Phase1UploadPlotDetailsState();
}

class _Phase1UploadPlotDetailsState extends State<Phase1UploadPlotDetails> {
  List gridsData = [
    "plotImg1".tr(),
    "plotImg2".tr(),
    "plotImg3".tr(),
    "masterPlanExtract".tr(),
  ];
  List<String> imagesString = [];
  Position? currentPosition;
  // List<dynamic> gisCoordinates = [];
  Uint8List? uint8list;

  String? layoutSelectedAnswer = "";
  String? layoutSelectedDoc;
  String? ownershipDocSelectedAnswer = "";
  String? ownershipSelectedDoc;
  String? ecDocSelectedAnswer = "";
  String? ecSelectedDoc;
  String? captureLocScreenshot;
  final urlPattern = r'^(http|https):\/\/([\w.]+\/?)\S*';
  @override
  void initState() {
    super.initState();
    imagesString = List.generate(4, (index) => "");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final uploadPlotDetailsProvider =
          Provider.of<Phase1UploadPlotDetailsViewModel>(context, listen: false);
      uploadPlotDetailsProvider.setLoaderVisibleStatus(true);
      final locEnabled =
          await uploadPlotDetailsProvider.handleLocationPermission(context);
      if (locEnabled) {
        final currentPos = await Geolocator.getCurrentPosition(
          locationSettings:
              LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        layoutSelectedDoc =
            prefs.getString(SharedPrefConstants.layoutSelectedDocKey);
        ecSelectedDoc = prefs.getString(SharedPrefConstants.ecSelectedDocKey);
        ownershipSelectedDoc =
            prefs.getString(SharedPrefConstants.ownershipSelectedDocKey);
        imagesString[0] = prefs.getString(SharedPrefConstants.plot1Img) ?? "";
        imagesString[1] = prefs.getString(SharedPrefConstants.plot2Img) ?? "";
        imagesString[2] = prefs.getString(SharedPrefConstants.plot3Img) ?? "";
        imagesString[3] =
            prefs.getString(SharedPrefConstants.plot4ImgMasterPlanExt) ?? "";
        final layoutAns =
            prefs.getString(SharedPrefConstants.layoutDocumentradioVal);
        final ownerDocAns =
            prefs.getString(SharedPrefConstants.ownershipDocumetRadioVal);
        final ecDocAns =
            prefs.getString(SharedPrefConstants.ecDocumentRadioVal);
        if ((layoutSelectedDoc != null && layoutSelectedDoc != "") ||
            layoutAns?.toLowerCase() == "y") {
          layoutSelectedAnswer = "Y";
        } else if (layoutAns != null &&
            layoutAns != "" &&
            layoutAns.toLowerCase() == "n") {
          layoutSelectedAnswer = "N";
        }
        if ((ecSelectedDoc != null && ecSelectedDoc != "") ||
            ecDocAns?.toLowerCase() == "y") {
          ecDocSelectedAnswer = "Y";
        } else if (ecDocAns != null &&
            ecDocAns != "" &&
            ecDocAns.toLowerCase() == "n") {
          ecDocSelectedAnswer = "N";
        }
        if ((ownershipSelectedDoc != null && ownershipSelectedDoc != "") ||
            ownerDocAns?.toLowerCase() == "y") {
          ownershipDocSelectedAnswer = "Y";
        } else if (ownerDocAns != null &&
            ownerDocAns != "" &&
            ownerDocAns.toLowerCase() == "n") {
          ownershipDocSelectedAnswer = "N";
        }
        currentPosition = currentPos;
        uploadPlotDetailsProvider.setLoaderVisibleStatus(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final uploadPlotDetailsProvider =
        Provider.of<Phase1UploadPlotDetailsViewModel>(context);
    final imgLoader = Provider.of<ImagePickerLoader>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: "Phase-1 Plot Details Upload",
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
                            selectedAnswer: layoutSelectedAnswer ?? "",
                            onChanged: (answer) {
                              setState(() {
                                layoutSelectedAnswer = answer;
                                // SharedPrefConstants.layoutDocumentradioVal = layoutSelectedAnswer;
                              });
                            },
                          ),
                          layoutSelectedAnswer?.toLowerCase() == "y" ||
                                  layoutSelectedAnswer?.toLowerCase() == "yes"
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
                                                  layoutSelectedDoc),
                                              callbackValue: (File file) {
                                                layoutSelectedDoc = file.path;
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
                            selectedAnswer: ownershipDocSelectedAnswer ?? "",
                            onChanged: (answer) {
                              setState(() {
                                ownershipDocSelectedAnswer = answer;
                              });
                            },
                          ),
                          ownershipDocSelectedAnswer?.toLowerCase() == "y" ||
                                  ownershipDocSelectedAnswer?.toLowerCase() ==
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
                                          filepath: (RegExp(urlPattern,
                                                          caseSensitive: false)
                                                      .hasMatch(
                                                          ownershipSelectedDoc ??
                                                              "") ||
                                                  File(ownershipSelectedDoc ??
                                                          "")
                                                      .existsSync())
                                              ? ownershipSelectedDoc
                                              : "",
                                          callbackValue: (File file) {
                                            ownershipSelectedDoc = file.path;
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
                            selectedAnswer: ecDocSelectedAnswer ?? "",
                            onChanged: (answer) {
                              setState(() {
                                ecDocSelectedAnswer = answer;
                              });
                            },
                          ),
                          ecDocSelectedAnswer?.toLowerCase() == "y" ||
                                  ecDocSelectedAnswer?.toLowerCase() == "yes"
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FilePickerComponent(
                                          filepath: (RegExp(urlPattern,
                                                          caseSensitive: false)
                                                      .hasMatch(ecSelectedDoc ??
                                                          "") ||
                                                  File(ecSelectedDoc ?? "")
                                                      .existsSync())
                                              ? ecSelectedDoc
                                              : "",
                                          callbackValue: (File file) {
                                            ecSelectedDoc = file.path;
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
                            layoutSelectedAnswer: layoutSelectedAnswer,
                            captureLocScreenshot: captureLocScreenshot,
                            ecDocSelectedAnswer: ecDocSelectedAnswer,
                            ecSelectedDoc: ecSelectedDoc,
                            images: imagesString,
                            layoutSelectedDoc: layoutSelectedDoc,
                            ownershipDocSelectedAnswer:
                                ownershipDocSelectedAnswer,
                            ownershipSelectedDoc: ownershipSelectedDoc,
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
    if (!kReleaseMode) debugPrint("$index Image::: ${imagesString[index]}");
    return ImageCaptureComponent(
        networkImg: imagesString[index],
        callbackValue: (XFile file) {
          imagesString[index] = file.path;
        },
        label: label);
  }
}
