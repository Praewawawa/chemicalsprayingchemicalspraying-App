import 'package:flutter/material.dart';

class CSCCardInfo extends StatelessWidget { // Card สำหรับแสดงข้อมูล
  const CSCCardInfo({super.key, required this.child, this.width, this.title});
  final Widget child; // child ที่จะใส่ใน Card
  final double? width; // ความกว้างของ Card
  final String? title; // ชื่อของ Card
  @override
  Widget build(BuildContext context) { // สร้าง Card
    // const width = MediaQuery.of(context).size.width;
    return Container( // Card
      // width: MediaQuery.of(context).size.width,
      width: width ?? 100, // กำหนดความกว้างของ Card
      height: 100, // กำหนดความสูงของ Card
      padding: EdgeInsets.all(8), // กำหนดระยะห่างภายใน Card
      decoration: BoxDecoration( // กำหนดการตกแต่งของ Card
          color: Colors.white, // สีพื้นหลังของ Card
          borderRadius: BorderRadius.all(Radius.circular(8)), // มุมของ Card
          boxShadow: [ // เงาของ Card
            BoxShadow( // เงาของ Card
              color: Color.fromARGB(150, 0, 0, 0).withOpacity(0.25), // สีของเงา
              offset: Offset(0, 4), // ระยะห่างของเงา
              blurRadius: 16, // ความเบลอของเงา
              spreadRadius: 0, // การกระจายของเงา
            )
          ]),
      child: Column( // สร้าง Column เพื่อใส่ Widget ลงไปใน Card
        children: [ 
          if (title != null && title!.isNotEmpty) // ถ้ามี title ให้แสดง
            Text(title!, style: TextStyle( // กำหนดสไตล์ของ title
              fontSize: 20, // ขนาดตัวอักษร
              fontWeight: FontWeight.w600 // น้ำหนักของตัวอักษร
            ),),
          child],
      ),
    );
  }
}
