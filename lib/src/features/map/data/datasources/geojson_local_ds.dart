import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class GeoJsonLocalDataSource {
  final String assetPath;
  GeoJsonLocalDataSource({this.assetPath = 'assets/geo/areas.geojson'});

  Future<List<Map<String, dynamic>>> fetchFeatures() async {
    final txt = await rootBundle.loadString(assetPath);
    final map = json.decode(txt) as Map<String, dynamic>;
    final feats = (map['features'] as List).cast<Map<String, dynamic>>();
    return feats;
  }
}
