import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:sugar_smart_assist/custom_views/navbar/dashboard_navbar.dart';
import 'package:sugar_smart_assist/custom_views/border_view.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:sugar_smart_assist/modules/dashboard/home/home_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenScreenState createState() => _HomeScreenScreenState();
}

class _HomeScreenScreenState extends State<HomeScreen> {
  late HomeApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = HomeApiService(context: context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call _getHealthMetrics when the view appears or dependencies change
    _getHealthMetrics();
  }

  void _getHealthMetrics() async {
    var res = await apiService.getUserHealthInformation();
    if (res != null) {
    } else {
      showAlertDialogWithOk(
        AppLocalizations.of(_getContext())!.notSetHealthMetricsAlertTitle,
        AppLocalizations.of(_getContext())!.notSetHealthMetricsAlertDesc,
        _getContext(),
        onOkPressed: () {
          Navigator.push(_getContext(), AppRouter().start(prediction));
        },
      );
    }
  }

  BuildContext _getContext() {
    return context;
  }

  Future<void> _refresh() async {
    _getHealthMetrics();
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
