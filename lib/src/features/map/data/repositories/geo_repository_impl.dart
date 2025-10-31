import 'package:geo_view/src/features/map/domain/entities/geo_entity.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/geo_repository.dart';
import '../datasources/geojson_local_ds.dart';
import '../models/geo_feature_model.dart';

class GeoRepositoryImpl implements GeoRepository {
  final GeoJsonLocalDataSource ds;
  GeoRepositoryImpl(this.ds);

  @override
  Future<Either<Failure, List<GeoEntity>>> loadGeoJson() async {
    try {
      final raw = await ds.fetchFeatures();
      final models = raw.map(GeoFeatureModel.fromGeoJson).toList();
      return Right(models);
    } catch (e) {
      return Left(LoadFailure('Falha ao ler GeoJSON: $e'));
    }
  }
}
