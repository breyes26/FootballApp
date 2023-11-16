import 'package:football_app/api_manager.dart';
import 'package:http/http.dart' as http;
import 'package:football_app/models/team.dart';
import 'dart:convert';
import 'package:football_app/models/standings.dart';

class StandingsEndpoint {
  static Future<Standings> getStandingsByLeagueID(String leagueID) async {
    final Uri uri = ApiManager.uri("/standings",
        queryParameters: {"league": leagueID, "season": ApiManager.currSeason});
    http.Response res = await http.get(uri, headers: ApiManager.headers);
    print("Got");
    final body;
    if (res.statusCode == 200) {
      body = jsonDecode(res.body);
      if (body['response'].isEmpty) throw res.body;
      Standings standings = Standings.fromJson(body["response"][0]);
      return standings;
    }
    throw res.body;
  }
}
