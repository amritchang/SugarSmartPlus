import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar_smart_assist/app_router/app_router.dart';
import 'package:sugar_smart_assist/app_url/app_url.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:sugar_smart_assist/models/key_value.dart';
import 'package:sugar_smart_assist/modules/dropdown/dropdown_screen_arguments.dart';
import 'package:sugar_smart_assist/storage/storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TextFieldType {
  username,
  mobileNumber,
  email,
  password,
  confirmPassword,
  amount,
  dropdown,
  datePicker,
  numberpad,
  numberpadWithDecimal,
  remarks,
  none,
}

typedef TextChanged<T> = void Function(String value);

class AppTextField extends StatefulWidget {
  const AppTextField({
    this.preText,
    required this.placeholder,
    this.type,
    this.isSecure,
    this.isRequired = true,
    this.defaultCheckValue,
    this.suffixButtonText,
    required this.onTextChanged,
    this.onRightButtonPressed,
    this.dropdownItems,
    this.dropdownType,
    this.onTap,
    this.controller,
    this.minValue,
    this.maxValue,
    Key? key,
  }) : super(key: key);

  final String? preText;
  final String placeholder;
  final TextFieldType? type;
  final bool? isSecure;
  final bool isRequired;
  final String? defaultCheckValue;
  final String? suffixButtonText;
  final TextChanged onTextChanged;
  final GestureTapCallback? onRightButtonPressed;
  final List<KeyValue>? dropdownItems;
  final DropDownType? dropdownType;
  final GestureTapCallback? onTap;
  final TextEditingController? controller;
  final double? minValue;
  final double? maxValue;

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  TextEditingController controller = TextEditingController();
  bool isTapGestureActive = false;
  List<KeyValue>? dropdownItemsLocal;

  @override
  void initState() {
    super.initState();
    dropdownItemsLocal = widget.dropdownItems;
    if (widget.controller != null) {
      controller = widget.controller!;
    }
    _setUpInitialPreText();
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setUpInitialPreText();
  }

  void _setUpInitialPreText() {
    if ((widget.preText ?? '').isNotEmpty) {
      controller.text = widget.preText ?? '';
      if (widget.type != TextFieldType.dropdown) {
        widget.onTextChanged(widget.preText ?? '');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == TextFieldType.dropdown &&
        widget.type == TextFieldType.datePicker) {
      setState(() {
        isTapGestureActive = !isTapGestureActive;
      });
    }
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: widget.isSecure ?? false,
      keyboardType: _getKeyboardType(widget.type ?? TextFieldType.none),
      enableInteractiveSelection: isTapGestureActive,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textGreyColor),
        ),
        labelText: widget.placeholder,
        labelStyle: AppFonts.bodyTextStyle(color: AppColors.textGreyColor),
        hintText: widget.placeholder,
        hintStyle: AppFonts.bodyTextStyle(color: AppColors.textGreyColor),
        prefixIcon: _getLeftButton(),
        errorMaxLines: 3,
        suffixIcon: widget.suffixButtonText != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                child: GestureDetector(
                  onTap: widget.onRightButtonPressed,
                  child: Text(
                    widget.suffixButtonText!,
                    style: AppFonts.buttonTitleStyle(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              )
            : null,
      ),
      validator: (value) {
        // Only validate if the field is required
        if (widget.isRequired == false) {
          return null;
        }
        if (widget.isRequired && (value == null || value.isEmpty)) {
          return AppLocalizations.of(context)!.fieldIsRequiredText;
        }
        return _validateFields(
            widget.type ?? TextFieldType.none, value, widget.defaultCheckValue);
      },
      onChanged: (text) {
        widget.onTextChanged(text);
      },
      onTap: () {
        if (widget.type == TextFieldType.datePicker && widget.onTap != null) {
          widget.onTap!();
        } else if (widget.type == TextFieldType.dropdown) {
          if ((dropdownItemsLocal ?? []).isNotEmpty) {
            _navigateToDropDownSelectionScreen();
          }
        }
      },
    );
  }

  BuildContext _getBuildContext() {
    return context;
  }

  void _navigateToDropDownSelectionScreen() {
    var arguments = DropdownScreenArguments(
        widget.placeholder,
        dropdownItemsLocal ?? [],
        widget.dropdownType ?? DropDownType.none,
        controller, (item, type) {
      widget.onTextChanged(item.key);
    });
    Navigator.push(context, AppRouter().start(dropdown, arguments));
  }

  Widget? _getLeftButton() {
    if (widget.type == TextFieldType.mobileNumber) {
      // Get the device's locale
      final countryCode = Storage().selectedCountryCode == ''
          ? Constant.defaultCountryCode
          : Storage().selectedCountryCode;

      Storage().selectedCountryCode = countryCode;
      return GestureDetector(
        onTap: () {
          // Handle left button tap, e.g., show country code selector
        },
        child: CountryCodePicker(
          initialSelection: countryCode,
          showFlagMain: true,
          showFlagDialog: true,
          flagWidth: 24,
          onChanged: (CountryCode countryCode) {
            // Handle country code selection here
            Storage().selectedCountryCode = countryCode.dialCode ?? '';
          },
        ),
      );
    }
    return null;
  }

  TextInputType _getKeyboardType(TextFieldType type) {
    switch (type) {
      case TextFieldType.username:
        return TextInputType.text;
      case TextFieldType.mobileNumber:
      case TextFieldType.numberpad:
        return TextInputType.number;
      case TextFieldType.numberpadWithDecimal:
        return const TextInputType.numberWithOptions(decimal: true);
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.dropdown:
      case TextFieldType.datePicker:
        return TextInputType.none;
      default:
        return TextInputType.text;
    }
  }

  String? _validateFields(
      TextFieldType type, String? value, String? defaultCheckValue) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.fieldIsRequiredText;
    }
    switch (type) {
      case TextFieldType.mobileNumber:
        {
          RegExp reg = RegExp(r"^[0-9][0-9]{8,15}$");
          return (reg.hasMatch(value))
              ? null
              : AppLocalizations.of(context)!.invalidMobileNumberText;
        }
      case TextFieldType.username:
        {
          //Mobile Number, Email, Password
          RegExp reg = RegExp(
              r"^(?:[0-9][0-9]{9,15}|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}|[a-zA-Z0-9._%+-]+)$");

          return (reg.hasMatch(value))
              ? null
              : AppLocalizations.of(context)!.invalidUserNameText;
        }
      case TextFieldType.email:
        {
          RegExp reg = RegExp(
            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$",
          );
          return (reg.hasMatch(value))
              ? null
              : AppLocalizations.of(context)!.invalidEmailText;
        }

      case TextFieldType.password:
        {
          RegExp reg =
              RegExp(r"^(?=.*[A-Z])((?=.*\W))(?=.*[0-9])(?=.*[a-z]).{6,15}$");
          return (reg.hasMatch(value))
              ? null
              : AppLocalizations.of(context)!.invalidPasswordText;
        }
      case TextFieldType.confirmPassword:
        return (defaultCheckValue == value)
            ? null
            : AppLocalizations.of(context)!.invalidConfirmPassword;

      case TextFieldType.amount:
        {
          RegExp reg = RegExp(r"^\d+(\.\d{1,2})?$");
          return (reg.hasMatch(value))
              ? null
              : AppLocalizations.of(context)!.invalidAmountText;
        }
      case TextFieldType.remarks:
        {
          RegExp reg = RegExp(r'^.{5,}$');
          return (reg.hasMatch(value))
              ? null
              : AppLocalizations.of(context)!.invalidRemarksText;
        }
      default:
        {
          double enteredValue = double.tryParse(value) ?? 0.0;

          if (widget.minValue != null && enteredValue < widget.minValue!) {
            return '${widget.placeholder} must be greater than ${widget.minValue}';
          }

          if (widget.maxValue != null && enteredValue > widget.maxValue!) {
            return '${widget.placeholder} must be less than ${widget.maxValue}';
          }
          return null;
        }
    }
  }
}
