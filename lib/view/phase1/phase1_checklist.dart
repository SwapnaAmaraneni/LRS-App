import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/models/check_details_optionssaved.dart';
import 'package:lrsofficer/models/check_details_response.dart';
import 'package:lrsofficer/models/questionare_dropdown_response.dart';
import 'package:lrsofficer/models/saved_applications/saved_application_details_response.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/checklist_question_tile_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/dropdown_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/file_picker_component.dart';
import 'package:lrsofficer/utils/file_path_check_utils.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_check_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phase1Checklist extends StatefulWidget {
  const Phase1Checklist({super.key});

  @override
  State<Phase1Checklist> createState() => _Phase1ChecklistState();
}

class _Phase1ChecklistState extends State<Phase1Checklist> {
  List<ListSaveData> checkList = [];
  List<TextEditingController> remarksControllers = [];
  final urlPattern = r'^(http|https):\/\/([\w.]+\/?)\S*';

  @override
  Widget build(BuildContext context) {
    final checkDetailsProvider =
        Provider.of<Phase1CheckDetailsViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarReusable(
            title: "Phase-1 Check Details",
          ),
          body: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.appBgScreens),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        if (checkDetailsProvider.applications.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: checkDetailsProvider.applications.length,
                            itemBuilder: (context, index) {
                              ListMasterPlans applicationsData =
                                  checkDetailsProvider.applications[index];
                              QuestionnaireResponse quesResponse =
                                  checkDetailsProvider.responses.firstWhere(
                                (element) =>
                                    element.sno == applicationsData.sNO,
                                orElse: () => QuestionnaireResponse(sno: ''),
                              );
                              List<QuesDROPDOWNs> dropdownItems =
                                  checkDetailsProvider
                                          .dROPDOWNs[applicationsData.sNO] ??
                                      [];
                              QuesDROPDOWNs selectedDropdownAnswer =
                                  QuesDROPDOWNs();
                              String pickedFile = "";
                              //dropdown selected value
                              if (applicationsData.iSDROPDOWN == "Y" &&
                                  dropdownItems.isNotEmpty) {
                                selectedDropdownAnswer =
                                    dropdownItems.firstWhere(
                                  (element) =>
                                      element.dDLID ==
                                      quesResponse.checkDRopDown,
                                  orElse: () => dropdownItems.isNotEmpty
                                      ? dropdownItems.first
                                      : QuesDROPDOWNs(),
                                );
                                quesResponse.checkDRopDown ?? '';
                              }
                              if (applicationsData.iSUPLOAD == "Y") {
                                pickedFile = quesResponse.document ?? '';
                              }
                              if (quesResponse.selectedAnswer == "Y" &&
                                  applicationsData.iSREMARKS == "Y" &&
                                  remarksControllers.isNotEmpty) {
                                remarksControllers[index].text =
                                    quesResponse.remarks ?? "";
                              }

                              if (!kReleaseMode) {
                                debugPrint(
                                    "remarks Ans :: ${quesResponse.remarks}");
                              }
                              return Column(
                                children: [
                                  QuestionTile(
                                    question:
                                        applicationsData.pLOTQUESTIONARY ?? "",
                                    sno: (index + 1).toString(),
                                    selectedAnswer:
                                        quesResponse.selectedAnswer ?? '',
                                    onChanged: (answer) async {
                                      //clear values on clicking no
                                      if (answer == "N") {
                                        checkDetailsProvider
                                            .clearDropdownTextfieldAndPDf(
                                                applicationsData.sNO);
                                      }
                                      checkDetailsProvider.updateAnswer(
                                          applicationsData.sNO, answer);
                                      if (applicationsData.iSDROPDOWN == "Y" &&
                                          answer == "Y") {
                                        await checkDetailsProvider
                                            .getDropdownValues(context,
                                                applicationsData.sNO ?? "");
                                      }
                                    },
                                  ),
                                  if (quesResponse.selectedAnswer == "Y" &&
                                      applicationsData.iSREMARKS == "Y" &&
                                      remarksControllers.isNotEmpty)
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: TextField(
                                        controller: remarksControllers[index],
                                        maxLines: null,
                                        maxLength: 300,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp(
                                              r'^[A-Za-z0-9 .\/@()_,-]{0,300}'))
                                        ],
                                        textInputAction: TextInputAction.done,
                                        onChanged: (value) {
                                          checkDetailsProvider.updateRemarks(
                                              applicationsData.sNO, value);
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(8.0),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: AppColors.appBarColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: AppColors.appBarColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: AppColors.appBarColor),
                                          ),
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          labelText: "Remarks *",
                                        ),
                                        style: const TextStyle(
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                  if (quesResponse.selectedAnswer == "Y" &&
                                      applicationsData.iSDROPDOWN == "Y" &&
                                      (dropdownItems).isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: DropdownReusable<QuesDROPDOWNs>(
                                        items: dropdownItems.map<
                                            DropdownMenuItem<QuesDROPDOWNs>>(
                                          (QuesDROPDOWNs item) {
                                            return DropdownMenuItem<
                                                QuesDROPDOWNs>(
                                              value: item,
                                              child: Text(
                                                item.dDLNAME ?? "",
                                                overflow: TextOverflow.visible,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                        onChanged: (QuesDROPDOWNs? value) {
                                          checkDetailsProvider
                                              .updateDropdownAnswer(
                                                  applicationsData.sNO ?? "",
                                                  value?.dDLID ?? "");
                                        },
                                        selectedValue:
                                            selectedDropdownAnswer.dDLID == null
                                                ? null
                                                : selectedDropdownAnswer,
                                        isEnabled: true,
                                      ),
                                    ),
                                  if (quesResponse.selectedAnswer == "Y" &&
                                      applicationsData.iSUPLOAD == "Y")
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              BorderSide.strokeAlignCenter),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: FilePickerComponent(
                                                  filepath: getNormalizedPath(
                                                      pickedFile),
                                                  callbackValue: (File file) {
                                                    pickedFile = file.path;
                                                    checkDetailsProvider
                                                        .updateDocPath(
                                                            pickedFile,
                                                            applicationsData
                                                                    .sNO ??
                                                                "@");
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              );
                            },
                          ),
                        /*  const Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: DocumentDownload(
                                            sroEditFlag:
                                                        .sroCodeEdit ??
                                                    ""
                                                layoutClusterwiseApplDetailsProvider
                                                        .clusterApplDetails[0]
                                                        .sroCodeEdit ??
                                                    ""),
                          ),
                        ), */
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ReusableButton(
              buttonText: "Next".tr(),
              onPressed: () {
                checkDetailsProvider.submit(context);
              },
            ),
          ),
        ),
        if (checkDetailsProvider.getLoaderVisibilityStatus)
          const LoaderComponent()
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final checkDetailsProvider =
          Provider.of<Phase1CheckDetailsViewModel>(context, listen: false);
      checkDetailsProvider.responses.clear();
      await checkDetailsProvider.checkDetailsViewModel(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? checkListString =
          prefs.getString(SharedPrefConstants.checkListKey);
      final List<dynamic> checkListJson =
          (checkListString != null && checkListString != "")
              ? jsonDecode(checkListString)
              : [];
      checkList.addAll(checkListJson
          .map((checkListMap) => ListSaveData.fromJson(checkListMap))
          .toList());
      remarksControllers.addAll(List.generate(
        checkDetailsProvider.applications.length,
        (index) => TextEditingController(),
      ));
      if (!kReleaseMode) {
        debugPrint("remarks length::  ${remarksControllers.length}");
      }
      for (var element in checkList) {
        if (element.sUBCHECKID != null && element.sTATUSID == "Y") {
          if (!mounted) return;
          await checkDetailsProvider.getDropdownValues(
              context, element.cHECKLISTID ?? "");
        }
        checkDetailsProvider.responses.add(QuestionnaireResponse(
            sno: element.cHECKLISTID,
            checkDRopDown: element.sUBCHECKID,
            document: element.cHECKDOC,
            remarks: element.rEMARKS,
            selectedAnswer: element.sTATUSID));
      }
    });
  }
}
