import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/gradient_grid_widget.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/res/reusable_widgets/footer_reusable.dart';
import 'package:lrsofficer/view_model/new_flow/fee_status_report_view_model.dart';
import 'package:provider/provider.dart';

class FeeStatusReportView extends StatefulWidget {
  const FeeStatusReportView({super.key});

  @override
  State<FeeStatusReportView> createState() => _FeeStatusReportViewState();
}

class _FeeStatusReportViewState extends State<FeeStatusReportView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final provider =
            Provider.of<FeeStatusReportViewModel>(context, listen: false);
        await provider.feeStatusApi(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeeStatusReportViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBarReusable(
              title: "Fee Status Report",
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(
                                            0xFF176646), // Dark Shade (~30% darker)
                                        Color(0xFF218F60), // Base Theme Color
                                        Color(
                                            0xFF4CB98B), // Light Shade (~30% lighter)
                                      ], // Gradient blue theme
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                        offset: const Offset(3, 5),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: CustomGradientGrid(
                                    title: "Fee Intimated",
                                    count:
                                        provider.getReportData?.feeIntimated ??
                                            0,
                                    color: Colors.white,
                                    icon: Icons.notifications_active,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(
                                            0xFF176646), // Dark Shade (~30% darker)
                                        Color(0xFF218F60), // Base Theme Color
                                        Color(
                                            0xFF4CB98B), // Light Shade (~30% lighter)
                                      ], // Gradient blue theme
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                        offset: const Offset(3, 5),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: CustomGradientGrid(
                                      title: "Fee Paid",
                                      count:
                                          provider.getReportData?.feePaid ?? 0,
                                      color: Colors.yellowAccent,
                                      icon: Icons.check_circle_outline,
                                      isClickable: true,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: const CustomFooterContainer())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section for Fee Count Display
