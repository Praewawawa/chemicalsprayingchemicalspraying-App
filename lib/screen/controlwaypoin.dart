import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chemicalspraying/router/routes.gr.dart'; // ✅ แก้ให้ถูก

class MapWithWaypointUI extends StatefulWidget {
  const MapWithWaypointUI({super.key});

  @override
  State<MapWithWaypointUI> createState() => _MapWithWaypointUIState();
}

class _MapWithWaypointUIState extends State<MapWithWaypointUI> {
  GoogleMapController? _controller;
  List<LatLng> _waypoints = [];
  int _relay = 5000;

  void _addWaypoint(LatLng point) {
    setState(() {
      _waypoints.add(point);
    });
  }

  void _removeWaypoint(int index) {
    setState(() {
      _waypoints.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAFF),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(13.7563, 100.5018),
                zoom: 16,
              ),
              onMapCreated: (controller) => _controller = controller,
              markers: _waypoints
                  .asMap()
                  .entries
                  .map(
                    (e) => Marker(
                      markerId: MarkerId('waypoint_${e.key}'),
                      position: e.value,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        e.key == 0 ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueViolet,
                      ),
                    ),
                  )
                  .toSet(),
              onTap: _addWaypoint,
            ),

            // ปุ่ม Save (มุมล่างขวา)
            Positioned(
              bottom: 220,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () {},
                child: const Icon(Icons.save_alt),
              ),
            ),

            // ตาราง Waypoint
            Positioned(
              bottom: 80,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._waypoints.asMap().entries.map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${e.key + 1} Waypoint  Lat: ${e.value.latitude.toStringAsFixed(5)}  Lng: ${e.value.longitude.toStringAsFixed(5)}'),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                              onPressed: () => _removeWaypoint(e.key),
                            )
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Relay'),
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            initialValue: _relay.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v) => setState(() => _relay = int.tryParse(v) ?? 0),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ปุ่ม Start / Cancel
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {},
                      child: const Text('เริ่ม'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {},
                      child: const Text('ยกเลิก'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
