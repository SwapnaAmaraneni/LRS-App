import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import '../res/constants/app_colors.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  WebViewController privacyPolicyController = WebViewController();
  WebViewController termsAndConditionsController = WebViewController();
  WebViewController copyrightsController = WebViewController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Privacy Policy"),
          centerTitle: true,
          backgroundColor: AppColors.primaryColorDark,
        ),
        body: Container(
          color: AppColors.themeColor,
          child: ContainedTabBarView(
            tabBarProperties: const TabBarProperties(
                indicatorColor: AppColors.white, indicatorWeight: 3.0),
            tabs: const [
              Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                "Terms and Conditions",
                style: TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Text(
                "Copyrights policy",
                style: TextStyle(fontSize: 14, color: Colors.white),
              )
            ],
            views: [
              WebViewWidget(
                controller: privacyPolicyController
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(const Color(0x00000000))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onWebResourceError: (WebResourceError error) {},
                    ),
                  )
                  ..loadRequest(Uri.parse(
                      'https://www.cgg.gov.in/mgov-privacy-policy/?depot_name=Municipal Administration and Urban Development (MAUD), Govt. of Telangana')),
                gestureRecognizers: {}..add(
                    Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer())),
              ),
              WebViewWidget(
                controller: termsAndConditionsController
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(const Color(0x00000000))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onWebResourceError: (WebResourceError error) {},
                    ),
                  )
                  ..loadRequest(Uri.parse(
                      'https://www.cgg.gov.in/mgov-terms-conditions/?depot_name=Municipal Administration and Urban Development (MAUD), Government of Telangana, India&capital=Hyderabad,%20Telangana')),
                gestureRecognizers: {}..add(
                    Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer())),
              ),
              WebViewWidget(
                controller: copyrightsController
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(const Color(0x00000000))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onWebResourceError: (WebResourceError error) {},
                    ),
                  )
                  ..loadRequest(Uri.parse(
                      'https://www.cgg.gov.in/mgov-copyright-policy/?depot_name=Municipal Administration and Urban Development (MAUD), Govt. of Telangana&depot_email=prlsecy_maud@telangana.gov.in')),
                gestureRecognizers: {}..add(
                    Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
