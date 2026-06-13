import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lrsofficer/data/logger_resuable.dart';
import 'package:lrsofficer/models/dashboard/dashboard_response.dart';
import 'package:lrsofficer/res/CustomAlerts/custom_error_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/exit_app_alert.dart';
import 'package:lrsofficer/res/CustomAlerts/logout_alert.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:lrsofficer/res/reusable_widgets/footer_reusable.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/view_model/plots_layouts/recommendations_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../res/reusable_widgets/app_bar_reusable.dart';
import '../utils/internet.dart';
import '../view_model/dashboard_view_model.dart';
import 'sidemenu_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isVisible = true;
  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        AppLogger().logDebug("pop::: $result $didPop");
        ExitAppAlert().showAlert(context: context);
      },
      child: Stack(
        children: [
          Scaffold(
            drawer: SideMenuView(
              employeeName: "${dashboardProvider.loginData.username}",
            ),
            appBar: AppBarReusable(
              title: "Dashboard",
              drawerPresent: true,
              actions: [
                GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.exit_to_app),
                  ),
                  onTap: () {
                    LogoutAppAlert().showAlert(context: context);
                  },
                )
              ],
            ),
            body: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.center,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            //  color: AppColors.themeColor,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.themeColor.withValues(alpha: 0.6),
                                AppColors.themeColor,
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    child: Image.asset(AppAssets.appIcon),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          "${dashboardProvider.loginData.username}",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Text(
                                          "${dashboardProvider.loginData.mOBILENO}",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          "${dashboardProvider.loginData.empID}",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                child: InkWell(
                                  splashColor: AppColors.themeColor
                                      .withValues(alpha: 0.2),
                                  highlightColor: AppColors.themeColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8.0),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.globalSearch);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.themeColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.only(
                                          left: 5.0, right: 10.0),
                                      title: Text(
                                        "Search any application",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: AppColors.themeColor
                                            .withValues(alpha: 0.8),
                                      ),
                                      leading: CircleAvatar(
                                          backgroundColor: AppColors.themeColor
                                              .withValues(alpha: 0.8),
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.5,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                ),
                                itemCount: dashboardProvider
                                        .newDashboardMenu?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final data = dashboardProvider
                                      .newDashboardMenu?[index];

                                  return GestureDetector(
                                    onTap: () {
                                      dashboardProvider.navigations(
                                          context, data ?? DashboardData());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: ((data?.iD == "19") ||
                                                (data?.iD == "20") ||
                                                (data?.iD == "5"))
                                            ? CupertinoColors.systemRed
                                            : const Color.from(
                                                alpha: 1,
                                                red: 0.949,
                                                green: 0.949,
                                                blue: 0.969),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withValues(alpha: 0.2),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            "${data?.iMAGEPATH}",
                                            width: 35,
                                            height: 35,
                                            color: ((data?.iD == "19") ||
                                                    (data?.iD == "20") ||
                                                    (data?.iD == "5"))
                                                ? CupertinoColors.white
                                                : AppColors.themeColor,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Image.asset(
                                                AppAssets.application,
                                                width: 35,
                                                height: 35,
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                AppAssets.application,
                                                width: 35,
                                                height: 35,
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          AnimatedOpacity(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            opacity: ((data?.iD == "19") ||
                                                    (data?.iD == "20") ||
                                                    (data?.iD == "5"))
                                                ? (_isVisible ? 1.0 : 0.5)
                                                : 1.0,
                                            child: Text(
                                              "${data?.mENUNAME}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: ((data?.iD == "19") ||
                                                        (data?.iD == "20") ||
                                                        (data?.iD == "5"))
                                                    ? AppColors.white
                                                    : AppColors.primarySwatch,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                padding: const EdgeInsets.all(10.0),
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(), // Prevent inner scrolling
                              ),
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.3,
                                  crossAxisCount: 2,
                                ),
                                itemCount:
                                    dashboardProvider.dashboardInfo.length,
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: SelectCard(
                                      dashboardData: dashboardProvider
                                          .dashboardInfo[index],
                                      themeColor: AppColors.primarySwatch,
                                    ),
                                  );
                                },
                                padding: const EdgeInsets.all(10.0),
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(), // Prevent inner scrolling
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: const CustomFooterContainer()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (dashboardProvider.getLoaderVisibilityStatus) LoaderComponent(),
        ],
      ),
    );
  }

  void _startBlinking() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _isVisible = !_isVisible;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;
      final dashboardProvider =
          Provider.of<DashboardViewModel>(context, listen: false);
      if (await internetCheck()) {
        await dashboardProvider.getResponseDetails();
        if (!mounted) return;
        await dashboardProvider.getDashboardDetails(context);
        _startBlinking();

        // clearAppCache();
      } else {
        if (!mounted) return;
        ErrorCustomCupertinoAlert().showAlert(
          context,
          message: "internetCheck".tr(),
        );
      }
    });
  }
}

Future<void> clearAppCache() async {
  try {
    final cacheDir = await getTemporaryDirectory();

    if (await cacheDir.exists()) {
      final dir = Directory(cacheDir.path);
      await for (var file in dir.list(recursive: true)) {
        try {
          await file.delete();
          // Skip deletion if the file is a PDF
          /*   if (!file.path.endsWith('.pdf') && await file.exists()) {
            await file.delete();
          } */
        } catch (e) {
          if (!kReleaseMode) debugPrint("Error deleting file: $e");
        }
      }
      if (!kReleaseMode) {
        debugPrint("Cache cleared successfully, excluding PDF files");
      }
    }
  } catch (e) {
    if (!kReleaseMode) debugPrint("Error clearing cache: $e");
  }
}

class SelectCard extends StatelessWidget {
  final DashboardData dashboardData;
  final MaterialColor themeColor;
  const SelectCard(
      {super.key, required this.dashboardData, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardViewModel>(context);

    return GestureDetector(
      onTap: () {
        final recommendationsProvider =
            Provider.of<RecommendationsViewModel>(context, listen: false);
        //recommendationsProvider.clearSavedData(context);
        print(
          "mENUNAME :: ${dashboardData.mENUNAME}",
        );
        if ((dashboardData.mENUNAME ?? "").toLowerCase().contains("plot")) {
          AppConstants.isLayoutPlot = "P";
        } else {
          AppConstants.isLayoutPlot = "L";
        }
        if ((dashboardData.mENUNAME ?? "").toLowerCase().contains("save")) {
          AppConstants.isSavedApplication = "yes";
        } else {
          AppConstants.isSavedApplication = "";
        }
        dashboardProvider.navigations(context, dashboardData);
      },
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(
              color: AppColors.primaryColorDark,
              width: 0.5,
            )),
        elevation: 2,
        color: ((dashboardData.iD == "19") ||
                (dashboardData.iD == "20") ||
                (dashboardData.iD == "5"))
            ? CupertinoColors.systemRed
            : Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    "${dashboardData.iMAGEPATH}",
                    width: 35,
                    height: 35,
                    color: ((dashboardData.iD == "19") ||
                            (dashboardData.iD == "20") ||
                            (dashboardData.iD == "5"))
                        ? CupertinoColors.white
                        : AppColors.themeColor,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Image.asset(
                            AppAssets.application,
                            width: 35,
                            height: 35,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.asset(
                          AppAssets.application,
                          width: 35,
                          height: 35,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    dashboardData.mENUNAME ?? "",
                    style: TextStyle(
                      color: ((dashboardData.iD == "19") ||
                              (dashboardData.iD == "20") ||
                              (dashboardData.iD == "5"))
                          ? AppColors.white
                          : AppColors.primarySwatch,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
