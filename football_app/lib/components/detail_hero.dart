import 'package:flutter/material.dart';
import 'package:football_app/app_db.dart';
import 'package:sqflite/sqlite_api.dart';

class DetailHero extends StatefulWidget {
  final String heroImageUrl;
  final String primaryText;
  final String secondaryText;
  final String type;
  final int elementID;
  const DetailHero(this.heroImageUrl, this.primaryText, this.secondaryText,
      this.type, this.elementID,
      {super.key});

  @override
  State<DetailHero> createState() => _DetailHeroState();
}

class _DetailHeroState extends State<DetailHero> {
  bool isFollowed = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    if (mounted) {
      bool entryExists = await DatabaseHelper.instance
          .entryExists(widget.type, widget.elementID.toString());
      if (entryExists) {
        setState(() {
          isFollowed = entryExists;
        });
      }
    }
  }

  void follow() async {
    try {
      int entryAdded =
          await DatabaseHelper.instance.add(widget.elementID, widget.type);
      setState(() {
        isFollowed = true;
      });
    } catch (e) {
      print("Already Followed");
    }
  }

  void unfollow() async {
    try {
      int entryRemoved = await DatabaseHelper.instance
          .removeEntry(widget.type, widget.elementID.toString());
      setState(() {
        isFollowed = false;
      });
    } catch (e) {
      print("Some error occurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        color: Colors.grey.shade200,
        child: Row(children: [
          Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50)),
              constraints: const BoxConstraints.tightFor(width: 70, height: 70),
              margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: ClipRect(
                child: Hero(
                    placeholderBuilder: (context, heroSize, child) =>
                        Container(),
                    tag: widget.heroImageUrl,
                    child: Image.network(
                      widget.heroImageUrl,
                      fit: BoxFit.contain,
                    )),
              )),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 160,
              child: Text(
                widget.primaryText,
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600),
              ),
            ),
            Text(widget.secondaryText)
          ]),
          GestureDetector(
            onTap: (isFollowed) ? () => unfollow() : () => follow(),
            child: Container(
              decoration: BoxDecoration(
                  color: (isFollowed) ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(10)),
              height: 40,
              width: 80,
              alignment: Alignment.center,
              child: Text(
                (isFollowed) ? "Followed" : "Follow",
                style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
            ),
          )
        ]));
  }
}
