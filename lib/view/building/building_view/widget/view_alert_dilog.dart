import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../configs/app_colors.dart';
import '../../../../configs/defaults.dart';
import '../../../../configs/ghaps.dart';
import '../../../../model/buliding_model.dart';
import '../../../../responsive.dart';

void showAlertDialog(BuildingModel project, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        title: Text('${project.projectName.capitalize} Information'),
        content: Container(
          height: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.height * 0.35
              : MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(
            vertical: AppDefaults.padding *
                (Responsive.isMobile(context) ? 1 : 0.5),
            horizontal: AppDefaults.padding *
                (Responsive.isMobile(context) ? 1 : 2.5),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: Responsive.isMobile(context) ? 60 : 100,
                    width: Responsive.isMobile(context) ? 60 : 100,
                    decoration: BoxDecoration(
                      // color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        project.image.toString(),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes !=
                                  null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ??
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
                              "https://img.freepik.com/free-photo/observation-urban-building-business-steel_1127-2397.jpg?t=st=1727338313~exp=1727341913~hmac=2e09cc7c51c7da785d7456f52aa5214acafe820f751d1e53d1a75e3cf4b69139&w=1380",
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Responsive.isMobile(context) ? gapW8 : gapW16,
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: project.prospectName.capitalize,
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
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  // fontSize: 20,
                                ),
                              ),
                              TextSpan(
                                text: project.projectName.capitalize,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  // fontSize: 20,
                                ),
                              ),
                            ])),
                        gapH4,
                        RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                text: "Floor No : ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  // fontSize: 20,
                                ),
                              ),
                              TextSpan(
                                text: project.floorNo.capitalize,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  // fontSize: 20,
                                ),
                              ),
                            ])),
                        gapH4,
                        if (!Responsive.isMobile(context))
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                    const TextSpan(
                                      text: "Apartment Size : ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        // fontSize: 20,
                                      ),
                                    ),
                                    TextSpan(
                                      text: project.appointmentSize.capitalize,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        // fontSize: 20,
                                      ),
                                    ),
                                  ])),
                              gapH4,
                              RichText(
                                  text: TextSpan(children: [
                                    const TextSpan(
                                      text: "Per sqft Price : ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        // fontSize: 20,
                                      ),
                                    ),
                                    TextSpan(
                                      text: project.persqftPrice.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        // fontSize: 20,
                                      ),
                                    ),
                                  ])),
                              gapH4,
                            ],
                          )
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                                const TextSpan(
                                  text: "Total Unit Price : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    // fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: project.totalUnitPrice.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    // fontSize: 20,
                                  ),
                                ),
                              ])),
                          gapH4,
                          RichText(
                              text: TextSpan(children: [
                                const TextSpan(
                                  text: "Utility Cost : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    // fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: project.unitCost.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    // fontSize: 20,
                                  ),
                                ),
                              ])),
                          gapH4,
                          RichText(
                              text: TextSpan(children: [
                                const TextSpan(
                                  text: "Car Parking : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    // fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: project.carParking.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    // fontSize: 20,
                                  ),
                                ),
                              ])),
                          gapH4,
                          RichText(
                              text: TextSpan(children: [
                                const TextSpan(
                                  text: "Total Cost : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    // fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: project.totalCost.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    // fontSize: 20,
                                  ),
                                ),
                              ])),
                        ],
                      ),
                    ),
                  if (!Responsive.isMobile(context))
                    Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "Last edited",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                // fontSize: 20,
                              ),
                            ),
                            gapH8,
                            Text(
                              project.updateDateTime.toString() ?? "N/A",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                // fontSize: 20,
                              ),
                            ),
                          ],
                        )),
                ],
              ),
              if (Responsive.isMobile(context))
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH8,
                    RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: "Apartment Size : ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              // fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: project.appointmentSize.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              // fontSize: 20,
                            ),
                          ),
                        ])),
                    gapH4,
                    RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: "Per sqft Price : ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              // fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: project.persqftPrice.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              // fontSize: 20,
                            ),
                          ),
                        ])),
                    gapH4,
                    RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: "Total Unit Price : ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              // fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: project.totalUnitPrice.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              // fontSize: 20,
                            ),
                          ),
                        ])),
                    gapH4,
                    RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: "Unit Cost : ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              // fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: project.unitCost.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              // fontSize: 20,
                            ),
                          ),
                        ])),
                    gapH4,
                    RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: "Car Parking : ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              // fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: project.carParking.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              // fontSize: 20,
                            ),
                          ),
                        ])),
                    gapH4,
                    RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: "Total Cost : ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              // fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: project.totalCost.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              // fontSize: 20,
                            ),
                          ),
                        ])),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
