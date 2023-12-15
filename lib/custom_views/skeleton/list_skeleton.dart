import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ListSkeleton extends StatefulWidget {
  const ListSkeleton({Key? key}) : super(key: key);

  @override
  _ListSkeletonState createState() => _ListSkeletonState();
}

class _ListSkeletonState extends State<ListSkeleton> {
  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 10,
              color: AppColors.themeWhite,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 12,
              color: AppColors.themeWhite,
            ),
          ],
        ),
      ),
      items: 10,
      period: const Duration(seconds: 2),
      highlightColor: Colors.grey.shade50,
      direction: SkeletonDirection.ltr,
    );
  }
}
