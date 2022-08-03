import 'package:flutter/material.dart';

import '../../../ApiHandler/Student/CCAAPIs.dart';
import '../../../Utilities/components.dart';
import '../../../Models/Student Models/CCAModel.dart';

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
    setState(() {
      isFetching = false;
    });
  }

  @override
  void initState() {
    getCCAsFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("My Curricular Acitivities"),
      body:(isFetching)
        ?Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text("Loading Data")
        ],
      ))
        :Column(
        children: [
          DefaultTabController(
            length: 3,
            child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.deepPurple,
                labelColor: Colors.deepPurple,
                tabs: const [
                  Tab(
                    text: "Pending",
                  ),
                  Tab(
                    text: "Accepted",
                  ),
                  Tab(
                    text: "Rejected",
                  )
                ]
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: [
                  (pending.isNotEmpty)
                      ?populateCCAObjectToListView(context, pending, "pending")
                      :Center(
                      child: Text("Actitities Yet To Be Submitted😅")
                  ),
                  (accepted.isNotEmpty)
                      ?populateCCAObjectToListView(context, accepted, "accepted")
                      :Center(
                      child: Text("Actitities Yet To Be Accepted😕")
                  ),
                  (rejected.isNotEmpty)
                      ?populateCCAObjectToListView(context, rejected, "rejected")
                      :Center(
                      child: Text("No Activities are Rejected😉")
                  ),
                ]
            ),
          )
        ],
      )
    );
  }
}
