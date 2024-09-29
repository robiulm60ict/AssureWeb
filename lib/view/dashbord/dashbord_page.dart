import 'package:flutter/material.dart';

import '../../configs/ghaps.dart';
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
              child: Column(
                children: [
                  const Overview(),
                  if (Responsive.isMobile(context)) gapW16,
                  if (Responsive.isMobile(context)) const PopularProducts(),
                  gapH16,
                  const ProductOverviews(),
                ],
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
