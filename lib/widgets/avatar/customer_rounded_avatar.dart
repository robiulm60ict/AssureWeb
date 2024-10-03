import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Make sure to import Material for Image.network
import '../../configs/defaults.dart';

class CustomerRoundedAvatar extends StatelessWidget {
  const CustomerRoundedAvatar({
    super.key,
    this.height = 54,
    this.width = 54,
    this.radius = AppDefaults.borderRadius,
    required this.imageSrc,
  });

  final double height, width, radius;
  final String? imageSrc; // Make imageSrc nullable

  @override
  Widget build(BuildContext context) {
    return ClipRRect( // Us// ing ClipOval to create a circular avatar
      borderRadius: BorderRadius.circular(8),

      child: SizedBox(
        height: height,
        width: width,
        child: imageSrc != null && imageSrc!.isNotEmpty
            ? Image.network(
          imageSrc!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child; // If loading is done, show the child
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
            return Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              child:ClipRRect(
                borderRadius: BorderRadius.circular(8),
              child:
              Image.asset("assets/images/building_noimage.jpg",fit: BoxFit.fill, height: height,
                width: width,),
              ));
          },
        )
            : Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          child: const Icon(Icons.person, color: Colors.grey), // Placeholder icon if no image
        ),
      ),
    );
  }
}
