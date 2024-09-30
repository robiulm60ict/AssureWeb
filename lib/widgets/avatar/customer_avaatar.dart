import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../configs/app_colors.dart';
import '../../configs/ghaps.dart';
import '../../responsive.dart';

class CustomerAvatar extends StatefulWidget {
  const CustomerAvatar({
    super.key,
    required this.name,
    required this.imageSrc,
    this.onPressed,
  });

  final String name, imageSrc;
  final VoidCallback? onPressed;

  @override
  State<CustomerAvatar> createState() => _CustomerAvatarState();
}

class _CustomerAvatarState extends State<CustomerAvatar> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHover: (value) {
        setState(() {
          isHovered = value;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              imageUrl: widget.imageSrc.toString(),
              placeholder: (c, s) => Image.asset(
                "assets/icons/noimageperson.jpg",
                fit: BoxFit.cover,
              ),
              errorWidget: (c, s, d) => Image.asset(
                  "assets/icons/noimageperson.jpg", width: 60,
                  height: 60,
                  fit: BoxFit.cover),
            ),
          ),

          // if(!Responsive.isMobile(context))  gapH4,
          Text(
            widget.name,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: isHovered ? AppColors.primary : null),
          )
        ],
      ),
    );
  }
}
