class Match {
  final Fixture fixture;
  final MatchTeam home;
  final MatchTeam away;
  final Goals goals;
  final FixtureLeague league;

  Match(this.fixture, this.home, this.away, this.goals, this.league);

  Match.blank()
      : fixture = Fixture.blank(),
        home = MatchTeam.blank(),
        away = MatchTeam.blank(),
        goals = Goals.blank(),
        league = FixtureLeague.blank();

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
        Fixture.fromJson(json['fixture']),
        MatchTeam.fromJson(json['teams']['home']),
        MatchTeam.fromJson(json['teams']['away']),
        Goals.fromJson(json['goals']),
        FixtureLeague.fromJson(json["league"]));
  }
}

class FixtureLeague {
  final int id;
  final String name;
  final String logoUrl;

  FixtureLeague(this.id, this.name, this.logoUrl);

  FixtureLeague.blank()
      : id = 0,
        name = "",
        logoUrl = "";

  factory FixtureLeague.fromJson(Map<String, dynamic> json) {
    return FixtureLeague(json['id'], json['name'], json['logo']);
  }
}

class Fixture {
  final int id;
  final String date;
  final Status status;

  Fixture(this.id, this.date, this.status);

  Fixture.blank()
      : id = 0,
        date = "",
        status = Status.blank();

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(json['id'], json['date'], Status.fromJson(json['status']));
  }
}

class Status {
  final int id;
  final String short;
  final int elapsed;

  Status(this.id, this.short, this.elapsed);

  Status.blank()
      : id = 0,
        short = "",
        elapsed = 0;

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(json['id'], json['short'], json['elapsed']);
  }
}

class MatchTeam {
  final int id;
  final String name;
  final String logoUrl;

  MatchTeam(this.id, this.name, this.logoUrl);

  MatchTeam.blank()
      : id = 0,
        name = "",
        logoUrl = "";

  factory MatchTeam.fromJson(Map<String, dynamic> json) {
    return MatchTeam(json['id'], json['name'], json['logo']);
  }
}

class Goals {
  final int home;
  final int away;

  Goals(this.home, this.away);

  Goals.blank()
      : home = 0,
        away = 0;

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(json['home'], json['away']);
  }
}
