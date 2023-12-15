import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class DashboardSkeleton extends StatefulWidget {
  const DashboardSkeleton({Key? key}) : super(key: key);

  @override
  _DashboardSkeletonState createState() => _DashboardSkeletonState();
}

class _DashboardSkeletonState extends State<DashboardSkeleton> {
  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 50,
              color: AppColors.themeWhite,
            ),
            Container(
              width: double.infinity,
              height: 100,
              color: AppColors.themeWhite,
            ),
          ].withSpaceBetween(height: 24),
        ),
      ),
      items: 3,
      period: const Duration(seconds: 2),
      highlightColor: Colors.grey.shade50,
      direction: SkeletonDirection.ltr,
    );
  }
}
