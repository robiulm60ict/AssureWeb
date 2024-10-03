
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/defaults.dart';
import '../../../configs/ghaps.dart';
import '../../../widgets/avatar/customer_rounded_avatar.dart';

class PopularProductItem extends StatefulWidget {
  const PopularProductItem({
    super.key,
    required this.name,
    required this.price,
    required this.imageSrc,
    required this.isActive,
    this.onPressed,
  });

  final String name, price, imageSrc;
  final String isActive;
  final Function()? onPressed;

  @override
  State<PopularProductItem> createState() => _PopularProductItemState();
}

class _PopularProductItemState extends State<PopularProductItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.padding * 0.5,
        vertical: AppDefaults.padding * 0.75,
      ),
    decoration: BoxDecoration( 
      
      borderRadius: BorderRadius.circular(8),
      color: Colors.black12.withOpacity(0.1),),


      margin: EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) {
          setState(() {
            isHovered = value;
          });
        },
        child: Row(
          children: [
            CustomerRoundedAvatar(imageSrc: widget.imageSrc),
            gapW8,
            Expanded(
              child: Text(
                widget.name,
                maxLines: 2,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isHovered ? AppColors.primary : null),
              ),
            ),
            gapW8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                 "${ widget.price} BDT",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isHovered ? AppColors.primary : null),
                ),
                gapH4,
                Chip(
                  backgroundColor: widget.isActive=="available"
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDefaults.padding * 0.25,
                      vertical: AppDefaults.padding * 0.25),
                  label: Text(
                    widget.isActive.toString().capitalize.toString(),
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: widget.isActive =="available"
                            ? AppColors.success
                            : AppColors.error),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
