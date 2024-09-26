import 'package:assure_apps/configs/app_colors.dart';
import 'package:assure_apps/configs/ghaps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../configs/app_constants.dart';
import '../../../../configs/defaults.dart';
import '../../../../responsive.dart';
import '../../building_sale_setup/building_sale_setup.dart';

class SaleBuildingListView extends StatelessWidget {
  const SaleBuildingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).go('/entry-point');
              // GoRouter.of(context).pop(); // Navigate back
            },
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft02,
              color: Colors.black,
              size: 24.0,
            ),
          ),
          backgroundColor: AppColors.bg,
          title: const Text('Available Building ')),
      body: Obx(() {
        if (buildingController.projects.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: [
            if (!Responsive.isMobile(context))
              Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 1 : 0.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 1 : 2.5),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.3 : 0.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 1 : 6.5),
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
                          children: [Text("Status")],
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
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buildingController.projects.length,
              itemBuilder: (context, index) {
                final project = buildingController.projects[index];
                return project.status.toString()=="available"?Container(
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(
                    vertical: AppDefaults.padding *
                        (Responsive.isMobile(context) ? 1 : 0.5),
                    horizontal: AppDefaults.padding *
                        (Responsive.isMobile(context) ? 1 : 2.5),
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: AppDefaults.padding *
                        (Responsive.isMobile(context) ? 0.3 : 0.5),
                    horizontal: AppDefaults.padding *
                        (Responsive.isMobile(context) ? 1 : 6.5),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BuildingSaleSetup(
                                    model: project,
                                  )));
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
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
                                      return Container(
                                        height: Responsive.isMobile(context)
                                            ? 60
                                            : 100,
                                        width: Responsive.isMobile(context)
                                            ? 60
                                            : 100,
                                        child: const Icon(Icons.error,
                                            color: Colors.red),
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
                                        // fontSize: 20,
                                      ),
                                    ),
                                  ])),
                                  gapH4,
                                  RichText(
                                      text: TextSpan(children: [
                                    const TextSpan(
                                      text: "Project Name : ",
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w400,
                                        // fontSize: 20,
                                      ),
                                    ),
                                    TextSpan(
                                      text: project.projectName.capitalize,
                                      style: const TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w400,
                                        // fontSize: 20,
                                      ),
                                    ),
                                  ])),
                                  gapH4,
                                  if (Responsive.isMobile(context))
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              const HugeIcon(
                                                icon: HugeIcons
                                                    .strokeRoundedBuilding03,
                                                color: Colors.black,
                                                size: 24.0,
                                              ),
                                              gapW8,
                                              Text(
                                                "${project.appointmentSize} sqft",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
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
                                                    BorderRadius.circular(8)),
                                            child: Text(
                                              "\$${project.totalCost}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )
                                        ]),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!Responsive.isMobile(context))
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 14),
                                  decoration: BoxDecoration(
                                      color:project.status.toString()=="available"
                                          ? Colors.green.shade200
                                          : Colors.red.shade200,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    "${project.status.toString().capitalize}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                          ),
                        if (!Responsive.isMobile(context))
                          Expanded(
                            child: Row(
                              children: [
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedBuilding03,
                                  color: Colors.black,
                                  size: 24.0,
                                ),
                                gapW8,
                                Text(
                                  "${project.appointmentSize} sqft",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
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
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        "${project.totalCost} BDT",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ])),
                      ],
                    ),
                  ),
                ):Container();
              },
            ),
          ],
        );
      }),
    );
  }
}
