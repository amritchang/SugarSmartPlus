import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/custom_views/empty_list_view.dart';
import 'package:sugar_smart_assist/custom_views/navbar/dashboard_navbar.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sugar_smart_assist/custom_views/skeleton/dashboard_skeleton.dart';
import 'package:sugar_smart_assist/helper/string_extension.dart';
import 'package:sugar_smart_assist/models/key_value.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history_api.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history_response.dart';
import 'package:sugar_smart_assist/modules/confirm_view/confirm_screen_arguments.dart';

class PredictionHistoryScreen extends StatefulWidget {
  const PredictionHistoryScreen({Key? key}) : super(key: key);
  @override
  _PredictionHistoryScreenState createState() =>
      _PredictionHistoryScreenState();
}

class _PredictionHistoryScreenState extends State<PredictionHistoryScreen> {
  late PredictionnHistoryApiService apiService;
  var _isLoading = true, _isLoadingMore = false, _isInit = false;
  List<PredictionHistoryResponse> _data = [];
  late bool _isLastPage;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    apiService = PredictionnHistoryApiService(context: context);

    _isLastPage = false;
    _scrollController = ScrollController();

    if (!_isInit) {
      _simulateLoad();
    }
    _isInit = true;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future _simulateLoad({bool isRefreshControl = false}) async {
    _data = [];
    if (_data.isEmpty) {
      var res = await apiService.getHistory();
      if (res != null && mounted) {
        setState(() {
          _isLoading = false;
          _data = res;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });
    _simulateLoad(isRefreshControl: true);
  }

  void _navigateToDetailScreen(PredictionHistoryResponse model) async {
    var request = model.prediction;
    if (request != null) {
      List<KeyValue> data = [
        KeyValue(
            key: AppLocalizations.of(_getContext())!.ageText,
            value: request.age),
        KeyValue(
            key: AppLocalizations.of(_getContext())!.genderText,
            value: request.gender),
        KeyValue(
            key: AppLocalizations.of(_getContext())!.pregnanciesText,
            value: request.pregnancies),
        KeyValue(
            key: '${AppLocalizations.of(_getContext())!.glucoseText} (mg/dL)',
            value: request.glucose),
        KeyValue(
            key:
                '${AppLocalizations.of(_getContext())!.bloodPressureText} (mmHg)',
            value: request.bloodpressure),
        KeyValue(
            key: AppLocalizations.of(_getContext())!.skinnThicknessText,
            value: request.skinthickness),
        KeyValue(
            key: '${AppLocalizations.of(_getContext())!.insulinText} (IU/mL)',
            value: request.insulin),
        KeyValue(
            key: AppLocalizations.of(_getContext())!
                .diabetesPedigreeFunctionText,
            value: request.diabetesPedigreeFunction),
        KeyValue(
            key: '${AppLocalizations.of(_getContext())!.bmiText} (kg/m^2)',
            value: request.bmi),
        KeyValue(
            key: AppLocalizations.of(_getContext())!.outcomeText,
            value: (request.outcome == '1.0' || request.outcome == '1')
                ? 'Positive'
                : 'Negative'),
        KeyValue(
            key: AppLocalizations.of(context)!.chanceToDiabetesText,
            value: (request.outcome == '1.0' || request.outcome == '1')
                ? ''
                : '${(double.parse(request.timeToDiabetes) * 100).toStringAsFixed(0)} %'),
      ];

      var suggestion = await apiService.getSuggestion(model.predictionId ?? '');

      if (suggestion != null) {
        final args = ConfirmScreenArguments(
          AppLocalizations.of(_getContext())!.predictionScreenTitle,
          data
              .where(
                  (item) => (item.value.isNotEmpty || item.childs.isNotEmpty))
              .toList(),
          model.predictionId ?? '',
          request.outcome,
          request,
          suggestion,
          ConfirmScreenType.none,
        );
        Navigator.push(_getContext(), AppRouter().start(confirmScreen, args));
      }
    }
  }

  BuildContext _getContext() {
    return context;
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;
      if (_scrollController.position.pixels > nextPageTrigger) {
        setState(() {
          _isLoadingMore = true;
        });
      }
    });
    return Scaffold(
      appBar: DashboardAppNavBar(),
      body: SafeArea(
        minimum: EdgeInsets.only(bottom: Constant.bottomPadding),
        child: Stack(
          children: [
            _buildBody(),
            Positioned(
              bottom: 10.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(AppRouter().start(prediction));
                },
                backgroundColor: AppColors.primaryColor,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.primaryBackgroundColor,
    );
  }

  Widget _buildBody() {
    if (!_isLoading && !_isLoadingMore && _data.isEmpty) {
      return getEmptyWidget(
          AppLocalizations.of(context)!.noDataFoundText,
          AppLocalizations.of(context)!.pleaseTryAgain,
          AppLocalizations.of(context)!.refreshButton, () {
        _refresh();
      });
    }
    return EasyRefresh(
      onRefresh: _refresh,
      controller: EasyRefreshController(),
      child: _isLoading
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: const DashboardSkeleton(),
            )
          : ListView.separated(
              itemCount:
                  (_data.isNotEmpty) ? _data.length + (_isLastPage ? 0 : 1) : 0,
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
              itemBuilder: (context, index) {
                if (index == _data.length) {
                  return null;
                }
                final transaction = _data[index];
                final previousTransaction = index > 0 ? _data[index - 1] : null;

                final isNewDate = previousTransaction == null ||
                    formatDate(
                            '${transaction.date?.toDate()}',
                            DateFormatType.deviceFormat,
                            DateFormatType.monthNameDayCommaYear) !=
                        formatDate(
                            '${previousTransaction.date?.toDate()}',
                            DateFormatType.deviceFormat,
                            DateFormatType.monthNameDayCommaYear);
                ;

                if (isNewDate) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                formatDate(
                                    '${transaction.date?.toDate()}',
                                    DateFormatType.deviceFormat,
                                    DateFormatType.dayOnly),
                                style: AppFonts.menuTitleTextStyle(
                                    color: AppColors.textBlackColor, size: 32),
                              ),
                              Text(
                                  formatDate(
                                      '${transaction.date?.toDate()}',
                                      DateFormatType.deviceFormat,
                                      DateFormatType.monthNameCommaYear),
                                  style: AppFonts.menuTitleTextStyle(
                                      color: AppColors.textBlackColor,
                                      size: 16)),
                            ].withSpaceBetween(width: 8.0),
                          )),
                      recentPrediction(transaction, false),
                    ],
                  );
                } else {
                  return recentPrediction(transaction, false);
                }
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 24);
              },
            ),
    );
  }

  Widget recentPrediction(PredictionHistoryResponse model, bool hideBorder) {
    return GestureDetector(
      onTap: () {
        if (model.prediction != null) {
          _navigateToDetailScreen(model);
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getIconWithSize(
                (model.prediction?.outcome == "1.0" ||
                        model.prediction?.outcome == "1")
                    ? 'close.png'
                    : 'check.png',
                40,
                40,
                backgroundColor: (model.prediction?.outcome == "1.0" ||
                        model.prediction?.outcome == "1")
                    ? AppColors.failureColor
                    : AppColors.successColor,
                cornerRadius: 5.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prediction of Diabetes',
                        style: AppFonts.titleMediumTextStyle(
                            color: AppColors.textBlackColor),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.outcomeText} ${model.prediction?.outcome}: ${(model.prediction?.outcome == "1.0" || model.prediction?.outcome == "1") ? "Positive" : "Negative"}',
                        style: AppFonts.bodyTextStyle(
                            color: AppColors.textGreyColor),
                      ),
                    ].withSpaceBetween(height: 12),
                  ),
                ].withSpaceBetween(height: 10),
              ),
            ),
          ].withSpaceBetween(width: 12),
        ),
      ),
    );
  }
}
