import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_view/src/features/map/domain/entities/geo_entity.dart';
import '../../../map/domain/usecases/load_geojson_usecase.dart';
import '../../../map/data/datasources/geojson_local_ds.dart';
import '../../../map/data/repositories/geo_repository_impl.dart';

final dataSourceProvider = Provider((_) => GeoJsonLocalDataSource());
final repoProvider =
    Provider((ref) => GeoRepositoryImpl(ref.read(dataSourceProvider)));
final loadGeoJsonProvider =
    Provider((ref) => LoadGeoJsonUseCase(ref.read(repoProvider)));

final featuresProvider = FutureProvider<List<GeoEntity>>((ref) async {
  final usecase = ref.read(loadGeoJsonProvider);
  final res = await usecase();
  return res.fold((l) => throw Exception(l.message), (r) => r);
});
