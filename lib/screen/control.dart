import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ControlScreen(),
    );
  }
}

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool isSwitched = false;
  int speed = 1;
  int timer = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {},
                ),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text("4.23 km/s", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("ความเร็ว"),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controlButton(Icons.arrow_upward),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controlButton(Icons.arrow_back),
                      controlButton(Icons.circle, label: "Auto"),
                      controlButton(Icons.arrow_forward),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controlButton(Icons.arrow_downward),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      infoBox("100%", "แบตเตอรี่"),
                      infoBox("100%", "ปริมาณสารเคมี"),
                    ],
                  ),
                  SizedBox(height: 20),
                  sliderControl("Timer", timer, 60, (value) {
                    setState(() {
                      timer = value.toInt();
                    });
                  }),
                  sliderControl("Speed", speed, 5, (value) {
                    setState(() {
                      speed = value.toInt();
                    });
                  }),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget controlButton(IconData icon, {String? label}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          padding: EdgeInsets.all(20),
        ),
        onPressed: () {},
        child: label != null ? Text(label) : Icon(icon, color: Colors.black),
      ),
    );
  }

  Widget infoBox(String value, String label) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label),
        ],
      ),
    );
  }

  Widget sliderControl(String label, int value, int max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Switch(value: true, onChanged: (val) {}),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Slider(
                value: value.toDouble(),
                min: 0,
                max: max.toDouble(),
                onChanged: onChanged,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text("$value"),
            ),
          ],
        ),
      ],
    );
  }
}
