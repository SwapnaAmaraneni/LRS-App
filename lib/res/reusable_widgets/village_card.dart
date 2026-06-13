import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrsofficer/res/constants/app_colors.dart';

class VillageWiseCountCard extends StatelessWidget {
  const VillageWiseCountCard(
      {super.key,
      required this.surveyCount,
      required this.applicationCount,
      required this.villageName,
      this.onTap});
  final String surveyCount;
  final String applicationCount;
  final String villageName;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
                  child: Align(
                      child: Text(
                    villageName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.themeColor),
                  )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.89,
                  child: const Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "surveyCount".tr(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.primaryColorDark),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              surveyCount,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColorDark,
                                  fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: const VerticalDivider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "applicationCount".tr(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.primaryColorDark),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              applicationCount,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColorDark,
                                  fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
