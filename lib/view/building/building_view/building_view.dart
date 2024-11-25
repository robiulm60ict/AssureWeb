import 'package:assure_apps/configs/app_colors.dart';
import 'package:assure_apps/configs/ghaps.dart';
import 'package:assure_apps/configs/routes.dart';
import 'package:assure_apps/view/building/building_update/building_update.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';

import '../../../../configs/defaults.dart';
import '../../../../responsive.dart';
import '../../../../widgets/delete_dialog.dart';
import '../../../configs/app_constants.dart';
import '../../../configs/app_image.dart';
import '../../../widgets/snackbar.dart';
import '../../building_sale/building_sale_setup/building_sale_setup.dart';
import 'widget/view_alert_dilog.dart';

class BuildingView extends StatelessWidget {
  const BuildingView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Obx(() {
        if (buildingController.isLoading.value == true) {
          return const Center(child: CircularProgressIndicator());
        } else if (buildingController.projects.isEmpty) {
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
                  vertical: AppDefaults.padding),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8)),
              child: const Row(
                children: [

                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                    child: Text(
                      "Building List",
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
                          children: [Text("Status")],
                        ),
                      ),
                    if (!Responsive.isMobile(context))
                      const Expanded(
                        child: Wrap(
                          children: [Text("Apartment Size")],
                        ),
                      ),
                    if (!Responsive.isMobile(context))
                      const Expanded(
                          flex: 2,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Text("Price")])),
                    if (!Responsive.isMobile(context))
                      const Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text("Action")],
                          ))
                  ],
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buildingController.projects.length,
              itemBuilder: (context, index) {
                final project = buildingController.projects[index];
                return InkWell(
                  onTap: (){

                    if(project.status.toString() == "available"){
                      // AppRoutes.push(context, page: BuildingSaleSetup(model: project,));
                      Navigator.pushNamed(
                        context,
                        '/buildingSaleSetup',
                        arguments: project,
                      );


                    }else{
                      wrongSnackBar(context,title: "Building","This building not available");
                    }
                  },
                  child: Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Wrap(crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    height:
                                        Responsive.isMobile(context) ? 60 : 100,
                                    width:
                                        Responsive.isMobile(context) ? 60 : 100,
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
                                          if (loadingProgress == null) {
                                            return child;
                                          }
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return SizedBox(
                                            height: Responsive.isMobile(context)
                                                ? 60
                                                : 100,
                                            width: Responsive.isMobile(context)
                                                ? 60
                                                : 100,
                                            child: Image.asset(
                                              "assets/images/building_noimage.jpg",
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
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 14),
                                          decoration: BoxDecoration(
                                              color: project.status.toString() ==
                                                      "available"
                                                  ? Colors.green.shade200
                                                  : Colors.red.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Text(
                                            "${project.status.toString().capitalize}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      if (Responsive.isMobile(context)) gapH4,
                                      if (Responsive.isMobile(context))
                                        Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          // mainAxisAlignment: MainAxisAlignment.end,
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 14),
                                      decoration: BoxDecoration(
                                          color: project.status.toString() ==
                                                  "available"
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
                                                  : Colors.blue.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Text(
                                            "${project.totalCost} BDT",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        )
                                      ])),
                            if (!Responsive.isMobile(context))
                              Expanded(
                                  flex: 1,
                                  child: Wrap(
                                    children: [
                                      project.status.toString() == "available"
                                          ?
                                      IconButton(
                                        onPressed: () {
                                          AppRoutes.push(context,
                                              page: BuildingUpdate(
                                                model: project,
                                              ));
                                        },
                                        icon: const HugeIcon(
                                          icon:
                                              HugeIcons.strokeRoundedPencilEdit02,
                                          color: Colors.black,
                                          size: 24.0,
                                        ),
                                      ):Container(),
                                      project.status.toString() == "available"
                                          ?
                                      IconButton(
                                          onPressed: () async {
                                            bool shouldDelete =
                                                await showDeleteConfirmationDialog(
                                                    context);
                                            if (shouldDelete) {
                                              buildingController.deleteProject(
                                                  project.id, context);
                                            }
                                          },
                                          icon: const HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedDeleteThrow,
                                            color: Colors.black,
                                            size: 24.0,
                                          )):Container(),
                                      IconButton(
                                          onPressed: () async {
                                            showAlertDialog(project, context);
                                          },
                                          icon: const HugeIcon(
                                            icon: HugeIcons.strokeRoundedView,
                                            color: Colors.black,
                                            size: 24.0,
                                          )),
                                    ],
                                  ))
                          ],
                        ),
                        if (Responsive.isMobile(context))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  AppRoutes.push(context,
                                      page: BuildingUpdate(
                                        model: project,
                                      ));

                                  // context.go('/buildingUpdate', extra: project);
                                },
                                icon: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedPencilEdit02,
                                  color: Colors.black,
                                  size: 24.0,
                                ),
                              ),
                              gapW16,
                              IconButton(
                                  onPressed: () async {
                                    bool shouldDelete =
                                        await showDeleteConfirmationDialog(
                                            context);
                                    if (shouldDelete) {
                                      buildingController.deleteProject(
                                          project.id, context);
                                    }
                                  },
                                  icon: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedDeleteThrow,
                                    color: Colors.black,
                                    size: 24.0,
                                  )),
                              gapW16,
                              IconButton(
                                  onPressed: () async {
                                    showAlertDialog(project, context);
                                  },
                                  icon: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedView,
                                    color: Colors.black,
                                    size: 24.0,
                                  )),
                            ],
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      });

  }
}
