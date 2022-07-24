import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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

  getProjects() async {
    var state = StoreProvider.of<AppStore>(context);
    int userStoreID = state.state.userStoreID;
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final projectStoreDao = database.projectStoreDao;
    var _projectStoreList =
        await projectStoreDao.findAllProjectByUserStoreID(userStoreID);
    setState(() {
      projectStoreList = _projectStoreList;
    });
    state.dispatch(ChangeBottomNavigationView(projectStoreList.length));
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
    getProjects();
  }

  @override
  Widget build(BuildContext context) {
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

      children: projectStoreList
          .map((e) => GestureDetector(
                key: UniqueKey(),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.projectName,
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                              fontSize: 20),
                        ),
                        Text(e.projectDescription)
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
