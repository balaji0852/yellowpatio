import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/SupportSystem/syncher.dart';
import 'package:yellowpatioapp/cloud/projectStoreCloud.dart';
import 'package:yellowpatioapp/db/entity/project_store.dart';
import 'package:yellowpatioapp/db/repository/project_store_dao.dart';
import 'package:yellowpatioapp/home.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';
import '../db/database.dart';
import '../redux_state_store/appStore.dart';

class AllProjectPage extends StatefulWidget {
  final bool loaded;

  const AllProjectPage({Key? key, required this.loaded}) : super(key: key);

  @override
  AllProjectPageState createState() => AllProjectPageState();
}

class AllProjectPageState extends State<AllProjectPage> {
  bool loading = false;
  List<projectStore> projectStoreList = [];
  //11/28/2022 : balaji , using local variable to set darkMode
  bool darkMode = false;
  var state;

  getProjects() async {
    var state = StoreProvider.of<AppStore>(context);
    int userStoreID = state.state.userStoreID;

    //migration
    // final database =
    //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // final projectStoreDao = database.projectStoreDao;

    var _projectStoreList =
        await projectStoreCloud().findAllProjectByUserStoreID(userStoreID);
    if (mounted) {
      setState(() {
        projectStoreList = _projectStoreList;
      });
    }

    //balaji : 11/25/2022 : plan:sending the 1 if empty projects, or
    //                      the first project id to the store, to BottomNavigationView
    state.dispatch(ChangeBottomNavigationView(projectStoreList.isEmpty
        ? 0
        : projectStoreList.elementAt(0).projectStoreID!));
  }

  @override
  void didUpdateWidget(covariant AllProjectPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("............");

    getProjects();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    Timer.periodic(Duration(minutes: 1), (timer) {
      if (mounted) {
        getProjects();
      }
    });
    // ReSyncher(interval: 1).serverConnector(getProjects(),mounted);
  }

  @override
  Widget build(BuildContext context) {
    state = StoreProvider.of<AppStore>(context);
    darkMode = state.state.darkMode;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,

      // itemCount: projectStoreList.length,
      // itemBuilder: (BuildContext context, int index) {
      //   return GestureDetector(
      //     key: UniqueKey(),
      //     child: Padding(
      //       padding: const EdgeInsets.all(3),
      //       child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               projectStoreList.elementAt(index).projectName,
      //               style: const TextStyle(
      //                   decoration: TextDecoration.underline,
      //                   color: Colors.blue,
      //                   fontSize: 20),
      //             ),
      //             Text(projectStoreList.elementAt(index).projectDescription)
      //           ]),
      //     ),
      //     onTap: () {
      //       print("jj");
      //       navigateProject(projectStoreList.elementAt(index).projectStoreID!);
      //     },
      //   );
      // }
      //sig42: balaji:adding loading description for the page
      children: projectStoreList.isEmpty
          ? [
              Container(
                alignment: Alignment.center,
                child: Column(children: [
                  Image.asset(
                    "assets/project5.png",
                    scale: 2,
                    width: 400,
                    height: 350,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "we're fetching you're mission critical business...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: darkMode ? Colors.white : Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ]),
              )
            ]
          : projectStoreList
              .map((e) => GestureDetector(
                    key: UniqueKey(),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              e.projectName,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 19),
                            ),
                            Text(
                              e.projectDescription,
                              style: TextStyle(
                                  color:
                                      darkMode ? Colors.white : Colors.black),
                            )
                          ]),
                    ),
                    onTap: () {
                      print("jj");
                      navigateProject(e.projectStoreID!);
                    },
                  ))
              .toList(),
    );
  }

  navigateProject(int projectStoreID) {
    var state = StoreProvider.of<AppStore>(context);
    state.dispatch(ChangeProjectStoreID(projectStoreID));
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }
}
