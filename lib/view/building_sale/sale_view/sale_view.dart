import 'package:assure_apps/view/building_sale/sale_view/sale_details_installment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/defaults.dart';
import '../../../configs/ghaps.dart';
import '../../../controllers/building_sale_controller/building_sale_controller.dart';
import '../../../responsive.dart';

class BuildingSalesScreen extends StatelessWidget {
  final BuildingSaleController controller = Get.put(BuildingSaleController());

  @override
  Widget build(BuildContext context) {
    // Fetch building sales data when the screen is loaded
    controller.fetchAllBuildingSales();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: const Text("Building Sales"),
      ),
      body: Obx(() {
        // Use the reactive buildingSales variable
        if (controller.buildingSales.isEmpty) {
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
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.buildingSales.length,
              itemBuilder: (context, index) {
                final buildingSale = controller.buildingSales[index]["buildingSale"];
                final building = controller.buildingSales[index]["building"];
                final customer = controller.buildingSales[index]["customer"];
                //
                // // Log the data for debugging
                // print("Building Sale: $buildingSale");
                // print("Building: $building");
                // print("Customer: $customer");
                //
                // // Safeguard against null values
                // final projectName = building?['projectName'] ?? 'Unknown';
                // final totalCost = buildingSale?['totalCost']?.toString() ?? '0';
                // final status = buildingSale?['status'] ?? 'Unknown';
                // final customerName = customer?['name'] ?? 'Unknown';
                //
                // return ListTile(
                //   title: Text("Building Sale ID: $projectName"),
                //   subtitle: Text(
                //     "Customer Name: $customerName\n"
                //         "Total Cost: $totalCost\n"
                //         "Status: $status",
                //   ),
                // );


              return  Container(
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
                    onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildingSalesInstallmentScreen(buildingSales: controller.buildingSales[index],)));

                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
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
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return SizedBox(
                                        height: Responsive.isMobile(context)
                                            ? 60
                                            : 100,
                                        width: Responsive.isMobile(context)
                                            ? 60
                                            : 100,
                                        child:   Image.network(
                                          "https://img.freepik.com/free-photo/observation-urban-building-business-steel_1127-2397.jpg?t=st=1727338313~exp=1727341913~hmac=2e09cc7c51c7da785d7456f52aa5214acafe820f751d1e53d1a75e3cf4b69139&w=1380",fit: BoxFit.fill,),
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
                                          text: building['prospectName'].toString().capitalize,
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
                                          text:customer?['name'] ?? 'Unknown'.toString().capitalize,
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
                                                    color
                                                        : Colors.red.shade100,
                                                    borderRadius:
                                                    BorderRadius.circular(8)),
                                                child: Text(
                                                  "${buildingSale['dueAmount']} BDT",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                              )


                                            ],
                                          ),
                                          gapW8,
                                          Container(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 14),
                                            decoration: BoxDecoration(
                                                color: index % 2 == 0
                                                    ? Colors.green.shade100
                                                    : Colors.blue.shade100,
                                                borderRadius:
                                                BorderRadius.circular(8)),
                                            child: Text(
                                              "\$${building['totalCost']} BDT",
                                              style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight.w700),
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
                                      color: Colors.red.shade100,
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  child: Text(
                                    "${buildingSale['dueAmount']} BDT",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
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
      }),
    );
  }
}
