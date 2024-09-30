import 'package:assure_apps/widgets/app_shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../configs/app_constants.dart';
import '../../configs/ghaps.dart';
import '../../configs/pdf/pdf_invoice_api.dart';
import '../../configs/pdf/pdf_web.dart';
import '../../responsive.dart';
import 'widgets/overview.dart';
import 'widgets/popular_products.dart';
import 'widgets/product_overview.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ElevatedButton(onPressed: ()async{
        //   if (kIsWeb) {
        //     // savePdfWeb();
        //     // Web-specific logic
        //   } else if (io.Platform.isAndroid || io.Platform.isIOS) {
        //     // await PdfInvoice.saleReportInvoice("Sales_Report", context);
        //
        //     // Mobile-specific logic
        //   } else {
        //     // Desktop logic
        //   }
        // }, child: Text("Pdf Test")),
        if (!Responsive.isMobile(context)) gapH24,
        Text(
          "Dashboard",
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        gapH20,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child:
                Obx(
    ()=> Column(
                    children: [
                      customerController.isLoading.value == true
                          ? const AppShimmer()
                          : const Overview(),
                      if (Responsive.isMobile(context)) gapW16,
                      if (Responsive.isMobile(context)) const PopularProducts(),
                      gapH16,
                      reportController.isDateFilterLoading.value == true
                          ? const AppShimmer()
                          : const ProductOverviews(),
                    ],
                  ),
                ),

            ),
            if (!Responsive.isMobile(context)) gapW16,
            if (!Responsive.isMobile(context))
              const Expanded(
                flex: 2,
                child: Column(
                  children: [
                    PopularProducts(),
                  ],
                ),
              ),
          ],
        )
      ],
    );
  }
}
