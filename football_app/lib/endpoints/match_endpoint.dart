import 'package:football_app/api_manager.dart';
import 'package:http/http.dart' as http;
import 'package:football_app/models/match.dart';
import 'dart:convert';

class MatchEndpoint {
  static Future<List<Match>> getAllLiveMatches() async {
    final Uri uri = ApiManager.uri("/fixtures", queryParameters: {
      "live": "all",
    });
    http.Response res = await http.get(uri, headers: ApiManager.headers);
    final body;
    if (res.statusCode == 200) {
      body = jsonDecode(res.body);
      if (body['response'].isEmpty) throw res.body;
      List matchesList = body["response"];
      List<Match> matches =
          matchesList.map((item) => Match.fromJson(item)).toList();
      return matches;
    }
    throw res.body;
  }

  static Future<List<Match>> getMatchesCurrSeason(String leagueID) async {
    final Uri uri = ApiManager.uri("/fixtures",
        queryParameters: {"league": leagueID, "season": ApiManager.currSeason});
    http.Response res = await http.get(uri, headers: ApiManager.headers);
    final body;
    if (res.statusCode == 200) {
      body = jsonDecode(res.body);
      if (body['response'].isEmpty) throw res.body;
      List matchesList = body["response"];
      List<Match> matches =
          matchesList.map((item) => Match.fromJson(item)).toList();
      return matches;
    }
    throw res.body;
  }

  static Future<List<Match>> getMatchesByDateLeague(String date) async {
    final Uri uri = ApiManager.uri("/fixtures",
        queryParameters: {"date": date, "timezone": ApiManager.timezoneEST});
    http.Response res = await http.get(uri, headers: ApiManager.headers);
    final body;
    if (res.statusCode == 200) {
      body = jsonDecode(res.body);
      if (body['response'].isEmpty) throw res.body;
      List matchesList = body["response"];
      List<Match> matches =
          matchesList.map((item) => Match.fromJson(item)).toList();
      return matches;
    }
    throw res.body;
  }
}
