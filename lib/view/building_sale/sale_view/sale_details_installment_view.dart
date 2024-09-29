import 'package:assure_apps/configs/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/defaults.dart';
import '../../../configs/ghaps.dart';
import '../../../controllers/building_sale_controller/building_sale_controller.dart';
import '../../../responsive.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      appBar: AppBar(
        title: Text("Building Sale Details"),
      ),
      body: Obx(() {
        // Use Obx to listen to observable data
        if (buildingSaleController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final data = buildingSaleController.buildingSaleData;
        if (data.isEmpty) {
          return Center(child: Text("No data found"));
        }

        final buildingSale = data["buildingSale"];
        final customer = data["customer"];
        final building = data["building"];

        return ListView(
          children: [
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
              child: InkWell(
                onTap: () {
                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildingSaleSetup(model: project,)));
                },
                child: Column(
                  children: [
                    const Text(
                      "Product Information",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
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
                                        child:   Image.network(
                                          "https://img.freepik.com/free-photo/observation-urban-building-business-steel_1127-2397.jpg?t=st=1727338313~exp=1727341913~hmac=2e09cc7c51c7da785d7456f52aa5214acafe820f751d1e53d1a75e3cf4b69139&w=1380",fit: BoxFit.fill,),
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
                                              gapW8,
                                              Text(
                                                "${building["appointmentSize"]} sqft",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          gapW8,
                                          Row(
                                            children: [
                                              const HugeIcon(
                                                icon: HugeIcons
                                                    .strokeRoundedMoney01,
                                                color: Colors.black,
                                                size: 24.0,
                                              ),
                                              gapW8,
                                              Text(
                                                "${building['perSftPrice']} BDT",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          gapW8,
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 4),
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
                                  "Per sqft ${building['perSftPrice']} BDT",
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
                                customer['image'].toString(),
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                                      ));
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
                                  text: customer['name'].toString().capitalize,
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
                                      customer['address'].toString().capitalize,
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
                                            "${customer["phone"]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      gapW8,
                                      Row(
                                        children: [
                                          const HugeIcon(
                                            icon: HugeIcons.strokeRoundedMail01,
                                            color: Colors.black,
                                            size: 18.0,
                                          ),
                                          gapW8,
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
                child: Column(
                  children: [
                    const Text(
                      "Building Sale Information",
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
                                      text: DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                              buildingSale['handoverDate'])),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
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
                                                "${building["appointmentSize"]} sqft",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          gapW8,
                                          Row(
                                            children: [
                                              const HugeIcon(
                                                icon: HugeIcons
                                                    .strokeRoundedMoney01,
                                                color: Colors.black,
                                                size: 24.0,
                                              ),
                                              gapW8,
                                              Text(
                                                "${building['perSftPrice']} BDT",
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
                                                color: Colors.green.shade100,
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
                                text:double.parse( buildingSale['dueAmount'].toString()).toStringAsFixed(2),
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
                                text: double.tryParse( buildingSale['bookDownPayment'].toString()??"")?.toStringAsFixed(2),

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
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // padding: EdgeInsets.symmetric(
                          //   vertical: AppDefaults.padding *
                          //       (Responsive.isMobile(context) ? 0.5 : 0.5),
                          //   horizontal: AppDefaults.padding *
                          //       (Responsive.isMobile(context) ? 1 : 2.5),
                          // ),
                          // margin: EdgeInsets.symmetric(
                          //   horizontal: AppDefaults.padding *
                          //       (Responsive.isMobile(context) ? 0.5 : 6.5),
                          // ),
                          child: DataTable(
                            columnSpacing:
                                Responsive.isMobile(context) ? 20 : null,
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Installment')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: List<DataRow>.generate(
                              buildingSale['installmentPlan'].length,
                              (index) {
                                var installment =
                                    buildingSale['installmentPlan'][index];
                                return DataRow(
                                  color: installment['status'].toString() !=
                                          "Unpaid"
                                      ? WidgetStateProperty.all(
                                          Colors.green.withOpacity(0.05))
                                      : WidgetStateProperty.all(
                                          Colors.red.withOpacity(0.05)),
                                  cells: <DataCell>[
                                    DataCell(Center(
                                        child: Text(
                                            '${installment['id']} Installment'))),
                                    DataCell(Center(
                                        child:
                                            Text('${installment['amount']}'))),
                                    DataCell(Center(
                                        child:
                                            Text('${installment['dueDate']}'))),
                                    DataCell(Center(
                                        child:
                                            Text('${installment['status']}'))),
                                    DataCell(Center(
                                        child:
                                            installment['status'].toString() !=
                                                    "Unpaid"
                                                ? const Text('Done')
                                                : IconButton(
                                                    onPressed: () {


                                                      buildingSaleController.updateInstallmentPlanStatus(
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
                                                                  "0"));


                                                      buildingSaleController.createSaleReport(
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
                                                              "Installment");
                                                    },
                                                    icon: const HugeIcon(
                                                      icon: HugeIcons
                                                          .strokeRoundedCheckmarkCircle03,
                                                      color: Colors.black,
                                                      size: 24.0,
                                                    )))),
                                  ],
                                );
                              },
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// class BuildingSalesInstallmentScreen extends StatefulWidget {
//   BuildingSalesInstallmentScreen({super.key, required this.buildingSales});
//
//   var buildingSales = <String, dynamic>{};
//
//   @override
//   State<BuildingSalesInstallmentScreen> createState() =>
//       _BuildingSalesInstallmentScreenState();
// }
//
// class _BuildingSalesInstallmentScreenState
//     extends State<BuildingSalesInstallmentScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final buildingSale = widget.buildingSales["buildingSale"];
//     final building = widget.buildingSales["building"];
//     final customer = widget.buildingSales["customer"];
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: AppColors.bg,
//           title: const Text("Building Sales Installment"),
//         ),
//         body: ListView(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.circular(8)),
//               padding: EdgeInsets.symmetric(
//                 vertical: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 1 : 0.5),
//                 horizontal: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 1 : 2.5),
//               ),
//               margin: EdgeInsets.symmetric(
//                 vertical: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 0.3 : 0.5),
//                 horizontal: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 1 : 6.5),
//               ),
//               child: InkWell(
//                 onTap: () {
//                   //   Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildingSaleSetup(model: project,)));
//                 },
//                 child: Column(
//                   children: [
//                     const Text(
//                       "Product Information",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: Row(
//                             children: [
//                               Container(
//                                 height: Responsive.isMobile(context) ? 60 : 100,
//                                 width: Responsive.isMobile(context) ? 60 : 100,
//                                 decoration: BoxDecoration(
//                                   color: AppColors.bg,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.network(
//                                     building['image'].toString(),
//                                     fit: BoxFit.cover,
//                                     loadingBuilder:
//                                         (context, child, loadingProgress) {
//                                       if (loadingProgress == null) {
//                                         return child;
//                                       }
//                                       return Center(
//                                         child: CircularProgressIndicator(
//                                           value: loadingProgress
//                                                       .expectedTotalBytes !=
//                                                   null
//                                               ? loadingProgress
//                                                       .cumulativeBytesLoaded /
//                                                   (loadingProgress
//                                                           .expectedTotalBytes ??
//                                                       1)
//                                               : null,
//                                         ),
//                                       );
//                                     },
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return SizedBox(
//                                         height: Responsive.isMobile(context)
//                                             ? 60
//                                             : 100,
//                                         width: Responsive.isMobile(context)
//                                             ? 60
//                                             : 100,
//                                         child: const Icon(Icons.error,
//                                             color: Colors.red),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                               Responsive.isMobile(context) ? gapW8 : gapW16,
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   RichText(
//                                       text: TextSpan(children: [
//                                     TextSpan(
//                                       text: building['prospectName']
//                                           .toString()
//                                           .capitalize,
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w600,
//                                         // fontSize: 20,
//                                       ),
//                                     ),
//                                   ])),
//                                   gapH4,
//                                   RichText(
//                                       text: TextSpan(children: [
//                                     const TextSpan(
//                                       text: "Project Name : ",
//                                       style: TextStyle(
//                                         color: Colors.black45,
//                                         fontWeight: FontWeight.w400,
//                                         // fontSize: 20,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: building['projectName']
//                                           .toString()
//                                           .capitalize,
//                                       style: const TextStyle(
//                                         color: Colors.black45,
//                                         fontWeight: FontWeight.w400,
//                                         // fontSize: 20,
//                                       ),
//                                     ),
//                                   ])),
//                                   gapH4,
//                                   if (Responsive.isMobile(context))
//                                     Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               const HugeIcon(
//                                                 icon: HugeIcons
//                                                     .strokeRoundedBuilding03,
//                                                 color: Colors.black,
//                                                 size: 24.0,
//                                               ),
//                                               gapW8,
//                                               Text(
//                                                 "${building["appointmentSize"]} sqft",
//                                                 style: const TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             ],
//                                           ),
//                                           gapW8,
//                                           Row(
//                                             children: [
//                                               const HugeIcon(
//                                                 icon: HugeIcons
//                                                     .strokeRoundedMoney01,
//                                                 color: Colors.black,
//                                                 size: 24.0,
//                                               ),
//                                               gapW8,
//                                               Text(
//                                                 "${building['perSftPrice']} BDT",
//                                                 style: const TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             ],
//                                           ),
//                                           gapW8,
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 5, horizontal: 14),
//                                             decoration: BoxDecoration(
//                                                 color: Colors.green.shade100,
//                                                 borderRadius:
//                                                     BorderRadius.circular(8)),
//                                             child: Text(
//                                               "${building['totalCost']} BDT",
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.w700),
//                                             ),
//                                           )
//                                         ]),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (!Responsive.isMobile(context))
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 const HugeIcon(
//                                   icon: HugeIcons.strokeRoundedBuilding03,
//                                   color: Colors.black,
//                                   size: 24.0,
//                                 ),
//                                 gapW8,
//                                 Text(
//                                   "${building['appointmentSize']} sqft",
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold),
//                                 )
//                               ],
//                             ),
//                           ),
//                         if (!Responsive.isMobile(context))
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 const HugeIcon(
//                                   icon: HugeIcons.strokeRoundedMoney01,
//                                   color: Colors.black,
//                                   size: 24.0,
//                                 ),
//                                 gapW8,
//                                 Text(
//                                   "${building['perSftPrice']} BDT",
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold),
//                                 )
//                               ],
//                             ),
//                           ),
//                         if (!Responsive.isMobile(context))
//                           Expanded(
//                               flex: 2,
//                               child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 5, horizontal: 14),
//                                       decoration: BoxDecoration(
//                                           color: Colors.green.shade100,
//                                           borderRadius:
//                                               BorderRadius.circular(8)),
//                                       child: Text(
//                                         "${building['totalCost']} BDT",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                     )
//                                   ])),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (!Responsive.isMobile(context))
//               Container(
//                 decoration: BoxDecoration(
//                     color: AppColors.white,
//                     borderRadius: BorderRadius.circular(8)),
//                 padding: EdgeInsets.symmetric(
//                   vertical: AppDefaults.padding *
//                       (Responsive.isMobile(context) ? 1 : 0.5),
//                   horizontal: AppDefaults.padding *
//                       (Responsive.isMobile(context) ? 1 : 2.5),
//                 ),
//                 margin: EdgeInsets.symmetric(
//                   vertical: AppDefaults.padding *
//                       (Responsive.isMobile(context) ? 0.3 : 0.5),
//                   horizontal: AppDefaults.padding *
//                       (Responsive.isMobile(context) ? 1 : 6.5),
//                 ),
//                 child: Row(
//                   children: [
//                     const Expanded(
//                       flex: 3,
//                       child: Row(
//                         children: [Text("Customer Information")],
//                       ),
//                     ),
//                     if (!Responsive.isMobile(context))
//                       const Expanded(
//                         child: Row(
//                           children: [Text("Phone")],
//                         ),
//                       ),
//                     if (!Responsive.isMobile(context))
//                       const Expanded(
//                           flex: 2,
//                           child: Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [Text("Email")])),
//                   ],
//                 ),
//               ),
//             Container(
//               decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.circular(8)),
//               padding: EdgeInsets.symmetric(
//                 vertical: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 1 : 0.5),
//                 horizontal: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 1 : 2.5),
//               ),
//               margin: EdgeInsets.symmetric(
//                 vertical: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 0.3 : 0.5),
//                 horizontal: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 1 : 6.5),
//               ),
//               child: InkWell(
//                 onTap: () {
//                   //   Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildingSaleSetup(model: project,)));
//                 },
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: Row(
//                         children: [
//                           Container(
//                             height: Responsive.isMobile(context) ? 50 : 100,
//                             width: Responsive.isMobile(context) ? 50 : 100,
//                             decoration: BoxDecoration(
//                               color: AppColors.bg,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.network(
//                                 customer['image'].toString(),
//                                 fit: BoxFit.cover,
//                                 loadingBuilder:
//                                     (context, child, loadingProgress) {
//                                   if (loadingProgress == null) {
//                                     return child;
//                                   }
//                                   return Center(
//                                     child: CircularProgressIndicator(
//                                       value:
//                                           loadingProgress.expectedTotalBytes !=
//                                                   null
//                                               ? loadingProgress
//                                                       .cumulativeBytesLoaded /
//                                                   (loadingProgress
//                                                           .expectedTotalBytes ??
//                                                       1)
//                                               : null,
//                                     ),
//                                   );
//                                 },
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return SizedBox(
//                                       height: Responsive.isMobile(context)
//                                           ? 60
//                                           : 100,
//                                       width: Responsive.isMobile(context)
//                                           ? 60
//                                           : 100,
//                                       child: Image.network(
//                                         "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
//                                         fit: BoxFit.cover,
//                                       ));
//                                 },
//                               ),
//                             ),
//                           ),
//                           Responsive.isMobile(context) ? gapW8 : gapW16,
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               RichText(
//                                   text: TextSpan(children: [
//                                 TextSpan(
//                                   text: customer['name'].toString().capitalize,
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                     // fontSize: 20,
//                                   ),
//                                 ),
//                               ])),
//                               gapH4,
//                               RichText(
//                                   text: TextSpan(children: [
//                                 const TextSpan(
//                                   text: "Address : ",
//                                   style: TextStyle(
//                                     color: Colors.black45,
//                                     fontWeight: FontWeight.w400,
//                                     // fontSize: 20,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text:
//                                       customer['address'].toString().capitalize,
//                                   style: const TextStyle(
//                                     color: Colors.black45,
//                                     fontWeight: FontWeight.w400,
//                                     // fontSize: 20,
//                                   ),
//                                 ),
//                               ])),
//                               gapH4,
//                               if (Responsive.isMobile(context))
//                                 Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           const HugeIcon(
//                                             icon: HugeIcons.strokeRoundedCall,
//                                             color: Colors.black,
//                                             size: 18.0,
//                                           ),
//                                           gapW8,
//                                           Text(
//                                             "${customer["phone"]}",
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           )
//                                         ],
//                                       ),
//                                       gapW8,
//                                       Row(
//                                         children: [
//                                           const HugeIcon(
//                                             icon: HugeIcons.strokeRoundedMail01,
//                                             color: Colors.black,
//                                             size: 18.0,
//                                           ),
//                                           gapW8,
//                                           Text(
//                                             "${customer['email'] == "" ? customer['email'] : "N/A"}",
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           )
//                                         ],
//                                       ),
//                                     ]),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (!Responsive.isMobile(context))
//                       Expanded(
//                         child: Row(
//                           children: [
//                             Text(
//                               "${customer["phone"]}",
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         ),
//                       ),
//                     if (!Responsive.isMobile(context))
//                       Expanded(
//                           flex: 2,
//                           child: Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   "${customer['email'] == "" ? customer['email'] : "N/A"}",
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold),
//                                 )
//                               ])),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.circular(8)),
//               padding: EdgeInsets.symmetric(
//                 vertical: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 1 : 0.5),
//                 horizontal: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 1 : 2.5),
//               ),
//               margin: EdgeInsets.symmetric(
//                 vertical: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 0.3 : 0.5),
//                 horizontal: AppDefaults.padding *
//                     (Responsive.isMobile(context) ? 1 : 6.5),
//               ),
//               child: InkWell(
//                 onTap: () {
//                   //   Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildingSaleSetup(model: project,)));
//                 },
//                 child: Column(
//                   children: [
//                     const Text(
//                       "Building Sale Information",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     gapH16,
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: Row(
//                             children: [
//                               Responsive.isMobile(context) ? gapW8 : gapW16,
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   RichText(
//                                       text: TextSpan(children: [
//                                     const TextSpan(
//                                       text: "Building Hand Over Date : ",
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w500,
//                                         // fontSize: 20,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: DateFormat('dd-MM-yyyy').format(
//                                           DateTime.parse(
//                                               buildingSale['handoverDate'])),
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w600,
//                                         // fontSize: 20,
//                                       ),
//                                     ),
//                                   ])),
//                                   gapH4,
//                                   if (Responsive.isMobile(context))
//                                     Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               const HugeIcon(
//                                                 icon: HugeIcons
//                                                     .strokeRoundedBuilding03,
//                                                 color: Colors.black,
//                                                 size: 24.0,
//                                               ),
//                                               gapW8,
//                                               Text(
//                                                 "${building["appointmentSize"]} sqft",
//                                                 style: const TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             ],
//                                           ),
//                                           gapW8,
//                                           Row(
//                                             children: [
//                                               const HugeIcon(
//                                                 icon: HugeIcons
//                                                     .strokeRoundedMoney01,
//                                                 color: Colors.black,
//                                                 size: 24.0,
//                                               ),
//                                               gapW8,
//                                               Text(
//                                                 "${building['perSftPrice']} BDT",
//                                                 style: const TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             ],
//                                           ),
//                                           gapW8,
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 5, horizontal: 14),
//                                             decoration: BoxDecoration(
//                                                 color: Colors.green.shade100,
//                                                 borderRadius:
//                                                     BorderRadius.circular(8)),
//                                             child: Text(
//                                               "${building['totalCost']} BDT",
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.w700),
//                                             ),
//                                           )
//                                         ]),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (!Responsive.isMobile(context))
//                           Expanded(
//                             child: RichText(
//                                 text: TextSpan(children: [
//                               const TextSpan(
//                                 text: "Due : ",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                   // fontSize: 20,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: buildingSale['dueAmount'].toString(),
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                   // fontSize: 20,
//                                 ),
//                               ),
//                             ])),
//                           ),
//                         if (!Responsive.isMobile(context))
//                           Expanded(
//                             child: RichText(
//                                 text: TextSpan(children: [
//                               const TextSpan(
//                                 text: "Booking Paid : ",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                   // fontSize: 20,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: ((double.tryParse(
//                                                 buildingSale['totalCost']
//                                                         ?.toString() ??
//                                                     '0') ??
//                                             0.0) -
//                                         (double.tryParse(
//                                                 buildingSale['dueAmount']
//                                                         ?.toString() ??
//                                                     '0') ??
//                                             0.0))
//                                     .toStringAsFixed(2),
//                                 // Format to 2 decimal places and ensure it's a string
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               )
//                             ])),
//                           ),
//                         if (!Responsive.isMobile(context))
//                           Expanded(
//                             flex: 2,
//                             child: RichText(
//                                 text: TextSpan(children: [
//                               const TextSpan(
//                                 text: "Grand Total : ",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                   // fontSize: 20,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: buildingSale['totalCost'].toString(),
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                   // fontSize: 20,
//                                 ),
//                               ),
//                             ])),
//                           ),
//                       ],
//                     ),
//                     SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: AppColors.white,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             vertical: AppDefaults.padding *
//                                 (Responsive.isMobile(context) ? 0.5 : 0.5),
//                             horizontal: AppDefaults.padding *
//                                 (Responsive.isMobile(context) ? 1 : 2.5),
//                           ),
//                           margin: EdgeInsets.symmetric(
//                             horizontal: AppDefaults.padding *
//                                 (Responsive.isMobile(context) ? 0.5 : 6.5),
//                           ),
//                           child: DataTable(
//                             columnSpacing:
//                                 Responsive.isMobile(context) ? 20 : null,
//                             columns: const <DataColumn>[
//                               DataColumn(label: Text('Installment')),
//                               DataColumn(label: Text('Amount')),
//                               DataColumn(label: Text('Date')),
//                               DataColumn(label: Text('Status')),
//                               DataColumn(label: Text('Action')),
//                             ],
//                             rows: List<DataRow>.generate(
//                               buildingSale['installmentPlan'].length,
//                               (index) {
//                                 var installment =
//                                     buildingSale['installmentPlan'][index];
//                                 return DataRow(
//                                   color: installment['status'].toString() !=
//                                           "Unpaid"
//                                       ? WidgetStateProperty.all(
//                                           Colors.green.withOpacity(0.05))
//                                       : WidgetStateProperty.all(
//                                           Colors.red.withOpacity(0.05)),
//                                   cells: <DataCell>[
//                                     DataCell(Center(
//                                         child: Text(
//                                             '${installment['id']} Installment'))),
//                                     DataCell(Center(
//                                         child:
//                                             Text('${installment['amount']}'))),
//                                     DataCell(Center(
//                                         child:
//                                             Text('${installment['dueDate']}'))),
//                                     DataCell(Center(
//                                         child:
//                                             Text('${installment['status']}'))),
//                                     DataCell(Center(
//                                         child: installment['status']
//                                                     .toString() !=
//                                                 "Unpaid"
//                                             ? const Text('Done')
//                                             : IconButton(
//                                                 onPressed: () {
//                                                   //  buildingSaleController.updateInstallmentPlanStatus(, installment['id'], "Paid");
//                                                   // print(widget.buildingSales[
//                                                   //         'documentId']
//                                                   //     .toString());
//                                                   // print(installment['id']
//                                                   //     .toString());
//
//                                                   buildingSaleController.updateInstallmentPlanStatus(
//                                                       widget.buildingSales[
//                                                               'documentId']
//                                                           .toString(),
//                                                       installment['id'],
//                                                       "Paid",
//                                                       context,
//                                                       double.parse(buildingSale[
//                                                                       'dueAmount']
//                                                                   ?.toString() ??
//                                                               '0') -
//                                                           double.parse(installment[
//                                                                       'amount']
//                                                                   .toString() ??
//                                                               "0"));
//
//                                                   print( buildingSale['buildingId']);
//                                                   print( buildingSale['customerId']);
//                                                   // print(widget.buildingSales['customerId']);
//                                                   buildingSaleController
//                                                       .createSaleReport(context,
//                                                           buildingId:
//                                                           buildingSale['buildingId']
//                                                               .toString(),
//                                                           customerId:
//                                                           buildingSale['customerId'].toString(),
//                                                           amount: buildingSale[
//                                                                   'dueAmount']
//                                                               ?.toString(),
//                                                           paymentType:
//                                                               "Installment");
//                                                 },
//                                                 icon: const HugeIcon(
//                                                   icon: HugeIcons
//                                                       .strokeRoundedCheckmarkCircle03,
//                                                   color: Colors.black,
//                                                   size: 24.0,
//                                                 )))),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }
// }
