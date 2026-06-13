import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:lrsofficer/res/reusable_widgets/app_bar_reusable.dart';
import 'package:lrsofficer/routes/app_routes.dart';
import 'package:lrsofficer/utils/loader.dart';
import 'package:lrsofficer/view_model/individual_plots_new_flow_viewmodel/layout_application_dashboard_viewmodel.dart';
import 'package:provider/provider.dart';

class LayoutApplicationsDashboard extends StatefulWidget {
  const LayoutApplicationsDashboard({super.key});

  @override
  State<LayoutApplicationsDashboard> createState() =>
      _LayoutApplicationsDashboardState();
}

class _LayoutApplicationsDashboardState
    extends State<LayoutApplicationsDashboard> {
  final List<Map<String, dynamic>> dashboardItems = [
    {
      "title": "Completed Layouts",
      "route": AppRoutes.villagewiseSurveyNumbersList,
      "color": Colors.green,
    },
    {
      "title": "Individual Plots",
      "route": AppRoutes.individualPlotVillageWiseSurveyNumber,
      "color": Colors.blue,
    },
  ];

  /* @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final provider = Provider.of<LayoutApplicationDashboardViewmodel>(context,
          listen: false);
    //  await provider.getLayoutMenu(context);
    });
  } */

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LayoutApplicationDashboardViewmodel>(context);
    return Stack(children: [
      Scaffold(
          appBar: const AppBarReusable(
            title: "Dashboard",
          ),
          body: Stack(alignment: AlignmentDirectional.center, children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.appBg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: dashboardItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: dashboardItems[index]['color'].withOpacity(0.8),
                    child: ListTile(
                      title: Text(
                        dashboardItems[index]['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        // Handle navigation or action here
                        Navigator.pushNamed(
                            context, dashboardItems[index]['route']);
                      },
                    ),
                  );
                },
              ),
            ),
          ])),
      if (provider.getLoaderVisibilityStatus) const LoaderComponent()
    ]);
  }
}
