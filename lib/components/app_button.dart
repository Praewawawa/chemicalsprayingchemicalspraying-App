import 'package:flutter/material.dart';
import 'package:chemicalspraying/constants/colors.dart';

enum ThemeButton {
  primary,
  danger,
}

enum ButtonType {
  filled,
  outlined,
}

class AppButton extends StatefulWidget {
  final  String title;
  final bool isLoading;
  final ThemeButton? theme;
  final ButtonType? type;
  final VoidCallback? onPressed;
  const AppButton({super.key, required this.title, this.isLoading = false, this.onPressed, this.theme, this.type});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {

  late Color bgColor;
  late Color textColor;
  late ButtonType buttonType;

  @override
  void initState() {
    super.initState();
    if (widget.theme == ThemeButton.primary) {
      bgColor = mainColor;
      textColor = whiteColor;
    } else if (widget.theme == ThemeButton.danger) {
      bgColor = redColor;
      textColor = whiteColor;
    } else {
      bgColor = mainColor;
      textColor = whiteColor;
    }

    buttonType = widget.type ?? ButtonType.filled;
  }
  @override
  Widget build(BuildContext context) {

    bool isFilled = buttonType == ButtonType.filled;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: isFilled ? null : Border.all(color: bgColor),
          color: isFilled ? bgColor : textColor,
        ),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: isFilled ? textColor : bgColor,
              fontSize: 20,
            ),
          ),
      ),
    ),
    if (widget.isLoading)
            Positioned(
                right: 24.0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    color: bgColor,
                    child: Padding(
                      padding: const EdgeInsets.all(0).copyWith(left: 8),
                      child: SizedBox(
                        height: 16.0,
                        width: 16.0,
                        child: CircularProgressIndicator(
                          color: isFilled ? textColor : bgColor,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                )),
    Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            splashColor: whiteColor.withOpacity(0.2),
            highlightColor: whiteColor.withOpacity(0.2),
          ),
    ))
        ]
      )
    );

  }
}