import '/domain/domain.dart';
import '/infrastructure/models/open_weather/city_model_response.dart';

class CityMapper {
  static City cityModelToEntity(CityResult geoDb) => City(
    name: geoDb.city,
    country: geoDb.country,
    region: geoDb.region,
    lat: geoDb.latitude,
    lon: geoDb.longitude,
    population: geoDb.population,
    type: geoDb.type
  );
}
