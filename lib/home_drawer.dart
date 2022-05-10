import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'config.dart';

class HomeDrawer extends StatefulWidget {
  @override
  HomeDraweWidget createState() {
    return HomeDraweWidget();
  }
}

class HomeDraweWidget extends State<HomeDrawer> {
  //var config = Config();
  int viewTypeState = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      viewTypeState = Config.dateViewPreference;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Sight - db"),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                gestureDetectorWithState([datePreferenceWidget(5)], 1),
               gestureDetectorWithState( [
                      datePreferenceWidget(2),
                      const SizedBox(
                        width: 3,
                      ),
                      datePreferenceWidget(2),
                    ], 2),
                gestureDetectorWithState([
                      datePreferenceWidget(1.5),
                      const SizedBox(
                        width: 3,
                      ),
                      datePreferenceWidget(1.5),
                      const SizedBox(
                        width: 3,
                      ),
                      datePreferenceWidget(1.5),
                    ], 3),
                gestureDetectorWithState( [
                        datePreferenceWidget(0.7),
                        const SizedBox(
                          width: 3,
                        ),
                        datePreferenceWidget(0.7),
                        const SizedBox(
                          width: 3,
                        ),
                        datePreferenceWidget(0.7),
                        const SizedBox(
                          width: 3,
                        ),
                        datePreferenceWidget(0.7),
                        const SizedBox(
                          width: 3,
                        ),
                        datePreferenceWidget(0.7),
                      ], 5)
              ],
            )
          ],
        ),
      ),
    );
  }

  Container datePreferenceWidget(double density) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(3)),
      width: density * 10,
      height: 60,
    );
  }

  GestureDetector gestureDetectorWithState(List<Widget> children,int viewType){
    return GestureDetector(
      key: UniqueKey(),
        onTap: (){
              Config.dateViewPreference = viewType;
              setState(() {
                viewTypeState = viewType;
              });
            },
      //  decoration: BoxDecoration(
      //     color: Colors.black, borderRadius: BorderRadius.circular(3)),
          child:Material(
            color: viewTypeState==viewType?Colors.grey:Colors.transparent,
          
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children:children,
            ),
          ),
    );
  }
}
