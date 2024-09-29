import 'package:assure_apps/configs/app_colors.dart';
import 'package:assure_apps/configs/ghaps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../configs/app_constants.dart';
import '../../../../configs/defaults.dart';
import '../../../../responsive.dart';

class CustomerListView extends StatelessWidget {
  const CustomerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
            Navigator.pop(context);
              // GoRouter.of(context).pop(); // Navigate back
            },
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft02,
              color: Colors.black,
              size: 24.0,
            ),
          ),
          backgroundColor: AppColors.bg,
          title: const Text('Customer ')),
      body: Obx(() {
        if (customerController.customers.isEmpty) {
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
                        children: [Text("Customer Information")],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const Expanded(
                        child: Row(
                          children: [Text("Phone")],
                        ),
                      ),
                    if (!Responsive.isMobile(context))
                      const Expanded(
                          flex: 2,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Text("Email")])),
                  ],
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customerController.customers.length,
              itemBuilder: (context, index) {
                final customer = customerController.customers[index];
                return             Container(
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
                      //   Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildingSaleSetup(model: project,)));
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                height: Responsive.isMobile(context) ? 50 : 100,
                                width: Responsive.isMobile(context) ? 50 : 100,
                                decoration: BoxDecoration(
                                  color: AppColors.bg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    customer.image.toString(),
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              (loadingProgress.expectedTotalBytes ?? 1)
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                        fit: BoxFit.cover,
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
                                          text: customer.name.toString().capitalize,
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
                                          text: "Address : ",
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w400,
                                            // fontSize: 20,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                          customer.address.toString().capitalize,
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
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              const HugeIcon(
                                                icon: HugeIcons.strokeRoundedCall,
                                                color: Colors.black,
                                                size: 18.0,
                                              ),
                                              gapW8,
                                              Text(
                                                customer.phone,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          gapW8,
                                        ]),
                                  if (Responsive.isMobile(context))
                                    gapH4,
                                  if (Responsive.isMobile(context))
                                  Row(
                                    children: [
                                      const HugeIcon(
                                        icon: HugeIcons.strokeRoundedMail01,
                                        color: Colors.black,
                                        size: 18.0,
                                      ),
                                      gapW8,
                                      Text(
                                        customer.email != "" ? customer.email : "N/A",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!Responsive.isMobile(context))
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  customer.phone,
                                  style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                    Text(
                                      customer.email != "" ? customer.email : "N/A",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
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
