import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:onyourmarks/Models/RSSModel.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../Utilities/components.dart';

class rssScreen extends StatefulWidget {
  const rssScreen({Key? key}) : super(key: key);

  @override
  State<rssScreen> createState() => _rssScreenState();
}

class _rssScreenState extends State<rssScreen> {
  List<RSSModel> rss = [];

  rssFunc() async{
    var res=await http.get(Uri.parse("https://www.google.com/alerts/feeds/07734694657347187411/9533695685504378251"));
    var rssItems = await AtomFeed.parse(res.body).items;
    var unescape = HtmlUnescape();
    for(var i in rssItems!){
      rss.add(RSSModel(unescape.convert(i.title ?? ""), unescape.convert(i.title ?? ""), i.links?.first.href));

    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          placeAExpandedHere(1),
          Expanded(
            flex: 20,
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: (){
                      launchUrl(Uri.parse(rss.elementAt(index).url.toString()));
                    },
                      child: populateTheEvents(
                          rss.elementAt(index).title,
                          rss.elementAt(index).content?.substring(6),
                          "")
                  );
                }, separatorBuilder: (BuildContext context, int index){
              return placeASizedBoxHere(20);
            }, itemCount: rss.length),
          ),
          placeAExpandedHere(1),
        ],
      ),
    );
  }

  @override
  void initState() {
    rssFunc();
  }
}
