import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/models/global_search/global_search_masters_response.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/checklist_question_tile_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/dropdown_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/officer_approval_status_reusable_widget.dart';
import 'package:lrsofficer/res/reusable_widgets/textformfield_reusable.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/view/global_search/view_officer_details_dialog.dart';
import 'package:lrsofficer/view_model/global_search_view_model.dart';
import 'package:provider/provider.dart';

class GlobalSearchView extends StatefulWidget {
  const GlobalSearchView({super.key});

  @override
  State<GlobalSearchView> createState() => _GlobalSearchViewState();
}

class _GlobalSearchViewState extends State<GlobalSearchView> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<GlobalSearchViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.clearAll();
      provider.globalSearchMastersService(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalSearchViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBarReusable(
            title: "Application Details Search",
          ),
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.appBg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header Section
                            Container(
                              padding: EdgeInsets.all(12),
                              color: Colors.teal,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Icon(Icons.person, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text("Application Details Search",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            QuestionTile(
                              question:
                                  "Do you want to search with application number or other details? *",
                              selectedAnswer: provider.selectedSearchType,
                              onChanged: (value) {
                                provider.onSearchTypeChange(value);
                              },
                            ),
                            SizedBox(height: 5),
                            if (provider.selectedSearchType?.toLowerCase() ==
                                "y")
                              Column(
                                children: [
                                  TextFormfieldReusable(
                                    padding: EdgeInsets.all(0),
                                    controller:
                                        provider.applicationNoController,
                                    errorMessage: "",
                                    hintText: "Application Number*",
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[A-Za-z0-9/_ ]+')),
                                    ],
                                    textLength: 50,
                                  ),
                                ],
                              ),

                            // Dropdowns & Input Fields
                            if (provider.selectedSearchType?.toLowerCase() ==
                                "n")
                              Column(
                                children: [
                                  DropdownReusable<Districts>(
                                    label: "Select District *",
                                    selectedValue: provider.selectedDistrict,
                                    items: provider.dropdownDistricts
                                        .map<DropdownMenuItem<Districts>>(
                                      (Districts item) {
                                        return DropdownMenuItem<Districts>(
                                          value: item,
                                          child: Text(
                                            item.dISTRICTNAME ?? "",
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {
                                      provider.onChangeDistrict(value);
                                    },
                                    isEnabled: true,
                                  ),
                                  const SizedBox(height: 5),
                                  DropdownReusable<Mandals>(
                                    label: "Select Mandal *",
                                    selectedValue: provider.selectedMandal,
                                    items: provider.dropdownMandals
                                        .map<DropdownMenuItem<Mandals>>(
                                      (Mandals item) {
                                        return DropdownMenuItem<Mandals>(
                                          value: item,
                                          child: Text(
                                            item.mANDALNAME ?? "",
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {
                                      provider.onChangeMandal(value);
                                    },
                                    isEnabled: true,
                                  ),
                                  const SizedBox(height: 5),
                                  DropdownReusable<Villages>(
                                    label: "Select Village *",
                                    selectedValue: provider.selectedVillage,
                                    items: provider.dropdownVillages
                                        .map<DropdownMenuItem<Villages>>(
                                      (Villages item) {
                                        return DropdownMenuItem<Villages>(
                                          value: item,
                                          child: Text(
                                            item.vILLAGENAME ?? "",
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {
                                      provider.onChangeVillage(value);
                                    },
                                    isEnabled: true,
                                  ),
                                  SizedBox(height: 5),
                                  TextFormfieldReusable(
                                    padding: const EdgeInsets.only(top: 10),
                                    controller: provider.nameController,
                                    errorMessage: "",
                                    hintText: "Name *",
                                    textLength: 100,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[A-Za-z0-9 _\-\/]{0,100}'))
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  TextFormfieldReusable(
                                    padding: const EdgeInsets.only(top: 10),
                                    controller: provider.surveyNoController,
                                    errorMessage: "",
                                    hintText: "Survey No",
                                    textLength: 100,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[A-Za-z0-9 _\-\/]{0,100}'))
                                    ],
                                  ),
                                ],
                              ),
                            SizedBox(height: 10),

                            // Submit Button
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  await provider.globalSearchService(context);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    Colors.teal,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if ((provider.searchedData?.length ?? 0) != 0)
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Card(
                          elevation: 4,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.0),
                                width: double.infinity,
                                child: Text("Application Search Result",
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Divider(
                                height: 5,
                                thickness: 1,
                                color: Colors.teal,
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: provider.searchedData?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          buildLabelValueRow(
                                              'Application ID',
                                              provider.searchedData?[index]
                                                  .applicationId),
                                          buildLabelValueRow(
                                              'Layout Owner Name',
                                              provider.searchedData?[index]
                                                  .layoutownername),
                                          buildLabelValueRow(
                                              'Father/Husband Name',
                                              provider.searchedData?[index]
                                                  .fatherHusbandName),
                                          buildLabelValueRow(
                                              'Mobile Number',
                                              provider.searchedData?[index]
                                                  .ownermobilenumber),
                                          buildLabelValueRow(
                                              'Survey Number',
                                              provider.searchedData?[index]
                                                  .surveyNumber),
                                          buildLabelValueRow(
                                              'Plot No',
                                              provider
                                                  .searchedData?[index].plotNo),
                                          buildLabelValueRow(
                                              'Layout/Plot',
                                              provider.searchedData?[index]
                                                          .isLayoutPlot ==
                                                      'P'
                                                  ? 'Plot'
                                                  : 'Layout'),
                                          Divider(height: 24, thickness: 1),
                                          buildLabelValueRow(
                                              'Status',
                                              provider
                                                  .searchedData?[index].sTATUS),
                                          buildLabelValueRow(
                                              'Fee Status',
                                              provider.searchedData?[index]
                                                  .fEESTATUS),
                                          Align(
                                            alignment:
                                                AlignmentGeometry.bottomRight,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                await provider
                                                    .getOfficerList(context);
                                                if (!context.mounted) return;
                                                OfficerDetailsDialog.show(
                                                    context,
                                                    provider.officersList);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all<
                                                        Color>(
                                                  Colors.teal,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Text(
                                                  "viewOfficerDetails".tr(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
        if (provider.getLoaderVisibilityStatus) LoaderComponent(),
      ],
    );
  }
}
