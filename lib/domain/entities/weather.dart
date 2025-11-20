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
    required this.windGust
  });

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
    'windGust' : windGust
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
  );
}
