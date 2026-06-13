import 'package:lrsofficer/res/constants/app_colors.dart';
import 'package:lrsofficer/res/reusable_widgets/image_picker_component.dart';
import 'package:lrsofficer/routes/app_pages.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_add_coordinates_view_model.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_application_details_view_model.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_application_list_view_model.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_check_list_view_model.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_layout_application_details_view_model.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_payment_details_view_model.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_recommendations_view_model.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_search_view_model.dart';
import 'package:lrsofficer/view_model/Prohibited_applications_view_model/prohibited_upload_plot_details_view_model.dart';
import 'package:lrsofficer/view_model/plots_layouts/add_coordinates_view_model.dart';
import 'package:lrsofficer/view_model/plots_layouts/check_details_view_model.dart';
import 'package:lrsofficer/view_model/plots_layouts/cluster_application_details_view_model.dart';
import 'package:lrsofficer/view_model/plots_layouts/cluster_list_count_view_model.dart';
import 'package:lrsofficer/view_model/plots_layouts/cluster_wise_application_list_view_model.dart';
import 'package:lrsofficer/view_model/plots_layouts/villagewise_applications_list_view_model.dart';
import 'package:lrsofficer/view_model/dashboard_view_model.dart';
import 'package:lrsofficer/view_model/document_download_viewmodel.dart';
import 'package:lrsofficer/view_model/geo_coordinates_view_model_new.dart';
import 'package:lrsofficer/view_model/global_search_view_model.dart';
import 'package:lrsofficer/view_model/igrs_inspection/igrs_add_coordinates_view_model.dart';
import 'package:lrsofficer/view_model/igrs_inspection/igrs_application_details_view_model.dart';
import 'package:lrsofficer/view_model/igrs_inspection/igrs_applications_list_view_model.dart';
import 'package:lrsofficer/view_model/igrs_inspection/igrs_check_list_view_model.dart';
import 'package:lrsofficer/view_model/igrs_inspection/igrs_payment_details_view_model.dart';
import 'package:lrsofficer/view_model/igrs_inspection/igrs_recommendations_view_model.dart';
import 'package:lrsofficer/view_model/igrs_inspection/igrs_upload_plot_details_view_model.dart';
import 'package:lrsofficer/view_model/individual_plots_new_flow_viewmodel/individual_plot_application_details_view_model.dart';
import 'package:lrsofficer/view_model/individual_plots_new_flow_viewmodel/individual_plots_dashboard_view_model.dart';
import 'package:lrsofficer/view_model/individual_plots_new_flow_viewmodel/layout_application_dashboard_viewmodel.dart';
import 'package:lrsofficer/view_model/plots_layouts/layout_cluster_application_details_view_model.dart';
import 'package:lrsofficer/view_model/login_view_model.dart';
import 'package:lrsofficer/view_model/login_with_userid_password_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/fee_initimated_unpaid_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/fee_paid_applications_list_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/fee_paid_payment_details_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_add_coordinates_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_application_details_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_check_list_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_payment_details_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_recommendations_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/fifp_inspection/fifp_upload_plot_details_view_model.dart';
import 'package:lrsofficer/view_model/new_flow/sla_breaches_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_add_coordinates_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_check_list_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_clusterwise_list_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_layout_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_payment_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_recommendations_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_search_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_surveynowise_list_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_upload_plot_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_reverted_view_models/phase2_reverted_villagewise_list_viewmodel.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_add_coordinates_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_check_list_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_clusterwise_list_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_layout_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_payment_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_recommendations_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_search_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_surveynowise_list_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_upload_plot_details_view_model.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_villagewise_list_viewmodel.dart';
import 'package:lrsofficer/view_model/otp_view_model.dart';
import 'package:lrsofficer/view_model/payment_details_viewmodel.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_add_coordinates_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_check_list_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_clusterwise_list_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_layout_application_details_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_payment_details_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_recommendations_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_search_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_surveynowise_list_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_upload_plot_details_view_model.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_villagewise_list_viewmodel.dart';
import 'package:lrsofficer/view_model/processed_applications_view_model/processed_application_list_view_model.dart';
import 'package:lrsofficer/view_model/processed_pl_byofficer_viewmodel.dart';
import 'package:lrsofficer/view_model/plots_layouts/recommendations_view_model.dart';
import 'package:lrsofficer/view_model/reset_password_view_model.dart';
import 'package:lrsofficer/view_model/saved_application_details_view_model.dart';
import 'package:lrsofficer/view_model/saved_applications_list_view_model.dart';
import 'package:lrsofficer/view_model/search_view_model.dart';
import 'package:lrsofficer/view_model/set_mpin_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_add_coordinates_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_application_details_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_check_list_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_clusterwise_list_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_layout_app_details_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_payment_details_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_recommendations_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_search_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_surveynowise_list_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_upload_plot_details_view_model.dart';
import 'package:lrsofficer/view_model/shortfall_applications_view_model/shortfall_villagewise_list_viewmodel.dart';
import 'package:lrsofficer/view_model/update_mobile_no_view_model.dart';
import 'package:lrsofficer/view_model/plots_layouts/upload_plot_details_view_model.dart';
import 'package:lrsofficer/view_model/validate_mpin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrsofficer/view_model/view_polygon_view_model.dart';
import 'package:provider/provider.dart';
import 'view_model/sidemenu_view_model.dart';
import 'view_model/splash_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
/* import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart'; */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
/*   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError; */
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(EasyLocalization(
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('hi', 'IN'),
            Locale('te', 'IN')
          ],
          path: 'assets/translation',
          fallbackLocale: const Locale('en', 'US'),
          child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => ImagePickerLoader()),
        ChangeNotifierProvider(create: (context) => SplashViewModel()),
        ChangeNotifierProvider(create: (context) => LoginWithMobileViewModel()),
        ChangeNotifierProvider(create: (context) => SetMpinViewModel()),
        ChangeNotifierProvider(create: (context) => ValidateMpinViewModel()),
        ChangeNotifierProvider(create: (context) => OtpViewModel()),
        ChangeNotifierProvider(create: (context) => ResetPasswordViewModel()),
        ChangeNotifierProvider(create: (context) => DashboardViewModel()),
        ChangeNotifierProvider(create: (context) => SideMenuViewModel()),
        ChangeNotifierProvider(
          create: (context) => VillageWiseSurveyNumbersListViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SurveyNumberWiseClustersListViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ClusterWiseApplicationListViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ClusterApplicationDetailsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CaptureGeoCoordinatesViewModelNew(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecommendationsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DocumentDownloadViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadPlotDetailsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CheckDetailsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PaymentDetailsViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UpdateMobileNoViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ViewPolygonViewModel(),
        ),
        ChangeNotifierProvider(
            create: (context) => LayoutClusterApplicationDetailsViewModel()),
        ChangeNotifierProvider(create: (context) => SearchViewModel()),
        ChangeNotifierProvider(create: (context) => AddCoordinatesViewModel()),
        ChangeNotifierProvider(
            create: (context) => SavedApplicationsListViewModel()),
        ChangeNotifierProvider(
            create: (context) => SavedApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => ProcessedApplicationListViewModel()),
        ChangeNotifierProvider(
            create: (context) => ProhibitedApplicationListViewModel()),
        ChangeNotifierProvider(
            create: (context) => ProhibitedApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => ProhibitedCheckDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => ProhibitedRecommendationsModel()),
        ChangeNotifierProvider(
            create: (context) => ProhibitedUploadPlotDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => ProhibitedPaymentDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => ProhibitedSearchViewModel()),
        ChangeNotifierProvider(
            create: (context) => ProhibitedAddCoordinatesViewModel()),
        ChangeNotifierProvider(
            create: (context) => ProhibitedLayoutApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => ProcessedPLByOfficerListViewModel()),
        ChangeNotifierProvider(
            create: (context) => ShortfallVillagewiseListViewModel()),
        ChangeNotifierProvider(
            create: (context) => ShortfallSurveyNowiseListViewModel()),
        ChangeNotifierProvider(
            create: (context) =>
                ShortfallClusterWiseApplicationListViewModel()),
        ChangeNotifierProvider(
            create: (_) => ShortfallApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => ShortfallLayoutApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => ShortfallUploadPlotDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => ShortfallAddCoordinatesViewModel()),
        ChangeNotifierProvider(
            create: (context) => ShortfallCheckDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => ShortfallPaymentDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => ShortfallRecommendationsModel()),
        ChangeNotifierProvider(create: (context) => ShortfallSearchViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase1VillagewiseListViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase1SurveyNowiseListViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase1ClusterWiseApplicationListViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase1ApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase1LayoutApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase1UploadPlotDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase1CheckDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase1PaymentDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase1RecommendationsModel()),
        ChangeNotifierProvider(
            create: (context) => Phase1AddCoordinatesViewModel()),
        ChangeNotifierProvider(create: (context) => Phase1SearchViewModel()),

        //Pahse2 Shortfall
        ChangeNotifierProvider(
            create: (context) => Phase2ShortfallVillagewiseListViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2ShortfallSurveyNowiseListViewModel()),
        ChangeNotifierProvider(
            create: (context) =>
                Phase2ShortfallClusterWiseApplicationListViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2ShortfallAddCoordinatesViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2ShortfallApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) =>
                Phase2ShortfallLayoutApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2ShortfallUploadPlotDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2ShortfallCheckDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2ShortfallPaymentDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2ShortfallRecommendationsModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2ShortfallSearchViewModel()),

        //Pahse2 Reverted
        ChangeNotifierProvider(
            create: (context) => Phase2RevertedVillagewiseListViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2RevertedSurveyNowiseListViewModel()),
        ChangeNotifierProvider(
            create: (context) =>
                Phase2RevertedClusterWiseApplicationListViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2RevertedAddCoordinatesViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2RevertedApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) =>
                Phase2RevertedLayoutApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2RevertedUploadPlotDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2RevertedCheckDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2RevertedPaymentDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2RevertedRecommendationsModel()),
        ChangeNotifierProvider(
            create: (context) => Phase2RevertedSearchViewModel()),

        //newFlow
        ChangeNotifierProvider(
            create: (context) => FeePaidApplicationsListViewModel()),
        ChangeNotifierProvider(create: (context) => SlaBreachesViewModel()),
        ChangeNotifierProvider(
            create: (context) => FeeInitimatedUnpaidViewModel()),
        ChangeNotifierProvider(
            create: (context) => FifpUploadPlotDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => FifpRecommendationsViewModel()),
        ChangeNotifierProvider(
            create: (context) => FifpPaymentDetailsViewModel()),
        ChangeNotifierProvider(create: (context) => FifpCheckListViewModel()),
        ChangeNotifierProvider(
            create: (context) => FifpApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => FifpAddCoordinatesViewModel()),
        ChangeNotifierProvider(
            create: (context) => FeePaidPaymentDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => IndividualPlotsDashboardViewModel()),
        ChangeNotifierProvider(
            create: (context) => IndividualPlotApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => LayoutApplicationDashboardViewmodel()),
        ChangeNotifierProvider(create: (context) => GlobalSearchViewModel()),

        //IGRS FLOW
        ChangeNotifierProvider(
            create: (context) => IGRSApplicationsListViewModel()),
        ChangeNotifierProvider(
            create: (context) => IGRSUploadPlotDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => IGRSRecommendationsViewModel()),
        ChangeNotifierProvider(
            create: (context) => IGRSPaymentDetailsViewModel()),
        ChangeNotifierProvider(create: (context) => IGRSCheckListViewModel()),
        ChangeNotifierProvider(
            create: (context) => IGRSApplicationDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => IGRSAddCoordinatesViewModel()),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: "LRS Officer",
        initialRoute: AppRoutes.initial,
        routes: AppPages.routes,
        theme: ThemeData(
            // fontFamily: 'ElMessiri',
            appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryColorDark,
          foregroundColor: AppColors.white,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: AppColors.white,
          ),
        )),
        darkTheme: ThemeData(
            // fontFamily: 'ElMessiri',
            appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryColorDark,
          foregroundColor: AppColors.white,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: AppColors.white,
          ),
        )),
        highContrastTheme: ThemeData(
            // fontFamily: 'ElMessiri',
            appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.primaryColorDark,
          foregroundColor: AppColors.white,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: AppColors.white,
          ),
        )),
        highContrastDarkTheme: ThemeData(
            // fontFamily: 'ElMessiri',
            appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryColorDark,
          foregroundColor: AppColors.white,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: AppColors.white,
          ),
        )),
      ),
    );
  }
}
