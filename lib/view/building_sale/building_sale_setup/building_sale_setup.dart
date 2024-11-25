import 'dart:io';

import 'package:assure_apps/configs/ghaps.dart';
import 'package:assure_apps/model/buliding_model.dart';
import 'package:assure_apps/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/app_constants.dart';
import '../../../configs/defaults.dart';
import '../../../responsive.dart';
import '../../../widgets/app_text_field.dart';

class BuildingSaleSetup extends StatefulWidget {
  BuildingSaleSetup({super.key, required this.model});

  BuildingModel model;

  @override
  State<BuildingSaleSetup> createState() => _BuildingSaleSetupState();
}

class _BuildingSaleSetupState extends State<BuildingSaleSetup> {
  @override
  void initState() {
    buildingSaleController.calculateInstalmentAmountResult(
        double.parse(widget.model!.totalCost.toString()));
    buildingSaleController.calculateInstalmentAmountResult(
        double.parse(widget.model!.totalCost.toString()));

    buildingSaleController.handoverDateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    buildingSaleController.installmentDateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              // context.go('/saleBuildingListView');
              // GoRouter.of(context).pop(); // Navigate back
            },
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft02,
              color: Colors.black,
              size: 24.0,
            ),
          ),
          backgroundColor: AppColors.bg,
          title: const Text('Building Sale')),
      backgroundColor: AppColors.bg,
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: buildingSaleController.formKey,
            child: Column(
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
                    horizontal: AppDefaults.padding *
                        (Responsive.isMobile(context) ? 1 : 6.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Building Total Amount ${widget.model?.totalCost.toString()}",
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                      buildingSaleController.selectedDiscountType.toString() ==
                              "full"
                          ? Obx(
                              () {
                                // Safely parse the total cost and discount amount, providing default values if necessary
                                double totalCost = double.tryParse(
                                        widget.model?.totalCost.toString() ??
                                            '0') ??
                                    0.0;
                                double discountAmount = double.tryParse(
                                        buildingSaleController
                                            .discountAmountTotal.value) ??
                                    0.0;

                                // Calculate the final amount after applying the discount
                                double finalAmount = totalCost - discountAmount;

                                return Text(
                                  "Applying ${buildingSaleController.totalDiscount.text} ${buildingSaleController.selectTotalAmountDiscountType == 'fixed' ? "৳" : "%"} Discount Amount: ${discountAmount.toStringAsFixed(2)}\nTotal Amount: ${finalAmount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                );
                              },
                            )
                          : Container(),
                      Obx(
                        () => Text(
                          "Booking & Down Payment Amount ${buildingSaleController.percentageAmount.value}",
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                      buildingSaleController.selectedDiscountType.toString() ==
                              "due"
                          ? Obx(
                              () => Text(
                                "Applying ${buildingSaleController.dueAmountDiscountController.text} ${buildingSaleController.selectDueAmountDiscountType == 'fixed' ? "৳" : "%"} Discount Amount : ${buildingSaleController.discountDueAmount.value}\n Due Amount : ${buildingSaleController.totalDueAmount.text}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          : Container(),
                      gapH8,
                      CupertinoSegmentedControl<String>(
                        padding: EdgeInsets.zero,
                        children: {
                          'no': Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Text(
                              'No Discount',
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.playfairDisplay().fontFamily,
                                color: buildingSaleController
                                            .selectedDiscountType ==
                                        'no'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          'full': Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Text(
                              'Full Discount',
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.playfairDisplay().fontFamily,
                                color: buildingSaleController
                                            .selectedDiscountType ==
                                        'full'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          'due': Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            child: Text(
                              'Due Discount',
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.playfairDisplay().fontFamily,
                                color: buildingSaleController
                                            .selectedDiscountType ==
                                        'due'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        },
                        onValueChanged: (value) {
                          setState(() {
                            buildingSaleController.clearData();
                            buildingSaleController.selectedDiscountType = value;
                            buildingSaleController.dueAmountDiscountController
                                .clear();
                            buildingSaleController.discountTotalAmount.value =
                                0.0;
                            buildingSaleController.totalDiscount.clear();
                            buildingSaleController.discountTotalAmount.value =
                                0.0;
                            buildingSaleController
                                .paymentBookingPercentageCountController
                                .clear();
                            buildingSaleController.installmentCountController
                                .clear();

                            buildingSaleController
                                .calculateInstalmentAmountResult(
                                    widget.model?.totalCost);
                          });
                        },
                        groupValue: buildingSaleController.selectedDiscountType,
                        unselectedColor: Colors.grey[300],
                        selectedColor: AppColors.primary,
                        borderColor: AppColors.primary,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      buildingSaleController.selectedDiscountType.toString() ==
                              "full"
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: CupertinoSegmentedControl<String>(
                                    padding: EdgeInsets.zero,
                                    children: {
                                      'fixed': Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 1.0),
                                        child: Text(
                                          'Discount Fixed(৳)',
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.playfairDisplay()
                                                    .fontFamily,
                                            color: buildingSaleController
                                                        .selectTotalAmountDiscountType ==
                                                    'fixed'
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      'percent': Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 0.0),
                                        child: Text(
                                          ' Percent(%)',
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.playfairDisplay()
                                                    .fontFamily,
                                            color: buildingSaleController
                                                        .selectTotalAmountDiscountType ==
                                                    'percent'
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    },
                                    onValueChanged: (value) {
                                      setState(() {
                                        buildingSaleController
                                                .selectTotalAmountDiscountType =
                                            value;

                                        buildingSaleController
                                            .calculateInstalmentAmountResult(
                                                widget.model?.totalCost);
                                        // Recalculate total when discount type changes
                                      });
                                    },
                                    groupValue: buildingSaleController
                                        .selectTotalAmountDiscountType,
                                    unselectedColor: Colors.grey[300],
                                    selectedColor: AppColors.primary,
                                    borderColor: AppColors.primary,
                                  ),
                                ),
                                gapW8,
                                Expanded(
                                  flex: 2,
                                  child: AppTextField(
                                    needLabel: false,
                                    textInputAction: TextInputAction.done,
                                    labelText: "Discount Amount",
                                    hintText: "0.00",
                                    keyboardType: TextInputType.number,
                                    controller:
                                        buildingSaleController.totalDiscount,
                                    labelColor: AppColors.textColorb1,
                                    isBoldLabel: true,
                                    hintColor: AppColors.grey,
                                    textColor: AppColors.textColorb1,
                                    isRequired: false,
                                    onChanged: (p0) {
                                      if (p0.isNotEmpty) {
                                        setState(() {
                                          if (buildingSaleController
                                                  .selectedDiscountType
                                                  .toString() ==
                                              "full") {
                                            double totalCost = double.tryParse(
                                                    widget.model?.totalCost
                                                            .toString() ??
                                                        '0') ??
                                                0.0;
                                            double discountAmount =
                                                double.tryParse(
                                                        buildingSaleController
                                                            .discountAmountTotal
                                                            .value) ??
                                                    0.0;

                                            // Calculate the final amount after applying the discount
                                            double finalAmount =
                                                totalCost - discountAmount;
                                            // if (p0.isEmpty) {
                                            //   buildingSaleController
                                            //       .totalDiscount
                                            //       .clear();
                                            // } else {
                                            //   buildingSaleController
                                            //           .totalDiscount.text =
                                            //       finalAmount
                                            //           .toStringAsFixed(2);
                                            // }

                                          }
                                          buildingSaleController
                                              .discountAmountTotal
                                              .value = "0.0";
                                          buildingSaleController
                                              .calculateInstalmentAmountResult(
                                                  widget.model?.totalCost);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: AppTextField(
                              textInputAction: TextInputAction.done,
                              labelText: "Due Amount",
                              readOnly: true,
                              hintText: "0.00",
                              keyboardType: TextInputType.number,
                              controller: buildingSaleController.dueAmount,
                              labelColor: AppColors.textColorb1,
                              isBoldLabel: true,
                              hintColor: AppColors.grey,
                              textColor: AppColors.textColorb1,
                              isRequired: false,
                              onChanged: (p0) {
                                buildingSaleController
                                    .calculateInstalmentAmountResult(
                                        widget.model?.totalCost);
                              },
                            ),
                          ),
                          gapW8,
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              textInputAction: TextInputAction.done,
                              labelText: "Booking & Down Payment (%)",
                              hintText: "Ex : 10 %",
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              controller: buildingSaleController
                                  .paymentBookingPercentageCountController,
                              labelColor: AppColors.textColorb1,
                              isBoldLabel: true,
                              inputFormatters: [
                                PercentageInputFormatter(),
                              ],
                              hintColor: AppColors.grey,
                              textColor: AppColors.textColorb1,
                              isRequired: true,
                              validator: (value) {
                                double? percentage =
                                    double.tryParse(value.toString());
                                if (value!.isEmpty) {
                                  return "Please enter your booking payment %";
                                } else if (percentage == null ||
                                    percentage > 100) {
                                  return "Percentage must be between 0 and 100";
                                }
                                return null;
                              },
                              onChanged: (p0) {
                                double? percentage = double.tryParse(p0);
                                if (p0.isEmpty) {
                                  double totalCost = double.tryParse(
                                          widget.model?.totalCost.toString() ??
                                              '0') ??
                                      0.0;
                                  double discountAmount = double.tryParse(
                                          buildingSaleController
                                              .discountAmountTotal.value) ??
                                      0.0;

                                  // Calculate the final amount after applying the discount
                                  double finalAmount =
                                      totalCost - discountAmount;
                                  buildingSaleController.dueAmount.text =
                                      finalAmount.toStringAsFixed(2);
                                  buildingSaleController
                                      .percentageAmount.value = 0.0;
                                }
                                setState(() {});
                                if (buildingSaleController
                                    .installmentCountController.text.isEmpty) {
                                  buildingSaleController
                                      .amountInstallmentController
                                      .clear();
                                }
                                if (percentage != null && percentage <= 100) {
                                  // buildingSaleController
                                  //     .calculateInstalmentAmountResult(double.parse(widget.model!.totalCost.toString()));
                                  buildingSaleController
                                      .calculateInstalmentAmountResult(
                                          double.parse(widget.model!.totalCost
                                              .toString()));
                                } else {
                                  // Optionally, you can show an error or limit input here
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      gapH8,
                      buildingSaleController.selectedDiscountType.toString() ==
                              "due"
                          ? Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: CupertinoSegmentedControl<String>(
                                    padding: EdgeInsets.zero,
                                    children: {
                                      'fixed': Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 0.0),
                                        child: Text(
                                          'Discount Fixed(৳)',
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.playfairDisplay()
                                                    .fontFamily,
                                            color: buildingSaleController
                                                        .selectDueAmountDiscountType ==
                                                    'fixed'
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      'percent': Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 0.0),
                                        child: Text(
                                          ' Percent (%)',
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.playfairDisplay()
                                                    .fontFamily,
                                            color: buildingSaleController
                                                        .selectDueAmountDiscountType ==
                                                    'percent'
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    },
                                    onValueChanged: (value) {
                                      setState(() {
                                        buildingSaleController
                                                .selectDueAmountDiscountType =
                                            value;
                                        buildingSaleController
                                            .calculateInstalmentAmountResult(
                                                widget.model?.totalCost);
                                        // Recalculate total when discount type changes
                                      });
                                    },
                                    groupValue: buildingSaleController
                                        .selectDueAmountDiscountType,
                                    unselectedColor: Colors.grey[300],
                                    selectedColor: AppColors.primary,
                                    borderColor: AppColors.primary,
                                  ),
                                ),
                                gapW8,
                                Expanded(
                                  flex: 2,
                                  child: AppTextField(
                                    needLabel: false,
                                    textInputAction: TextInputAction.done,
                                    labelText: "Discount Amount",
                                    hintText: "0.00",
                                    keyboardType: TextInputType.number,
                                    controller: buildingSaleController
                                        .dueAmountDiscountController,
                                    labelColor: AppColors.textColorb1,
                                    isBoldLabel: true,
                                    hintColor: AppColors.grey,
                                    textColor: AppColors.textColorb1,
                                    isRequired: false,
                                    onChanged: (p0) {
                                      if (p0.isEmpty) {
                                        setState(() {
                                          buildingSaleController
                                              .dueAmountDiscountController
                                              .clear();
                                          buildingSaleController
                                              .discountDueAmount.value = 0.0;
                                          buildingSaleController
                                                  .totalDueAmount.text =
                                              buildingSaleController
                                                  .dueAmount.text;
                                        });
                                      }
                                      buildingSaleController
                                          .calculateInstalmentAmountResult(
                                              widget.model?.totalCost);
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      gapH8,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: AppTextField(
                            textInputAction: TextInputAction.done,
                            labelText: "Hand Over Date",
                            hintText: "DD-MM-YYYY",
                            keyboardType: TextInputType.number,
                            controller:
                                buildingSaleController.handoverDateController,
                            labelColor: AppColors.textColorb1,
                            isBoldLabel: true,
                            hintColor: AppColors.grey,
                            textColor: AppColors.textColorb1,
                            isRequired: true,
                            onChanged: (p0) {
                              buildingSaleController
                                  .calculateInstalmentAmountResult(
                                      widget.model?.totalCost);
                              buildingSaleController
                                  .calculateInstalmentAmountResult(
                                      widget.model?.totalCost);
                            },
                            onTap: _selectDate,
                          )),
                          gapW8,
                          Expanded(
                            child: AppTextField(
                              textInputAction: TextInputAction.done,
                              labelText: "Installment Date",
                              hintText: "DD-MM-YYYY",
                              // Updated hint for date format
                              keyboardType: TextInputType.datetime,
                              // Changed to datetime for date input
                              controller: buildingSaleController
                                  .installmentDateController,
                              labelColor: AppColors.textColorb1,
                              isBoldLabel: true,
                              hintColor: AppColors.grey,
                              textColor: AppColors.textColorb1,
                              isRequired: true,

                              // Triggered when the user changes the date manually
                              onChanged: (p0) {
                                // Ensure the input is in the correct date format before calculating
                                // buildingSaleController
                                //     .calculateInstalmentAmountResult(widget.model?.totalCost);
                                buildingSaleController
                                    .calculateInstalmentAmountResult(
                                        widget.model?.totalCost);
                                buildingSaleController.installmentNumberData();
                              },

                              // Triggered when the user taps the field to pick a date
                              onTap: _selectDateInstallment,
                            ),
                          )
                        ],
                      ),
                      gapH8,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              textInputAction: TextInputAction.next,
                              labelText: "Amount Of Installment",
                              hintText: "0.00",
                              readOnly: true,
                              keyboardType: TextInputType.number,
                              controller: buildingSaleController
                                  .amountInstallmentController,
                              labelColor: AppColors.textColorb1,
                              isBoldLabel: true,
                              hintColor: AppColors.grey,
                              textColor: AppColors.textColorb1,
                              isRequired: false,
                              onChanged: (p0) {
                                // buildingSaleController
                                //     .calculateInstalmentAmountResult(widget.model?.totalCost);
                                buildingSaleController
                                    .calculateInstalmentAmountResult(
                                        widget.model?.totalCost);
                              },
                            ),
                          ),
                          gapW8,
                          Expanded(
                            child: AppTextField(
                              textInputAction: TextInputAction.done,
                              labelText: "Number of Installment",
                              hintText: "Ex : 5",
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              keyboardType: TextInputType.number,
                              controller: buildingSaleController
                                  .installmentCountController,
                              labelColor: AppColors.textColorb1,
                              isBoldLabel: true,
                              hintColor: AppColors.grey,
                              textColor: AppColors.textColorb1,
                              isRequired: true,
                              validator: (value) {
                                double? installments = double.tryParse(
                                    buildingSaleController.dueAmount.text);

                                if (installments == null || installments <= 0) {
                                  return null;
                                } else {
                                  if (value!.isEmpty) {
                                    return "Please enter your number of installments";
                                  }
                                }
                                return null;
                              },
                              onChanged: (p0) {
                                // First, parse the due amount as a double
                                if (p0.isEmpty) {
                                  buildingSaleController
                                      .amountInstallmentController
                                      .clear();
                                  // buildingSaleController. interestAmount.value=0.0;
                                }
                                double? dueAmount = double.tryParse(
                                    buildingSaleController.dueAmount.text);

                                // Check if the dueAmount is valid and greater than or equal to 0
                                if (dueAmount == null || dueAmount <= 0) {
                                  print("Invalid due amount$dueAmount");
                                  // Optionally show a snackbar or error message
                                  wrongSnackBar(context, "You don't have Due");
                                } else {
                                  // If dueAmount is valid, print it for debugging
                                  print("Valid due amount: $dueAmount");

                                  // Perform the result calculations
                                  // buildingSaleController.calculateInstalmentAmountResult(double.parse(widget.model!.totalCost.toString()));
                                  buildingSaleController
                                      .calculateInstalmentAmountResult(
                                          double.parse(widget.model!.totalCost
                                              .toString()));
                                  buildingSaleController
                                      .installmentNumberData();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                gapH16,
                if (!Responsive.isMobile(context)) gapH24,
                Container(
                  width: double.infinity,
                  // height: Responsive.isMobile(context)
                  //     ? MediaQuery
                  //     .of(context)
                  //     .size
                  //     .height * 0.30
                  //     : MediaQuery
                  //     .of(context)
                  //     .size
                  //     .height * 0.24,
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
                    // vertical:
                    //     AppDefaults.padding * (Responsive.isMobile(context) ? 1 : 1.5),
                    horizontal: AppDefaults.padding *
                        (Responsive.isMobile(context) ? 1 : 6.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Customer Information",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  Responsive.isDesktop(context) ? null : 16,
                            ),
                      ),
                      // if (Responsive.isMobile(context)) gapH8,
                      // if (Responsive.isMobile(context))
                      //   Expanded(
                      //     child: Center(
                      //       child: Column(
                      //         children: [
                      //
                      //           Obx(
                      //             () => Align(
                      //               alignment: Alignment.center,
                      //               child: InkWell(
                      //                   onTap: () async {
                      //                     final res = await showDialog(
                      //                       context: context,
                      //                       builder: (context) => AlertDialog(
                      //                         shape: OutlineInputBorder(
                      //                           borderRadius:
                      //                               BorderRadius.circular(8.0),
                      //                         ),
                      //                         actionsPadding:
                      //                             const EdgeInsets.all(8.0),
                      //                         alignment: Alignment.center,
                      //                         title: const Text(
                      //                           "Choose Option",
                      //                           textAlign: TextAlign.center,
                      //                           style: TextStyle(
                      //                             fontSize: 16.0,
                      //                             fontWeight: FontWeight.w700,
                      //                           ),
                      //                         ),
                      //                         content: Column(
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.center,
                      //                           mainAxisSize: MainAxisSize.min,
                      //                           children: [
                      //                             ElevatedButton(
                      //                               child: const Text(
                      //                                   "From Gallery"),
                      //                               onPressed: () {
                      //                                 Navigator.pop(
                      //                                     context, true);
                      //                               },
                      //                             ),
                      //                             const SizedBox(height: 5.0),
                      //                             ElevatedButton(
                      //                               child: const Text(
                      //                                   "Take Photo"),
                      //                               onPressed: () {
                      //                                 Navigator.pop(
                      //                                     context, false);
                      //                               },
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     );
                      //                     if (res != null) {
                      //                       await imageController.pickImage(
                      //                           fromGallery: res);
                      //                     } else {
                      //                       // Get.snackbar(
                      //                       //     '', 'Select an option to continue');
                      //                     }
                      //                   },
                      //                   child: Stack(
                      //                     alignment: Alignment.bottomRight,
                      //                     children: [
                      //                       ClipRRect(
                      //                         borderRadius:
                      //                             BorderRadius.circular(10),
                      //                         // Adjust the radius as needed
                      //                         child: imageController
                      //                                 .resizedImagePath
                      //                                 .value
                      //                                 .isNotEmpty
                      //                             ? Container(
                      //                                 width: 50.0,
                      //                                 height: 50.0,
                      //                                 decoration: BoxDecoration(
                      //                                   image: DecorationImage(
                      //                                     image: FileImage(File(
                      //                                         imageController
                      //                                             .originalImagePath
                      //                                             .value)),
                      //                                     fit: BoxFit.cover,
                      //                                   ),
                      //                                 ),
                      //                               )
                      //                             : Image.asset(
                      //                                 AppImage.noBuilding,
                      //                                 width: 50.0,
                      //                                 height: 50.0,
                      //                                 fit: BoxFit.cover,
                      //                               ),
                      //                       ),
                      //                       const Positioned(
                      //                         right: 4,
                      //                         child: Icon(
                      //                           Icons.camera_alt_outlined,
                      //                           size: 18.0,
                      //                           color: Colors.blue,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   )),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      gapH8,
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        textInputAction: TextInputAction.next,
                                        labelText: "Customer Name",
                                        hintText: "Enter Customer Name",
                                        keyboardType: TextInputType.name,
                                        controller: buildingSaleController
                                            .customerNameController,
                                        labelColor: AppColors.textColorb1,
                                        isBoldLabel: true,
                                        hintColor: AppColors.grey,
                                        textColor: AppColors.textColorb1,
                                        isRequired: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter name";
                                          }
                                          return null;
                                        },
                                        onChanged: (p0) {
                                          //  searchFlightBloc.firstName = p0;
                                        },
                                      ),
                                    ),
                                    gapW8,
                                    Expanded(
                                      child: AppTextField(
                                        textInputAction: TextInputAction.done,
                                        labelText: "Customer Phone",
                                        hintText: "Enter Customer Phone",
                                        keyboardType: TextInputType.name,
                                        controller: buildingSaleController
                                            .customerPhoneController,
                                        labelColor: AppColors.textColorb1,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9-()+ ]')),
                                        ],
                                        isBoldLabel: true,
                                        hintColor: AppColors.grey,
                                        textColor: AppColors.textColorb1,
                                        isRequired: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter phone ";
                                          }
                                          return null;
                                        },
                                        onChanged: (p0) {},
                                      ),
                                    ),
                                  ],
                                ),
                                gapH8,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        textInputAction: TextInputAction.done,
                                        labelText: "Customer Email",
                                        hintText: "Enter Customer Email",
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[a-zA-Z0-9@._-]')),
                                          // Allows alphanumeric, '@', '.', '_', '-'
                                        ],
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: buildingSaleController
                                            .customerEmailController,
                                        labelColor: AppColors.textColorb1,
                                        isBoldLabel: true,
                                        hintColor: AppColors.grey,
                                        textColor: AppColors.textColorb1,
                                        isRequired: false,
                                        validator: (value) {
                                          if (value != null &&
                                              value.isNotEmpty &&
                                              !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                                  .hasMatch(value)) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                        onChanged: (p0) {},
                                      ),
                                    ),
                                    gapW8,
                                    Expanded(
                                      child: AppTextField(
                                        textInputAction: TextInputAction.done,
                                        labelText: "Customer Address",
                                        hintText: "Enter Customer Address",
                                        keyboardType: TextInputType.text,
                                        controller: buildingSaleController
                                            .customerAddressController,
                                        labelColor: AppColors.textColorb1,
                                        isBoldLabel: true,
                                        hintColor: AppColors.grey,
                                        textColor: AppColors.textColorb1,
                                        isRequired: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter address ";
                                          }
                                          return null;
                                        },
                                        onChanged: (p0) {},
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // if (!Responsive.isMobile(context))
                          //   Expanded(
                          //     child: Center(
                          //       child: Column(
                          //         children: [
                          //           formInfo("Upload image"),
                          //           Obx(
                          //             () => Align(
                          //               alignment: Alignment.center,
                          //               child: InkWell(
                          //                   onTap: () async {
                          //                     final res = await showDialog(
                          //                       context: context,
                          //                       builder: (context) =>
                          //                           AlertDialog(
                          //                         shape: OutlineInputBorder(
                          //                           borderRadius:
                          //                               BorderRadius.circular(
                          //                                   8.0),
                          //                         ),
                          //                         actionsPadding:
                          //                             const EdgeInsets.all(
                          //                                 16.0),
                          //                         alignment: Alignment.center,
                          //                         title: const Text(
                          //                           "Choose Option",
                          //                           textAlign: TextAlign.center,
                          //                           style: TextStyle(
                          //                             fontSize: 16.0,
                          //                             fontWeight:
                          //                                 FontWeight.w700,
                          //                           ),
                          //                         ),
                          //                         content: Column(
                          //                           crossAxisAlignment:
                          //                               CrossAxisAlignment
                          //                                   .center,
                          //                           mainAxisSize:
                          //                               MainAxisSize.min,
                          //                           children: [
                          //                             ElevatedButton(
                          //                               child: const Text(
                          //                                   "From Gallery"),
                          //                               onPressed: () {
                          //                                 Navigator.pop(
                          //                                     context, true);
                          //                               },
                          //                             ),
                          //                             const SizedBox(
                          //                                 height: 10.0),
                          //                             ElevatedButton(
                          //                               child: const Text(
                          //                                   "Take Photo"),
                          //                               onPressed: () {
                          //                                 Navigator.pop(
                          //                                     context, false);
                          //                               },
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     );
                          //                     if (res != null) {
                          //                       await imageController.pickImage(
                          //                           fromGallery: res);
                          //                     } else {
                          //                       // Get.snackbar(
                          //                       //     '', 'Select an option to continue');
                          //                     }
                          //                   },
                          //                   child: Stack(
                          //                     alignment: Alignment.bottomRight,
                          //                     children: [
                          //                       ClipRRect(
                          //                         borderRadius:
                          //                             BorderRadius.circular(10),
                          //                         // Adjust the radius as needed
                          //                         child: imageController
                          //                                 .resizedImagePath
                          //                                 .value
                          //                                 .isNotEmpty
                          //                             ? Container(
                          //                                 width: 70.0,
                          //                                 height: 70.0,
                          //                                 decoration:
                          //                                     BoxDecoration(
                          //                                   image:
                          //                                       DecorationImage(
                          //                                     image: FileImage(File(
                          //                                         imageController
                          //                                             .originalImagePath
                          //                                             .value)),
                          //                                     fit: BoxFit.cover,
                          //                                   ),
                          //                                 ),
                          //                               )
                          //                             : Image.asset(
                          //                                 AppImage.noBuilding,
                          //                                 width: 70.0,
                          //                                 height: 70.0,
                          //                                 fit: BoxFit.cover,
                          //                               ),
                          //                       ),
                          //                       const Positioned(
                          //                         right: 4,
                          //                         child: Icon(
                          //                           Icons.camera_alt_outlined,
                          //                           size: 18.0,
                          //                           color: Colors.blue,
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   )),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                        ],
                      )
                    ],
                  ),
                ),
                gapH8,
                kIsWeb
                    ? Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: AppDefaults.padding *
                              (Responsive.isMobile(context) ? 0.5 : 6.5),
                        ),
                        width: double.infinity,
                        height: AppDefaults.height(context) * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Obx(
                            () => Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () async {
                                  final res = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      actionsPadding:
                                          const EdgeInsets.all(16.0),
                                      alignment: Alignment.center,
                                      title: const Text(
                                        "Choose Option",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ElevatedButton(
                                            child: const Text("From Gallery"),
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                          ),
                                          const SizedBox(height: 10.0),
                                          Responsive.isMobile(context)
                                              ? ElevatedButton(
                                                  child:
                                                      const Text("Take Photo"),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  );
                                  if (res != null) {
                                    await imageController.pickImage(
                                        fromGallery: res);
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: imageController
                                              .resizedImagePath.value.isNotEmpty
                                          ? (kIsWeb
                                              ? Image.network(
                                                  imageController
                                                      .resizedImagePath.value,
                                                  fit: BoxFit.cover,
                                                  width: 70.0,
                                                  height: 70.0,
                                                )
                                              : Image.file(
                                                  File(imageController
                                                      .originalImagePath.value),
                                                  fit: BoxFit.cover,
                                                  width: 70.0,
                                                  height: 70.0,
                                                ))
                                          : Container(
                                              width: Responsive.isMobile(
                                                      context)
                                                  ? AppDefaults.width(context) *
                                                      0.5
                                                  : AppDefaults.width(context) *
                                                      0.2,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 10),
                                              decoration: const BoxDecoration(
                                                  color: Colors.white),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const HugeIcon(
                                                    icon: HugeIcons
                                                        .strokeRoundedUpload04,
                                                    color: Colors.black,
                                                    size: 24.0,
                                                  ),
                                                  gapW8,
                                                  SizedBox(
                                                    child: Text(
                                                      "Click or drop image",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade500),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: Responsive.isMobile(context)
                            ? AppDefaults.height(context) * 0.1
                            : AppDefaults.height(context) * 0.2,
                        padding: EdgeInsets.symmetric(
                          vertical: AppDefaults.padding *
                              (Responsive.isMobile(context) ? 1 : 0.5),
                          horizontal: AppDefaults.padding *
                              (Responsive.isMobile(context) ? 1 : 2.5),
                        ),
                        margin: EdgeInsets.symmetric(
                          // vertical:
                          //     AppDefaults.padding * (Responsive.isMobile(context) ? 1 : 1.5),
                          horizontal: AppDefaults.padding *
                              (Responsive.isMobile(context) ? 1 : 6.5),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Obx(
                            () => Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                  onTap: () async {
                                    final res = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        actionsPadding:
                                            const EdgeInsets.all(16.0),
                                        alignment: Alignment.center,
                                        title: const Text(
                                          "Choose Option",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ElevatedButton(
                                              child: const Text("From Gallery"),
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                            ),
                                            const SizedBox(height: 10.0),
                                            Responsive.isMobile(context)
                                                ? ElevatedButton(
                                                    child: const Text(
                                                        "Take Photo"),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    );
                                    if (res != null) {
                                      await imageController.pickImage(
                                          fromGallery: res);
                                    } else {
                                      // Get.snackbar(
                                      //     '', 'Select an option to continue');
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        // Adjust the radius as needed
                                        child: imageController.resizedImagePath
                                                .value.isNotEmpty
                                            ? Container(
                                                width: 70.0,
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: FileImage(File(
                                                        imageController
                                                            .originalImagePath
                                                            .value)),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width:
                                                    Responsive.isMobile(context)
                                                        ? AppDefaults.width(
                                                                context) *
                                                            0.5
                                                        : AppDefaults.width(
                                                                context) *
                                                            0.2,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6,
                                                        horizontal: 10),
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const HugeIcon(
                                                      icon: HugeIcons
                                                          .strokeRoundedUpload04,
                                                      color: Colors.black,
                                                      size: 24.0,
                                                    ),
                                                    gapW8,
                                                    SizedBox(
                                                      // width: AppDefaults.width(
                                                      //   context) *
                                                      //   0.3,
                                                      child: Text(
                                                        "Click or drop image",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .grey.shade500),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                      ),
                                      // const Positioned(
                                      //   right: 4,
                                      //   child: Icon(
                                      //     Icons.camera_alt_outlined,
                                      //     size: 18.0,
                                      //     color: Colors.blue,
                                      //   ),
                                      // ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                gapH8,
                if (!Responsive.isMobile(context)) gapH24,
                Obx(() => Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding *
                            (Responsive.isMobile(context) ? 0.5 : 6.5),
                      ),
                      // width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: AppDefaults.padding *
                                (Responsive.isMobile(context) ? 0.5 : 0.5),
                            horizontal: AppDefaults.padding *
                                (Responsive.isMobile(context) ? 1 : 2.5),
                          ),
                          child: DataTable(
                            // columnSpacing: Responsive.isMobile(context) ? 20 : null,
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Installment')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Status')),
                            ],
                            rows: List<DataRow>.generate(
                              buildingSaleController.installmentPlan.length,
                              (index) {
                                var installment = buildingSaleController
                                    .installmentPlan[index];
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(
                                        '${installment['id']} Installment')),
                                    DataCell(Text('${installment['amount']}')),
                                    DataCell(Text('${installment['dueDate']}')),
                                    DataCell(Text('${installment['status']}')),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    )),
                gapH8,
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDefaults.padding *
                        (Responsive.isMobile(context) ? 1 : 0.5),
                    horizontal: AppDefaults.padding *
                        (Responsive.isMobile(context) ? 1 : 2.5),
                  ),
                  margin: EdgeInsets.symmetric(
                    // vertical:
                    //     AppDefaults.padding * (Responsive.isMobile(context) ? 1 : 1.5),
                    horizontal: AppDefaults.padding *
                        (Responsive.isMobile(context) ? 1 : 6.5),
                  ),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1.0, color: Colors.blue),
                      ),
                      onPressed: () {
                        if (buildingSaleController.formKey.currentState!
                            .validate()) {
                          buildingSaleController
                              .uploadImageAndCreateBuildingSale(
                                  widget.model.id,
                                  imageController.resizedImagePath.value,
                                  context,
                                  widget.model.totalCost);
                        }
                      },
                      child: const Text("Building Sale")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3101),
    );

    if (pickedDate != null) {
      setState(() {
        buildingSaleController.handoverDateController.text =
            pickedDate.toIso8601String().split('T')[0];
      });
    }
  }

  void _selectDateInstallment() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3101),
    );

    if (pickedDate != null) {
      setState(() {
        buildingSaleController.installmentDateController.text =
            pickedDate.toIso8601String().split('T')[0];

        buildingSaleController
            .calculateInstalmentAmountResult(widget.model.totalCost);
        buildingSaleController.installmentNumberData();
      });
    }
  }
}

class PercentageInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }

    // Ensure the value is a valid double and restrict between 0 and 100
    final double? value = double.tryParse(text);
    if (value == null || value < 0 || value > 100) {
      return oldValue; // If the input is invalid, retain the old value
    }

    return newValue; // Otherwise, accept the new value
  }
}
