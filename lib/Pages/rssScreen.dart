import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:onyourmarks/Models/RSSModel.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../Utilities/components.dart';
import '../Utilities/functions.dart';

class rssScreen extends StatefulWidget {
  const rssScreen({Key? key}) : super(key: key);

  @override
  State<rssScreen> createState() => _rssScreenState();
}

class _rssScreenState extends State<rssScreen> {
  List<RSSModel> rss = [];
  bool isFetching = true;
  bool errorLoading = false;
  rssFunc() async{
    var res = await http.get(
        Uri.parse("https://www.google.com/alerts/feeds/07734694657347187411/9533695685504378251")
    ).catchError((err) {
      errorLoading = true;
      toast("Error Loading the Page");
      setState(() {

      });
      return err;
    });
    if(!errorLoading){
      var rssItems = await AtomFeed.parse(res.body).items;
      var unescape = HtmlUnescape();
      RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);

      if(rssItems?.length == 0 || rssItems == null){
        debugPrint("Error");
        errorLoading = true;
        setState(() {

        });
      }
      if(!errorLoading){
        for(var i in rssItems!){
          String _title = unescape.convert(i.title ?? "").replaceAll(exp, '');
          String _content = unescape.convert(i.content ?? "").replaceAll(exp, '');
          rss.add(RSSModel(_title,_content , i.links?.first.href));
          if(rss.length == 10){
            setState(() {
              isFetching = false;
            });
            break;
          }
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return (errorLoading)
    ?Center(
        child:Padding(
          padding: const EdgeInsets.all(38.0),
          child: Column(
            children: [
              Image.asset(
                  "Images/Image-1.png"
              ),
              SizedBox(
                height: 10,
              ),
              Text("Error Loading Blogs")
            ],
          ),
        )
    )
    :(isFetching)
        ?loadingPage()
        :Expanded(
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
