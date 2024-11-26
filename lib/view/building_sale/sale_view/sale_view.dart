import 'package:assure_apps/configs/app_constants.dart';
import 'package:assure_apps/configs/routes.dart';
import 'package:assure_apps/view/building_sale/sale_view/sale_details_installment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/app_image.dart';
import '../../../configs/defaults.dart';
import '../../../configs/ghaps.dart';
import '../../../controllers/building_sale_controller/building_sale_controller.dart';
import '../../../responsive.dart';

class BuildingSalesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Fetch building sales data when the screen is loaded
    buildingSaleController.fetchAllBuildingSales();

    return  Obx(() {
      // Use the reactive buildingSales variable
      if (buildingSaleController.isLoadingSales.value == true) {
        return const SizedBox(
          height: 500,
          child: Center(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          )),
        );
      } else if (buildingSaleController.buildingSales.isEmpty) {
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
                    "Building Sale",
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
                        children: [Text("Deu Amount")],
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
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: buildingSaleController.buildingSales.length,
            itemBuilder: (context, index) {
              final buildingSale =
              buildingSaleController.buildingSales[index]["buildingSale"];
              final building = buildingSaleController.buildingSales[index]["building"];
              final customer = buildingSaleController.buildingSales[index]["customer"];


              return Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 1.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 1.5),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.3 : 0.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 0.5),
                ),
                child: InkWell(
                  onTap: () {
                    Get.find<BuildingSaleController>().saveBuildingSaleId( buildingSaleController.buildingSales[index]['documentId']);

                    Get.toNamed('/buildingSaleDetail', arguments:  buildingSaleController.buildingSales[index]['documentId'],);


                    // AppRoutes.push(context,
                    //     page: BuildingSaleDetailScreen(
                    //
                    //       documentId: buildingSaleController.buildingSales[index]
                    //       ['documentId'],
                    //       buildingSales: buildingSaleController.buildingSales[index],
                    //     ));
                    // AppRoutes.pushReplacement(context, page: BuildingSalesInstallmentScreen(buildingSales: controller.buildingSales[index],));
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
                                  building['image'].toString(),
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
                                  errorBuilder: (context, error, stackTrace) {
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
                                        text: building['prospectName']
                                            .toString()
                                            .capitalize,
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
                                        text: "Customer Name : ",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w400,
                                          // fontSize: 20,
                                        ),
                                      ),
                                      TextSpan(
                                        text: customer?['name'] ??
                                            'Unknown'.toString().capitalize,
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
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 14),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8)),
                                              child: Text(
                                                "${double.parse(buildingSale['dueAmount'].toString()).toStringAsFixed(2)} BDT",
                                                style:  TextStyle(
                                                  fontWeight: FontWeight.w700,  color: double.parse(buildingSale['dueAmount'].toString()) == 0.00
                                                    ? Colors.green
                                                    : Colors.redAccent,),
                                              ),
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
                                                  : Colors.blue.shade100,
                                              borderRadius:
                                              BorderRadius.circular(8)),
                                          child: Text(
                                            "${building['totalCost']} BDT",
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
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  "${double.parse(buildingSale['dueAmount'].toString()).toStringAsFixed(2)} BDT",
                                  style:  TextStyle(
                                    fontWeight: FontWeight.w700,  color: double.parse(buildingSale['dueAmount'].toString()) == 0.00
                                      ? Colors.green
                                      : Colors.redAccent,),
                                ),
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
                                      "${building['totalCost']} BDT",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ])),
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
