import 'package:assure_apps/configs/routes.dart';
import 'package:assure_apps/view/building/building_view/building_view.dart';
import 'package:assure_apps/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/app_constants.dart';
import '../../../configs/defaults.dart';
import '../../../configs/ghaps.dart';
import '../../../controllers/building_controller/building_controller.dart';
import '../../../widgets/section_title.dart';
import '../../../widgets/snackbar.dart';
import '../../building_sale/building_sale_setup/building_sale_setup.dart';
import 'popular_product_item.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: AppColors.bgSecondayLight,
        borderRadius: BorderRadius.all(
          Radius.circular(AppDefaults.borderRadius),
        ),
      ),
      padding: const EdgeInsets.all(AppDefaults.padding * 0.75),
      child: Column(
        children: [
          gapH8,
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDefaults.padding * 0.5,
            ),
            child: SectionTitle(
              title: "Popular Building",
              color: AppColors.secondaryLavender,
            ),
          ),
          gapH16,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDefaults.padding * 0.5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Products', style: Theme.of(context).textTheme.labelSmall),
                Text('Price', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          gapH8,
          const Divider(),
          Obx(
            () =>buildingController.isLoading.value==true?const AppShimmerProduct(): ListView.builder(
              itemCount: buildingController.projects.length<7?buildingController.projects.length:7,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                final project = buildingController.projects[index];
                return PopularProductItem(
                        name: project.projectName,
                        price: project.totalCost.toString(),
                        imageSrc: project.image.toString(),
                        isActive: project.status.toString(),
                        onPressed: () {
                          if(project.status.toString() == "available"){
                            Get.find<BuildingController>().saveBuildingModelId(project.id);
                            Get.toNamed('/buildingSaleSetup', arguments: project);
                            // AppRoutes.push(context, page: BuildingSaleSetup(model: project,));

                          }else{
                            wrongSnackBar(context,title: "Building","This building not available");
                          }

                        },
                      )
                    ;
              },
            ),
          ),
          gapH16,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDefaults.padding * 0.5,
            ),
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                dashbordScreenController.dataIndex.value=2;
                // AppRoutes.push(context, page: const BuildingView());


              },
              child: Text(
                "All Building",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          gapH8,
        ],
      ),
    );
  }
}
