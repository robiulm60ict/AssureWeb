import 'package:assure_apps/configs/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../configs/app_colors.dart';
import '../../../configs/defaults.dart';
import '../../../configs/ghaps.dart';
import '../../../configs/pdf/pdf_invoice_api.dart';
import '../../../controllers/building_sale_controller/building_sale_controller.dart';
import '../../../responsive.dart';
import '../../../widgets/delete_dialog.dart';

class BuildingSaleDetailScreen extends StatefulWidget {
  final String documentId;
  var buildingSales = <String, dynamic>{};

  BuildingSaleDetailScreen(
      {required this.documentId, required this.buildingSales}) {
    // Fetch the building sale details when the screen is initialized
    buildingSaleController.fetchSingleBuildingSale(documentId);
  }

  @override
  State<BuildingSaleDetailScreen> createState() =>
      _BuildingSaleDetailScreenState();
}

class _BuildingSaleDetailScreenState extends State<BuildingSaleDetailScreen> {
  final BuildingSaleController buildingSaleController =
      Get.put(BuildingSaleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: const Text("Building Sale Details"),
        actions: [
          IconButton(
              onPressed: () async {
                if (kIsWeb) {
                  // savePdfWeb();
                  // Web-specific logic
                } else if (io.Platform.isAndroid || io.Platform.isIOS) {
                  await PdfInvoice.saleReportInvoice(
                      buildingSaleController.buildingSaleData, context);

                  // Mobile-specific logic
                } else {
                  await PdfInvoice.saleReportInvoice(
                      buildingSaleController.buildingSaleData, context);
                  // Desktop logic
                }
              },
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedPrinter,
                color: Colors.black,
                size: 24.0,
              )),
          (!Responsive.isMobile(context) || !Responsive.isTablet(context))
              ? const SizedBox(
                  width: 100,
                )
              : gapW4
        ],
      ),
      body: Obx(() {
        // Use Obx to listen to observable data
        if (buildingSaleController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = buildingSaleController.buildingSaleData;
        if (data.isEmpty) {
          return const Center(child: Text("No data found"));
        }

        final buildingSale = data["buildingSale"];
        final customer = data["customer"];
        final building = data["building"];

        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 0.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 2.5),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.3 : 0.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 6.5),
                ),
                child: InkWell(
                  onTap: () {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildingSaleSetup(model: project,)));
                  },
                  child: Column(
                    children: [
                      const Text(
                        "Building Information",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Container(
                                  height:
                                      Responsive.isMobile(context) ? 55 : 100,
                                  width:
                                      Responsive.isMobile(context) ? 55 : 100,
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
                                              ? 55
                                              : 100,
                                          width: Responsive.isMobile(context)
                                              ? 55
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
                                Responsive.isMobile(context) ? gapW4 : gapW16,
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
                                        text: "Project Name : ",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w400,
                                          // fontSize: 20,
                                        ),
                                      ),
                                      TextSpan(
                                        text: building['projectName']
                                            .toString()
                                            .capitalize,
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
                                                gapW4,
                                                Text(
                                                  "${building["appointmentSize"]} sqft ,",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            gapW4,
                                            Row(
                                              children: [
                                                // const HugeIcon(
                                                //   icon: HugeIcons
                                                //       .strokeRoundedMoney01,
                                                //   color: Colors.black,
                                                //   size: 24.0,
                                                // ),
                                                // gapW4,
                                                Text(
                                                  "Per sqft ${building['persqftPrice']} BDT",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            gapW4,
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 4),
                                              decoration: BoxDecoration(
                                                  color: Colors.green.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Text(
                                                "${building['totalCost']} BDT",
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
                                  const HugeIcon(
                                    icon: HugeIcons.strokeRoundedBuilding03,
                                    color: Colors.black,
                                    size: 24.0,
                                  ),
                                  gapW8,
                                  Text(
                                    "${building['appointmentSize']} sqft",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          if (!Responsive.isMobile(context))
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "Per sqft ${building['persqftPrice']} BDT",
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
                                            color: Colors.green.shade100,
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
                    ],
                  ),
                ),
              ),
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
              Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 0.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 2.5),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.3 : 0.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 6.5),
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
                                  customer['image'].toString(),
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
                                        child: Image.network(
                                          "https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/man-person-icon.png",
                                          fit: BoxFit.cover,
                                        )

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
                                    text:
                                        customer['name'].toString().capitalize,
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
                                    text: customer['address']
                                        .toString()
                                        .capitalize,
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
                                            gapW4,
                                            Text(
                                              "${customer["phone"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        gapW4,
                                        Row(
                                          children: [
                                            const HugeIcon(
                                              icon:
                                                  HugeIcons.strokeRoundedMail01,
                                              color: Colors.black,
                                              size: 18.0,
                                            ),
                                            gapW4,
                                            Text(
                                              "${customer['email'] != "" ? customer['email'] : "N/A"}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
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
                              Text(
                                "${customer["phone"]}",
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
                                  Text(
                                    "${customer['email'] != "" ? customer['email'] : "N/A"}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                ])),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 0.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 2.5),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.3 : 0.5),
                  horizontal: AppDefaults.padding *
                      (Responsive.isMobile(context) ? 0.5 : 6.5),
                ),
                child: InkWell(
                  onTap: () {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildingSaleSetup(model: project,)));
                  },
                  child: Column(
                    children: [
                      const Text(
                        "Building Sale details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      gapH16,
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Responsive.isMobile(context) ? gapW8 : gapW16,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(children: [
                                      const TextSpan(
                                        text: "Building Hand Over Date : ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          // fontSize: 20,
                                        ),
                                      ),
                                      TextSpan(
                                        text: buildingSale['handoverDate'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          // fontSize: 20,
                                        ),
                                      ),
                                    ])),
                                    gapH4,
                                    // if (Responsive.isMobile(context))
                                    //   Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.end,
                                    //       children: [
                                    //         Row(
                                    //           children: [
                                    //             const HugeIcon(
                                    //               icon: HugeIcons
                                    //                   .strokeRoundedBuilding03,
                                    //               color: Colors.black,
                                    //               size: 24.0,
                                    //             ),
                                    //             gapW8,
                                    //             Text(
                                    //               "${building["appointmentSize"]} sqft ,",
                                    //               style: const TextStyle(
                                    //                   fontWeight:
                                    //                       FontWeight.bold),
                                    //             )
                                    //           ],
                                    //         ),
                                    //         gapW8,
                                    //         Row(
                                    //           children: [
                                    //             // const HugeIcon(
                                    //             //   icon: HugeIcons
                                    //             //       .strokeRoundedMoney01,
                                    //             //   color: Colors.black,
                                    //             //   size: 24.0,
                                    //             // ),
                                    //             // gapW8,
                                    //             Text(
                                    //               "Per sqft ${building['persqftPrice']} BDT",
                                    //               style: const TextStyle(
                                    //                   fontWeight:
                                    //                       FontWeight.bold),
                                    //             )
                                    //           ],
                                    //         ),
                                    //         gapW4,
                                    //         Container(
                                    //           padding:
                                    //               const EdgeInsets.symmetric(
                                    //                   vertical: 5,
                                    //                   horizontal: 14),
                                    //           decoration: BoxDecoration(
                                    //               color: Colors.green.shade100,
                                    //               borderRadius:
                                    //                   BorderRadius.circular(8)),
                                    //           child: Text(
                                    //             "${building['totalCost']} BDT",
                                    //             style: const TextStyle(
                                    //                 fontWeight:
                                    //                     FontWeight.w700),
                                    //           ),
                                    //         )
                                    //       ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (!Responsive.isMobile(context))
                            Expanded(
                              child: RichText(
                                  text: TextSpan(children: [
                                const TextSpan(
                                  text: "Due : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    // fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: double.parse(
                                          buildingSale['dueAmount'].toString())
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    // fontSize: 20,
                                  ),
                                ),
                              ])),
                            ),
                          if (!Responsive.isMobile(context))
                            Expanded(
                              child: RichText(
                                  text: TextSpan(children: [
                                const TextSpan(
                                  text: "Booking Paid : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    // fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: double.tryParse(
                                          buildingSale['bookDownPayment']
                                              .toString())
                                      ?.toStringAsFixed(2),

                                  // Format to 2 decimal places and ensure it's a string
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ])),
                            ),
                          if (!Responsive.isMobile(context))
                            Expanded(
                              flex: 2,
                              child: RichText(
                                  text: TextSpan(children: [
                                const TextSpan(
                                  text: "Grand Total : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    // fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: buildingSale['totalCost'].toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    // fontSize: 20,
                                  ),
                                ),
                              ])),
                            ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        // Ensures the container takes full available width
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,

                          child: Scrollbar(
                            thickness: 10,
                            // thumbVisibility: true,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              width: MediaQuery.of(context).size.width,
                              // Ensures the inner container also takes full width
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                // Background color of the table
                                borderRadius: BorderRadius.circular(
                                    8), // Rounded corners for styling
                              ),
                              child: DataTable(
                                columnSpacing:
                                    Responsive.isMobile(context) ? 10.0 : null,
                                // Spacing between columns, adjust as needed
                                columns: const <DataColumn>[
                                  DataColumn(label: Text('Installment')),
                                  // Expanded to distribute width evenly
                                  DataColumn(label: Text('Amount')),
                                  DataColumn(label: Text('Date')),
                                  DataColumn(label: Text('Status')),
                                  DataColumn(label: Text('Action')),
                                ],
                                rows: List<DataRow>.generate(
                                  buildingSale['installmentPlan'].length,
                                  // Dynamically generate rows
                                  (index) {
                                    var installment =
                                        buildingSale['installmentPlan']
                                            [index]; // Get each installment data
                                    return DataRow(
                                      color: MaterialStateProperty.all(
                                        installment['status'].toString() !=
                                                "Unpaid"
                                            ? Colors.green.withOpacity(
                                                0.05) // Paid rows in light green
                                            : Colors.red.withOpacity(
                                                0.05), // Unpaid rows in light red
                                      ),
                                      cells: <DataCell>[
                                        DataCell(Text(
                                            '${installment['id']} Installment')),
                                        // Installment ID
                                        DataCell(
                                            Text('${installment['amount']}')),
                                        // Installment Amount
                                        DataCell(
                                            Text('${installment['dueDate']}')),
                                        // Due Date
                                        DataCell(
                                            Text('${installment['status']}')),
                                        // Payment Status
                                        DataCell(
                                          installment['status'].toString() !=
                                                  "Unpaid"
                                              ? const Text(
                                                  'Done',
                                                  textAlign: TextAlign
                                                      .center, // Center the text within the available space
                                                ) // Mark as "Done" if paid
                                              : IconButton(
                                                  onPressed: () async {
                                                    bool shouldDelete =
                                                        await showConfirmConfirmationDialog(
                                                            context);
                                                    if (shouldDelete) {
                                                      // Update installment to "Paid"
                                                      buildingSaleController
                                                          .updateInstallmentPlanStatus(
                                                        widget.buildingSales[
                                                                'documentId']
                                                            .toString(),
                                                        buildingSale[
                                                            'buildingId'],
                                                        installment['id'],
                                                        "Paid",
                                                        context,
                                                        double.parse(buildingSale[
                                                                        'dueAmount']
                                                                    ?.toString() ??
                                                                '0') -
                                                            double.parse(installment[
                                                                        'amount']
                                                                    .toString() ??
                                                                "0"),
                                                      );

                                                      // Create sale report after payment
                                                      buildingSaleController
                                                          .createSaleReport(
                                                        context,
                                                        buildingId: buildingSale[
                                                                'buildingId']
                                                            .toString(),
                                                        customerId: buildingSale[
                                                                'customerId']
                                                            .toString(),
                                                        amount: buildingSale[
                                                                'dueAmount']
                                                            ?.toString(),
                                                        paymentType:
                                                            "Installment",
                                                      );
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.check_circle_outline,
                                                    color: Colors.black,
                                                    size: 24.0,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
