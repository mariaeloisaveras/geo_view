import 'package:geo_view/src/features/map/domain/entities/geo_entity.dart';

import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';

abstract class GeoRepository {
  Future<Either<Failure, List<GeoEntity>>> loadGeoJson();
}
