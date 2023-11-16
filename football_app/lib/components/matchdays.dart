import 'package:flutter/material.dart';
import 'package:football_app/models/match.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:football_app/color_helper.dart';

class Matchdays extends StatefulWidget {
  final List<MapEntry<String, List<Match>>> matchdays;
  final int offset;
  final Color tileColor;
  final Color tileFontColor;
  Matchdays(this.matchdays, this.offset, this.tileColor, this.tileFontColor,
      {super.key});

  final ItemScrollController _scrollController = ItemScrollController();

  @override
  createState() => _MatchdaysState();
}

class _MatchdaysState extends State<Matchdays> {
  _MatchdaysState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade100),
        child: ScrollablePositionedList.builder(
            initialScrollIndex: widget.offset,
            itemScrollController: widget._scrollController,
            itemCount: widget.matchdays.length,
            itemBuilder: (context, index) {
              return widget.matchdays
                  .map((matchday) => Container(
                        child: _renderMatchDayTile(context, matchday),
                      ))
                  .toList()[index];
            }));
  }

  Widget _renderMatchDayTile(
    BuildContext context,
    MapEntry<String, List<Match>> matchday,
  ) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: widget.tileColor,
      ),
      child: Column(
          children: [
                _renderMatchdayDate(context, matchday.value[0].fixture.date)
              ] +
              matchday.value
                  .map((match) =>
                      renderFixture(context, match, widget.tileFontColor))
                  .toList()),
    );
  }

  Widget _renderMatchdayDate(BuildContext context, String date) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            DateFormat("EEEE, MMM d").format(DateTime.tryParse(date)),
            style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: widget.tileFontColor),
          ),
        ],
      ),
    );
  }
}

Widget renderFixture(BuildContext context, Match match, Color fontColor) {
  return Container(
    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
            height: 15,
            width: 15,
            child: (match.fixture.status.short == "FT" ||
                    match.fixture.status.short == "NS" ||
                    match.fixture.status.short == "TBD" ||
                    match.fixture.status.short == "PST")
                ? Container()
                : Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      match.fixture.status.short,
                      style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )),
        SizedBox(
          width: 80,
          child: Text(
            match.home.name,
            style: TextStyle(fontSize: 13, color: fontColor),
          ),
        ),
        SizedBox(
          height: 15,
          width: 15,
          child: Image.network(
            match.home.logoUrl,
            fit: BoxFit.cover,
          ),
        ),
        renderScore(
            context,
            match.goals.home.toString(),
            match.goals.away.toString(),
            DateFormat("h:mm a")
                .format(DateTime.parse(match.fixture.date).toLocal()),
            fontColor),
        SizedBox(
          height: 15,
          width: 15,
          child: Image.network(
            match.away.logoUrl,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 80,
          child: Text(
            match.away.name,
            style: TextStyle(fontSize: 13, color: fontColor),
          ),
        ),
      ],
    ),
  );
}

Widget renderScore(BuildContext context, String home, String away,
    String matchTime, Color fontColor) {
  return SizedBox(
      width: 50,
      child: Text(
        (home != "null") ? "$home-$away" : matchTime,
        style: TextStyle(fontSize: 13, color: fontColor),
        textAlign: TextAlign.center,
      ));
}
