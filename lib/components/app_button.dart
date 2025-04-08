import 'package:flutter/material.dart';
import 'package:chemicalspraying/constants/colors.dart';

enum ThemeButton { //ธีมของปุ่ม
  // primary = สีหลัก, danger = สีอันตราย
  primary,
  danger,
}

enum ButtonType { //ประเภทของปุ่ม
  // filled = ปุ่มเต็ม, outlined = ปุ่มขอบ
  filled,
  outlined,
}

class AppButton extends StatefulWidget { //ปุ่มกด
  final  String title; //ชื่อปุ่ม
  final IconData? icon; //ไอคอนปุ่ม
  final bool isLoading; //ปุ่มกำลังโหลด
  final ThemeButton? theme; //ธีมของปุ่ม
  final ButtonType? type; //ประเภทของปุ่ม
  final double? width; //ความกว้างของปุ่ม
  final double? height; //ความสูงของปุ่ม
  final VoidCallback? onPressed; //ฟังก์ชันที่ใช้เมื่อกดปุ่ม
  const AppButton({
    super.key, 
    required this.title, 
    this.isLoading = false, 
    this.onPressed,
    this.width,
    this.height,
    this.icon, 
    this.theme, 
    this.type}); //กำหนดค่าเริ่มต้นของปุ่ม

  @override
  State<AppButton> createState() => _AppButtonState(); //สร้างสถานะของปุ่ม
}

class _AppButtonState extends State<AppButton> { //สถานะของปุ่ม

  late Color bgColor; //สีพื้นหลังของปุ่ม
  late Color textColor; //สีตัวอักษรของปุ่ม
  late ButtonType buttonType; //ประเภทของปุ่ม
  late ThemeButton theme; //ธีมของปุ่ม
  late double width; //ความกว้างของปุ่ม
  late double height; //ความสูงของปุ่ม

  @override
  void initState() { //กำหนดสีของปุ่ม
    super.initState();
    if (widget.theme == ThemeButton.primary) { //ถ้าเป็นธีมหลัก
      bgColor = mainColor; //สีพื้นหลังของปุ่ม
      textColor = whiteColor; //สีตัวอักษรของปุ่ม
    } else if (widget.theme == ThemeButton.danger) { //ถ้าเป็นธีมอันตราย
      bgColor = redColor; //สีพื้นหลังของปุ่ม
      textColor = whiteColor; //สีตัวอักษรของปุ่ม
    } else {
      bgColor = mainColor; //สีพื้นหลังของปุ่ม
      textColor = whiteColor; //สีตัวอักษรของปุ่ม
    }

    buttonType = widget.type ?? ButtonType.filled; //ประเภทของปุ่ม
  }
  @override
  Widget build(BuildContext context) { //ทำให้ปุ่มกดได้ทั้งปุ่ม
    //กำหนดสีของปุ่ม

    bool isFilled = buttonType == ButtonType.filled; //ถ้าเป็นปุ่มเต็ม
    return ClipRRect( //ทำให้มุมของปุ่มมน
      borderRadius: BorderRadius.circular(10), //ทำให้มุมของปุ่มมน
      child: Stack( //ทำให้ปุ่มกดได้ทั้งปุ่ม
        children: [ //ทำให้ปุ่มกดได้ทั้งปุ่ม
          Container( 
          width: widget.width,
          height: widget.height,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), //กำหนดระยะห่างของปุ่ม

        decoration: BoxDecoration( //กำหนดการตกแต่งของปุ่ม
          borderRadius: BorderRadius.circular(10), //ทำให้มุมของปุ่มมน
          border: isFilled ? null : Border.all(color: bgColor), //ถ้าเป็นปุ่มขอบให้มีขอบ
          color: isFilled ? bgColor : textColor, //ถ้าเป็นปุ่มเต็มให้มีสีพื้นหลัง
        ),
        child: Center( // Center the text inside the button
          child: Text(
            widget.title, //ชื่อปุ่ม
            style: TextStyle( //กำหนดสไตล์ของตัวอักษร
              color: isFilled ? textColor : bgColor, //ถ้าเป็นปุ่มเต็มให้มีสีตัวอักษร
              fontSize: 20, //ขนาดตัวอักษร
            ),
          ),
      ),
    ),
    if (widget.isLoading)  //ปุ่มกำลังโหลด
            Positioned(
                right: 24.0, //กำหนดระยะห่างของปุ่ม
                top: 0, 
                bottom: 0,
                child: Center( 
                  child: Container( //ทำให้ปุ่มกดได้ทั้งปุ่ม
                    color: bgColor, //สีพื้นหลังของปุ่ม
                    child: Padding(
                      padding: const EdgeInsets.all(0).copyWith(left: 8), //กำหนดระยะห่างของปุ่ม
                      child: SizedBox(
                        height: 16.0, //กำหนดความสูงของปุ่ม
                        width: 16.0, //กำหนดความกว้างของปุ่ม
                        child: CircularProgressIndicator( //ทำให้ปุ่มกดได้ทั้งปุ่ม
                          color: isFilled ? textColor : bgColor, //สีของปุ่ม
                          strokeWidth: 2, //ความหนาของปุ่ม
                        ),
                      ),
                    ),
                  ),
                )),
    Positioned.fill( //ทำให้ปุ่มกดได้ทั้งปุ่ม
        child: Material( 
          color: Colors.transparent, //ทำให้ปุ่มกดได้ทั้งปุ่ม
          child: InkWell( 
            onTap: widget.onPressed, //ฟังก์ชันที่ใช้เมื่อกดปุ่ม
            splashColor: whiteColor.withOpacity(0.2), //สีของปุ่มเมื่อกด
            highlightColor: whiteColor.withOpacity(0.2), //สีของปุ่มเมื่อกด
          ),
    ))
        ]
      )
    );

  }
}