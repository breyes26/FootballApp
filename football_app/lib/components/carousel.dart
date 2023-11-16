import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:football_app/views/league_detail.dart';
import 'package:football_app/views/player_detail.dart';
import 'package:football_app/views/team_detail.dart';
import 'package:http/http.dart' as http;

const double carouselHeight = 75.0;
const double tileMainImageHeight = 55;
const double tileMainImageWidth = 55;
const double tileCaptionSize = 15;
const double tileFlagSize = 16;

class Carousel extends StatefulWidget {
  final List<dynamic> itemList;
  final String type;
  const Carousel(this.itemList, this.type, {super.key});

  @override
  createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  _CarouselState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: CarouselSlider(
          items: _listBuilder(context),
          options: CarouselOptions(
              scrollDirection: Axis.horizontal,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              viewportFraction: .70,
              height: carouselHeight)),
    );
  }

  List<Widget> _listBuilder(BuildContext context) {
    final List<Widget> list = [];
    for (var item in widget.itemList) {
      list.add(_renderTile(context, item));
    }

    return list;
  }

  Widget _renderTile(BuildContext context, item) {
    return GestureDetector(
        onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => widget.type == "Player"
                          ? PlayerDetail(item.id, item.name, item.photoUrl)
                          : widget.type == "League"
                              ? LeagueDetail(item)
                              : TeamDetail(item.id, item.name, item.logoUrl)))
            },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 3))
              ]),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _renderPrimary(
                    (widget.type == "Player") ? item.photoUrl : item.logoUrl,
                    tileMainImageWidth,
                    tileMainImageHeight),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _renderCaption(context, item.name),
                      (widget.type == "Player")
                          ? _renderPlayerTeamLogo(context, item.team.logoUrl)
                          : (widget.type == "League")
                              ? _renderLeagueCountryFlag(
                                  context, item.country.flagUrl)
                              : Container()
                    ])
              ]),
        ));
  }

  Widget _renderPrimary(String url, double width, double height) {
    return Container(
      constraints: BoxConstraints.tightFor(width: width, height: height),
      child: Hero(tag: url, child: Image.network(url, fit: BoxFit.contain)),
    );
  }

  Widget _renderCaption(BuildContext context, String text) {
    return Container(
        width: 110,
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontSize: tileCaptionSize),
        ));
  }

  Widget _renderPlayerTeamLogo(BuildContext context, String url) {
    if (url.isEmpty) {
      return Container();
    }

    try {
      return Container(
        constraints: const BoxConstraints.tightFor(
            width: tileFlagSize, height: tileFlagSize),
        child: Image.network(
          url,
        ),
      );
    } catch (e) {
      print("Could not load image $url");
      return Container();
    }
  }

  Widget _renderLeagueCountryFlag(BuildContext context, String url) {
    if (url.isEmpty) {
      return Container();
    }

    try {
      return Container(
        constraints: const BoxConstraints.tightFor(
            width: tileFlagSize, height: tileFlagSize),
        child: SvgPicture.network(
          url,
        ),
      );
    } catch (e) {
      print("Could not load image $url");
      return Container();
    }
  }
}
