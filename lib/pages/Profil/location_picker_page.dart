import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerPage extends StatefulWidget {
  final LatLng initialPosition;

  const LocationPickerPage({super.key, required this.initialPosition});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late LatLng selectedPosition;

  @override
  void initState() {
    super.initState();
    selectedPosition = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Lokasi")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: selectedPosition, zoom: 15),
        onTap: (position) {
          setState(() {
            selectedPosition = position;
          });
        },
        markers: {
          Marker(markerId: const MarkerId('selected'), position: selectedPosition),
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Pilih Lokasi Ini"),
        icon: const Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context, selectedPosition);
        },
      ),
    );
  }
}
