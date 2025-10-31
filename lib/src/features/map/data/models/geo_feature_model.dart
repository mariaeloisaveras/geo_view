import 'package:geo_view/src/features/map/domain/entities/geo_entity.dart';

class GeoFeatureModel extends GeoEntity {
  GeoFeatureModel({
    required super.id,
    required super.name,
    required super.type,
    required super.coordinates,
  });

  factory GeoFeatureModel.fromGeoJson(Map<String, dynamic> f) {
    final props = (f['properties'] ?? {}) as Map<String, dynamic>;
    final geom = (f['geometry'] ?? {}) as Map<String, dynamic>;
    final type = (geom['type'] ?? 'Unknown').toString();
    final coords = geom['coordinates'];

    List<List<double>> flat = [];

    if (type == 'Point' && coords is List) {
      flat = [List<double>.from(coords.map((e) => (e as num).toDouble()))];
    } else if (type == 'LineString' && coords is List) {
      flat = List<List<double>>.from(
        coords
            .map((p) => List<double>.from(p.map((e) => (e as num).toDouble()))),
      );
    } else if (type == 'Polygon' && coords is List && coords.isNotEmpty) {
      // pega o anel externo
      flat = List<List<double>>.from(
        (coords.first as List).map(
          (p) => List<double>.from(p.map((e) => (e as num).toDouble())),
        ),
      );
    }

    return GeoFeatureModel(
      id: (f['id'] ?? props['id'] ?? '').toString(),
      name: (props['name'] ?? props['nome'] ?? 'Sem nome').toString(),
      type: type,
      coordinates: flat,
    );
  }
}
