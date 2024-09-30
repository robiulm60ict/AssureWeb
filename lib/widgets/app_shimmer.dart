/*
AppShimmer
@Author Soton Ahmed <soton.m360ict@gmail.com>
Start Date: 27-12-2023
Last Update: 27-12-2023
*/

import 'package:assure_apps/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../configs/defaults.dart';


class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics:const NeverScrollableScrollPhysics(),
      itemCount: 2,
        itemBuilder: (_,i)=> Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width:Responsive.isMobile(context)? AppDefaults.width(context)*0.2:AppDefaults.width(context)*0.04,
                    height: Responsive.isMobile(context)? AppDefaults.height(context)*0.1:AppDefaults.height(context)*0.07,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                    ),
                  ),
                   SizedBox(width: AppDefaults.bodyPadding,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Responsive.isMobile(context)?AppDefaults.width(context)*0.3: AppDefaults.width(context)*0.4,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Container(
                        width: Responsive.isMobile(context)? AppDefaults.width(context)*0.3:AppDefaults.width(context)*0.4,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10,),

              Container(
                width: double.maxFinite,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.maxFinite,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.maxFinite,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.maxFinite,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                ),
              ),
              const SizedBox(height: 10,),
              //  SizedBox(height: AppDefaults.bodyPadding,),

            ],
          ),
        )
    );

  }
}
class AppShimmerProduct extends StatelessWidget {
  const AppShimmerProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics:const NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (_,i)=> Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width:Responsive.isMobile(context)? AppDefaults.width(context)*0.1:AppDefaults.width(context)*0.02,
                    height: Responsive.isMobile(context)? AppDefaults.height(context)*0.1:AppDefaults.height(context)*0.07,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                    ),
                  ),
                  SizedBox(width: AppDefaults.bodyPadding,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Responsive.isMobile(context)?AppDefaults.width(context)*0.08: AppDefaults.width(context)*0.10,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Container(
                        width: Responsive.isMobile(context)? AppDefaults.width(context)*0.04:AppDefaults.width(context)*0.02,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10,),

              Container(
                width: double.maxFinite,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.maxFinite,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.maxFinite,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
                ),
              ),
              const SizedBox(height: 10,),
              // Container(
              //   width: double.maxFinite,
              //   height: 15,
              //   decoration: BoxDecoration(
              //     color: Colors.grey,
              //     borderRadius: BorderRadius.circular(AppDefaults.bodyPadding),
              //   ),
              // ),
              // const SizedBox(height: 10,),
              //  SizedBox(height: AppDefaults.bodyPadding,),

            ],
          ),
        )
    );

  }
}
