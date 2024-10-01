import 'package:assure_apps/configs/app_constants.dart';
import 'package:assure_apps/view/customer/customer_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../configs/app_image.dart';
import '../../../configs/ghaps.dart';
import '../../../responsive.dart';
import '../../../widgets/avatar/customer_avaatar.dart';

class CoustomersOverview extends StatelessWidget {
  const CoustomersOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Obx(
        ()=> Expanded(
                child: Text.rich(
                  TextSpan(
                    text: "Welcome ",
                    children: [
                      TextSpan(
                        text: "${customerController.customers.length} customers",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        gapH8,
        customerController.customers.isNotEmpty?   Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(
              () => SizedBox(
                height: 80, // Set a specific height for the ListView
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: customerController.customers.length > (Responsive.isMobile(context)?2:3)
                      ? Responsive.isMobile(context)?2:3
                      : customerController.customers.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var customer = customerController.customers[index];
                    return SizedBox(
                      // height: 100,
                      child: CustomerAvatar(
                        name: customer.name,
                        imageSrc: customer.image,
                        onPressed: () {},
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.08,
                    );
                  },
                ),
              ),
            ),
            Column(
              children: [
                OutlinedButton(

                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CustomerListView()));
                  },
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(50, 50),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.arrow_forward_outlined),
                ),
                gapH4,
                const Text("View all"),
              ],
            )
          ],
        ):  SizedBox(
          height: 100,
            child: Lottie.asset(AppImage.noData)),

        gapH24,
      ],
    );
  }
}
