import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/custom_views/empty_list_view.dart';
import 'package:sugar_smart_assist/models/key_value.dart';
import 'package:sugar_smart_assist/modules/confirm_view/confirm_screen_arguments.dart';
import 'package:sugar_smart_assist/custom_views/navbar/dashboard_navbar.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sugar_smart_assist/custom_views/skeleton/dashboard_skeleton.dart';
import 'package:sugar_smart_assist/helper/string_extension.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history_api.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history_request.dart';
import 'package:sugar_smart_assist/modules/history/prediction_history_response.dart';
import 'package:intl/intl.dart';

class PredictionHistoryScreen extends StatefulWidget {
  const PredictionHistoryScreen({Key? key}) : super(key: key);
  @override
  _PredictionHistoryScreenState createState() =>
      _PredictionHistoryScreenState();
}

class _PredictionHistoryScreenState extends State<PredictionHistoryScreen> {
  late PredictionnHistoryApiService apiService;
  late PredictionHistoryRequest request;
  var _isLoading = true, _isLoadingMore = false, _isInit = false;
  List<PredictionHistoryResponse> _data = [];
  late bool _isLastPage;
  late int _pageNumber;
  late ScrollController _scrollController;
  final int _numberOfPostsPerRequest = 10;
  late bool _isFetching;

  @override
  void initState() {
    super.initState();
    apiService = PredictionnHistoryApiService(context: context);
    request = PredictionHistoryRequest();
    request.startingDate = DateFormat(DateFormatType.yearMonthDayDashed.pattern)
        .format(DateTime.now().subtract(const Duration(days: 90)));
    request.endingDate = DateFormat(DateFormatType.yearMonthDayDashed.pattern)
        .format(DateTime.now());
    _pageNumber = 1;
    _isLastPage = false;
    _isFetching = false;
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
      _pageNumber = 1;
      request.page = _pageNumber;
      var res = await apiService.getTransactions(request);
      if (res != null && mounted) {
        setState(() {
          _isLoading = false;
          _data = res;
          _pageNumber++;
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

  void _loadMoreData() {
    if (_isFetching) {
      return;
    }
    request.page = _pageNumber;
    _isFetching = true;
    apiService.getTransactions(request).then((res) {
      if (res != null) {
        setState(() {
          _data = res;
          _isLastPage = res.length < _numberOfPostsPerRequest;
          _isLoadingMore = false;
          _pageNumber++;
        });
        _isFetching = false;
      } else {
        setState(() {
          _isLoadingMore = false;
        });
        _isFetching = false;
      }
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });
    _simulateLoad(isRefreshControl: true);
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;
      if (_scrollController.position.pixels > nextPageTrigger) {
        setState(() {
          _isLoadingMore = true;
        });
        _loadMoreData();
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
                  return _isLoadingMore
                      ? const Center(
                          child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ))
                      : null;
                }
                final transaction = _data[index];
                final previousTransaction = index > 0 ? _data[index - 1] : null;

                final isNewDate = previousTransaction == null ||
                    formatDate(
                            transaction.date ?? '',
                            DateFormatType.yearMonthDayDashedCommaTime,
                            DateFormatType.monthNameDayCommaYear) !=
                        formatDate(
                            previousTransaction.date ?? '',
                            DateFormatType.yearMonthDayDashedCommaTime,
                            DateFormatType.monthNameDayCommaYear);

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
                                    transaction.date ?? '',
                                    DateFormatType.yearMonthDayDashedCommaTime,
                                    DateFormatType.dayOnly),
                                style: AppFonts.menuTitleTextStyle(
                                    color: AppColors.textBlackColor, size: 32),
                              ),
                              Text(
                                  formatDate(
                                      transaction.date ?? '',
                                      DateFormatType
                                          .yearMonthDayDashedCommaTime,
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
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getIconWithSize(
                model.transactionType?.toLowerCase() == 'load'
                    ? 'incoming_icon.png'
                    : 'outgoing_icon.png',
                40,
                40,
                backgroundColor: model.transactionType?.toLowerCase() == 'load'
                    ? AppColors.successColor
                    : AppColors.failureColor,
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
                        model.serviceName ??
                            model.destinationAccount ??
                            model.destinationOwnerName ??
                            '',
                        style: AppFonts.titleMediumTextStyle(
                            color: AppColors.textBlackColor),
                      ),
                      Text(
                        '${formatDate(model.date ?? '', DateFormatType.yearMonthDayDashedCommaTime, DateFormatType.hourMinuteAmPm)} | ${model.transactionStatus}',
                        style: AppFonts.bodyTextStyle(
                            color: AppColors.textGreyColor),
                      ),
                    ].withSpaceBetween(height: 12),
                  ),
                ].withSpaceBetween(height: 10),
              ),
            ),
            Text(
              (model.amount ?? 0).toStringAsFixed(2),
              style: AppFonts.titleMediumTextStyle(
                  color: model.transactionType?.toLowerCase() == 'load'
                      ? AppColors.successColor
                      : AppColors.failureColor),
            ),
          ].withSpaceBetween(width: 12),
        ),
      ),
    );
  }
}
