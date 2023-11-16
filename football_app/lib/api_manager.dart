class ApiManager {
  static const apiScheme = "https";
  static const apiHost = "api-football-v1.p.rapidapi.com";
  static const prefix = "/v3";

  static const apiKey = 'd46b92fd51mshe3b9b0b42395778p13d8d8jsn8e5ac614cf3c';
  static const headers = {'x-rapidapi-key': apiKey, 'x-rapidapi-host': apiHost};
  static const timezoneEST = "America/New_York";
  static const currSeason = "2023";

  static Uri uri(String path, {required Map<String, dynamic> queryParameters}) {
    final uri = Uri(
        scheme: apiScheme,
        host: apiHost,
        path: '$prefix$path',
        queryParameters: queryParameters);
    return uri;
  }
}
