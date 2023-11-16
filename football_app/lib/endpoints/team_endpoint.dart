import 'package:football_app/api_manager.dart';
import 'package:http/http.dart' as http;
import 'package:football_app/models/team.dart';
import 'dart:convert';

class TeamEndpoint {
  static const _popularTeams = ["541", "529", "50", "49"];
  static Future<Team> getTeamByID(String id) async {
    final Uri uri = ApiManager.uri("/teams", queryParameters: {
      "id": id,
    });
    http.Response res = await http.get(uri, headers: ApiManager.headers);
    final body;
    if (res.statusCode == 200) {
      body = jsonDecode(res.body);
      if (body['response'].isEmpty) throw res.body;
      Team team = Team.fromJson(body["response"][0]);
      return team;
    }
    throw res.body;
  }

  static Future<List<Team>> getPopularTeams() async {
    int received = 0;
    List<Team> result = [];
    while (received < _popularTeams.length) {
      try {
        Future<Team> futureLeague = getTeamByID(_popularTeams[received]);
        result.add(await futureLeague);
      } catch (e) {
        print(e);
      }
      received++;
    }

    return result;
  }
}
