import 'package:flutter/material.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/view/plots_layouts/plots/add_coordinates.dart';
import 'package:lrsofficer/view/plots_layouts/check_details.dart';
import 'package:lrsofficer/view/plots_layouts/plots/cluster_application_details.dart';
import 'package:lrsofficer/view/plots_layouts/surveynowise_clusters_list.dart';
import 'package:lrsofficer/view/plots_layouts/clusterwise_application_list.dart';
import 'package:lrsofficer/view/plots_layouts/villagewise_surveynumbers_list.dart';
import 'package:lrsofficer/view/forgot_password.dart';
import 'package:lrsofficer/view/global_search/global_search_view.dart';
import 'package:lrsofficer/view/igrs_inspection_view/igrs_add_coordinates.dart';
import 'package:lrsofficer/view/igrs_inspection_view/igrs_application_details.dart';
import 'package:lrsofficer/view/igrs_inspection_view/igrs_application_list_view.dart';
import 'package:lrsofficer/view/igrs_inspection_view/igrs_checklist.dart';
import 'package:lrsofficer/view/igrs_inspection_view/igrs_payment_details.dart';
import 'package:lrsofficer/view/igrs_inspection_view/igrs_recommendations.dart';
import 'package:lrsofficer/view/igrs_inspection_view/igrs_upload_plot_details.dart';
import 'package:lrsofficer/view/individual_plots_new_flow/individual_plot_application_details.dart';
import 'package:lrsofficer/view/individual_plots_new_flow/individual_plot_clusterwise_applications.dart';
import 'package:lrsofficer/view/individual_plots_new_flow/individual_plot_surveynumber_wise_cluters.dart';
import 'package:lrsofficer/view/individual_plots_new_flow/individual_plot_village_wise_survey_numbers.dart.dart';
import 'package:lrsofficer/view/individual_plots_new_flow/layout_applications_dashboard.dart';
import 'package:lrsofficer/view/plots_layouts/layout/add_unsold_plot_details.dart';
import 'package:lrsofficer/view/plots_layouts/layout/layout_cluster_application_details.dart';
import 'package:lrsofficer/view/login.dart';
import 'package:lrsofficer/view/login_with_userid_password.dart';
import 'package:lrsofficer/view/new_flow/fee_paid_application_list_view.dart';
import 'package:lrsofficer/view/new_flow/fee_paid_payment_details.dart';
import 'package:lrsofficer/view/new_flow/fee_status_report_view.dart';
import 'package:lrsofficer/view/new_flow/fee_intimated_not_paid_list_view.dart';
import 'package:lrsofficer/view/new_flow/fifp_inspection/fifp_add_coordinates.dart';
import 'package:lrsofficer/view/new_flow/fifp_inspection/fifp_application_details.dart';
import 'package:lrsofficer/view/new_flow/fifp_inspection/fifp_checklist.dart';
import 'package:lrsofficer/view/new_flow/fifp_inspection/fifp_payment_details.dart';
import 'package:lrsofficer/view/new_flow/fifp_inspection/fifp_recommendations.dart';
import 'package:lrsofficer/view/new_flow/fifp_inspection/fifp_upload_plot_details.dart';
import 'package:lrsofficer/view/new_flow/sla_breaches_list_view.dart';
import 'package:lrsofficer/view/otp.dart';
import 'package:lrsofficer/view/plots_layouts/payment_details.dart';
import 'package:lrsofficer/view/phase1/phase1_checklist.dart';
import 'package:lrsofficer/view/phase1/phase1_clusterwise_list.dart';
import 'package:lrsofficer/view/phase1/phase1_ir_re_application_details.dart';
import 'package:lrsofficer/view/phase1/phase1_layouts/phase1_layout_add_unsold_plot.dart';
import 'package:lrsofficer/view/phase1/phase1_layouts/phase1_layout_application_details.dart';
import 'package:lrsofficer/view/phase1/phase1_payment_details.dart';
import 'package:lrsofficer/view/phase1/phase1_plots/phase1_add_coordinates.dart';
import 'package:lrsofficer/view/phase1/phase1_plots/phase1_tp_application_details.dart';
import 'package:lrsofficer/view/phase1/phase1_recommendations.dart';
import 'package:lrsofficer/view/phase1/phase1_surveynowise_list.dart';
import 'package:lrsofficer/view/phase1/phase1_upload_plot_details.dart';
import 'package:lrsofficer/view/phase1/phase1_villagewise_list.dart';
import 'package:lrsofficer/view/phase1/searched_phase1_list.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_checklist.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_clusterwise_list.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_ir_re_application_details.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_layouts/phase2_reverted_layout_add_unsold_plot.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_layouts/phase2_reverted_layout_application_details.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_payment_details.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_plots/phase2_reverted_add_coordinates.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_plots/phase2_reverted_tp_application_details.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_recommendations.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_surveynowise_list.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_upload_plot_details.dart';
import 'package:lrsofficer/view/phase2_reverted/phase2_reverted_villagewise_list.dart';
import 'package:lrsofficer/view/phase2_reverted/searched_phase2_reverted_list.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_checklist.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_clusterwise_list.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_ir_re_application_details.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_layouts/phase2_shortfall_layout_add_unsold_plot.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_layouts/phase2_shortfall_layout_application_details.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_payment_details.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_plots/phase2_shortfall_add_coordinates.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_plots/phase2_shortfall_tp_application_details.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_recommendations.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_surveynowise_list.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_upload_plot_details.dart';
import 'package:lrsofficer/view/phase2_shortfall/phase2_shortfall_villagewise_list.dart';
import 'package:lrsofficer/view/phase2_shortfall/searched_phase2_shortfall_list.dart';
import 'package:lrsofficer/view/privacy_policy.dart';
import 'package:lrsofficer/view/processed_applications/processed_application_list.dart';
import 'package:lrsofficer/view/processed_pl_by_officer/processed_pl_officer_list.dart';
import 'package:lrsofficer/view/prohibited_application/prohibited_application_list.dart';
import 'package:lrsofficer/view/prohibited_application/prohibited_checklist.dart';
import 'package:lrsofficer/view/prohibited_application/prohibited_ir_re_application_details.dart';
import 'package:lrsofficer/view/prohibited_application/prohibited_layouts/prohibited_layout_add_unsold_plot.dart';
import 'package:lrsofficer/view/prohibited_application/prohibited_layouts/prohibited_layout_application_details.dart';
import 'package:lrsofficer/view/prohibited_application/prohibited_payment_details.dart';
import 'package:lrsofficer/view/prohibited_application/prohibited_plots/prohibited_add_coordinates.dart';
import 'package:lrsofficer/view/prohibited_application/prohibited_plots/prohibited_tp_application_details.dart';
import 'package:lrsofficer/view/prohibited_application/prohibited_recommendations.dart';
import 'package:lrsofficer/view/prohibited_application/prohibited_upload_plot_details.dart';
import 'package:lrsofficer/view/plots_layouts/recommendations_view.dart';
import 'package:lrsofficer/view/registration.dart';
import 'package:lrsofficer/view/plots_layouts/ir_re_application_details.dart';
import 'package:lrsofficer/view/satellite_google_map.dart';
import 'package:lrsofficer/view/saved_applications/saved_add_unsold_plots_list.dart';
import 'package:lrsofficer/view/saved_applications/saved_application_details.dart';
import 'package:lrsofficer/view/saved_applications/saved_applications_list.dart';
import 'package:lrsofficer/view/saved_applications/saved_check_details.dart';
import 'package:lrsofficer/view/saved_applications/saved_upload_plot_details.dart';
import 'package:lrsofficer/view/plots_layouts/search_cluster_wise_application_list.dart';
import 'package:lrsofficer/view/set_mpin.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_checklist.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_clusterwise_list.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_ir_re_application_details.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_layouts/shortfall_layout_add_unsold_plot.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_layouts/shortfall_layout_app_details.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_payment_details.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_plots/shortfall_add_coordinates.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_plots/shortfall_tp_application_details.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_recommendations.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_search_application_list.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_surveynowise_list.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_upload_plot_details.dart';
import 'package:lrsofficer/view/shortfall_application/shortfall_villagewise_list.dart';
import 'package:lrsofficer/view/plots_layouts/upload_polt_detail.dart';
import 'package:lrsofficer/view/validate_mpin.dart';
import '../view/app_info.dart';
import '../view/dashboard.dart';
import '../view/splash_view.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.splash: (context) => const SplashView(),
      AppRoutes.login: (context) => const LoginScreen(),
      AppRoutes.loginWithMobilePassword: (context) =>
          const LoginWithMobileAndPassword(),
      AppRoutes.setMpin: (context) => const SetMPINPage(),
      AppRoutes.validateMpin: (context) => const ValidateMpin(),
      AppRoutes.otp: (context) => const Otp(),
      AppRoutes.resetPassword: (context) => const ForgotPasswordPage(),
      AppRoutes.dashboard: (context) => const DashboardView(),
      AppRoutes.privacypolicy: (context) => const PrivacyPolicy(),
      AppRoutes.appInfo: (context) => const AppInfo(),
      AppRoutes.villagewiseSurveyNumbersList: (context) =>
          const VillageWiseSurveyNumbersList(),
      AppRoutes.checkDetails: (context) => const CheckDetails(),
      AppRoutes.surveyNoWiseClustersList: (context) =>
          const SurveyNoWiseClustersList(),
      AppRoutes.clusterwiseApplicationList: (context) =>
          const ClusterWiseApplicationList(),
      AppRoutes.clusterApplicationDetails: (context) =>
          const ClusterApplicationDetails(),
      AppRoutes.uploadePlotDetails: (context) => const UploadPlotDetails(),
      // AppRoutes.mapWidget: (context) => MapWidget(
      //       callbackValue: (p0) {},
      //     ),
      AppRoutes.recommendations: (context) => const RecommendationsView(),
      AppRoutes.paymentDetails: (context) => const PaymentDetails(),
      AppRoutes.revenueApplicationDetails: (context) =>
          const IrReApplicationDetails(),
      AppRoutes.viewMapPolygon: (context) => const GoogleMapSatelliteWidget(),
      AppRoutes.addUnsoldPlotDetails: (context) => const AddUnsoldPlotDetails(),
      AppRoutes.layoutClusterApplicationsDetails: (context) =>
          const LayoutClusterApplicationDetails(),
      AppRoutes.serachApplicationList: (context) =>
          const SearchClusterwiseApplicationList(),
      AppRoutes.registartion: (context) => const RegistationScreen(),
      AppRoutes.addCoordinates: (context) => const AddCoordinates(),
      AppRoutes.globalSearch: (context) => const GlobalSearchView(),
      AppRoutes.savedApplicationList: (context) =>
          const SavedApplicationsList(),
      AppRoutes.savedApplicationDetails: (context) =>
          const SavedApplicationDetails(),
      AppRoutes.savedCheckDetails: (context) => const SavedCheckDetails(),
      AppRoutes.savedUploadPlotDetails: (context) =>
          const SavedUploadPlotDetails(),
      AppRoutes.savedAddUnsoldPlotsList: (context) => SavedAddUnsoldPlotsList(),
      AppRoutes.prohibitedApplicationList: (context) =>
          const ProhibitedApplicationList(),
      AppRoutes.prohibitedTpApplicationDetails: (context) =>
          const ProhibitedApplicationDetails(),
      AppRoutes.prohibitedIrReApplicationDetails: (context) =>
          const ProhibitedIrReApplicationDetails(),
      AppRoutes.prohibitedLayoutApplicationDetails: (context) =>
          const ProhibitedLayoutApplicationDetails(),
      AppRoutes.prohibitedChecklist: (context) => const ProhibitedChecklist(),
      AppRoutes.prohibitedRecommendations: (context) =>
          const ProhibitedRecommendations(),
      AppRoutes.prohibitedPaymentDetails: (context) =>
          const ProhibitedPaymentDetails(),
      AppRoutes.prohibitedUploadPlotDetails: (context) =>
          const ProhibitedUploadPlotDetails(),
      AppRoutes.processedApplicationList: (context) =>
          const ProcessedApplicationList(),
      AppRoutes.prohibitedAddCoordinates: (context) =>
          const ProhibitedAddCoordinates(),
      AppRoutes.prohibitedAddUnsoldPlots: (context) =>
          const ProhibitedAddUnsoldPlotDetails(),
      AppRoutes.processedPLbyOfficerList: (context) =>
          const ProcessedPlotLayoutByOfficerList(),

      //Shortfall Navigations
      AppRoutes.shortfallVillagewiseList: (context) =>
          const ShortfallVillagewiseList(),
      AppRoutes.shortfallSurveyNowiseList: (context) =>
          const ShortfallSurveyNowiseList(),
      AppRoutes.shortfallClusterwiseList: (context) =>
          const ShortfallClusterWiseApplicationList(),
      AppRoutes.shortfallTpApplicationDetails: (context) =>
          const ShortfallApplicationDetails(),
      AppRoutes.shortfallUploadPlotDetails: (context) =>
          const ShortfallUploadPlotDetails(),
      AppRoutes.shortfallIrReApplicationDetails: (context) =>
          const ShortfallIrReApplicationDetails(),
      AppRoutes.shortfallLayoutApplicationDetails: (context) =>
          const ShortfallLayoutApplicationDetails(),
      AppRoutes.shortfallChecklist: (context) => const ShortfallChecklist(),
      AppRoutes.shortfallRecommendations: (context) =>
          const ShortfallRecommendations(),
      AppRoutes.shortfallPaymentDetails: (context) =>
          const ShortfallPaymentDetails(),
      AppRoutes.shortfallAddCoordinates: (context) =>
          const ShortfallAddCoordinates(),
      AppRoutes.shortfallAddUnsoldPlots: (context) =>
          const ShortfallAddUnsoldPlotDetails(),
      AppRoutes.shortfallSearchList: (context) =>
          const SearchShortfallClusterwiseApplicationList(),

      //Phase1
      AppRoutes.phase1VillageWiseList: (context) => Phase1VillagewiseList(),
      AppRoutes.phase1SurveyWiseList: (context) => Phase1SurveyNowiseList(),
      AppRoutes.phase1ClusterWiseList: (context) =>
          Phase1ClusterWiseApplicationList(),
      AppRoutes.phase1TpApplicationDetails: (context) =>
          Phase1ApplicationDetails(),
      AppRoutes.phase1IrReApplicationDetails: (context) =>
          Phase1IrReApplicationDetails(),
      AppRoutes.phase1LayoutApplicationDetails: (context) =>
          Phase1LayoutApplicationDetails(),
      AppRoutes.phase1Checklist: (context) => Phase1Checklist(),
      AppRoutes.phase1UploadPlotDetails: (context) => Phase1UploadPlotDetails(),
      AppRoutes.phase1Recommendations: (context) => Phase1Recommendations(),
      AppRoutes.phase1PaymentDetails: (context) => Phase1PaymentDetails(),
      AppRoutes.phase1AddCoordinates: (context) => Phase1AddCoordinates(),
      AppRoutes.phase1AddUnsoldPlots: (context) => Phase1AddUnsoldPlotDetails(),
      AppRoutes.phase1SearchedApplicationList: (context) =>
          SearchPhase1ApplicationList(),

      //Phase2 Shortfall
      AppRoutes.phase2ShortfallVillageWiseList: (context) =>
          Phase2ShortfallVillagewiseList(),
      AppRoutes.phase2ShortfallSurveyWiseList: (context) =>
          Phase2ShortfallSurveyNowiseList(),
      AppRoutes.phase2ShortfallClusterWiseList: (context) =>
          Phase2ShortfallClusterWiseApplicationList(),
      AppRoutes.phase2ShortfallTpApplicationDetails: (context) =>
          Phase2ShortfallApplicationDetails(),
      AppRoutes.phase2ShortfallIrReApplicationDetails: (context) =>
          Phase2ShortfallIrReApplicationDetails(),
      AppRoutes.phase2ShortfallLayoutApplicationDetails: (context) =>
          Phase2ShortfallLayoutApplicationDetails(),
      AppRoutes.phase2ShortfallChecklist: (context) =>
          Phase2ShortfallChecklist(),
      AppRoutes.phase2ShortfallUploadPlotDetails: (context) =>
          Phase2ShortfallUploadPlotDetails(),
      AppRoutes.phase2ShortfallRecommendations: (context) =>
          Phase2ShortfallRecommendations(),
      AppRoutes.phase2ShortfallPaymentDetails: (context) =>
          Phase2ShortfallPaymentDetails(),
      AppRoutes.phase2ShortfallAddCoordinates: (context) =>
          Phase2ShortfallAddCoordinates(),
      AppRoutes.phase2ShortfallAddUnsoldPlots: (context) =>
          Phase2ShortfallAddUnsoldPlotDetails(),
      AppRoutes.phase2SearchedApplicationList: (context) =>
          SearchPhase2ShortfallApplicationList(),

      //phase2 Reverted

      AppRoutes.phase2RevertedVillageWiseList: (context) =>
          Phase2RevertedVillagewiseList(),
      AppRoutes.phase2RevertedSurveyWiseList: (context) =>
          Phase2RevertedSurveyNowiseList(),
      AppRoutes.phase2RevertedClusterWiseList: (context) =>
          Phase2RevertedClusterWiseApplicationList(),
      AppRoutes.phase2RevertedTpApplicationDetails: (context) =>
          Phase2RevertedApplicationDetails(),
      AppRoutes.phase2RevertedIrReApplicationDetails: (context) =>
          Phase2RevertedIrReApplicationDetails(),
      AppRoutes.phase2RevertedLayoutApplicationDetails: (context) =>
          Phase2RevertedLayoutApplicationDetails(),
      AppRoutes.phase2RevertedChecklist: (context) => Phase2RevertedChecklist(),
      AppRoutes.phase2RevertedUploadPlotDetails: (context) =>
          Phase2RevertedUploadPlotDetails(),
      AppRoutes.phase2RevertedRecommendations: (context) =>
          Phase2RevertedRecommendations(),
      AppRoutes.phase2RevertedPaymentDetails: (context) =>
          Phase2RevertedPaymentDetails(),
      AppRoutes.phase2RevertedAddCoordinates: (context) =>
          Phase2RevertedAddCoordinates(),
      AppRoutes.phase2RevertedAddUnsoldPlots: (context) =>
          Phase2RevertedAddUnsoldPlotDetails(),
      AppRoutes.phase2RevertedSearchedApplicationList: (context) =>
          SearchPhase2RevertedApplicationList(),

//new Flow
      AppRoutes.feeStatusReport: (context) => const FeeStatusReportView(),
      AppRoutes.feePaidApplications: (context) =>
          const FeePaidApplicationListView(),
      AppRoutes.slaBreachesApplications: (context) =>
          const SlaBreachesListView(),
      AppRoutes.feeInitimatedUnpaid: (context) => const FeeUnpaidListView(),
      AppRoutes.fifpAppDetails: (context) => const FifpApplicationDetails(),
      AppRoutes.fifpUploadPlotDetails: (context) =>
          const FifpUploadPlotDetails(),
      AppRoutes.fifpAddCoordinates: (context) => const FifpAddCoordinates(),
      AppRoutes.fifpCheckList: (context) => const FifpChecklist(),
      AppRoutes.fifpPaymentDetails: (context) => const FifpPaymentDetails(),
      AppRoutes.feePaidPaymentDetails: (context) =>
          const FeePaidPaymentDetails(),
      AppRoutes.fifpRecommendations: (context) => const FifpRecommendations(),

      AppRoutes.layoutApplicationsDashboard: (context) =>
          const LayoutApplicationsDashboard(),
      AppRoutes.individualPlotVillageWiseSurveyNumber: (context) =>
          const IndividualPlotVillageWiseSurveyNumber(),
      AppRoutes.individualPlotApplicationDetails: (context) =>
          const IndividualPlotApplicationDetails(),
      AppRoutes.individualPlotSurveynumberWiseCluters: (context) =>
          const IndividualPlotSurveynumberWiseCluters(),
      AppRoutes.individualPlotClusterwiseApplications: (context) =>
          const IndividualPlotClusterwiseApplications(),

//IGRS
      AppRoutes.igrsApplicationList: (context) =>
          const IGRSApplicationListView(),
      AppRoutes.igrsAppDetails: (context) => const IGRSApplicationDetails(),
      AppRoutes.igrsUploadPlotDetails: (context) =>
          const IGRSUploadPlotDetails(),
      AppRoutes.igrsAddCoordinates: (context) => const IGRSAddCoordinates(),
      AppRoutes.igrsCheckList: (context) => const IGRSChecklist(),
      AppRoutes.igrsPaymentDetails: (context) => const IGRSPaymentDetails(),
      AppRoutes.igrsRecommendations: (context) => const IGRSRecommendations(),
    };
  }
}
