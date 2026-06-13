import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/models/recommendation_details_response.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/dropdown_reusable.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_recommendations_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FifpRecommendations extends StatefulWidget {
  const FifpRecommendations({super.key});

  @override
  State<FifpRecommendations> createState() => _FifpRecommendationsState();
}

class _FifpRecommendationsState extends State<FifpRecommendations> {
  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode) debugPrint("UserType:: ${AppConstants.userType}");
    final recommendationsProvider =
        Provider.of<FifpRecommendationsViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarReusable(
            title: "Fee Paid Recommendations",
          ),
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: ExactAssetImage(AppAssets.appBgScreens),
                ),
              ),
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  if (recommendationsProvider
                      .recommendationListMasterPlans.isNotEmpty)
                    DropdownReusable<RecommendationsListMasterPlans>(
                      width: MediaQuery.of(context).size.width * 0.95,
                      label: 'Recommendations *',
                      items: recommendationsProvider
                          .recommendationListMasterPlans
                          .map<
                              DropdownMenuItem<RecommendationsListMasterPlans>>(
                        (RecommendationsListMasterPlans item) {
                          return DropdownMenuItem<
                              RecommendationsListMasterPlans>(
                            value: item,
                            child: Text(
                              item.recommendation ?? "",
                              overflow: TextOverflow.visible,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (RecommendationsListMasterPlans? value) {
                        recommendationsProvider.setDropdownValue(value);
                      },
                      selectedValue:
                          recommendationsProvider.selectedRecommendationValue,
                      isEnabled: true,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 90,
                          child: Text(
                            'Remarks *',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: TextField(
                            maxLines: 5,
                            maxLength: 4000,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[A-Za-z0-9 .\/@()_,-]{0,4000}')),
                            ],
                            cursorColor: AppColors.appBarColor,
                            controller:
                                recommendationsProvider.remarksController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(6.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.appBarColor),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.appBarColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      /*if (AppConstants.userType.toLowerCase() == "tp")
                        Visibility(
                          visible: (AppConstants.isSavedApplication != "yes"),
                          child: Flexible(
                            flex: 2,
                            child: Center(
                              child: ReusableButton(
                                buttonText: "Save",
                                onPressed: () {
                                  WarningCustomCupertinoAlertTwoButtons()
                                      .showAlert(
                                    context,
                                    message: "Are you sure you want to save?",
                                    onPressedOk: () {
                                      Navigator.pop(context);
                                      recommendationsProvider.finalSaveMethod(
                                          context, remarksController.text);
                                    },
                                    onPressedCancel: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ), */
                      Flexible(
                        flex: 2,
                        child: Center(
                          child: ReusableButton(
                            buttonText: "Final Submit",
                            onPressed: () {
                              recommendationsProvider.finalSubmitMethod(
                                  context,
                                  recommendationsProvider
                                      .remarksController.text);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (recommendationsProvider.getLoaderVisibilityStatus)
          const LoaderComponent()
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final recommendationsProvider =
          Provider.of<FifpRecommendationsViewModel>(context, listen: false);
      await recommendationsProvider.getRecommendationsDetails(context);
      if (AppConstants.isSavedApplication == "yes") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final approvalFlag =
            prefs.getString(SharedPrefConstants.recommendationsKey);
        final savedRemarks = prefs.getString(SharedPrefConstants.notesKey);
        final recommendation =
            recommendationsProvider.recommendationListMasterPlans.firstWhere(
          (element) => element.recommendation == approvalFlag,
          orElse: () => recommendationsProvider.recommendationListMasterPlans[0],
        );
        recommendationsProvider.setDropdownValue(recommendation);
        recommendationsProvider.remarksController.text =
            recommendationsProvider.remarksController.text.isNotEmpty
                ? recommendationsProvider.remarksController.text
                : savedRemarks ?? "";
      }
    });
  }
}
