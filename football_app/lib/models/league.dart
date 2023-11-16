class League {
  final int id;
  final String name;
  final String type;
  final String logoUrl;
  final Country country;

  League(this.id, this.name, this.type, this.logoUrl, this.country);

  League.blank()
      : id = 0,
        name = '',
        type = "",
        logoUrl = "",
        country = Country.blank();

  factory League.fromJson(Map<String, dynamic> json) {
    final leagueInfo = json['league'];
    final countryInfo = json['country'];
    return League(
        leagueInfo['id'],
        leagueInfo['name'],
        leagueInfo['type'],
        leagueInfo['logo'],
        (json.containsKey("country"))
            ? Country.fromJson(countryInfo)
            : Country.blank());
  }
}

class Country {
  final String name;
  final String code;
  final String flagUrl;

  Country(this.name, this.code, this.flagUrl);

  Country.blank()
      : name = "",
        code = "",
        flagUrl = "";

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(json['name'], json['code'], json['flag']);
  }
}
