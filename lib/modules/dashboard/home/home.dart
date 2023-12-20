import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/custom_views/alert/alert_handler.dart';
import 'package:sugar_smart_assist/custom_views/navbar/dashboard_navbar.dart';
import 'package:sugar_smart_assist/custom_views/border_view.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:sugar_smart_assist/helper/local_auth_helper.dart';
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
  var _isInit = false;

  @override
  void initState() {
    super.initState();
    apiService = HomeApiService(context: context);
    if (!_isInit) {
      if (!isHealthMetricsAlertShown) {
        isHealthMetricsAlertShown = true;
        _getHealthMetrics();
      }
    }
    _isInit = true;
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
    isHealthMetricsAlertShown = false;
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
        children: [getBorderLineView(), _getMetricCardsView()]
            .withSpaceBetween(height: 24),
      ),
    );
  }

  Widget _getMetricCardsView() {
    return Column(
      children: [
        MetricCard(
          title: 'Overview',
          metrics: {
            'Total Pregnancies': '5',
            'Average Glucose Levels': '120 mg/dL',
            'Average Blood Pressure': '120/80 mmHg',
            'Average Skin Thickness': '20 mm',
            'Average Insulin Levels': '15 units',
            'Average BMI': '25.5',
            'Average Diabetes Pedigree Function': '0.5',
            'Average Age': '35',
          },
        ),
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final Map<String, String> metrics;
  final Widget? child;

  MetricCard({required this.title, required this.metrics, this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  AppFonts.titleBoldTextStyle(color: AppColors.textBlackColor),
            ),
            const SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: metrics.entries
                  .map((entry) => Text(
                        '${entry.key}: ${entry.value}',
                        style: AppFonts.bodyTextStyle(
                            color: AppColors.textBlackColor),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10.0),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
