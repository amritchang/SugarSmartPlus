import 'package:sugar_smart_assist/models/service.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';

enum MenuType {
  category,
  service,
  dashboard,
  resetPin,
  changePin,
  changePassword,
  deleteUser,
  changeLanguage,
  loadFund,
  globalPayments,
  giftCards,
  none
}

class Menu {
  String? menuId;
  String? menuName;
  String? menuIcon;
  String? menuDesc;
  MenuType? menuType;
  Service? service;
  String? defaultMenuIcon;

  Menu({
    this.menuId,
    this.menuName,
    this.menuIcon,
    this.menuDesc,
    this.menuType,
    this.service,
    String? defaultMenuIcon,
  }) : defaultMenuIcon = defaultMenuIcon ?? Constant.defaultPaymentImage;
}
