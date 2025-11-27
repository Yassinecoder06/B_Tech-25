import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  final List<LatLng> _markers = [];
  final List<LatLng> _polylinePoints = [];
  LatLng? _selectedMarkerPosition;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Search & Navigation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerMapOnUserLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search for a place...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _performSearch,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(51.509364, -0.128928), // Default London
                    initialZoom: 13.0,
                    maxZoom: 18.0,
                    minZoom: 3.0,
                    onTap: (tapPosition, latLng) {
                      setState(() {
                        _markers.add(latLng);
                        _polylinePoints.add(latLng);
                        _fitBounds();
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    if (_markers.isNotEmpty)
                      MarkerLayer(
                        markers: _markers.map((latLng) {
                          return Marker(
                            point: latLng,
                            width: 40,
                            height: 40,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedMarkerPosition = latLng;
                                });
                              },
                              child: const Icon(Icons.location_pin, color: Colors.red),
                            ),
                          );
                        }).toList(),
                      ),
                    if (_polylinePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _polylinePoints,
                            color: Colors.blue,
                            strokeWidth: 4.0,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (_searchResults.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return ListTile(
                        title: Text(result['display_name']),
                        onTap: () {
                          _mapController.move(
                            LatLng(result['lat'], result['lon']),
                            15.0,
                          );
                          setState(() {
                            _searchResults.clear();
                            _searchController.clear();
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
          if (_selectedMarkerPosition != null)
            Positioned(
              bottom: 20,
              left: 20,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Marker at:\n${_selectedMarkerPosition!.latitude}, ${_selectedMarkerPosition!.longitude}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Future<void> _performSearch() async {
    String query = _searchController.text;
    if (query.isEmpty) return;

    final url = Uri.parse('https://nominatim.openstreetmap.org/search?format=json&q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _searchResults = data.map((place) {
          return {
            'display_name': place['display_name'],
            'lat': double.parse(place['lat']),
            'lon': double.parse(place['lon']),
          };
        }).toList();
      });
    }
  }

  void _fitBounds() {
    if (_markers.isNotEmpty) {
      LatLngBounds bounds = LatLngBounds.fromPoints(_markers);
      final center = bounds.center;
      final zoom = _mapController.camera.zoom;
      _mapController.move(center, zoom);
    }
  }

  Future<void> _centerMapOnUserLocation() async {
    setState(() {
      _isLoading = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _mapController.move(LatLng(position.latitude, position.longitude), 13.0);
      _isLoading = false;
    });
  }
}
