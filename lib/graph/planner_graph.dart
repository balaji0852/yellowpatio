import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/Pages/color_store.dart';
import 'package:yellowpatioapp/db/entity/class_data_instanceMaster.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/graph/dropwdown.dart';
import 'package:yellowpatioapp/graph/graph_dialog.dart';
import 'package:yellowpatioapp/graph/time_instance_widget.dart';

import '../config.dart';
import '../redux_state_store/appStore.dart';

//having a listview with a fiexed height container is good, but having a
//column and a listview inside the box
//container can't have color in outside and a decoration, throws error
//typedefs are always outside
class PlannerGraph extends StatefulWidget {
  final ClassMaster classMaster;
  final int graphType;
  final ScrollController MainWidgetScrollView;
  final int reKey;
  const PlannerGraph(
      {Key? key,
      required this.classMaster,
      required this.graphType,
      required this.MainWidgetScrollView,
      required this.reKey})
      : super(key: key);

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
  var state;
  //dates List and Row uses and manipulates the date integers - 5
  late int day1, day2, day3, day4, day5;
  double planner_graph_height = 625;
  List<String> viewCategory = ["all", "done", "to-do", "working"];
  int selectedViewCategoryID = 0;

  static List<String> time = List.generate(
      24,
      (index) => index <= 11
          ? (index + 1).toString() 
          : (index + 1).toString() );
  late List<String>? dates = [];
  final itemSize = 2402.0;
  bool openDialog = false;
  List<ClassDataInstanceMaterDuplicate> hourlyDataInstanceFromChild = [];
  int viewType = 1;
  //11/28/2022 : balaji , using local variable to set darkMode
  bool darkMode = false;
  //11/30/2022 : balaji, adding below list for implementing quick view
  List<List<test>>? quickViewData = List.generate(5, (index) => List.empty(growable: true));

  @override
  void initState() {
    super.initState();

    //temp
    //TODO - for removal, check 155 line, was a temp walkaround.
    var config = Config();
    setState(() {
      viewType = Config.dateViewPreference;
      print(viewType);
    });

    //TODO removal - used to call for 3 view previously
    initializeDate(DateTime.now().millisecondsSinceEpoch);
    //moving dateSetter to didChangeDependencies
  }

  setListviewWidget() {
    //TODO -done : fixed animation, by change value to '90' *
    Future.delayed(const Duration(milliseconds: 1000), () {
      widgetScrollCOntroller.animateTo(
          90 * double.parse(DateTime.now().hour.toString()),
          curve: Curves.linear,
          duration: const Duration(milliseconds: 300));
    });
  }

  openDialogCallback(bool openDialog,
      List<ClassDataInstanceMaterDuplicate> hourlyDataInstanceFromChild) {
    //adding List to callback for now, this is to populate the List<HourlyDataInstance>
    //to graph_dialog, finding central state management...
    setState(() {
      this.hourlyDataInstanceFromChild = hourlyDataInstanceFromChild;
      this.openDialog = openDialog;
    });
  }

  getQuickViewData(
      int column, List<ClassDataInstanceMaterDuplicate> todayQuickViewData) {
    if (mounted) {
      List<test> _todayQuickData = List.empty(growable: true);
      int currentPresence = 0;
      for (var dataInstances in todayQuickViewData) {
        if (_todayQuickData.where((instance) {
          return instance.colorID == dataInstances.itemClassColorID;
        }).isNotEmpty) {

          var _test = _todayQuickData
                      .where((instance) {
                        return instance.colorID ==
                            dataInstances.itemClassColorID;
                      })
                      .first;
          
          _todayQuickData[_todayQuickData.lastIndexWhere(
              (instance) =>
                  instance.colorID == dataInstances.itemClassColorID)] = test(
              index: _test.index,
              columnName: column,
              colorID: dataInstances.itemClassColorID,
              presenceCount: _test.presenceCount+1 );
        } else {
          _todayQuickData.add(test(
              index: currentPresence,
              colorID: dataInstances.itemClassColorID,
              presenceCount: 1,
              columnName: column));
          currentPresence++;
        }

        //_todayQuickData[dataInstances.itemClassColorID] += 1;
        // if (_todayQuickData.containsKey(dataInstances.itemClassColorID)) {
        //   int temp = _todayQuickData[dataInstances.itemClassColorID]! + 1;
        //   _todayQuickData.putIfAbsent(
        //       dataInstances.itemClassColorID, () => temp);
        // } else {
        //   _todayQuickData.putIfAbsent(dataInstances.itemClassColorID, () => 1);
        // }
      }
      setState(() {
        quickViewData![column] = _todayQuickData;
      });
    }
  }

  closeDialogCallback(bool openDialog) {
    //adding List to callback for now, this is to populate the List<HourlyDataInstance>
    //to graph_dialog, finding central state management...
    setState(() {
      this.openDialog = openDialog;
    });
  }

  initializeDate(int day) {
    //int day = DateTime.now().millisecondsSinceEpoch;
    day5 = day - 4 * 86400000;
    day4 = day - 3 * 86400000;
    day3 = day - 2 * 86400000;
    day2 = day - 86400000;
    day1 = day;
  }

  addDateToList() {
    setState(() {
      dates!.clear();

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
    });
  }

  @override
  void didUpdateWidget(covariant PlannerGraph oldWidget) {
    super.didUpdateWidget(oldWidget);

  
    int _viewType = state.state.dateViewPreference;
    if (_viewType != viewType || widget.reKey != oldWidget.reKey) {
      initializeDate(DateTime.parse(dates!.last).millisecondsSinceEpoch);
      viewType = _viewType;
      quickViewDataCleanUp();
      addDateToList();
      //dateSetter(false, true);
    }
  }

  void updateStoreValue() {
    state = StoreProvider.of<AppStore>(context);
    viewType = state.state.dateViewPreference;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    updateStoreValue();
    dateSetter(false, true);
  }

  quickViewDataCleanUp() {
    quickViewData![0].clear();
    quickViewData![1].clear();
    quickViewData![2].clear();
    quickViewData![3].clear();
    quickViewData![4].clear();
  }

  pageDownScroller(ScrollController mainWidgetScrollController) {
    mainWidgetScrollController.animateTo(850,
        curve: Curves.linear, duration: const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    state = StoreProvider.of<AppStore>(context);
    darkMode = state.state.darkMode;
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 575,
              color: darkMode ? Colors.black : Colors.white,
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
                              width: 15,
                              // ignore: prefer_const_literals_to_create_immutables
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: time
                                      .map((e) => SizedBox(
                                            height: 100,
                                            child: Text(
                                              e,
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: darkMode
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ))
                                      .toList()),
                            ),
                            // SizedBox(
                            //   height: 2400,
                            //   width: 2,
                            //   child: Container(
                            //     color:darkMode?Colors.white: Colors.black,
                            //   ),
                            // ),
                            //Dates are provided to TimeIntanceWidget, they query it and save in 24-List, type 2D...
                            //TimeIntanceWidget makes the query for a day, or based csp(comment section page) view
                            //csp will provide the 2D List, classmaster object is provided. plannerGraph->timeInstanceWidget...
                            //set the color of widget as per ClassMaster object.
                            if (viewType >= 5)
                              TimeInstanceWidget(
                                //1 day view
                                //today:day1
                                reKey: widget.reKey,
                                columnName: 4,
                                today: day5,
                                classMaster: widget.classMaster,
                                openCallback: openDialogCallback,
                                viewType: selectedViewCategoryID,
                                graphType: widget.graphType,
                                filter: viewType,
                                getDataCallBack: getQuickViewData,
                              ),
                            if (viewType >= 5)
                              TimeInstanceWidget(
                                //1 day view
                                //today:day1
                                reKey: widget.reKey,

                                columnName: 3,
                                today: day4,
                                classMaster: widget.classMaster,
                                openCallback: openDialogCallback,
                                viewType: selectedViewCategoryID,

                                graphType: widget.graphType,
                                filter: viewType,
                                getDataCallBack: getQuickViewData,
                              ),

                            if (viewType >= 3)
                              TimeInstanceWidget(
                                //1 day view
                                //today:day1
                                reKey: widget.reKey,

                                columnName: 2,
                                today: day3,
                                key: _key1,
                                classMaster: widget.classMaster,
                                openCallback: openDialogCallback,
                                viewType: selectedViewCategoryID,
                                graphType: widget.graphType,
                                filter: viewType,
                                getDataCallBack: getQuickViewData,
                              ),

                            if (viewType >= 2)
                              TimeInstanceWidget(
                                //1 day view
                                //today:day1
                                reKey: widget.reKey,

                                columnName: 1,
                                today: day2,
                                key: _key2,

                                classMaster: widget.classMaster,
                                openCallback: openDialogCallback,
                                viewType: selectedViewCategoryID,
                                graphType: widget.graphType,
                                filter: viewType,
                                getDataCallBack: getQuickViewData,
                              ),

                            if (viewType >= 1)
                              TimeInstanceWidget(
                                reKey: widget.reKey,
                                columnName: 0,
                                today: day1,
                                key: _key3,
                                classMaster: widget.classMaster,
                                openCallback: openDialogCallback,
                                viewType: selectedViewCategoryID,
                                graphType: widget.graphType,
                                filter: viewType,
                                getDataCallBack: getQuickViewData,
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
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  height: 1.5,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Container(
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  width: 15,
                ),
                if (viewType >= 5) quickViewDataWidget(4),
                if (viewType >= 4) quickViewDataWidget(3),
                if (viewType >= 3) quickViewDataWidget(2),
                if (viewType >= 2) quickViewDataWidget(1),
                if (viewType >= 1) quickViewDataWidget(0),
                const SizedBox(
                  width: 5,
                )
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: dates!
                          .map(
                            (e) => Text(
                              e.substring(5, 10),
                              style: TextStyle(
                                  color:
                                      darkMode ? Colors.white : Colors.black),
                            ),
                            // if (quickViewData!
                            //     .elementAt(dates!.indexOf(e))!
                            //     .isNotEmpty)
                            //     Container(child:

                            // Flex(
                            //   direction: Axis.horizontal,
                            //   children: quickViewData!
                            //       .elementAt(0)
                            //       .map((color) {
                            //     return Container(
                            //       child: Text(
                            //           color.presenceCount.toString()+" 888"),
                            //       height: 10,
                            //       width: 10,
                            //       color: ColorStore()
                            //           .getColorByID(color.colorID),
                            //     );
                            //   }).toList(),
                            // )
                          )
                          .toList(),
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
                Text('View',
                    style: TextStyle(
                        fontSize: 14,
                        color: darkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold)),
                DropDown(
                  callBack: (selected) {
                    setState(() {
                      selectedViewCategoryID = viewCategory.indexOf(selected!);
                      quickViewDataCleanUp();
                    });
                  },
                  darkMode: darkMode,
                  dropdownTitle: viewCategory.elementAt(selectedViewCategoryID),
                  viewCategory: viewCategory,
                ),
                const Spacer(
                  flex: 1,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new,
                      size: 25, color: darkMode ? Colors.white : Colors.black),
                  onPressed: () {
                    dateSetter(false, false);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios,
                      size: 25, color: darkMode ? Colors.white : Colors.black),
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
        Positioned(
            bottom: 550,
            child: CircleAvatar(
              radius: 21,
             
              backgroundColor: darkMode ? Colors.black : Colors.white,
              child:Center(child:  IconButton(
                color: darkMode ? Colors.white : Colors.black,
              
                onPressed: () {
                  pageDownScroller(widget.MainWidgetScrollView);
                },
                icon: const Icon(
                  Icons.arrow_circle_down,
                  size: 35,
                ),
              ),),
            )),
        if (openDialog)
        GestureDetector(
          onTap: () => openDialogCallback(false,[]),
          child:  Container(
            height: 670,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Text(''),
          ),
        )
         ,
        if (openDialog)
          GraphDialog(
            openCallback: openDialogCallback,
            hourlyDataInstance: hourlyDataInstanceFromChild,
            classMaster: widget.classMaster,
          ),
        
      ],
    );
  }

  dateSetter(bool isIncrement, bool isIntl) {
      //setState(() {
      if (viewType == 1) {
        day1 = isIntl
            ? day1
            : isIncrement
                ? day1 + 86400000
                : day1 - 86400000;
      } else if (viewType == 2) {
        day2 = isIntl
            ? day2
            : isIncrement
                ? day1 + 86400000
                : day2 - 2 * 86400000;
        day1 = day2 + 86400000;
      } else if (viewType == 3) {
        day3 = isIntl
            ? day3
            : isIncrement
                ? day1 + 86400000
                : day3 - 3 * 86400000;
        day2 = day3 + 86400000;
        day1 = day3 + 2 * 86400000;
      } else if (viewType == 5) {
        day5 = isIntl
            ? day5
            : isIncrement
                ? day1 + 86400000
                : day5 - 5 * 86400000;
        day4 = day5 + 86400000;
        day3 = day5 + 2 * 86400000;
        day2 = day5 + 3 * 86400000;
        day1 = day5 + 4 * 86400000;
      }
    //});
    setListviewWidget();
    //balaji : 12/4/2022 : adding below if/ for quickview implementation
    //if (!isIntl) {
    quickViewDataCleanUp();
    //}
    addDateToList();
  }

  calls() {
    print("--planner_graph:calls");
    print(day1);
    print(day2);
    print(day3);

  }

  Widget quickViewDataWidget(int index) {
    return SizedBox(
      height: 20,
      width: (MediaQuery.of(context).size.width - 50) / viewType,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: quickViewData!
            .elementAt(index)
            .where((element) => viewType > 2 ? element.index < 3 : true)
            .map((quickDate) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 0, 2),
              child: Container(
                alignment: Alignment.center,
                height: 15,
                width: quickDate.presenceCount < 10 ? 15 : 18,
                color: quickDate.index > 1 && viewType > 2
                    ? darkMode
                        ? Colors.black
                        : Colors.white
                    : ColorStore().getColorByID(quickDate.colorID),
                child: Text(
                  quickDate.index > 1 && viewType > 2
                      ? "+"
                      : quickDate.presenceCount > 10
                          ? "10+"
                          : quickDate.presenceCount.toString(),
                  style: TextStyle(
                      fontSize: 9,
                      color: quickDate.index > 1 && viewType > 2
                          ? darkMode
                              ? Colors.white
                              : Colors.black
                          : Colors.black),
                ),
              ));
        }).toList(),
      ),
    );
  }
}

class test {
  test({
    required this.index,
    required this.colorID,
    required this.presenceCount,
    required this.columnName,
  });

  final int index;
  final int columnName;
  final int colorID;
  final int presenceCount;
}
