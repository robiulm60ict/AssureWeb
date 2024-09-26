import 'dart:io';

import 'package:assure_apps/configs/ghaps.dart';
import 'package:assure_apps/model/buliding_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/app_constants.dart';
import '../../../configs/app_image.dart';
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
    buildingSaleController.calculateResult(widget.model.totalCost);
    buildingSaleController
        .calculateInstalmentAmountResult(widget.model.totalCost);

    buildingSaleController.handoverDateController.text =
        DateTime.now().toIso8601String().split('T')[0];
    buildingSaleController.installmentDateController.text =
        DateTime.now().toIso8601String().split('T')[0];
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
                        "Payment Information",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  Responsive.isDesktop(context) ? null : 16,
                            ),
                      ),
                      Text(
                        "Building Total Amount ${widget.model.totalCost.toString()}",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Obx(
                        ()=> Text(
                          "Booking & Down Payment Amount ${buildingSaleController. percentageAmount.value}",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      gapH8,
                      Row(
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
                                    .calculateResult(widget.model.totalCost);
                              },
                            ),
                          ),
                          gapW8,
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              textInputAction: TextInputAction.done,
                              labelText: "Booking & Down Payment",
                              hintText: "0.00 %",
                              keyboardType: TextInputType.number,
                              controller: buildingSaleController
                                  .paymentBookingPercentageCountController,
                              labelColor: AppColors.textColorb1,
                              isBoldLabel: true,
                              hintColor: AppColors.grey,
                              textColor: AppColors.textColorb1,
                              isRequired: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your booking payment %";
                                }
                                return null;
                              },
                              onChanged: (p0) {
                                buildingSaleController
                                    .calculateResult(widget.model.totalCost);
                                buildingSaleController
                                    .calculateInstalmentAmountResult(
                                        widget.model.totalCost);
                              },
                            ),
                          ),
                        ],
                      ),
                      gapH8,
                      Row(
                        children: [
                          Expanded(
                              child: AppTextField(
                            textInputAction: TextInputAction.done,
                            labelText: "Hand Over Date",
                            hintText: "0.00",
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
                                  .calculateResult(widget.model.totalCost);
                              buildingSaleController
                                  .calculateInstalmentAmountResult(
                                      widget.model.totalCost);
                            },
                            onTap: _selectDate,
                          )),
                          gapW8,
                          Expanded(
                            child: AppTextField(
                              textInputAction: TextInputAction.done,
                              labelText: "Installment Date",
                              hintText: "YYYY-MM-DD",
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
                                buildingSaleController
                                    .calculateResult(widget.model.totalCost);
                                buildingSaleController
                                    .calculateInstalmentAmountResult(
                                        widget.model.totalCost);
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
                        children: [
                          Expanded(
                            child: AppTextField(
                              textInputAction: TextInputAction.next,
                              labelText: "Amount Off Installment",
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
                                buildingSaleController
                                    .calculateResult(widget.model.totalCost);
                                buildingSaleController
                                    .calculateInstalmentAmountResult(
                                        widget.model.totalCost);
                              },
                            ),
                          ),
                          gapW8,
                          Expanded(
                            child: AppTextField(
                              textInputAction: TextInputAction.done,
                              labelText: "Number of Installment",
                              hintText: "Enter Installment",
                              keyboardType: TextInputType.number,
                              controller: buildingSaleController
                                  .installmentCountController,
                              labelColor: AppColors.textColorb1,
                              isBoldLabel: true,
                              hintColor: AppColors.grey,
                              textColor: AppColors.textColorb1,
                              isRequired: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your number of installment";
                                }
                                return null;
                              },
                              onChanged: (p0) {
                                buildingSaleController
                                    .calculateResult(widget.model.totalCost);
                                buildingSaleController
                                    .calculateInstalmentAmountResult(
                                        widget.model.totalCost);
                                buildingSaleController.installmentNumberData();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                gapH16,
                Container(
                  width: double.infinity,
                  height: Responsive.isMobile(context)
                      ? MediaQuery.of(context).size.height * 0.48
                      : MediaQuery.of(context).size.height * 0.24,
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
                      if (Responsive.isMobile(context))
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                formInfo("Upload image"),
                                Obx(
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
                                                  const EdgeInsets.all(8.0),
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
                                                    child: const Text(
                                                        "From Gallery"),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  ElevatedButton(
                                                    child: const Text(
                                                        "Take Photo"),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                  ),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // Adjust the radius as needed
                                              child: imageController
                                                      .resizedImagePath
                                                      .value
                                                      .isNotEmpty
                                                  ? Container(
                                                      width: 50.0,
                                                      height: 50.0,
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
                                                  : Image.asset(
                                                      AppImage.noBuilding,
                                                      width: 50.0,
                                                      height: 50.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            const Positioned(
                                              right: 4,
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 18.0,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: buildingSaleController
                                            .customerEmailController,
                                        labelColor: AppColors.textColorb1,
                                        isBoldLabel: true,
                                        hintColor: AppColors.grey,
                                        textColor: AppColors.textColorb1,
                                        isRequired: false,
                                        // validator: (value) {
                                        //   if (value!.isEmpty) {
                                        //     return "Please enter your customer email ";
                                        //   }
                                        //   return null;
                                        // },
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
                          if (!Responsive.isMobile(context))
                            Expanded(
                              child: Center(
                                child: Column(
                                  children: [
                                    formInfo("Upload image"),
                                    Obx(
                                      () => Align(
                                        alignment: Alignment.center,
                                        child: InkWell(
                                            onTap: () async {
                                              final res = await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  shape: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  actionsPadding:
                                                      const EdgeInsets.all(
                                                          16.0),
                                                  alignment: Alignment.center,
                                                  title: const Text(
                                                    "Choose Option",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  content: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ElevatedButton(
                                                        child: const Text(
                                                            "From Gallery"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, true);
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          height: 10.0),
                                                      ElevatedButton(
                                                        child: const Text(
                                                            "Take Photo"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, false);
                                                        },
                                                      ),
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
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // Adjust the radius as needed
                                                  child: imageController
                                                          .resizedImagePath
                                                          .value
                                                          .isNotEmpty
                                                      ? Container(
                                                          width: 70.0,
                                                          height: 70.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: FileImage(File(
                                                                  imageController
                                                                      .originalImagePath
                                                                      .value)),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        )
                                                      : Image.asset(
                                                          AppImage.noBuilding,
                                                          width: 70.0,
                                                          height: 70.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                                const Positioned(
                                                  right: 4,
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 18.0,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
                gapH8,
                Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
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
                        margin: EdgeInsets.symmetric(
                          horizontal: AppDefaults.padding *
                              (Responsive.isMobile(context) ? 0.5 : 6.5),
                        ),
                        child: DataTable(
                          columnSpacing:
                              Responsive.isMobile(context) ? 20 : null,
                          columns: const <DataColumn>[
                            DataColumn(label: Text('Installment')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Status')),
                          ],
                          rows: List<DataRow>.generate(
                            buildingSaleController.installmentPlan.length,
                            (index) {
                              var installment =
                                  buildingSaleController.installmentPlan[index];
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Center(
                                      child: Text(
                                          '${installment['id']} Installment'))),
                                  DataCell(Center(
                                      child: Text('${installment['amount']}'))),
                                  DataCell(Center(
                                      child:
                                          Text('${installment['dueDate']}'))),
                                  DataCell(Center(
                                      child: Text('${installment['status']}'))),
                                ],
                              );
                            },
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
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        buildingSaleController.handoverDateController.text =
            pickedDate.toIso8601String().split('T')[0];
      });
    }
  }

  // void  _selectDateInstallment(BuildContext context) async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //
  //   if (pickedDate != null) {
  //     // Update the text controller with the selected date in the "YYYY-MM-DD" format
  //     buildingSaleController. installmentDateController.text = pickedDate.toIso8601String().substring(0, 10);
  //
  //     // Recalculate and update installment plan
  //     buildingSaleController.      installmentNumberData();
  //   }
  // }
  void _selectDateInstallment() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
