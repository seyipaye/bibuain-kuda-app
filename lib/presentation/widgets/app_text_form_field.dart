import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/theme.dart';
import '../utils/values.dart';
import 'styles.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField(
      {Key? key,
      this.obscureText = false,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.label,
      this.hintText,
      this.enabled = true,
      this.textInputType = TextInputType.text,
      this.onChanged,
      this.prefixText,
      this.prefixIcon,
      this.suffixIcon,
      this.textEditingController,
      this.inputFormatters,
      this.maxLength,
      this.maxLines = 1,
      this.moneyInput = false,
      this.onTap,
      this.readOnly = false,
      this.decoration,
      this.onSaved,
      this.validator,
      this.initialValue,
      this.textInputAction,
      this.onSubmitted,
      this.minLines,
      this.expands = false,
      this.maxLengthEnforcement,
      this.autofillHints,
      this.style})
      : super(key: key);

  final String? initialValue;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSubmitted;
  final String? hintText;
  final String? label;
  final bool enabled;
  final bool readOnly;
  final TextInputType textInputType;
  final ValueChanged<String>? onChanged;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final bool moneyInput;
  final TextStyle? style;
  final InputDecoration? decoration;
  final TextInputAction? textInputAction;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final _textFormField = TextFormField(
      autofillHints: autofillHints,
      autovalidateMode: autovalidateMode,
      textAlignVertical: TextAlignVertical.center,
      minLines: minLines,
      expands: expands,
      keyboardType: moneyInput
          ? const TextInputType.numberWithOptions(signed: false, decimal: false)
          : textInputType,
      onChanged: onChanged,
      onTap: onTap,
      initialValue: initialValue,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: textInputAction,
      maxLengthEnforcement: maxLengthEnforcement,
      inputFormatters: inputFormatters,
      // inputFormatters: moneyInput
      //     ? [WhitelistingTextInputFormatter.digitsOnly, MoneyFormatter()]
      //     : [LengthLimitingTextInputFormatter(maxLength)],
      controller: textEditingController,
      //cursorColor: Colors.grey,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      showCursor: !readOnly,
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
      onFieldSubmitted: onSubmitted,
      style: style,
      decoration: decoration ??
          InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: suffixIcon,
            ),
            prefixText: prefixText,
          ),
    );

    return label == null
        ? _textFormField
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label ?? '',
                style: kLabelStyle(context).copyWith(fontFamily: 'Cabin'),
              ),
              const SizedBox(
                height: AppMargin.m10,
              ),
              _textFormField,
            ],
          );
  }
}

class AppTextFormField2 extends StatefulWidget {
  AppTextFormField2(
      {Key? key,
      this.style,
      this.focusNode,
      this.obscureText = false,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.label,
      this.hintText,
      this.enabled = true,
      this.textInputType = TextInputType.text,
      this.onChanged,
      this.prefixText,
      this.prefixIcon,
      this.suffixIcon,
      this.textEditingController,
      this.inputFormatters,
      this.maxLength,
      this.maxLines = 1,
      this.moneyInput = false,
      this.onTap,
      this.readOnly = false,
      this.decoration,
      this.onSaved,
      this.validator,
      this.initialValue,
      this.textInputAction,
      this.onSubmitted,
      this.minLines,
      this.showCursor,
      this.keyboardType,
      this.expands = false,
      this.maxLengthEnforcement,
      this.autofillHints})
      : super(key: key);

  final TextStyle? style;
  final String? initialValue;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final String? Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSubmitted;
  final String? hintText;
  final String? label;
  final bool enabled;
  final bool readOnly;
  final TextInputType textInputType;
  final ValueChanged<String>? onChanged;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final bool? showCursor;
  final bool moneyInput;
  final InputDecoration? decoration;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  final MaxLengthEnforcement? maxLengthEnforcement;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextFormField2> createState() => _AppTextFormField2State();
}

class _AppTextFormField2State extends State<AppTextFormField2> {
  FocusNode get _effectiveFocusNode => widget.focusNode ?? FocusNode();
  Color? fillColor;

  @override
  void initState() {
    fillColor = AppColors.input_bg;

    _effectiveFocusNode.addListener(() {
      if (_effectiveFocusNode.hasFocus) {
        setState(() {
          fillColor = AppColors.primary.shade100;
        });
      } else {
        setState(() {
          fillColor = AppColors.input_bg;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _textFormField = TextFormField(
      autofillHints: widget.autofillHints,
      autovalidateMode: widget.autovalidateMode,
      minLines: widget.minLines,
      focusNode: _effectiveFocusNode,
      textAlignVertical: TextAlignVertical.center,
      expands: widget.expands,
      keyboardType: widget.moneyInput
          ? const TextInputType.numberWithOptions(signed: false, decimal: false)
          : widget.textInputType,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      initialValue: widget.initialValue,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: widget.textInputAction,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      inputFormatters: widget.inputFormatters,
      // inputFormatters: moneyInput
      //     ? [WhitelistingTextInputFormatter.digitsOnly, MoneyFormatter()]
      //     : [LengthLimitingTextInputFormatter(maxLength)],
      controller: widget.textEditingController,
      //cursorColor: Colors.grey,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor ?? !widget.readOnly,
      maxLines: widget.maxLines,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onFieldSubmitted: widget.onSubmitted,
      style: widget.style,
      decoration: widget.decoration ??
          InputDecoration(
            filled: true,
            fillColor: fillColor,
            focusColor: AppColors.primary.shade200,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: widget.suffixIcon,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            prefixText: widget.prefixText,
            helperMaxLines: 2,
            errorMaxLines: 2,
            isDense: true,
            focusedBorder: kGetInputBorder3(AppColors.primary),
            enabledBorder: kGetInputBorder2(AppColors.input_bg),
            errorBorder: kGetInputBorder3(AppColors.red),
            focusedErrorBorder: kGetInputBorder3(AppColors.red),
            hintStyle: getLabelSmallStyle(
              color: AppColors.hint,
            ),
          ),
    );

    return widget.label == null
        ? _textFormField
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label ?? '',
                style: kLabelStyle(context).copyWith(fontFamily: 'Cabin'),
              ),
              const SizedBox(
                height: AppMargin.m10,
              ),
              _textFormField,
            ],
          );
  }
}
