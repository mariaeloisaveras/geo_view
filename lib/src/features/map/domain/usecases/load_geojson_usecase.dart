import 'package:geo_view/src/features/map/domain/entities/geo_entity.dart';

import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/geo_repository.dart';

class LoadGeoJsonUseCase {
  final GeoRepository repo;
  LoadGeoJsonUseCase(this.repo);

  Future<Either<Failure, List<GeoEntity>>> call() => repo.loadGeoJson();
}
