import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/custom_views/navbar/dashboard_navbar.dart';
import 'package:sugar_smart_assist/custom_views/border_view.dart';
import 'package:sugar_smart_assist/custom_views/shadow.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:sugar_smart_assist/helper/local_auth_helper.dart';
import 'package:sugar_smart_assist/models/health_metrics.dart';
import 'package:sugar_smart_assist/models/suggestion.dart';
import 'package:sugar_smart_assist/modules/dashboard/home/home_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sugar_smart_assist/modules/prediction/prediction_request.dart';
import 'package:sugar_smart_assist/storage/storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenScreenState createState() => _HomeScreenScreenState();
}

class _HomeScreenScreenState extends State<HomeScreen> {
  late HomeApiService apiService;
  var _isInit = false;
  List<MetricItem> _metricItems = [];
  HealthMetrics? _healthMetrics;
  SuggestionModel? _currentSuggestion;
  String _gender = '';

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
    _setGender();
  }

  void _getHealthMetrics() async {
    var res = await apiService.getUserHealthInformation();
    if (res != null) {
      _healthMetrics = res;
      _getCurrentSuggestion();
    }
    _setMetricItems();
  }

  void _getCurrentSuggestion() async {
    var res =
        await apiService.getSuggestion(_healthMetrics?.predictionId ?? '');
    if (res != null) {
      setState(() {
        _currentSuggestion = res;
      });
    }
  }

  void _setGender() async {
    var user = await Storage().getUser();
    _gender = user?.gender ?? '';
  }

  String _getGender() {
    return _gender;
  }

  void _setMetricItems() async {
    var user = await Storage().getUser();
    var isEmpty = _healthMetrics == null;
    var isMale = user?.gender?.toLowerCase() == "male";
    setState(() {
      _metricItems = [
        MetricItem(
            label: AppLocalizations.of(_getContext())!.ageText,
            value: isEmpty ? '?' : (_healthMetrics?.age ?? ""),
            description: ''),
        if (!isMale)
          MetricItem(
            label: AppLocalizations.of(_getContext())!.pregnanciesText,
            value: isEmpty ? '?' : (_healthMetrics?.pregnancies ?? ""),
            description: '',
          ),
        MetricItem(
            label: AppLocalizations.of(_getContext())!.glucoseText,
            value: isEmpty ? '?' : (_healthMetrics?.glucose ?? ""),
            description: 'mg/dL'),
        MetricItem(
            label: AppLocalizations.of(_getContext())!.bloodPressureText,
            value: isEmpty ? '?' : (_healthMetrics?.bloodpressure ?? ""),
            description: 'mmHg'),
        MetricItem(
            label: AppLocalizations.of(_getContext())!.skinnThicknessText,
            value: isEmpty ? '?' : (_healthMetrics?.skinthickness ?? ""),
            description: 'IU/mL'),
        MetricItem(
            label: AppLocalizations.of(_getContext())!.insulinText,
            value: isEmpty ? '?' : (_healthMetrics?.insulin ?? ""),
            description: ''),
        MetricItem(
            label: AppLocalizations.of(_getContext())!
                .diabetesPedigreeFunctionText,
            value: isEmpty
                ? '?'
                : (_healthMetrics?.diabetesPedigreeFunction ?? ""),
            description: 'kg/m^2'),
        MetricItem(
            label: AppLocalizations.of(_getContext())!.bmiText,
            value: isEmpty ? '?' : (_healthMetrics?.bmi ?? ""),
            description: '')
      ];
    });
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
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 110),
        child: EasyRefresh.custom(
          onRefresh: _refresh,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [_buildBody()],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.primaryBackgroundColor,
    );
  }

  void _handleTap() {
    if (_healthMetrics != null) {
      var healthReq =
          PredictionModel.fromHelthMetrics(_healthMetrics!, _getGender());
      Navigator.push(_getContext(), AppRouter().start(prediction, healthReq));
    } else {
      Navigator.push(_getContext(), AppRouter().start(prediction));
    }
  }

  Widget _buildBody() {
    if (_metricItems.isEmpty) {
      _getHealthMetrics();
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          getBorderLineView(),
          if (_healthMetrics == null) _getSuggestionBox(),
          if (_currentSuggestion != null)
            _getSuggestionBox(AppLocalizations.of(context)!.suggestionText,
                _currentSuggestion?.suggestion),
          _getMetricListView(),
        ].withSpaceBetween(height: 12),
      ),
    );
  }

  Widget _getMetricListView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount:
          _metricItems.length, // Adjust based on the number of items you have
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        return MetricItem(
          label: _metricItems[index].label,
          value: _metricItems[index].value,
          description: _metricItems[index].description,
          onTap: () {
            _handleTap();
          },
        );
      },
    );
  }

  Widget _getSuggestionBox([String? title, String? body]) {
    return InkWell(
      onTap: () {
        _handleTap();
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: _currentSuggestion == null
              ? AppColors.primaryColor
              : AppColors.failureColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: cardShadow(),
        ),
        child: Column(
          children: [
            Text(
              title ??
                  AppLocalizations.of(_getContext())!
                      .notSetHealthMetricsAlertTitle,
              style: AppFonts.titleBoldTextStyle(
                color: AppColors.textWhiteColor,
                size: 20.0,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              body ??
                  AppLocalizations.of(_getContext())!
                      .notSetHealthMetricsAlertDesc,
              style: AppFonts.titleBoldTextStyle(
                color: AppColors.textWhiteColor,
                size: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final String description;
  Function()? onTap;

  MetricItem(
      {required this.label,
      required this.value,
      required this.description,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        color: AppColors.primaryBoxColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                  boxShadow: cardShadow(), // Customize the color as needed
                ),
                child: Center(
                  child: Text(
                    value,
                    style:
                        AppFonts.bodyTextStyle(color: AppColors.textWhiteColor),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppFonts.titleBoldTextStyle(
                    color: AppColors.textBlackColor, size: 14.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppFonts.bodyTextStyle(
                    color: AppColors.textBlackColor, size: 12.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
