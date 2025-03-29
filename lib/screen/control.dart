import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage( name: 'ControlRoute')
class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            children: [
              // แถวบน: ปุ่มย้อนกลับ และ Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back),
                  Switch(
                    value: true,
                    onChanged: (val) {},
                    activeColor: Colors.green,
                  )
                ],
              ),

              const SizedBox(height: 10),

              // ปุ่มควบคุม Auto (รูปร่างคล้ายรีโมต)
              _buildControlPad(),

              const SizedBox(height: 20),

              // สถานะ 3 อย่าง
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _StatusCard(title: 'ความเร็วลม', value: '4.23 km/s'),
                  _StatusCard(title: 'แบตเตอรี่', value: '100%'),
                  _StatusCard(title: 'ปริมาณสารเคมี', value: '100%'),
                ],
              ),

              const SizedBox(height: 20),

              // Timer
              _TimerControl(),

              const SizedBox(height: 20),

              // Speed Control
              _SpeedControl(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlPad() {
    return SizedBox(
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: _controlButton(Icons.arrow_drop_up),
          ),
          Positioned(
            bottom: 0,
            child: _controlButton(Icons.arrow_drop_down),
          ),
          Positioned(
            left: 0,
            child: _controlButton(Icons.arrow_left),
          ),
          Positioned(
            right: 0,
            child: _controlButton(Icons.arrow_right),
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.text_fields, color: Colors.grey),
                Text('Auto', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatusCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _TimerControl extends StatelessWidget {
  const _TimerControl();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Timer", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(value: true, onChanged: (v) {}, activeColor: Colors.green),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("00 : 01 : 0"),
            ),
          ],
        ),
      ],
    );
  }
}

class _SpeedControl extends StatelessWidget {
  const _SpeedControl();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Speed", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(value: true, onChanged: (v) {}, activeColor: Colors.green),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("1"),
            ),
          ],
        ),
      ],
    );
  }
}