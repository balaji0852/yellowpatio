import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';
import 'package:yellowpatioapp/redux_state_store/appStore.dart';
import 'package:yellowpatioapp/redux_state_store/reducer/date_preference_reducer.dart';

import 'config.dart';

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

  @override
  void initState() {
    super.initState();
    setState(() {
      viewTypeState = Config.dateViewPreference;
    });
  }

  @override
  void didUpdateWidget(covariant HomeDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);

    //changing DB, through post ui change.
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    state = StoreProvider.of<AppStore>(context);
    setState(() {
          uid = state.state.selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    state = StoreProvider.of<AppStore>(context);

    return Drawer(
      key: UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("planB"),
                CloseButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 20,
                ),
                Text("Date view")
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
                  height: 2,
                ),
                datePreferenceWidget(2, 'Two day'),
                const SizedBox(
                  height: 2,
                ),
                datePreferenceWidget(3, 'Three day'),
                const SizedBox(
                  height: 2,
                ),
                datePreferenceWidget(5, 'Five day')
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(" uid "+uid.toString())    
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
        focusColor: Colors.red,
        color: state.state.dateViewPreference == viewType
            ? Colors.grey
            : Colors.white,
        onPressed: callback,
        child: Text(text),
      );
    });
  }
}
