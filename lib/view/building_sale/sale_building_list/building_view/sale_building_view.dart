import 'package:assure_apps/configs/app_colors.dart';
import 'package:assure_apps/configs/ghaps.dart';
import 'package:assure_apps/configs/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';

import '../../../../configs/app_constants.dart';
import '../../../../configs/app_image.dart';
import '../../../../configs/defaults.dart';
import '../../../../responsive.dart';
import '../../building_sale_setup/building_sale_setup.dart';

class SaleBuildingListView extends StatelessWidget {
  const SaleBuildingListView({super.key});

  @override
  Widget build(BuildContext context) {
    final availableProjects = buildingController.projects
        .where((project) => project.status.toString() == "available")
        .toList();
    return Obx(() {
      if (buildingController.isLoading.value == true) {
        return const Center(child: CircularProgressIndicator());
      } else if (availableProjects.isEmpty) {
        return Center(
          child: Lottie.asset(AppImage.noData),
        );
      }
      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: AppDefaults.padding *
                  (Responsive.isMobile(context) ? 0.5 : 0.5),
              horizontal: AppDefaults.padding *
                  (Responsive.isMobile(context) ? 0.5 : 0.5),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: AppDefaults.padding,
                vertical: AppDefaults.padding
            ),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [

                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                  child: Text(
                    "Available Building List",
                    style: TextStyle(
                        fontSize: 20, color: AppColors.textColorb1),
                  ),
                ),

              ],
            ),
          ),
          if (!Responsive.isMobile(context))
            Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.symmetric(
                vertical: AppDefaults.padding *
                    (Responsive.isMobile(context) ? 1 : 1.5),
                horizontal: AppDefaults.padding *
                    (Responsive.isMobile(context) ? 1 : 1.5),
              ),
              margin: EdgeInsets.symmetric(
                vertical: AppDefaults.padding *
                    (Responsive.isMobile(context) ? 0.3 : 0.5),
                horizontal: AppDefaults.padding *
                    (Responsive.isMobile(context) ? 1 : 0.5),
              ),
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Row(
                      children: [Text("Product")],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    const Expanded(
                      child: Row(
                        children: [Text("Apartment Size")],
                      ),
                    ),
                  if (!Responsive.isMobile(context))
                    const Expanded(
                        flex: 2,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text("Price")])),
                ],
              ),
            ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: availableProjects.length,
            // Update itemCount to reflect available projects
            itemBuilder: (context, index) {
              // Filter available projects
              // final availableProjects = buildingController.projects
              //     .where((project) => project.status.toString() == "available")
              //     .toList();

              // If there are no available projects, show "No Data"
              if (availableProjects.isEmpty) {
                return const Center(
                    child: Text(
                        "No Data")); // Display only once when no available projects
              }

              // Proceed to display the available project
              final project = availableProjects[index];

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 1 : 1.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 1 : 1.5),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.3 : 0.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 1 : 0.5),
                ),
                child: InkWell(
                  onTap: () {
                    AppRoutes.push(context,
                        page: BuildingSaleSetup(
                          model: project,
                        ));
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              height: Responsive.isMobile(context) ? 60 : 100,
                              width: Responsive.isMobile(context) ? 60 : 100,
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  project.image.toString(),
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                            .expectedTotalBytes !=
                                            null
                                            ? loadingProgress
                                            .cumulativeBytesLoaded /
                                            (loadingProgress
                                                .expectedTotalBytes ??
                                                1)
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox(
                                      height: Responsive.isMobile(context)
                                          ? 60
                                          : 100,
                                      width: Responsive.isMobile(context)
                                          ? 60
                                          : 100,
                                      child: Image.asset("assets/images/building_noimage.jpg",
                                        fit: BoxFit.fill,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Responsive.isMobile(context) ? gapW8 : gapW16,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: project.prospectName.capitalize,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ]),
                                ),
                                gapH4,
                                RichText(
                                  text: TextSpan(children: [
                                    const TextSpan(
                                      text: "Project Name : ",
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: project.projectName.capitalize,
                                      style: const TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ]),
                                ),
                                gapH4,
                                if (Responsive.isMobile(context))
                                  Wrap( crossAxisAlignment: WrapCrossAlignment.center,

                                    children: [

                                          const HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedBuilding03,
                                            color: Colors.black,
                                            size: 24.0,
                                          ),
                                          gapW8,
                                          Text(
                                            "${project.appointmentSize} sft",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),

                                      gapW8,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 14),
                                        decoration: BoxDecoration(
                                          color: index % 2 == 0
                                              ? Colors.green.shade100
                                              : Colors.red.shade100,
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "${project.totalCost} BDT",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (!Responsive.isMobile(context))
                        Expanded(
                          child: Wrap(
                            children: [
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedBuilding03,
                                color: Colors.black,
                                size: 24.0,
                              ),
                              gapW8,
                              Text(
                                "${project.appointmentSize} sft",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      if (!Responsive.isMobile(context))
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 14),
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${project.totalCost} BDT",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ); // Display your project data here
            },
          )
        ],
      );
    });
  }
}
