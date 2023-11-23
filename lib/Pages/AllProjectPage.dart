import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:planb/Pages_SR/projectManagement_page.dart';
import 'package:planb/SupportSystem/syncher.dart';
import 'package:planb/cloud/projectStoreCloud.dart';
import 'package:planb/db/entity/project_store.dart';
import 'package:planb/db/repository/project_store_dao.dart';
import 'package:planb/home.dart';
import 'package:planb/redux_state_store/action/actions.dart';
import '../db/database.dart';
import '../redux_state_store/appStore.dart';

//1/21/2023 : add services object for ReSyncher
//1/25/2023 : adding mixin WidgetsBindingObserver and its observers,object, for ReSyncher use.
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
  var services = ReSyncher(interval: 5);

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
    services.isUIMounted = false;
    services = ReSyncher(interval: 15);
    getProjects();
    services.serverConnector(() => getProjects(), mounted);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    getProjects();
    services.serverConnector(() => getProjects(), mounted);
  }

  @override
  void dispose() {
    super.dispose();

    services.isUIMounted = false;
  }

  handleService(event) {
    print("***************project page*************");
    if (FGBGType.background == event) {
      print("***************project page-background*************");
      services.isUIMounted = false;
    } else if (FGBGType.foreground == event) {
      print("***************project page-foreground*************");
    }
  }

  @override
  Widget build(BuildContext context) {
    state = StoreProvider.of<AppStore>(context);
    darkMode = state.state.darkMode;

    return FGBGNotifier(
      onEvent: (event) {
        handleService(event);
      },
      child: ListView(
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
                      darkMode
                          ? "assets/project5-dark.jpg"
                          : "assets/project5.png",
                      scale: 2,
                      width: 400,
                      height: 350,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "we're fetching you're mission critical business data...",
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
                        //Balaji:02/07/2023 : part of billing feature adding this...
                        if (e.deactivateProject!) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProjectManagement(isProjectCreation: false,deactivateProject: true,)),
                          );
                        } else {
                          navigateProject(e.projectStoreID!);
                        }
                      },
                    ))
                .toList(),
      ),
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
