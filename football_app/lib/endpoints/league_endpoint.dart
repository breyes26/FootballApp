import 'package:football_app/api_manager.dart';
import 'package:http/http.dart' as http;
import 'package:football_app/models/league.dart';
import 'dart:convert';

class LeagueEndpoint {
  static const _popularLeagues = ["39", "140", "78", "61", "253", "71"];

  static Future<League> getLeagueByID(String id) async {
    final Uri uri = ApiManager.uri("/leagues", queryParameters: {
      "id": id,
    });
    http.Response res = await http.get(uri, headers: ApiManager.headers);
    final body;
    if (res.statusCode == 200) {
      body = jsonDecode(res.body);
      if (!(body["response"].isEmpty)) {
        League league = League.fromJson(body["response"][0]);
        return league;
      }
      throw res.body;
    }
    throw res.body;
  }

  static Future<List<League>> getLeagueBySearch(String leagueName) async {
    final Uri uri = ApiManager.uri("/leagues", queryParameters: {
      "search": leagueName,
    });
    http.Response res = await http.get(uri, headers: ApiManager.headers);
    final body;
    if (res.statusCode == 200) {
      body = jsonDecode(res.body);
      if (!(body["response"].isEmpty)) {
        List leaguesFromServer = body["response"];

        List<League> leagues =
            leaguesFromServer.map((item) => League.fromJson(item)).toList();

        return leagues;
      }
      throw res.body;
    }
    throw res.body;
  }

  static Future<List<League>> getPopularLeagues() async {
    int received = 0;
    List<League> result = [];
    while (received < _popularLeagues.length) {
      try {
        Future<League> futureLeague = getLeagueByID(_popularLeagues[received]);
        result.add(await futureLeague);
      } catch (e) {
        print(e);
      }
      received++;
    }
    return result;
  }
}
