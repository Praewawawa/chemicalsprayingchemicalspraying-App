import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../bloc/language/language_state.dart';
import '../constants/color.dart';
import '../constants/size.dart'; 
import '../models/language.dart';

class AppTextField extends StatefulWidget { //สร้างคลาส AppTextField เพื่อใช้ในการสร้าง TextField
  //สร้าง TextField ที่สามารถใช้งานได้ง่ายขึ้น โดยมีการกำหนดค่าต่างๆ เช่น สี ขนาด ฟอนต์ และการตรวจสอบความถูกต้องของข้อมูล
  const AppTextField( // Constructor
      {required this.title, //เป็นชื่อของ TextField
      this.focusNode, //เป็น FocusNode ของ TextField
      this.hitText = "", //เป็นข้อความที่แสดงเมื่อไม่มีการกรอกข้อมูลใน TextField
      this.titleColor = blackColor, //เป็นสีของชื่อ TextField
      this.validator, //เป็นฟังก์ชันที่ใช้ตรวจสอบความถูกต้องของข้อมูลที่กรอกใน TextField
      this.onChanged, //เป็นฟังก์ชันที่ใช้เมื่อมีการเปลี่ยนแปลงข้อมูลใน TextField
      this.onTapOutside, //เป็นฟังก์ชันที่ใช้เมื่อมีการคลิกนอก TextField
      this.textInputAction, //เป็น Action ของ TextInput
      this.autovalidateMode, //เป็นโหมดการตรวจสอบความถูกต้องของข้อมูลใน TextField
      this.obscureText = false, //เป็นการซ่อนข้อความใน TextField
      this.controller, //เป็น Controller ของ TextField
      this.onFieldSubmitted, //เป็นฟังก์ชันที่ใช้เมื่อมีการส่งข้อมูลใน TextField
      this.onEditingComplete, //เป็นฟังก์ชันที่ใช้เมื่อมีการแก้ไขข้อมูลใน TextFieldเสร็จสิ้น
      this.suffixTop, //เป็น Widget ที่แสดงด้านบนของ TextField
      this.suffixBottom, //เป็น Widget ที่แสดงด้านล่างของ TextField
      this.keyboardType = TextInputType.text,  //เป็นประเภทของ Keyboard ที่แสดงเมื่อมีการคลิกที่ TextField
      this.backgroundColor = whiteColor, //เป็นสีพื้นหลังของ TextField
      this.borderColor = borderInputColor, //เป็นสีของกรอบ TextField
      this.borderFocusColor = primaryColor, //เป็นสีของกรอบ TextField เมื่อมีการ Focus
      this.cursorColor = primaryColor, //เป็นสีของ Cursor ใน TextField
      this.controller, //เป็น Controller ของ TextField
      this.textColor = blackColor, //เป็นสีของข้อความใน TextField
      this.required = false, //เป็นการกำหนดว่าต้องกรอกข้อมูลใน TextField หรือไม่
      this.enabled = true, //เป็นการกำหนดว่า TextField สามารถกรอกข้อมูลได้หรือไม่
      this.isTextAlignCenter = false, //เป็นการกำหนดว่า TextField จะจัดข้อความไปที่กลางหรือไม่
      this.isStep = false, //เป็นการกำหนดว่า TextField เป็นแบบ Step หรือไม่
      this.minLines = 1, //เป็นจำนวนบรรทัดขั้นต่ำของ TextField
      this.maxLines = 1, //เป็นจำนวนบรรทัดสูงสุดของ TextField
      this.onStepDown, //เป็นฟังก์ชันที่ใช้เมื่อมีการกดปุ่ม Step Down
      this.onStepUp, //เป็นฟังก์ชันที่ใช้เมื่อมีการกดปุ่ม Step Up
      this.height = 50, //เป็นความสูงของ TextField
      this.height, //เป็นความสูงของ TextField
      this.width, //เป็นความกว้างของ TextField
      super.key}); //เป็นการกำหนดค่าต่างๆ ของ TextField

  final String title; //เป็นชื่อของ TextField
  final Color? titleColor; //เป็นสีของชื่อ TextField
  final FocusNode? focusNode; //เป็น FocusNode ของ TextField
  final LanguageBloc? languageBloc; //เป็น Bloc ของภาษา
  final String hitText; //เป็นข้อความที่แสดงเมื่อไม่มีการกรอกข้อมูลใน TextField
  final FormFieldValidator<String>? validator; //เป็นฟังก์ชันที่ใช้ตรวจสอบความถูกต้องของข้อมูลที่กรอกใน TextField
  final ValueChanged<String>? onChanged; //เป็นฟังก์ชันที่ใช้เมื่อมีการเปลี่ยนแปลงข้อมูลใน TextField
  final Function()? onTapOutside; //เป็นฟังก์ชันที่ใช้เมื่อมีการคลิกนอก TextField
  final TextInputAction? textInputAction; //เป็น Action ของ TextInput 
  final AutovalidateMode? autovalidateMode; //เป็นโหมดการตรวจสอบความถูกต้องของข้อมูลใน TextField
  final bool obscureText;   //เป็นการซ่อนข้อความใน TextField
  final TextEditingController? controller;  //เป็น Controller ของ TextField
  final ValueChanged<String>? onFieldSubmitted;   //เป็นฟังก์ชันที่ใช้เมื่อมีการส่งข้อมูลใน TextField
  final VoidCallback? onEditingComplete;  //เป็นฟังก์ชันที่ใช้เมื่อมีการแก้ไขข้อมูลใน TextFieldเสร็จสิ้น
  final Widget? suffixTop;  //เป็น Widget ที่แสดงด้านบนของ TextField
  final Widget? suffixBottom; //เป็น Widget ที่แสดงด้านล่างของ TextField
  final TextInputType keyboardType; //เป็นประเภทของ Keyboard ที่แสดงเมื่อมีการคลิกที่ TextField
  final Color backgroundColor; //เป็นสีพื้นหลังของ TextField
  final Color borderColor;  //เป็นสีของกรอบ TextField
  final Color borderColorError; //เป็นสีของกรอบ TextField เมื่อมีการ Focus
  final Color borderFocusColor; //เป็นสีของกรอบ TextField เมื่อมีการ Focus
  final Color cursorColor; //เป็นสีของ Cursor ใน TextField
  final Color textColor; //เป็นสีของข้อความใน TextField
  final bool required; //เป็นการกำหนดว่าต้องกรอกข้อมูลใน TextField หรือไม่
  final bool enabled;   //เป็นการกำหนดว่า TextField สามารถกรอกข้อมูลได้หรือไม่
  final bool isStep; //เป็นการกำหนดว่า TextField เป็นแบบ Step หรือไม่
  final bool isTextAlignCenter;   //เป็นการกำหนดว่า TextField จะจัดข้อความไปที่กลางหรือไม่
  final int minLines;   //เป็นจำนวนบรรทัดขั้นต่ำของ TextField
  final int? maxLines; //เป็นจำนวนบรรทัดสูงสุดของ TextField
  final double? height; //เป็นความสูงของ TextField
  final double? width; //เป็นความกว้างของ TextField
  final Function()? onStepDown; //เป็นฟังก์ชันที่ใช้เมื่อมีการกดปุ่ม Step Down
  final Function()? onStepUp;  //เป็นฟังก์ชันที่ใช้เมื่อมีการกดปุ่ม Step Up

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> { // State ของ AppTextField
  String? _validationError;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();

  Language? curLang; //ตัวแปรที่ใช้เก็บค่าภาษา

  _initLanguage(Language newLang) { //ฟังก์ชันที่ใช้ในการกำหนดค่าภาษา
    if (curLang == null || curLang != newLang) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_validationError != null) {
          _fieldKey.currentState?.validate();
        }
        setState(() { //ทำการเปลี่ยนแปลงค่าภาษา
          curLang = newLang;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) { //ฟังก์ชันที่ใช้ในการสร้าง Widget
    bool isError = _validationError != null && _validationError != "";
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        _initLanguage(state.selectedLanguage);
        return Stack(  //สร้าง Stack เพื่อให้สามารถวาง Widget ซ้อนกันได้
          children: [ 
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != '') //ถ้ามีชื่อ TextField
                  Row(
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: widget.controller,
                      obscureText: widget.isPassword,
                      keyboardType: widget.keyboardType,
                      focusNode: widget.focusNode,
                      validator: widget.validator,
                      onChanged: widget.onChanged,
                      decoration: InputDecoration(
                        labelText: widget.title,
                        labelStyle: TextStyle(
                          color: isError
                              ? redColor
                              : widget.focusNode?.hasFocus == true
                                  ? greenColor
                                  : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: widget.hint,
                        hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        contentPadding: const EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: greenColor, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: redColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: redColor),
                        ),
                      ),
                    ),

                    children: [ //สร้าง Row เพื่อให้สามารถวาง Widget ซ้อนกันได้
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              TextSpan( //สร้าง TextSpan เพื่อให้สามารถวาง Widget ซ้อนกันได้
                                text: widget.title,
                              ),
                              if (widget.required) //ถ้ามีการกำหนดให้ต้องกรอกข้อมูล
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: redColor))
                            ],
                            style: TextStyle( //กำหนด Style ของ TextSpan
                                fontSize: 14, color: widget.titleColor),
                          ),
                          overflow: TextOverflow.ellipsis, //ถ้ามีการกำหนดให้ต้องกรอกข้อมูล
                        ),
                      ),
                      if (widget.suffixTop != null) widget.suffixTop!
                    ],
                  ),
                const SizedBox(height: 4),
                SizedBox( //สร้าง SizedBox เพื่อให้สามารถกำหนดขนาดของ Widget ได้
                  height: widget.height,
                  child: TextFormField(
                    textAlign: widget.isTextAlignCenter
                        ? TextAlign.center
                        : TextAlign.start,
                    key: _fieldKey,
                    style: TextStyle( //กำหนด Style ของ TextFormField
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
                    onChanged: (value) { //เมื่อมีการเปลี่ยนแปลงข้อมูลใน TextField
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
                    decoration: InputDecoration(  //กำหนด Decoration ของ TextFormField
                      fillColor: widget.backgroundColor,
                      errorStyle: const TextStyle(fontSize: 0.01),
                      focusedBorder: OutlineInputBorder( //กำหนดกรอบของ TextFormField เมื่อมีการ Focus
                        borderRadius:
                            BorderRadius.circular(borderRadiusTextfieldSize),
                        borderSide: BorderSide(
                          color: isError ? redColor : widget.borderFocusColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder( //กำหนดกรอบของ TextFormField เมื่อมีการ Enable
                        borderRadius:
                            BorderRadius.circular(borderRadiusTextfieldSize),
                        borderSide: BorderSide(
                            color: isError ? redColor : widget.borderColor),
                      ),
                      errorBorder: OutlineInputBorder( //กำหนดกรอบของ TextFormField เมื่อมีการ Error
                        borderRadius:
                            BorderRadius.circular(borderRadiusTextfieldSize),
                        borderSide: BorderSide(
                            color: isError ? redColor : widget.borderColor,
                            width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder( //กำหนดกรอบของ TextFormField เมื่อมีการ Focus และ Error
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
                          ? Row( //สร้าง Row เพื่อให้สามารถวาง Widget ซ้อนกันได้ 
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
                    validator: (value) { //เมื่อมีการตรวจสอบความถูกต้องของข้อมูลใน TextField
                      String? error = widget.validator?.call(value);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() { //ทำการเปลี่ยนแปลงค่าภาษา
                          _validationError = error;
                        });
                      });
                      return error;
                    }, //เมื่อมีการตรวจสอบความถูกต้องของข้อมูลใน TextField
                    onFieldSubmitted: widget.onFieldSubmitted,
                    textInputAction: widget.textInputAction,
                    autovalidateMode: widget.autovalidateMode,
                  ),
                ),
                widget.validator != null 
                    ? Container( //สร้าง Container เพื่อให้สามารถกำหนดขนาดของ Widget ได้
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
