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
          CircleAvatar(
            radius: Responsive.isMobile(context) ? 30 : 30, // Adjust radius based on mobile or desktop
            backgroundColor: AppColors.bg, // Set background color
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
              widget.  imageSrc.toString(),
                fit: BoxFit.fill,  height: Responsive.isMobile(context) ? 70 : 100,
                width: Responsive.isMobile(context) ? 70 : 100,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Image has loaded
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    height: Responsive.isMobile(context) ? 70 : 100,
                    width: Responsive.isMobile(context) ? 70 : 100,
                    child:  ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                       child:
                        Image.network(
                      "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                      fit: BoxFit.fill,  height: Responsive.isMobile(context) ? 70 : 100,
                          width: Responsive.isMobile(context) ? 70 : 100,
                    )),
                  );
                },
              ),
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
