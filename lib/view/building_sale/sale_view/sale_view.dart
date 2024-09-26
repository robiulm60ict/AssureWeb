import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/building_sale_controller/building_sale_controller.dart';

class BuildingSalesScreen extends StatelessWidget {
  final BuildingSaleController controller = Get.put(BuildingSaleController());

  @override
  Widget build(BuildContext context) {
    // Fetch building sales data when the screen is loaded
    controller.fetchAllBuildingSales();

    return Scaffold(
      appBar: AppBar(
        title: Text("Building Sales"),
      ),
      body: Obx(() {
        // Use the reactive buildingSales variable
        if (controller.buildingSales.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.buildingSales.length,
          itemBuilder: (context, index) {
            final buildingSale = controller.buildingSales[index]["buildingSale"];
            final building = controller.buildingSales[index]["building"];
            final customer = controller.buildingSales[index]["customer"];

            // Log the data for debugging
            print("Building Sale: $buildingSale");
            print("Building: $building");
            print("Customer: $customer");

            // Safeguard against null values
            final projectName = building?['projectName'] ?? 'Unknown';
            final totalCost = buildingSale?['totalCost']?.toString() ?? '0';
            final status = buildingSale?['status'] ?? 'Unknown';
            final customerName = customer?['name'] ?? 'Unknown';

            return ListTile(
              title: Text("Building Sale ID: $projectName"),
              subtitle: Text(
                "Customer Name: $customerName\n"
                    "Total Cost: $totalCost\n"
                    "Status: $status",
              ),
            );
          },
        );
      }),
    );
  }
}
