class ApiConstants {
  ApiConstants._();
  static const String baseUrl = qaBaseUrl;
  static const String filesImagesBaseUrl = qafilesImagesBaseUrl;

  //Files
  static const String devfilesImagesBaseUrl =
      "https://devlrs.cgg.gov.in/LRSSERVICES2020/LRSPLOT/";
  static const String qafilesImagesBaseUrl =
      "https://qalrs.cgg.gov.in/LRS_Layout_services/LRSPLOT/";
  static const String uatfilesImagesBaseUrl =
      "https://uatlrs.cgg.gov.in/lrs_layout_services/LRSPLOT/";
  static const String stagefilesImagesBaseUrl =
      "https://staginglrs.cgg.gov.in/Layout_services/LRSPLOT/";
  static const String livefilesImagesBaseUrl =
      "https://lrs.telangana.gov.in/Layout_services/LRSPLOT/";

  static const String devBaseUrl = "https://devlrs.cgg.gov.in/LRSSERVICES2020/";
  static const String uatBaseUrl =
      "https://uatlrs.cgg.gov.in/lrs_layout_services/";
  static const String qaBaseUrl =
      "https://qalrs.cgg.gov.in/LRS_Layout_services/";
  static const String liveBaseUrl =
      "https://lrs.telangana.gov.in/Layout_services/";
  static const String stageBaseUrl =
      "https://staginglrs.cgg.gov.in/Layout_services/";
  static const String versionCheckEndPoint = "LRSPLOT/VersionCheck";
  static const String loginEndPoint = "LRSPLOT/OfficerLogin";
  static const String generateMpinEndPoint = "LRSPLOT/GenerateMPIN";
  ////
  static const String clusterwiseVillageEndPoint =
      "LRSPLOT/ClusterWiseVillageCount"; // done

  static const String checkDetails = "LRSPLOT/CheckDeatails"; //done
  static const String clusterListCountEndPoint =
      "LRSPLOT/LISTofClusterCount"; //done
  static const String clusterwiseApplicationList =
      "LRSPLOT/ClusterwiseApplicationList"; //done
  static const String clusterwiseApplicationDetails =
      "LRSPLOT/ApplicationDetails"; //done
  static const String arcgisBaseurl = "https://gis.cgg.gov.in/arcgis/";
  static const String addFteature =
      "rest/services/LRS/PlotDetails/FeatureServer/0/addFeatures"; //not done
  static const String generateToken = "admin/generateToken"; //not done
  static const String certifiedCopyBaseUrl =
      "http://igrs.telangana.gov.in/IGRS_CCAServices/rest/nicservices/"; //not done
  static const String certifiedCopyEndpoint = "DOC/CertifiedCopy";
  static const String getCertifiedCopy = "LRSPLOT/GetCertifiedCopy";
  static const String recommendationDetails =
      "LRSPLOT/RecommendationDetails"; //done
  static const String clusterPaymentDetailsCalc =
      "LRSPLOT/ClusterCalculation"; //done
  static const String listOfMasterPlanZDP =
      "LRSPLOT/ListOfMasterPlanZDP"; //done

  static const String resendOtp = "LRSPLOT/ResendOTP"; // not needed
  static const String finalSubmit =
      "LRSPLOT/VillageWiseClusterInspection"; // done
  static const String updateMobileNo = "LRSPLOT/UpdateMobileno"; //done
  static const String quesDropdown = "LRSPLOT/QuestionnaireDropDown";
  static const String viewGisCoordinates = "LRSPLOT/GISCOORDINATES"; //done
  static const String searchApplication = "LRSPLOT/APPLICATIONSEARCH";

  //Saved Applications
  static const String savedApplicationsListEndPoint =
      "LRSPLOT/SAVEDAPPLICATIONS";
  static const String savedApplicationsDetailsEndPoint =
      "LRSPLOT/SAVEDAPPLICATIONSDETAILS";
  static const String savedApplicationFinalSubmit =
      "LRSPLOT/SAVEDAPPLICATIONSUBMITTED";
  static const String clusterwiseApplicationListProhibited =
      "LRSPLOT/ClusterwiseApplicationListProhibited";
  static const String applicationDetailsPrhibited =
      "LRSPLOT/ApplicationDetails_Prhibited";
  static const String proceesedApplications = "LRSPLOT/ProceesedApplications";
  static const String prohibitedFinalSubmit =
      "LRSPLOT/VillageWiseClusterInspectionProhibitedSubmit";
  static const String searchProhibitedApplication =
      "LRSPLOT/APPLICATIONSEARCHProhibitted";
  static const String dashboardApi = "LRSPLOT/DynamicMenu";
  static const String processedplOfficer =
      "LRSPLOT/OtherOfficerProcessedApplicationList";
  //Shortfall
  static const String shortfallVillagewiseListEndPoint =
      "LRSPLOT/ShortfallClusterWiseVillageCount";
  static const String shortfallSurveyNowiseListEndPoint =
      "LRSPLOT/ShortfallLISTofClusterCount";
  static const String shortfallClusterwiseListEndPoint =
      "LRSPLOT/ShortfallClusterwiseApplicationList";
  static const String shortfallSearchApplicationEndPoint =
      "LRSPLOT/APPLICATIONSEARCHOLD";

  //Bulk Update
  static const String bulkUpdateEndpoint = "LRSPLOT/Cluster_Wise_Submit";

  //Phase1
  static const String phase1VillagewiseListEndPoint =
      "LRSPLOT/ClusterWiseVillageCountWeb";
  static const String phase1SurveyNowiseListEndPoint =
      "LRSPLOT/LISTofClusterCountWeb";
  static const String phase1ClusterwiseListEndPoint =
      "LRSPLOT/ClusterwiseApplicationListWeb";
  static const String phase1SearchApplicationEndPoint =
      "LRSPLOT/APPLICATIONSEARCHPHASE1";

  //New Shortfall
  static const String phase2ShortfallVillagewiseListEndPoint =
      "LRSPLOT/ShortfallClusterWiseVillageCountNew";
  static const String phase2ShortfallSurveyNowiseListEndPoint =
      "LRSPLOT/ShortfallLISTofClusterCountNew";
  static const String phase2ShortfallClusterwiseListEndPoint =
      "LRSPLOT/ShortfallClusterwiseApplicationListNew";
  static const String phase2ShortfallFinalSubmitEndPoint =
      "LRSPLOT/ShortFallSubmitVillageWiseClusterInspectionNew";
  static const String phase2ShortfallSearchApplicationEndPoint =
      "LRSPLOT/APPLICATIONSEARCHNEW";

  //Phase2Reverted

  static const String phase2RevertedVillagewiseListEndPoint =
      "LRSPLOT/RevertedClusterWiseVillageCountNew";
  static const String phase2RevertedSurveyNowiseListEndPoint =
      "LRSPLOT/RevertedLISTofClusterCountNew";
  static const String phase2RevertedClusterwiseListEndPoint =
      "LRSPLOT/RevertedClusterwiseApplicationListNew";
  static const String phase2RevertedFinalSubmitEndPoint =
      "LRSPLOT/RevertedSubmitVillageWiseClusterInspectionNew";
  static const String phase2RevertedSearchApplicationEndPoint =
      "LRSPLOT/APPLICATIONSEARCHREVERTED";

  // static const String feePaidVillagewiseListEndPoint =
  //     "LRSPLOT/RevertedClusterWiseVillageCountNew";
  // static const String feePaidSurveyNowiseListEndPoint =
  //     "LRSPLOT/RevertedLISTofClusterCountNew";
  // static const String feePaidClusterwiseListEndPoint =
  //     "LRSPLOT/RevertedClusterwiseApplicationListNew";
  // static const String feePaidFinalSubmitEndPoint =
  //     "LRSPLOT/RevertedSubmitVillageWiseClusterInspectionNew";
  // static const String feePaidSearchApplicationEndPoint =
  //     "LRSPLOT/APPLICATIONSEARCHREVERTED";

  //New flow
  static const String dynamicMenuNew = "LRSFIFP/DynamicDashboard";
  static const String feeStatusEndPoint = "LRSFIFP/FeeStatusReport";
  static const String feePaidApplicationsEndPoint =
      "LRSFIFP/FeePaidApplicationList";
  static const String slaBreachedEndPoint =
      "LRSFIFP/SLABreachedApplicationList";
  static const String feeIntimatedEndPoint =
      "LRSFIFP/FeeIntimatedApplicationList";
  static const String fifpApplicationDetails = "LRSFIFP/ApplicationDetails";
  static const String fifpCheckList = "LRSFIFP/CheckList";
  static const String fifpFinalSubmit = "LRSFIFP/FinalSubmitFeePaidApplication";
  static const String remarksSubmit = "LRSFIFP/SubmitFeeIntimatedRemarks";
  static const String layoutDynamicSubMenu = "LRSPLOT/LayoutDynamicSubMenu";
  static const String globalSearchMasters = "LRSFIFP/GetGlobalSearchMasters";
  static const String globalSearch = "LRSFIFP/GlobalSearch";
  static const String globalSearchOfficersList =
      "LRSFIFP/OfficerDetailsForGlobalSearch";

  //IGRS
  static const String igrsApplicationList = "LRSFIFP/IGRSApplicationList";
  static const String igrsApplicationDetails = "LRSFIFP/IGRSApplicationDetails";
  static const String igrsCheckList = "LRSFIFP/CheckList";
  static const String igrsFinalSubmit = "LRSFIFP/FinalSubmitIGRSApplication";
}
