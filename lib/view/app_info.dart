import 'package:lrsofficer/res/constants/app_assets.dart';
import 'package:flutter/material.dart';
import '../res/constants/app_constants.dart';
import '../res/reusable_widgets/app_bar_reusable.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({super.key});

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarReusable(
        title: "App Info",
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.appBgScreens),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     fit: BoxFit.cover,
            //     image: ExactAssetImage(AppAssets.appBg),
            //   ),
            // ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(
              left: 14,
              right: 14,
              top: 14,
              bottom: 14,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 15),
                  child: Image.asset(
                    AppAssets.appIcon,
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.height * 0.15,
                  ),
                ),
                const Text(
                  "LRS OFFICER",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text(
                          "Version :",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          AppConstants.appVersion,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: const Text(
                        "Updated On :",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    SizedBox(
                      child: Text(
                        AppConstants.updatedDate,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      //bottomSheet: const CustomFooterContainer(),
    );
  }
}
