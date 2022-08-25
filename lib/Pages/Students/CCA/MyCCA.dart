import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../ApiHandler/Student/CCAAPIs.dart';
import '../../../Models/Student Models/CCAModel.dart';
import '../../../Utilities/Components/functional.dart';
import '../../../Utilities/functions.dart';
import 'CCAForm.dart';

class MyCCA extends StatefulWidget {
  const MyCCA({Key? key}) : super(key: key);

  @override
  State<MyCCA> createState() => _MyCCAState();
}

class _MyCCAState extends State<MyCCA> with TickerProviderStateMixin{
  late TabController _tabController = TabController(length: 3, vsync: this);
  List<CCAModel> activities = [];
  List<CCAModel> pending = [];
  List<CCAModel> accepted = [];
  List<CCAModel> rejected = [];
  var isFetching = true;

  getCCAsFunc() async{
    activities = await getMyActivities();
    for(var i in activities){
      (i.isVerified == "pending")
          ?pending.add(i)
          :(i.isVerified == "accepted")
              ?accepted.add(i)
              :rejected.add(i);
    }
    (mounted)?setState(() {
      isFetching = false;
    }):null;
  }

  @override
  void initState() {
    getCCAsFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        placeASizedBoxHere(50),
        getHeader(texts[32], texts[33]),
        placeASizedBoxHere(20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (isFetching)
                  ?loadingPage()
                  :DefaultTabController(
                length: 3,
                child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.deepPurple,
                    labelColor: Colors.deepPurple,
                    tabs:  [
                      Tab(
                        text: texts[34],
                      ),
                      Tab(
                        text: texts[35],
                      ),
                      Tab(
                        text: texts[36],
                      )
                    ]
                ),
              ),
              (isFetching)
                  ?Text("")
                  :Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      (pending.isNotEmpty)
                          ?populateCCAObjectToListView(context, pending, "pending")
                          :Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(texts[37]),
                              placeASizedBoxHere(20),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(17.5)
                                  ),
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentCCAForm()));
                                  }, child: Icon(CupertinoIcons.add))
                            ],
                          )
                      ),
                      (accepted.isNotEmpty)
                          ?populateCCAObjectToListView(context, accepted, "accepted")
                          :Center(
                          child: Text(texts[38])
                      ),
                      (rejected.isNotEmpty)
                          ?populateCCAObjectToListView(context, rejected, "rejected")
                          :Center(
                          child: Text(texts[39])
                      ),
                    ]
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
