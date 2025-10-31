import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  final List<LatLng> initialMarkers;
  const MapView({super.key, this.initialMarkers = const []});

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final _mapController = MapController();
  final _markers = <Marker>[];
  Marker? _userMarker;
  StreamSubscription<Position>? _positionSub;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    _markers.addAll(widget.initialMarkers.map(_pin));
    _loadUserLocation();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  Future<void> locateUser({bool moveCamera = true, bool showFeedback = false}) =>
      _loadUserLocation(moveCamera: moveCamera, showFeedback: showFeedback);

  Marker _pin(LatLng p, {Color color = Colors.red}) => Marker(
        point: p,
        width: 36,
        height: 36,
        child: Icon(Icons.location_pin, color: color, size: 32),
      );

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _loadUserLocation(
      {bool moveCamera = true, bool showFeedback = false}) async {
    if (_isRequesting) return;
    _isRequesting = true;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (showFeedback) {
          _showSnack('Ative o serviço de localização para usar este recurso.');
        }
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (showFeedback) {
          _showSnack('Permissão de localização negada.');
        }
        return;
      }

      final position = await _findAccuratePosition();
      final userPoint = LatLng(position.latitude, position.longitude);
      if (!mounted) return;

      setState(() {
        _userMarker = _pin(userPoint, color: Colors.blueAccent);
      });
      if (moveCamera) {
        _mapController.move(userPoint, 15);
      }
      if (showFeedback) {
        _showSnack(
            'Localização atualizada (±${position.accuracy.toStringAsFixed(0)} m)');
      }
    } catch (e) {
      if (showFeedback) {
        _showSnack('Não foi possível obter a localização.');
      }
      debugPrint('Erro ao obter localização: $e');
    } finally {
      _isRequesting = false;
    }
  }

  Future<Position> _findAccuratePosition() async {
    final initial = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );

    if (initial.accuracy <= 50) {
      return initial;
    }

    final completer = Completer<Position>();
    await _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      ),
    ).listen((pos) {
      if (pos.accuracy <= 50 && !completer.isCompleted) {
        completer.complete(pos);
      }
    });

    try {
      return await completer.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () => initial,
      );
    } finally {
      await _positionSub?.cancel();
      _positionSub = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(-23.55, -46.63),
        initialZoom: 11,
        onTap: (tap, p) {
          setState(() => _markers.add(_pin(p)));
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.geo_view',
        ),
        MarkerLayer(
          markers: [
            ..._markers,
            if (_userMarker != null) _userMarker!,
          ],
        ),
      ],
    );
  }
}
