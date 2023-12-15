import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';

Widget getTemplatedIconWithSize(
    String imageName, Color color, double height, double width) {
  return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: Image(
          image: AssetImage('assets/images/$imageName'),
          height: height,
          width: width));
}

Widget getIcon(String imageName,
    {Color? backgroundColor, double cornerRadius = 0.0}) {
  return Container(
    decoration: BoxDecoration(
      color: backgroundColor?.withOpacity(0.2),
      borderRadius: BorderRadius.circular(cornerRadius),
    ),
    child: Image(
      image: AssetImage('assets/images/$imageName'),
    ),
  );
}

Widget getIconWithSize(String imageName, double height, double width,
    {Color? backgroundColor, double cornerRadius = 0.0}) {
  return Container(
    decoration: BoxDecoration(
      color: backgroundColor?.withOpacity(0.2),
      borderRadius: BorderRadius.circular(cornerRadius),
    ),
    child: Image(
      image: AssetImage('assets/images/$imageName'),
      height: height,
      width: width,
    ),
  );
}

Widget getCircularIconWithSize(
    String imageUrl, String? defaultIconName, double imageSize) {
  // Calculate the radius of the CircleAvatar based on imageSize
  double avatarRadius = imageSize / 2;

  return ClipOval(
    child: SizedBox(
      width: imageSize,
      height: imageSize,
      child: Center(
        child: CachedNetworkImage(
          memCacheWidth: imageSize.toInt(),
          memCacheHeight: imageSize.toInt(),
          maxHeightDiskCache: imageSize.toInt(),
          maxWidthDiskCache: imageSize.toInt(),
          imageUrl: imageUrl,
          placeholder: (context, url) =>
              _buildDefaultImage(imageSize, defaultIconName, avatarRadius),
          errorWidget: (context, url, error) =>
              _buildDefaultImage(imageSize, defaultIconName, avatarRadius),
          imageBuilder: (context, imageProvider) =>
              _buildCircularImage(imageProvider, avatarRadius),
        ),
      ),
    ),
  );
}

Widget getCircularIconWithSizeWithBgColor(
    String imageUrl, String? defaultIconName, double imageSize,
    [Color? backgroundColor]) {
  // Calculate the radius of the CircleAvatar based on imageSize
  double avatarRadius = imageSize;

  return Container(
    width: avatarRadius,
    height: avatarRadius,
    decoration: BoxDecoration(
      color: backgroundColor ?? AppColors.primaryColor,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Image.network(
        imageUrl,
        width: avatarRadius - 15,
        height: avatarRadius - 15,
      ),
    ),
  );
}

Widget _buildDefaultImage(
    double imageSize, String? defaultIconName, double avatarRadius) {
  return CircleAvatar(
    backgroundImage: AssetImage('assets/images/$defaultIconName'),
    radius: avatarRadius,
  );
}

Widget _buildCircularImage(
    ImageProvider<Object> imageProvider, double avatarRadius) {
  return CircleAvatar(
    backgroundImage: imageProvider,
    radius: avatarRadius,
  );
}
