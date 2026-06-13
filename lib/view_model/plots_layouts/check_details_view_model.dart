import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/data/local_store_helper.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/check_details_optionssaved.dart';
import 'package:lrsofficer/models/check_details_payload.dart';
import 'package:lrsofficer/models/check_details_response.dart';
import 'package:lrsofficer/models/questionare_dropdown_request.dart';
import 'package:lrsofficer/models/questionare_dropdown_response.dart';
import 'package:lrsofficer/models/villagewise_cluster_inspection_submit/final_submit_payload.dart';
import 'package:lrsofficer/repository/check_details_repository.dart';
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
import 'package:lrsofficer/models/saved_applications/saved_application_details_response.dart' as savedApplication;

class CheckDetailsViewModel with ChangeNotifier {


  List<savedApplication.ListSaveData> checkList = [];
  List<TextEditingController> remarksControllers = [];


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


  clearAll() {
    checkList.clear();
    remarksControllers.clear();
    applications.clear();
    responses.clear();
    dROPDOWNs.clear();
    notifyListeners();
  }

  // Method to update the file path
  void updateFile(String sNO, String filePath) {
    // fileMap[sNO] = filePath;
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> submit(BuildContext context) async {
    setLoaderVisibleStatus(true);
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
    List<Map<String, dynamic>> answerMaps =
        answeredChecklist.map((answer) => answer.toJson()).toList();
    String answerListJson = jsonEncode(answerMaps);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefConstants.checkListKey, answerListJson);
    final userType =
        await LocalStoreHelper().readTheData(SharedPrefConstants.userType);
    setLoaderVisibleStatus(false);
    if (!context.mounted) return;
    userType.toString().toLowerCase() == "tp"
        ? Navigator.pushNamed(context, AppRoutes.paymentDetails)
        : Navigator.pushNamed(context, AppRoutes.recommendations);
    // }
  }

  bool validateQues(
    BuildContext context,
    List<ListMasterPlans> checklistQues,
    List<CHECKLIST> answeredList,
  ) {
    for (final question in checklistQues) {
      final response = answeredList.firstWhere(
        (item) => item.cHECKLISTID == question.sNO,
        orElse: () => CHECKLIST(),
      );

      // Helper to show validation alert and stop immediately
      void showError(String msg) {
        ValidationIoSAlert().showAlert(context, description: msg);
      }

      // 🔹 Check: question not answered
      if (response.cHECKLISTID == null) {
        showError(
            "Please select an answer for question ${question.pLOTQUESTIONARY}");
        return false;
      }

      // 🔹 Check: answer is empty
      final status = response.sTATUSID?.toString().trim() ?? "";
      if (status.isEmpty) {
        showError(
            "Please select an answer for question ${question.pLOTQUESTIONARY}");
        return false;
      }

      // 🔹 Conditional checks based on question type
      if (status == "Y") {
        if (question.iSREMARKS == "Y" &&
            (response.remarks?.trim().isEmpty ?? true)) {
          showError(
              "Please enter remarks for question ${question.pLOTQUESTIONARY}");
          return false;
        }

        if (question.iSDROPDOWN == "Y" &&
            ((response.checkDRopDown?.trim().isEmpty ?? true) ||
                response.checkDRopDown == "0")) {
          showError(
              "Please select a dropdown option for question ${question.pLOTQUESTIONARY}");
          return false;
        }

        if (question.iSUPLOAD == "Y" &&
            (response.docment?.trim().isEmpty ?? true)) {
          showError(
              "Please upload a document for question ${question.pLOTQUESTIONARY}");
          return false;
        }
      }
    }

    // ✅ All validations passed
    return true;
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
        CheckDetailsResponse? response =
            await CheckDetailsRepository().checkDetailsRepo(context, request);
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
    } catch (error) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } finally {
      setLoaderVisibleStatus(false);
    }
  }

  void updateAnswer(String? sno, String? answer) {
    var response = responses.firstWhere(
      (element) => element.sno == sno,
      orElse: () {
        var newResponse =
            QuestionnaireResponse(sno: sno, selectedAnswer: answer);
        responses.add(newResponse);
        return newResponse;
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
        QuestionareDropdownResponse? response = await CheckDetailsRepository()
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
    } catch (error) {
      setLoaderVisibleStatus(false);
      if (!context.mounted) return;
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
    } finally {
      setLoaderVisibleStatus(false);
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
