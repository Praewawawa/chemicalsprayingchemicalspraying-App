import 'dart:io';

void readAllFiles(String dirPath) {
  final dir = Directory(dirPath);
  if (dir.existsSync()) {
    for (var file in dir.listSync(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        print("📂 อ่านไฟล์: ${file.path}");
        print(file.readAsStringSync()); // อ่านเนื้อหาไฟล์
        print("\n---------------------------\n");
      }
    }
  } else {
    print("❌ โฟลเดอร์ไม่พบ: $dirPath");
  }
}

void main() {
  readAllFiles("lib/"); // อ่านทุกไฟล์ Dart ในโฟลเดอร์ lib
}
 