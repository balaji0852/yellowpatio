import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/Pages/projectPage.dart';
import 'package:yellowpatioapp/Pages/project_setting.dart';
import 'package:yellowpatioapp/Pages_SR/projectManagement_page.dart';
import 'package:yellowpatioapp/db/entity/project_setting.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';
import 'package:yellowpatioapp/redux_state_store/appStore.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/date_preference_reducer.dart';

import 'cloud/UserStoreCloud.dart';
import 'config.dart';
import 'db/entity/user_store.dart';
import 'home.dart';

class HomeDrawer extends StatefulWidget {
  @override
  HomeDraweWidget createState() {
    return HomeDraweWidget();
  }
}

class HomeDraweWidget extends State<HomeDrawer> {
  //TODO - FOR REMOVAL ---- LINE 102 <-REASON
  int viewTypeState = 1;
  // ignore: prefer_typing_uninitialized_variables

  var state;
  int uid = 0;
  int projectStoreID = 0;
  //11/28/2022 : balaji , using local variable to set darkMode
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      viewTypeState = Config.dateViewPreference;
      // state = StoreProvider.of<AppStore>(context);
      // darkMode = state.state.darkMode;
    });
  }

  @override
  void didUpdateWidget(covariant HomeDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
                        userSetting();

    //changing DB, through post ui change.
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    state = StoreProvider.of<AppStore>(context);
    setState(() {
      uid = state.state.userStoreID;
      projectStoreID = state.state.projectStoreID;
    });
  }

  @override
  Widget build(BuildContext context) {
    state = StoreProvider.of<AppStore>(context);
    darkMode = state.state.darkMode;

    return Drawer(
      backgroundColor: darkMode ? Colors.black : Colors.white,
      key: UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("planB",
                    style: TextStyle(
                        color: darkMode ? Colors.white : Colors.black,
                        fontSize: 20)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Text("Date view",
                    style: TextStyle(
                        color: darkMode ? Colors.black : Colors.white))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                datePreferenceWidget(1, 'One day'),
                const SizedBox(
                  height: 3,
                ),
                datePreferenceWidget(2, 'Two day'),
                const SizedBox(
                  height: 4,
                ),
                datePreferenceWidget(3, 'Three day'),
                const SizedBox(
                  height: 5,
                ),
                datePreferenceWidget(5, 'Five day'),
                const SizedBox(
                  height: 6,
                ),
                MaterialButton(
                  key: UniqueKey(),
                  height: 50,
                  color: darkMode ? Colors.grey[850] : Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProjectPage()),
                    );
                  },
                  child: Text(
                    "Projects",
                    style: TextStyle(
                        color: darkMode ? Colors.white : Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                // MaterialButton(
                //   key: UniqueKey(),
                //   height: 50,
                //   color: darkMode ? Colors.grey[850] : Colors.white,
                //   onPressed: () {
                //     Navigator.pop(context);

                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const ProjectSettingW()),
                //     );
                //   },
                //   child: Text(
                //     "Projects Management",
                //     style: TextStyle(
                //         color: darkMode ? Colors.white : Colors.black),
                //   ),
                // ),
                MaterialButton(
                  key: UniqueKey(),
                  height: 50,
                  color: darkMode ? Colors.grey[850] : Colors.white,
                  onPressed: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProjectManagement(isProjectCreation: false,)),
                    );
                  },
                  child: Text(
                    "Projects Management-server",
                    style: TextStyle(
                        color: darkMode ? Colors.white : Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                MaterialButton(
                  key: UniqueKey(),
                  height: 50,
                  color: darkMode ? Colors.grey[850] : Colors.white,
                  onPressed: () {
                    setState(() {
                      state.dispatch(ChangeDarkMode(!darkMode));
                      darkMode = !darkMode;
                    });
                  },
                  child: Text(
                    darkMode?"lite Mode":"Dark Mode",
                    style: TextStyle(
                        color: darkMode ? Colors.white : Colors.black),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 9,
            ),
            Text(
              " uid " + uid.toString(),
              style: TextStyle(color: darkMode ? Colors.white : Colors.black),
            ),
            Text(
              " project id " + projectStoreID.toString(),
              style: TextStyle(color: darkMode ? Colors.white : Colors.black),
            )
          ],
        ),
      ),
    );
  }

  //TODO - for removal , since config object no more used for
  //        storing preference, and viewTypeState is not used anymore
  //        since the redux migration
  setDateView(int viewType) {
    Config.dateViewPreference = viewType;
    setState(() {
      viewTypeState = viewType;
    });
  }

  Widget datePreferenceWidget(int viewType, String text) {
    return StoreConnector<AppStore, VoidCallback>(converter: (store) {
      return () => store.dispatch(ChangeDateViewPreference(viewType));
    }, builder: (context, callback) {
      return MaterialButton(
        key: UniqueKey(),
        height: 50,
        focusColor: darkMode ? Colors.grey[850] : Colors.white,
        color: state.state.dateViewPreference == viewType
            ? Colors.blue
            : darkMode
                ? Colors.grey[850]
                : Colors.white,
        onPressed:callback ,
        child: Text(text,
            style: TextStyle(color: darkMode ? Colors.white : Colors.black)),
      );
    });
  }

  Future<void> userSetting() async {
    var state = StoreProvider.of<AppStore>(context);

    //write logic to check presence of user;
      //cloud migration
      // var userManagement = UserManagement();
      // int _userStoreID = await userManagement.userRegisterationShim(context);
      // while (_userStoreID==-1){
      //   _userStoreID = await userManagement.userRegisterationShim(context);
      // }
      UserStore userStore = UserStore(
          linkedEmail: FirebaseAuth.instance.currentUser!.email!,
          userName: FirebaseAuth.instance.currentUser!.displayName!,
          linkedPhone: FirebaseAuth.instance.currentUser!.phoneNumber == null
              ? "empty"
              : FirebaseAuth.instance.currentUser!.phoneNumber!,
          photoURL: FirebaseAuth.instance.currentUser!.photoURL!,
          themeID: state.state.darkMode?1:0,
          timeViewPreference: -1,
          dateViewPreference: state.state.dateViewPreference);

      userStore = await UserStoreCloud().putUserStore(userStore);
    }
}
