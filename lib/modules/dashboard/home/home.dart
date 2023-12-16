import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/custom_views/navbar/dashboard_navbar.dart';
import 'package:sugar_smart_assist/custom_views/border_view.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:sugar_smart_assist/models/menu.dart';
import 'package:sugar_smart_assist/modules/dashboard/home/home_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sugar_smart_assist/custom_views/skeleton/dashboard_skeleton.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenScreenState createState() => _HomeScreenScreenState();
}

class _HomeScreenScreenState extends State<HomeScreen> {
  late HomeApiService apiService;
  var _isLoading = true, _isInit = false;

  @override
  void initState() {
    super.initState();
    apiService = HomeApiService(context: context);
    if (!_isInit) {
      _simulateLoad();
    }
    _isInit = true;
  }

  Future _simulateLoad({bool isRefreshControl = false}) async {}

  List<Menu> getRandomElements(List<Menu> list, int count) {
    final random = Random();
    final List<Menu> randomElements = [];
    final List<int> usedIndices = [];

    while (randomElements.length < count && list.isNotEmpty) {
      int randomIndex;

      // Generate a random index that hasn't been used before
      do {
        randomIndex = random.nextInt(list.length);
      } while (usedIndices.contains(randomIndex));

      randomElements.add(list[randomIndex]);
      usedIndices.add(randomIndex);
    }

    return randomElements;
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });
    await _simulateLoad(isRefreshControl: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppNavBar(),
      body: EasyRefresh.custom(
        onRefresh: _refresh,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [_buildBody()],
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.primaryBackgroundColor,
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20,
          0), // if padding is changed, please change width of container in DashboardMainMenuView, _mainMenu
      child: Column(
        children: [
          getBorderLineView(),
        ].withSpaceBetween(height: 24),
      ),
    );
  }
}
