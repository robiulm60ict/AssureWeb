import 'package:assure_apps/configs/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/defaults.dart';
import '../../../configs/ghaps.dart';
import '../../../responsive.dart';
import '../../configs/app_image.dart';
import '../../controllers/building_sale_payment_report_controller/building_sale_payment_report_controller.dart';
import '../../widgets/custom_date_range.dart';

class SalesListReportScreen extends StatefulWidget {
  @override
  State<SalesListReportScreen> createState() => _SalesListReportScreenState();
}

class _SalesListReportScreenState extends State<SalesListReportScreen> {
  final BuildingSalePaymentReportController controller =
      Get.put(BuildingSalePaymentReportController());
  DateTime? startDate;
  DateTime? endDate;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    startDate = DateTime(now.year, now.month, 1);
    endDate = DateTime(now.year, now.month + 1, 0);
    // controller.fetchAllBuildingSalesDateRange(
    //     startDate: startDate, endDate: endDate);
  }

  Future<void> _selectDateRange(StateSetter setState) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now().subtract(const Duration(days: 7)),
        end: endDate ?? DateTime.now(),
      ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        AppRoutes.pop(context);
      });
      // Add your controller method here

      controller.fetchAllBuildingSalesDateRange(
          startDate: startDate, endDate: endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch building sales data when the screen is loaded
    // controller.fetchAllBuildingSales();

    return Obx(() {
      // Use the reactive buildingSales variable
      if (controller.isDateFilterLoading.value == true) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: AppDefaults.padding *
                  (Responsive.isMobile(context) ? 0.3 : 0.5),
              horizontal: AppDefaults.padding *
                  (Responsive.isMobile(context) ? 0.5 : 0.5),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: AppDefaults.padding, vertical: AppDefaults.padding),
            decoration: BoxDecoration(
                color: AppColors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                  child: Text(
                    "Sale Report",
                    style:
                        TextStyle(fontSize: 20, color: AppColors.textColorb1),
                  ),
                ),
                const Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTapDown: (TapDownDetails details) {
                      _showFilterMenu(context, details.globalPosition);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 248, 248, 248),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: const Color.fromARGB(38, 0, 0, 0), width: 0.3),
                      ),
                      child: const Row(
                        children: [
                          Icon(Iconsax.setting_3,
                              size: 20, color: AppColors.primary),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Filter",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: AppColors.grey),
                          )
                        ],
                      ),
                    ),
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
                      child: Wrap(
                        children: [Text("Date & Time")],
                      ),
                    ),
                  if (!Responsive.isMobile(context))
                    const Expanded(
                        flex: 2,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text("Amount")])),
                  if (!Responsive.isMobile(context))
                    const Expanded(
                        flex: 2,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text("Payment Type")])),
                ],
              ),
            ),

          controller.buildingSalesReport.isEmpty?Center(
      child: Lottie.asset(AppImage.noData),
      ):
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.buildingSalesReport.length,
            itemBuilder: (context, index) {
              final buildingSale =
                  controller.buildingSalesReport[index]["SalePaymentReport"];
              final building =
                  controller.buildingSalesReport[index]["building"];
              final customer =
                  controller.buildingSalesReport[index]["customer"];

              return Container(
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
                child: InkWell(
                  onTap: () {
                    // AppRoutes.pushReplacement(context,
                    //     page: BuildingSalesInstallmentScreen(
                    //       buildingSales: controller.buildingSales[index],
                    //     ));
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
                                    text: customer?['name'].toString() ??
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
                                  Container(
                                    // padding: const EdgeInsets.symmetric(
                                    //     vertical: 5, horizontal: 14),
                                    decoration: BoxDecoration(
                                        // color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      DateFormat("dd:MM:yyyy : hh:mm a").format(
                                          (buildingSale['DateTime']
                                                  as Timestamp)
                                              .toDate()),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                if (Responsive.isMobile(context)) gapH4,
                                if (Responsive.isMobile(context))
                                  Wrap(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 14),
                                        decoration: BoxDecoration(
                                            color: index % 2 == 0
                                                ? Colors.orange.shade100
                                                : Colors.yellow.shade100,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          buildingSale['paymentType']
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      gapW4,
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
                                          "${double.parse(buildingSale['Amount'].toString()).toStringAsFixed(2)} BDT",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (Responsive.isMobile(context)) gapH4,
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
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  DateFormat("dd:MM:yyyy : hh:mm a").format(
                                      (buildingSale['DateTime'] as Timestamp)
                                          .toDate()),
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
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      "${double.parse(buildingSale['Amount'].toString()).toStringAsFixed(2)} BDT",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ])),
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
                                            ? Colors.orange.shade100
                                            : Colors.yellow.shade100,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      buildingSale['paymentType'].toString(),
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

  void _showFilterMenu(BuildContext context, Offset offset) async {
    final screenSize = MediaQuery.of(context).size;
    final left = offset.dx;
    final top = offset.dy;
    final right = screenSize.width - left;
    final bottom = screenSize.height - top;

    await showMenu(
      color: const Color.fromARGB(255, 248, 248, 248),
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      items: [
        PopupMenuItem(
          padding: const EdgeInsets.all(0),
          enabled: false,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return  MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 10, left: 20, right: 10),
                      decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(255, 248, 248, 248),
                      ),
                      child: const Text('Filter'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomDateRange(
                                  label: "Start Date",
                                  date: startDate,
                                  onTap: () => _selectDateRange(setState),
                                ),
                                const SizedBox(height: 10),
                                CustomDateRange(
                                  label: "End Date",
                                  date: endDate,
                                  onTap: () => _selectDateRange(setState),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                startDate = DateTime(now.year, now.month, 1);
                                endDate = DateTime(now.year, now.month + 1, 0);
                                controller.fetchAllBuildingSalesDateRange(
                                    startDate: startDate, endDate: endDate);
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Clear',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
