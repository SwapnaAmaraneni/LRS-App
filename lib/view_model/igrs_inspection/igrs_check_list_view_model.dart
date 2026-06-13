import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/check_details_optionssaved.dart';
import 'package:lrsofficer/models/check_details_payload.dart';
import 'package:lrsofficer/models/check_details_response.dart';
import 'package:lrsofficer/models/questionare_dropdown_request.dart';
import 'package:lrsofficer/models/questionare_dropdown_response.dart';
import 'package:lrsofficer/models/villagewise_cluster_inspection_submit/final_submit_payload.dart';
import 'package:lrsofficer/repository/igrs_repo/igrs_check_list_repository.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/validation_ios_alert.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/api_error_codes.dart';
import 'package:lrsofficer/utils/error_handling_utils.dart';
import 'package:lrsofficer/utils/file_path_check_utils.dart';
import 'package:lrsofficer/utils/internet.dart';
import 'package:lrsofficer/utils/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IGRSCheckListViewModel with ChangeNotifier {
  List<ListMasterPlans> applications = [];
  List<QuestionnaireResponse> responses = [];
  //saves the dropdown values for each question
  Map<String, List<QuesDROPDOWNs>?> dROPDOWNs = {};

  bool isLoaderVisible = false;
  bool get getLoaderVisibilityStatus => isLoaderVisible;
  void setLoaderVisibleStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  // Method to update the file path
  void updateFile(String sNO, String filePath) {
    // fileMap[sNO] = filePath;
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> submit(BuildContext context) async {
    List<CHECKLIST> answeredChecklist = [];
    for (var items in responses) {
      if (items.selectedAnswer != null) {
        answeredChecklist.add(
          CHECKLIST(
            sTATUSID: items.selectedAnswer,
            cHECKLISTID: items.sno,
            checkDRopDown: items.checkDRopDown,
            docment: setCompleteUrl(items.document),
            remarks: items.remarks,
          ),
        );
      }
      //SharedPreferences prefs = await SharedPreferences.getInstance();
    }
    if (validateQues(context, applications, answeredChecklist)) {
      List<Map<String, dynamic>> answerMaps =
          answeredChecklist.map((answer) => answer.toJson()).toList();
      String answerListJson = jsonEncode(answerMaps);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefConstants.checkListKey, answerListJson);
      final userType =
          await LocalStoreHelper().readTheData(SharedPrefConstants.userType);

      if (!context.mounted) return;
      if (userType.toString().toLowerCase() == "tp") {
        Navigator.pushNamed(context, AppRoutes.igrsPaymentDetails);
      } else {
        Navigator.pushNamed(context, AppRoutes.igrsRecommendations);
      }
    }
    /*  userType.toString().toLowerCase() == "tp"
        ? Navigator.pushNamed(context, AppRoutes.IGRSPaymentDetails)
        : Navigator.pushNamed(context, AppRoutes.IGRSRecommendations); */
    // }
  }

  bool validateQues(
    BuildContext context,
    List<ListMasterPlans> checklistQues,
    List<CHECKLIST> checkList,
  ) {
    bool isAllQuestionsAnswered = true;
    for (ListMasterPlans question in checklistQues) {
      // Check if the question is present in the checklist
      if (!checkList.any((element) => element.cHECKLISTID == question.sNO)) {
        ValidationIoSAlert().showAlert(
          context,
          description:
              "Please select an answer for question ${question.pLOTQUESTIONARY}",
        );
        isAllQuestionsAnswered = false;
        return isAllQuestionsAnswered;
      }

      // Proceed with existing validations if the question is present
      CHECKLIST? quesResponse = checkList.firstWhere(
        (element) => element.cHECKLISTID == question.sNO,
        orElse: () => CHECKLIST(), // handle null case gracefully
      );

      if (quesResponse.sTATUSID.toString().isEmpty ||
          quesResponse.sTATUSID == null) {
        ValidationIoSAlert().showAlert(
          context,
          description:
              "Please select an answer for question ${question.pLOTQUESTIONARY}",
        );
        isAllQuestionsAnswered = false;
        return isAllQuestionsAnswered;
      } else if (question.iSREMARKS == "Y" &&
          quesResponse.sTATUSID == "Y" &&
          (quesResponse.remarks.toString().isEmpty ||
              quesResponse.remarks == null)) {
        ValidationIoSAlert().showAlert(
          context,
          description:
              "Please enter remarks for question ${question.pLOTQUESTIONARY}",
        );
        isAllQuestionsAnswered = false;
        return isAllQuestionsAnswered;
      } else if (question.iSDROPDOWN == "Y" &&
          quesResponse.sTATUSID == "Y" &&
          (quesResponse.checkDRopDown.toString().isEmpty ||
              quesResponse.checkDRopDown == null ||
              quesResponse.checkDRopDown == "0")) {
        ValidationIoSAlert().showAlert(
          context,
          description:
              "Please select a dropdown option for question ${question.pLOTQUESTIONARY}",
        );
        isAllQuestionsAnswered = false;
        return isAllQuestionsAnswered;
      } else if (question.iSUPLOAD == "Y" &&
          quesResponse.sTATUSID == "Y" &&
          (quesResponse.docment.toString().isEmpty ||
              quesResponse.docment == null)) {
        ValidationIoSAlert().showAlert(
          context,
          description:
              "Please upload a document for question ${question.pLOTQUESTIONARY}",
        );
        isAllQuestionsAnswered = false;
        return isAllQuestionsAnswered;
      }
    }

    return isAllQuestionsAnswered;
  }

  Future<void> checkDetailsViewModel(BuildContext context) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        CheckDetailsPayload request = CheckDetailsPayload();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.userID =
            await sharedpref.readTheData(SharedPrefConstants.userID);
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.mPIN = await sharedpref.readTheData(SharedPrefConstants.mpin);
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        CheckDetailsResponse? response = await IGRSCheckDetailsRepository()
            .igrsCheckDetailsRepo(context, request);
        responses.clear();
        setLoaderVisibleStatus(false);

        if (response?.statusCode == ApiErrorCodes.success &&
            response?.listMasterPlans != []) {
          applications = response?.listMasterPlans ?? [];
          saveQuesCheckListToSharedPreferences(
              applications, SharedPrefConstants.questionsChecklist);
/*         responses.addAll(applications
            .map((listMasterPlans) =>
                QuestionnaireResponse(sno: listMasterPlans.sNO))
            .toList()); */
          notifyListeners();

          // responses.forEach((element) {

          // });
        } else if (response?.statusCode == ApiErrorCodes.badRequest) {
          if (!context.mounted) return;

          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        } else if (response?.statusCode == ApiErrorCodes.sessionExpired) {
          if (!context.mounted) return;

          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          );
        } else {
          if (!context.mounted) return;

          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert().showAlert(
          context,
          message: "internetCheck".tr(),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        );
      }
    } on DioException catch (dioError) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(dioError, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } catch (e) {
      setLoaderVisibleStatus(false);
      AppLogger().logDebug("Unexpected error: $e");
      if (!context.mounted) return;
      ErrorHandlingUtils().showErrorDialog(
          context, "An unexpected error occurred. Please try again.");
    }
  }

  void updateAnswer(String? sno, String? answer) {
    var response = responses.firstWhere(
      (element) => element.sno == sno,
      orElse: () {
        var phase2Response =
            QuestionnaireResponse(sno: sno, selectedAnswer: answer);
        responses.add(phase2Response);
        return phase2Response;
      },
    );

    response.selectedAnswer = answer;
    notifyListeners();

    // responses.forEach((element) {

    // });
  }

  void updateDropdownAnswer(String quesID, String answer) {
    var response = responses.firstWhere(
      (element) => element.sno == quesID,
      orElse: () => QuestionnaireResponse(sno: ""),
    );

    AppLogger().logDebug("response------------------ ${response.toJson()}");
    response.checkDRopDown = answer;
    notifyListeners();
  }

  Future<void> getDropdownValues(BuildContext context, String quesID) async {
    try {
      if (await internetCheck()) {
        setLoaderVisibleStatus(true);
        QuestionareDropdownRequest request = QuestionareDropdownRequest();
        LocalStoreHelper sharedpref = LocalStoreHelper();
        request.questionID = quesID;
        request.empID = await sharedpref.readTheData(SharedPrefConstants.empID);
        request.tokenID =
            await sharedpref.readTheData(SharedPrefConstants.token);
        request.isLayoutPlot = AppConstants.isLayoutPlot;

        if (!context.mounted) return;
        QuestionareDropdownResponse? response =
            await IGRSCheckDetailsRepository()
                .questionsDropDownRepo(context, request);
        setLoaderVisibleStatus(false);

        if (response?.dROPDOWNs != []) {
          dROPDOWNs[quesID] = response?.dROPDOWNs;
          notifyListeners();
        } else if (response?.statusCode == ApiErrorCodes.badRequest) {
          if (!context.mounted) return;

          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        } else if (response?.statusCode == ApiErrorCodes.sessionExpired) {
          if (!context.mounted) return;

          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              await LocalStoreHelper().removeData(SharedPrefConstants.mpin);
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          );
        } else {
          if (!context.mounted) return;

          ErrorCustomCupertinoAlert().showAlert(
            context,
            message: response?.statusMsg ?? "",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        if (!context.mounted) return;
        ErrorCustomCupertinoAlert().showAlert(
          context,
          message: "internetCheck".tr(),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        );
      }
    } on DioException catch (dioError) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(dioError, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } catch (e) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(e, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    }
  }

  void clearDropdownTextfieldAndPDf(String? sNO) {
    var response = responses.firstWhere(
      (element) => element.sno == sNO,
      orElse: () => QuestionnaireResponse(sno: ""),
    );

    response.checkDRopDown = null;
    response.remarks = "";
    response.document = null;
    notifyListeners();
  }

  void updateRemarks(String? sNO, String value) {
    var response = responses.firstWhere(
      (element) => element.sno == sNO,
      orElse: () => QuestionnaireResponse(sno: ""),
    );

    response.remarks = value;

    notifyListeners();
  }

  Future<void> openFilePicker(BuildContext context, String quesID) async {
    File pickedFile;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
        ],
        allowMultiple: false,
      );

      if (result != null) {
        pickedFile = File(result.files.single.path!);
        if (pickedFile.path.contains(".pdf")) {
          int fileSize = await pickedFile.length();

          // Check if the file size is within the allowed range
          if (fileSize >= 5 * 1024 && fileSize <= 5 * 1024 * 1024) {
            var response = responses.firstWhere(
              (element) => element.sno == quesID,
              orElse: () => QuestionnaireResponse(sno: ""),
            );
            response.document = pickedFile.path;

            notifyListeners();
            // for (var element in responses) {

            // }
          } else {
            if (!context.mounted) return;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Invalid File Size'),
                  content: const Text(
                      'Please select a file between 5KB and 5MB in size.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please select a PDF file"),
          ));
        }
      }
    } catch (e) {
      AppLogger().logDebug("Error picking file: $e");
    }
  }

  Future<void> saveQuesCheckListToSharedPreferences(
      List<ListMasterPlans> list, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedList = encodeListToJSON(list);
    await prefs.setString(name, encodedList);
  }

  String encodeListToJSON(List<ListMasterPlans> list) {
    List<Map<String, dynamic>> jsonList =
        list.map((item) => item.toJson()).toList();
    return jsonEncode(jsonList);
  }

  void updateDocPath(String path, String quesId) {
    var response = responses.firstWhere(
      (element) => element.sno == quesId,
      orElse: () => QuestionnaireResponse(sno: ""),
    );
    response.document = path;
    notifyListeners();
  }
}
