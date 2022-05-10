import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/graph/graph_dialog.dart';
import 'package:yellowpatioapp/graph/time_instance_widget.dart';

import '../config.dart';

//having a listview with a fiexed height container is good, but having a
//column and a listview inside the box
//container can't have color in outside and a decoration, throws error
//typedefs are always outside
class PlannerGraph extends StatefulWidget {
  final ClassMaster classMaster;
  const PlannerGraph({Key? key, required this.classMaster}) : super(key: key);

  @override
  PlannerGraphPage createState() {
    return PlannerGraphPage();
  }
}

class PlannerGraphPage extends State<PlannerGraph> {
  final GlobalKey<TimeInstancePage> _key1 = GlobalKey();
  final GlobalKey<TimeInstancePage> _key2 = GlobalKey();
  final GlobalKey<TimeInstancePage> _key3 = GlobalKey();
  ScrollController widgetScrollCOntroller = ScrollController();
  //dates List and Row uses and manipulates the date integers - 5
  late int day1, day2, day3, day4, day5;

  static List<String> time = List.generate(
      24,
      (index) => index <= 11
          ? (index + 1).toString() + "am"
          : (index + 1).toString() + "pm");
  late List<String>? dates = [];
  final itemSize = 2402.0;
  bool openDialog = false;
  List<DataInstancesMaster> hourlyDataInstanceFromChild = [];
  int viewType = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //temp
    var config = Config();
    setState(() {
      viewType = Config.dateViewPreference;
      print(viewType);
    });

    //used to call for 3 view previously
    //dateSetter(true, true);
    initializeDate();

    widgetScrollCOntroller.addListener(() {
      print(widgetScrollCOntroller.offset);
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      widgetScrollCOntroller.animateTo(
          30 * double.parse(DateTime.now().toString().substring(11, 13)),
          curve: Curves.linear,
          duration: const Duration(milliseconds: 300));

      print(50 * double.parse(DateTime.now().toString().substring(11, 13)));
    });
  }

  openDialogCallback(
      bool openDialog, List<DataInstancesMaster> hourlyDataInstanceFromChild) {
    //adding List to callback for now, this is to populate the List<HourlyDataInstance>
    //to graph_dialog, finding central state management...
    setState(() {
      this.hourlyDataInstanceFromChild = hourlyDataInstanceFromChild;
      this.openDialog = openDialog;
    });
  }

  closeDialogCallback(bool openDialog) {
    //adding List to callback for now, this is to populate the List<HourlyDataInstance>
    //to graph_dialog, finding central state management...
    setState(() {
      this.openDialog = openDialog;
    });
  }

  initializeDate() {
    int day = DateTime.now().millisecondsSinceEpoch;
    day5 = day - 4 * 86400000;
    day4 = day - 3 * 86400000;
    day3 = day - 2 * 86400000;
    day2 = day - 86400000;
    day1 = day;
    addDateToList();
  }

  addDateToList() {
    if (viewType == 5) {
      dates!.add(DateTime.fromMillisecondsSinceEpoch(day5).toString());
      dates!.add(DateTime.fromMillisecondsSinceEpoch(day4).toString());
      dates!.add(DateTime.fromMillisecondsSinceEpoch(day3).toString());
      dates!.add(DateTime.fromMillisecondsSinceEpoch(day2).toString());
      dates!.add(DateTime.fromMillisecondsSinceEpoch(day1).toString());
    } else if (viewType == 3) {
      dates!.add(DateTime.fromMillisecondsSinceEpoch(day3).toString());
      dates!.add(DateTime.fromMillisecondsSinceEpoch(day2).toString());
      dates!.add(DateTime.fromMillisecondsSinceEpoch(day1).toString());
    } else if (viewType == 2) {
      dates!.add(DateTime.fromMillisecondsSinceEpoch(day2).toString());
      dates!.add(DateTime.fromMillisecondsSinceEpoch(day1).toString());
    } else {
      dates!.add(DateTime.fromMillisecondsSinceEpoch(day1).toString());
    }
  }

  @override
  void didUpdateWidget(covariant PlannerGraph oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    print("didUpdateWidget");
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 425,
              color: Colors.white,
              child: ListView(
                itemExtent: itemSize,
                controller: widgetScrollCOntroller,
                children: [
                  Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40,
                              // ignore: prefer_const_literals_to_create_immutables
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: time
                                      .map((e) => SizedBox(
                                            height: 100,
                                            child: Text(e),
                                          ))
                                      .toList()),
                            ),
                            SizedBox(
                              height: 2400,
                              width: 2,
                              child: Container(
                                color: Colors.black,
                              ),
                            ),
                            //Dates are provided to TimeIntanceWidget, they query it and save in 24-List, type 2D...
                            //TimeIntanceWidget makes the query for a day, or based csp(comment section page) view
                            //csp will provide the 2D List, classmaster object is provided. plannerGraph->timeInstanceWidget...
                            //set the color of widget as per ClassMaster object.
                            if (viewType >= 5)
                              TimeInstanceWidget(
                                //1 day view
                                //today:day1
                                today: day5,
                                classMaster: widget.classMaster,
                                openCallback: openDialogCallback,
                                viewType: viewType,
                              ),
                            if (viewType >= 5)
                              TimeInstanceWidget(
                                //1 day view
                                //today:day1
                                today: day4,
                                classMaster: widget.classMaster,
                                openCallback: openDialogCallback,
                                viewType: viewType,
                              ),

                            if (viewType >= 3)
                              TimeInstanceWidget(
                                //1 day view
                                //today:day1
                                today: day3,
                                key: _key1,
                                classMaster: widget.classMaster,
                                openCallback: openDialogCallback,
                                viewType: viewType,
                              ),

                            if (viewType >= 2)
                              TimeInstanceWidget(
                                //1 day view
                                //today:day1
                                today: day2,
                                key: _key2,
                                classMaster: widget.classMaster,
                                openCallback: openDialogCallback,
                                viewType: viewType,
                              ),

                            if (viewType >= 1)
                              TimeInstanceWidget(
                                today: day1,
                                key: _key3,
                                classMaster: widget.classMaster,
                                openCallback: openDialogCallback,
                                viewType: viewType,
                              ),

                            // Container(
                            //   height: 1250,
                            //   width: (MediaQuery.of(context).size.width - 50) / 5,
                            //   color: Colors.white,
                            //   child: Column(),
                            // ),
                            // Container(
                            //   height: 1250,
                            //   width: (MediaQuery.of(context).size.width - 50) / 5,
                            //   color: Colors.white,
                            //   child: Column(
                            //     children: [],
                            //   ),
                            // ),
                          ]),
                      Row(
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          SizedBox(
                            height: 2,
                            width: MediaQuery.of(context).size.width - 50,
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 40,
                ),
                SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          dates!.map((e) => Text(e.substring(5, 10))).toList(),
                    )),
                const SizedBox(
                  width: 5,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 3,
                ),
                const Text('View',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                androidDropdown(['day', 'month', 'year'], (p0) => {}, 'month'),
                const Spacer(
                  flex: 1,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_left,
                    size: 35,
                  ),
                  onPressed: () {
                    dateSetter(false, false);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_right,
                    size: 35,
                  ),
                  onPressed: () {
                    dateSetter(true, false);
                  },
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
          ],
        ),
        if (openDialog)
          GraphDialog(
            openCallback: openDialogCallback,
            hourlyDataInstance: hourlyDataInstanceFromChild,
            classMaster: widget.classMaster,
          ),
      ],
    );
  }

  Container androidDropdown(
      List<String> items, Function(String?)? callBack, String dropdownTitle) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String item in items) {
      var newItem = DropdownMenuItem(
        key: UniqueKey(),
        child: Text(item, style: const TextStyle(fontSize: 13)),
        value: item,
      );
      dropdownItems.add(newItem);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: DropdownButton<String>(
        hint: Text(
          dropdownTitle,
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
        ),
        items: dropdownItems,
        borderRadius: BorderRadius.circular(25),
        onChanged: callBack,
      ),
    );
  }

  // incrementDate() {
  //   //on back button: increament the epoch to 3days, goes the planner page
  //   //is set to pasted last 3 set of days, from present.
  //   //1 day view
  //   //day1 = day1 + 86400000;

  //   day1 = day1 + 3 * 86400000;
  //   day2 = day1 + 86400000;
  //   day3 = day1 + 2 * 86400000;
  //   // print('00000000000000000000000000000000');
  //   // dateTest(day1);
  //   // dateTest(day2);
  //   // dateTest(day3);
  //   // print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
  //   //dateSetter(true);
  //   // calls();
  // }

  // decrementDate() {
  //   //1 day view
  //   //day1 = day1 - 86400000;

  //   day1 = day1 - 3 * 86400000;
  //   day2 = day1 + 86400000;
  //   day3 = day1 + 2 * 86400000;
  //   // day2 = day1 + 86400000;
  //   // day3 = day2 + 86400000;
  //   // print("---------------------------------");
  //   // dateTest(day1);
  //   // dateTest(day2);
  //   // dateTest(day3);
  //   // print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
  //   //dateSetter(false);
  //   // calls();
  // }

  dateSetter(bool isIncrement, bool isIntl) {
    setState(() {
      dates!.clear();
      if (viewType == 1) {
        //for viewType 1:)
        day1 = isIncrement ? day1 + 86400000 : day1 - 86400000;
        // dates!.add(DateTime.fromMillisecondsSinceEpoch(day1).toString());
      } else if (viewType == 2) {
        day2 = isIncrement ? day1 + 86400000 : day2 - 2 * 86400000;
        day1 = day2 + 86400000;
        // dates!.add(DateTime.fromMillisecondsSinceEpoch(day2).toString());
        // dates!.add(DateTime.fromMillisecondsSinceEpoch(day1).toString());
      } else if (viewType == 3) {
        day3 = isIncrement ? day1 + 86400000 : day3 - 3 * 86400000;
        day2 = day3 + 86400000;
        day1 = day3 + 2 * 86400000;
        widgetScrollCOntroller.animateTo(
            30 * double.parse(DateTime.now().toString().substring(11, 13)),
            curve: Curves.linear,
            duration: const Duration(milliseconds: 500));

        // dates!.add(DateTime.fromMillisecondsSinceEpoch(day3).toString());
        // dates!.add(DateTime.fromMillisecondsSinceEpoch(day2).toString());
        // dates!.add(DateTime.fromMillisecondsSinceEpoch(day1).toString());
      } else if (viewType == 5) {
        day5 = isIncrement ? day1 + 86400000 : day5 - 5 * 86400000;
        day4 = day5 + 86400000;
        day3 = day5 + 2 * 86400000;
        day2 = day5 + 3 * 86400000;
        day1 = day5 + 4 * 86400000;
        widgetScrollCOntroller.animateTo(
            30 * double.parse(DateTime.now().toString().substring(11, 13)),
            curve: Curves.linear,
            duration: const Duration(milliseconds: 500));
        // dates!.add(DateTime.fromMillisecondsSinceEpoch(day5).toString());
        // dates!.add(DateTime.fromMillisecondsSinceEpoch(day4).toString());
        // dates!.add(DateTime.fromMillisecondsSinceEpoch(day3).toString());
        // dates!.add(DateTime.fromMillisecondsSinceEpoch(day2).toString());
        // dates!.add(DateTime.fromMillisecondsSinceEpoch(day1).toString());
      }
    });
    addDateToList();
  }

  calls() {
    print("--planner_graph:calls");
    print(day1);
    print(day2);
    print(day3);

    // _key1.currentState!.getTodayInstance(day1);
    // _key2.currentState!.getTodayInstance(day2);
    // _key2.currentState!.getTodayInstance(day3);
  }
}

class test extends StatelessWidget {
  test({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(text);
  }
}
