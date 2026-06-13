import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_constants.dart';
import 'package:provider/provider.dart';
import '../res/constants/app_assets.dart';
import '../res/constants/app_colors.dart';
import '../view_model/sidemenu_view_model.dart';

class SideMenuView extends StatefulWidget {
  final String employeeName;

  const SideMenuView({
    super.key,
    required this.employeeName,
  });
  @override
  State<SideMenuView> createState() => _SideMenuViewState();
}

class _SideMenuViewState extends State<SideMenuView> {
  List<Map<String, dynamic>> subtitleGroups = [
    {
      'title': '',
      'subtitles': [
        {'title': 'Home', 'image': AppAssets.home},
        {
          'title': 'Search any application',
          'image': AppAssets.applicationSearch
        },
        // {'title': 'Reports', 'image': AppAssets.report},
      ],
    },
    {
      'title': 'Info',
      'subtitles': [
        {'title': 'Privacy Policy', 'image': AppAssets.privacy},
        {'title': 'App Info', 'image': AppAssets.appInfo}
      ],
    },
    {
      'title': 'Others',
      'subtitles': [
        {'title': 'Exit application', 'image': AppAssets.exit},
        {'title': 'Logout', 'image': AppAssets.logout},
        {'title': 'Delete Account', 'image': AppAssets.deleteIcon}
      ],
    },
  ]; // Define the subtitle groups as a list of maps
  List<Map<String, dynamic>> subtitles = [];

  String? imagePath;

  @override
  void initState() {
    super.initState();
    if (AppConstants.deleteFlag != "true") {
      for (var item in subtitleGroups) {
        item['subtitles']
            .removeWhere((subtitle) => subtitle['title'] == 'Delete Account');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuViewModel>(context);
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.appBarColor,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(AppAssets.appIcon)),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    widget.employeeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView.builder(
                itemCount: subtitleGroups.length,
                itemBuilder: (BuildContext context, int index) {
                  String groupTitle = subtitleGroups[index]['title'];
                  List<Map<String, dynamic>> subtitles =
                      subtitleGroups[index]['subtitles'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (groupTitle != '') ...{
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 5.0),
                          child: Text(
                            groupTitle,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black45),
                          ),
                        ),
                        Column(
                          children: subtitles.map((subtitle) {
                            return ListTile(
                              leading: Image.asset(
                                subtitle['image'],
                                width: 28.0,
                                height: 28.0,
                                fit: BoxFit.cover,
                              ),
                              title: Text(subtitle['title']),
                              onTap: () {
                                sideMenuProvider.navigationTo(
                                    context, subtitle['title']);
                              },
                            );
                          }).toList(),
                        ),
                      } else ...{
                        Column(
                          children: subtitles.map((subtitle) {
                            return ListTile(
                              leading: Image.asset(
                                subtitle['image'],
                                width: 28.0,
                                height: 28.0,
                                fit: BoxFit.cover,
                              ),
                              title: Text(subtitle['title']),
                              onTap: () {
                                sideMenuProvider.navigationTo(
                                    context, subtitle['title']);
                              },
                            );
                          }).toList(),
                        ),
                      },
                      const Divider()
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
