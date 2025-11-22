class Weather {
  final String city;
  final double temperature;
  final String description;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final String main;
  final String country;
  final int cloudiness;
  final int pressure;
  final int timezone;
  final int visibility;
  final double tempMin;
  final double tempMax;
  final int sunrise;
  final int sunset;
  final double windGust;
  final double lat;
  final double lon;

  const Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.main,
    required this.country,
    required this.cloudiness,
    required this.pressure,
    required this.timezone,
    required this.visibility,
    required this.tempMin,
    required this.tempMax,
    required this.sunrise,
    required this.sunset,
    required this.windGust,
    required this.lat,
    required this.lon
  });

  Weather copyWith({
    String? city,
    double? temperature,
    String? description,
    double? feelsLike,
    int? humidity,
    double? windSpeed,
    int? windDeg,
    String? main,
    String? country,
    int? cloudiness,
    int? pressure,
    int? timezone,
    int? visibility,
    double? tempMin,
    double? tempMax,
    int? sunrise,
    int? sunset,
    double? windGust,
    double? lat,
    double? lon,
  }) {
    return Weather(
      city: city ?? this.city,
      temperature: temperature ?? this.temperature,
      description: description ?? this.description,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      windDeg: windDeg ?? this.windDeg,
      main: main ?? this.main,
      country: country ?? this.country,
      cloudiness: cloudiness ?? this.cloudiness,
      pressure: pressure ?? this.pressure,
      timezone: timezone ?? this.timezone,
      visibility: visibility ?? this.visibility,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      windGust: windGust ?? this.windGust,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'temperature': temperature,
    'description': description,
    'feelsLike': feelsLike,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'windDeg': windDeg,
    'main': main,
    'country': country,
    'cloudiness': cloudiness,
    'pressure': pressure,
    'timezone': timezone,
    'visibility' : visibility,
    'tempMin' : tempMin,
    'tempMax' : tempMax,
    'sunrise' : sunrise,
    'sunset' : sunset,
    'windGust' : windGust,
    'lat' : lat,
    'lon' : lon
  };

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    city: json['city'],
    temperature: (json['temperature'] ?? json['temp']).toDouble(),
    description: json['description'] ?? json['weather_description'],
    feelsLike: (json['feelsLike'] ?? json['feels_like']).toDouble(),
    humidity: json['humidity'],
    windSpeed: (json['windSpeed'] ?? json['wind_speed']).toDouble(),
    windDeg: json['windDeg'] ?? json['wind_deg'],
    main: json['main'],
    country: json['country'],
    cloudiness: json['cloudiness'] ?? json['clouds'],
    pressure: json['pressure'],
    timezone: json['timezone'],
    visibility: json['visibility'],
    tempMin: (json['tempMin'] ?? json['temp_min']).toDouble(),
    tempMax: (json['tempMax'] ?? json['temp_max']).toDouble(),
    sunrise: json['sunrise'] ?? 0,
    sunset: json['sunset'] ?? 0,
    windGust: (json['windGust'] ?? json['wind_gust'] ?? 0).toDouble(),
    lat: json['lat'],
    lon: json['lon']
  );
}
