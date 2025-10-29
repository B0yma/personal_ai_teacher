import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcon extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;

  const CustomIcon(
    this.assetName, {
    super.key,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$assetName',
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}