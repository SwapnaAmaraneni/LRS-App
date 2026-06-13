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
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_upload_plot_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/shared_pref_constants.dart';

class ProhibitedUploadPlotDetails extends StatefulWidget {
  const ProhibitedUploadPlotDetails({super.key});

  @override
  State<ProhibitedUploadPlotDetails> createState() =>
      _ProhibitedUploadPlotDetailsState();
}

class _ProhibitedUploadPlotDetailsState
    extends State<ProhibitedUploadPlotDetails> {
  List gridsData = [
    "plotImg1".tr(),
    "plotImg2".tr(),
    "plotImg3".tr(),
    "masterPlanExtract".tr(),
  ];

  // currentPosition is GPS data – always re-fetched, kept local
  Position? currentPosition;
  Uint8List? uint8list;
  final urlPattern = r'^(http|https):\/\/([\w.]+\/?)\\S*';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final provider = Provider.of<ProhibitedUploadPlotDetailsViewModel>(
          context,
          listen: false);

      provider.setLoaderVisibleStatus(true);
      final locEnabled =
          await provider.handleLocationPermission(context);
      if (locEnabled) {
        final currentPos = await Geolocator.getCurrentPosition(
          locationSettings:
              LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
        );

        // Only restore from SharedPreferences if not yet initialized
        if (!provider.isInitialized) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          provider.layoutSelectedDoc =
              prefs.getString(SharedPrefConstants.layoutSelectedDocKey);
          provider.ecSelectedDoc =
              prefs.getString(SharedPrefConstants.ecSelectedDocKey);
          provider.ownershipSelectedDoc =
              prefs.getString(SharedPrefConstants.ownershipSelectedDocKey);

          provider.imagesString[0] =
              prefs.getString(SharedPrefConstants.plot1Img) ?? "";
          provider.imagesString[1] =
              prefs.getString(SharedPrefConstants.plot2Img) ?? "";
          provider.imagesString[2] =
              prefs.getString(SharedPrefConstants.plot3Img) ?? "";
          provider.imagesString[3] =
              prefs.getString(SharedPrefConstants.plot4ImgMasterPlanExt) ?? "";

          final layoutAns =
              prefs.getString(SharedPrefConstants.layoutDocumentradioVal);
          final ownerDocAns =
              prefs.getString(SharedPrefConstants.ownershipDocumetRadioVal);
          final ecDocAns =
              prefs.getString(SharedPrefConstants.ecDocumentRadioVal);

          if ((provider.layoutSelectedDoc != null &&
                  provider.layoutSelectedDoc != "") ||
              layoutAns?.toLowerCase() == "y") {
            provider.layoutSelectedAnswer = "Y";
          } else if (layoutAns != null &&
              layoutAns != "" &&
              layoutAns.toLowerCase() == "n") {
            provider.layoutSelectedAnswer = "N";
          }

          if ((provider.ecSelectedDoc != null &&
                  provider.ecSelectedDoc != "") ||
              ecDocAns?.toLowerCase() == "y") {
            provider.ecDocSelectedAnswer = "Y";
          } else if (ecDocAns != null &&
              ecDocAns != "" &&
              ecDocAns.toLowerCase() == "n") {
            provider.ecDocSelectedAnswer = "N";
          }

          if ((provider.ownershipSelectedDoc != null &&
                  provider.ownershipSelectedDoc != "") ||
              ownerDocAns?.toLowerCase() == "y") {
            provider.ownershipDocSelectedAnswer = "Y";
          } else if (ownerDocAns != null &&
              ownerDocAns != "" &&
              ownerDocAns.toLowerCase() == "n") {
            provider.ownershipDocSelectedAnswer = "N";
          }

          provider.isInitialized = true;
        }

        if (mounted) {
          setState(() {
            currentPosition = currentPos;
          });
        }
        provider.setLoaderVisibleStatus(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final uploadPlotDetailsProvider =
        Provider.of<ProhibitedUploadPlotDetailsViewModel>(context);
    final imgLoader = Provider.of<ImagePickerLoader>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: "Prohibited Plot Details Upload",
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
                            selectedAnswer:
                                uploadPlotDetailsProvider.layoutSelectedAnswer,
                            onChanged: (answer) {
                              uploadPlotDetailsProvider
                                  .setLayoutSelectedAnswer(answer);
                            },
                          ),
                          uploadPlotDetailsProvider.layoutSelectedAnswer
                                          .toLowerCase() ==
                                      "y" ||
                                  uploadPlotDetailsProvider.layoutSelectedAnswer
                                          .toLowerCase() ==
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
                                                    .setLayoutSelectedDoc(
                                                        file.path);
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
                                .ownershipDocSelectedAnswer,
                            onChanged: (answer) {
                              uploadPlotDetailsProvider
                                  .setOwnershipDocSelectedAnswer(answer);
                            },
                          ),
                          uploadPlotDetailsProvider.ownershipDocSelectedAnswer
                                          .toLowerCase() ==
                                      "y" ||
                                  uploadPlotDetailsProvider
                                          .ownershipDocSelectedAnswer
                                          .toLowerCase() ==
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
                                                .setOwnershipSelectedDoc(
                                                    file.path);
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
                                uploadPlotDetailsProvider.ecDocSelectedAnswer,
                            onChanged: (answer) {
                              uploadPlotDetailsProvider
                                  .setEcDocSelectedAnswer(answer);
                            },
                          ),
                          uploadPlotDetailsProvider.ecDocSelectedAnswer
                                          .toLowerCase() ==
                                      "y" ||
                                  uploadPlotDetailsProvider.ecDocSelectedAnswer
                                          .toLowerCase() ==
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
                                                .setEcSelectedDoc(file.path);
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
                            child: gridItem(
                                uploadPlotDetailsProvider, gridsData[index], index),
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
                            ownershipDocSelectedAnswer: uploadPlotDetailsProvider
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
    ProhibitedUploadPlotDetailsViewModel provider,
    String label,
    int index,
  ) {
    if (!kReleaseMode) {
      debugPrint("$index Image::: ${provider.imagesString[index]}");
    }
    return ImageCaptureComponent(
        networkImg: provider.imagesString[index],
        callbackValue: (XFile file) {
          provider.setImage(index, file.path);
        },
        label: label);
  }
}
