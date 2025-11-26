class CityModelResponse {
  final List<CityResult> data;

  CityModelResponse({
    required this.data,
  });

  factory CityModelResponse.fromJson(Map<String, dynamic> json) =>
      CityModelResponse(
        data: List<CityResult>.from(
          json['data'].map((x) => CityResult.fromJson(x)),
        ),
      );
}

class CityResult {
  final String city;
  final String country;
  final String region;
  final double latitude;
  final double longitude;
  final int? population;
  final String type;

  CityResult({
    required this.city,
    required this.country,
    required this.region,
    required this.latitude,
    required this.longitude,
    this.population,
    required this.type
  });

  factory CityResult.fromJson(Map<String, dynamic> json) => CityResult(
        city: json['city'],
        country: json['country'],
        region: json['region'] ?? '',
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        population: json['population'],
        type: json['type'],
      );
}
