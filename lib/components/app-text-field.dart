import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../bloc/language/language_state.dart';
import '../constants/color.dart';
import '../constants/size.dart';
import '../models/language.dart';

class AppTextField extends StatefulWidget {
  const AppTextField(
      {required this.title,
      this.focusNode,
      this.hitText = "",
      this.titleColor = blackColor,
      this.validator,
      this.onChanged,
      this.onTapOutside,
      this.textInputAction,
      this.autovalidateMode,
      this.obscureText = false,
      this.controller,
      this.onFieldSubmitted,
      this.onEditingComplete,
      this.suffixTop,
      this.suffixBottom,
      this.keyboardType = TextInputType.text,
      this.backgroundColor = whiteColor,
      this.borderColor = borderInputColor,
      this.borderFocusColor = primaryColor,
      this.cursorColor = primaryColor,
      this.textColor = blackColor,
      this.required = false,
      this.enabled = true,
      this.isTextAlignCenter = false,
      this.isStep = false,
      this.minLines = 1,
      this.maxLines = 1,
      this.onStepDown,
      this.onStepUp,
      this.height,
      this.width,
      super.key});

  final String title;
  final Color? titleColor;
  final FocusNode? focusNode;
  final String hitText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final Function()? onTapOutside;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final Widget? suffixTop;
  final Widget? suffixBottom;
  final TextInputType keyboardType;
  final Color backgroundColor;
  final Color borderColor;
  final Color borderFocusColor;
  final Color cursorColor;
  final Color textColor;
  final bool required;
  final bool enabled;
  final bool isStep;
  final bool isTextAlignCenter;
  final int minLines;
  final int? maxLines;
  final double? height;
  final double? width;
  final Function()? onStepDown;
  final Function()? onStepUp;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  String? _validationError;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();

  Language? curLang;

  _initLanguage(Language newLang) {
    if (curLang == null || curLang != newLang) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_validationError != null) {
          _fieldKey.currentState?.validate();
        }
        setState(() {
          curLang = newLang;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isError = _validationError != null && _validationError != "";
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        _initLanguage(state.selectedLanguage);
        return Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != '')
                  Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                text: widget.title,
                              ),
                              if (widget.required)
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: redColor))
                            ],
                            style: TextStyle(
                                fontSize: 14, color: widget.titleColor),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.suffixTop != null) widget.suffixTop!
                    ],
                  ),
                const SizedBox(height: 4),
                SizedBox(
                  height: widget.height,
                  child: TextFormField(
                    textAlign: widget.isTextAlignCenter
                        ? TextAlign.center
                        : TextAlign.start,
                    key: _fieldKey,
                    style: TextStyle(
                        color: widget.enabled ? widget.textColor : grayIOSColor,
                        fontSize: 16),
                    focusNode: widget.focusNode,
                    keyboardType: widget.keyboardType,
                    controller: widget.controller,
                    obscureText: widget.obscureText,
                    cursorColor: widget.cursorColor,
                    cursorErrorColor: isError ? redColor : widget.cursorColor,
                    enabled: widget.enabled,
                    maxLines: widget.maxLines,
                    minLines: widget.minLines,
                    onTapOutside: (event) {
                      widget.onTapOutside?.call();
                      widget.focusNode?.unfocus();
                    },
                    onChanged: (value) {
                      widget.onChanged?.call(value);
                      if (widget.autovalidateMode !=
                          AutovalidateMode.onUserInteraction) {
                        if (_validationError != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _validationError = null;
                            });
                          });
                        }
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: widget.backgroundColor,
                      errorStyle: const TextStyle(fontSize: 0.01),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(borderRadiusTextfieldSize),
                        borderSide: BorderSide(
                          color: isError ? redColor : widget.borderFocusColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(borderRadiusTextfieldSize),
                        borderSide: BorderSide(
                            color: isError ? redColor : widget.borderColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(borderRadiusTextfieldSize),
                        borderSide: BorderSide(
                            color: isError ? redColor : widget.borderColor,
                            width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(borderRadiusTextfieldSize),
                        borderSide: BorderSide(
                            color: isError ? redColor : widget.borderFocusColor,
                            width: 1),
                      ),
                      hintText: null,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12),
                      suffixIcon: widget.isStep
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: widget.onStepDown,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: widget.onStepUp,
                                ),
                              ],
                            )
                          : null,
                    ),
                    validator: (value) {
                      String? error = widget.validator?.call(value);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _validationError = error;
                        });
                      });
                      return error;
                    },
                    onFieldSubmitted: widget.onFieldSubmitted,
                    textInputAction: widget.textInputAction,
                    autovalidateMode: widget.autovalidateMode,
                  ),
                ),
                widget.validator != null
                    ? Container(
                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _validationError ?? "",
                                style: const TextStyle(
                                    fontSize: 12, color: redColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.suffixBottom != null)
                              widget.suffixBottom!
                          ],
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ],
        );
      },
    );
  }
}
