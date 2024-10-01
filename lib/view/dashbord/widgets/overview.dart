import 'package:assure_apps/configs/app_constants.dart';
import 'package:flutter/material.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/defaults.dart';
import '../../../configs/ghaps.dart';
import '../../../widgets/section_title.dart';
import 'overview_tabs.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  // Initialize the valueData outside the build method
  String valueData = "All time"; // Initialize with a default value

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondayLight,
        borderRadius:
        BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SectionTitle(title: "Overview"),
              const Spacer(),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDefaults.borderRadius)),
                    border: Border.all(width: 2, color: AppColors.highlightLight),
                  ),
                  child: DropdownButton<String>(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding, vertical: 0),
                    style: Theme.of(context).textTheme.labelLarge,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDefaults.borderRadius)),
                    underline: const SizedBox(),
                    value: valueData, // Default value
                    items: const [
                      DropdownMenuItem(
                        value: "All time",
                        child: Text("All time"),
                      ),
                      DropdownMenuItem(
                        value: "This year",
                        child: Text("This year"),
                      ),
                      DropdownMenuItem(
                        value: "Month",
                        child: Text("Month"),
                      ),
                      DropdownMenuItem(
                        value: "Week",
                        child: Text("Week"),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          valueData = newValue; // Update the valueData
                          reportController.fetchAllBuildingSales(
                            dateFilter: newValue, // Pass the updated value
                          );
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          gapH24,
          OverviewTabs(),
        ],
      ),
    );
  }
}
