class GeoEntity {
  final String id;
  final String name;
  final String type; // Point | LineString | Polygon
  final List<List<double>> coordinates; // lista simplificada [lon,lat]

  const GeoEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.coordinates,
  });
}
