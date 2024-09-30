import 'package:assure_apps/configs/routes.dart';
import 'package:assure_apps/view/building/building_view/building_view.dart';
import 'package:assure_apps/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/app_constants.dart';
import '../../../configs/defaults.dart';
import '../../../configs/ghaps.dart';
import '../../../widgets/section_title.dart';
import '../../building_sale/building_sale_setup/building_sale_setup.dart';
import '../../building_sale/sale_building_list/building_view/sale_building_view.dart';
import 'popular_product_item.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
            () =>buildingController.isLoading.value==true?AppShimmerProduct(): ListView.builder(
              itemCount: buildingController.projects.length<3?buildingController.projects.length:4,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                final project = buildingController.projects[index];
                return PopularProductItem(
                        name: project.projectName,
                        price: project.totalCost.toString() ?? "",
                        imageSrc: project.image.toString(),
                        isActive: project.status.toString(),
                        onPressed: () {
                          AppRoutes.push(context, page: BuildingSaleSetup(model: project,));

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
                AppRoutes.push(context, page: const BuildingView());


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
