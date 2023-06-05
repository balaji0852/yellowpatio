import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/Pages/color_store.dart';
import 'package:yellowpatioapp/cloud/dataInstanceMasterCloud.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/class_data_instanceMaster.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/graph/time_view_widget.dart';
import 'package:collection/collection.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';

import '../SupportSystem/syncher.dart';
import '../db/entity/user_store.dart';
import '../redux_state_store/appStore.dart';

// didChangeDependencies is called exactly after initstate for the first time
// didUpdateWidget on parent data change, then post this method build is called
//when Flex is set direction horizontal, and want the children widget to expand vertically, crossaxis stretch not the main, :)
class TimeInstanceWidget extends StatefulWidget {
  final ClassMaster classMaster;
  final int today;
  final Function(bool, List<ClassDataInstanceMaterDuplicate>, int selectedIndex)
      openCallback;
  final Function(int, List<ClassDataInstanceMaterDuplicate>) getDataCallBack;
  final int columnName;
  final int viewType;
  final int graphType;
  final int filter;
  final int reKey;
  const TimeInstanceWidget(
      {Key? key,
      required this.reKey,
      required this.classMaster,
      required this.today,
      required this.openCallback,
      required this.viewType,
      required this.graphType,
      required this.filter,
      required this.columnName,
      required this.getDataCallBack})
      : super(key: key);

  @override
  TimeInstancePage createState() {
    return TimeInstancePage();
  }
}

class TimeInstancePage extends State<TimeInstanceWidget> {
  ColorStore colorStore = ColorStore();
  List<ClassDataInstanceMaterDuplicate>? commentCopy = [];
  List<List<ClassDataInstanceMaterDuplicate>> todayInstance =
      List.generate(24, (index) => []);
  var classMasterDummy;
  List<ClassDataInstanceMaterDuplicate>? temp;
  int viewType = 2;
  late int projectStoreID;
  //11/28/2022 : balaji , using local variable to set darkMode
  bool darkMode = false;
  var state;
  CancelableOperation? _cancelableOperation;
  var services = ReSyncher(interval: 15);
  int reKey = 0;
  int indexToRemove = -1;
  Function eq = const DeepCollectionEquality().equals;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reKey = widget.reKey;
    //updateStoreValue();
    //getTodayInstance(widget.today);
  }

  //balaji : 12/3/22 - r
  // void updateStoreValue() {
  //   var state = StoreProvider.of<AppStore>(context);
  //   viewType = state.state.dateViewPreference;
  // }

  //balaji : 11/30/2022 adding this if case for quick view impl
  //balaji : 12/4/2022, adding below todayInstance cleanup, as per pg.1.1
  //-----------------------changes under(cu) - balaji : 1/27/2023 cleanup only for changes in
  //------------------------------------------ widget.today and widget.viewType
  @override
  void didUpdateWidget(covariant TimeInstanceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.today != widget.today ||
        oldWidget.filter != widget.filter ||
        oldWidget.viewType != widget.viewType ||
        oldWidget.reKey != widget.reKey) {
      if (oldWidget.today != widget.today ||
          oldWidget.viewType != widget.viewType) {
        todayInstance = List.generate(24, (index) => []);
      }
      _cancelableOperation!.cancel();
      getTodayInstance(widget.today);
      destroyTTCFlow();
      services.isUIMounted = false;
      services = ReSyncher(interval: 15);
      services.serverConnector(() => getTodayInstance(widget.today), mounted);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getTodayInstance(widget.today);
    services.serverConnector(() => getTodayInstance(widget.today), mounted);
  }

  handleService(event) {
    print("***************tiw*************");
    if (FGBGType.background == event) {
      print("***************tiw-background*************");
      services.isUIMounted = false;
    } else if (FGBGType.foreground == event) {
      print("***************tiw-foreground*************");
    }
  }

  @override
  void dispose() {
    super.dispose();

    services.isUIMounted = false;
  }

  @override
  Widget build(BuildContext context) {
    state = StoreProvider.of<AppStore>(context);
    darkMode = state.state.darkMode;

    return StoreConnector<AppStore, ClassDataInstanceMaterDuplicate>(
        converter: (store) => store.state.demoInstance,
        builder: (context, _demoInstance) {
          return FGBGNotifier(
            onEvent: (event) {
              handleService(event);
            },
            child: Container(
              height: 2640,
              width: (MediaQuery.of(context).size.width - 20) / widget.filter,
              color: darkMode ? Colors.black : Colors.white,
              child: Column(
                  children: todayInstance.map((element) {
                int index = 0;
                modifyTodayInstance(todayInstance.indexOf(element) + 1);
                // print(element.length > 5);
                // print(element.map((e) => e));
                //element = element.length>=5?element.sublist(0,3):element;
                return SizedBox(
                  height: 110,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 0.2,
                        width: MediaQuery.of(context).size.width - 20,
                        child: Container(
                          color: darkMode ? Colors.white : Colors.black,
                          child: Text(""),
                        ),
                      ),
                      if (element.isEmpty && widget.graphType == 1)
                        GestureDetector(
                          onTap: () {
                            createTTCFlow(todayInstance.indexOf(element) + 1);
                          },
                          child: SizedBox(
                            height: 109,
                            width: MediaQuery.of(context).size.width - 20,
                            child: Container(
                                color: Colors.transparent, child: Text(" ")),
                          ),
                        ),
                      if (element.isNotEmpty)
                        SizedBox(
                          height: 109,
                          child: Flex(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            key: UniqueKey(),
                            direction: Axis.horizontal,
                            children: element
                                .whereIndexed((index, element) =>
                                    index <
                                    ViewChangesHelper().limiter(widget.filter))
                                .map((e) {
                              int viewSetterValues = ViewChangesHelper()
                                  .viewSetterForType(widget.filter);
                              double fontSize = viewSetterValues == 1
                                  ? 9
                                  : viewSetterValues == 2
                                      ? 10
                                      : 11;
                              index++;

                              double height =
                                  (DateTime.fromMillisecondsSinceEpoch(
                                                  e.instancesTime)
                                              .minute /
                                          60) *
                                      20;

                              if (index ==
                                      ViewChangesHelper()
                                          .limiter(widget.filter) ||
                                  ((widget.filter == 3 || widget.filter == 5) &&
                                      index ==
                                          ViewChangesHelper()
                                              .limiter(widget.filter))) {
                                return SizedBox(
                                  width: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "+",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: colorStore.getColorByID(
                                                e.itemClassColorID)),
                                      )
                                    ],
                                  ),
                                );
                              }
                              if (index >
                                  ViewChangesHelper()
                                      .viewSetterForType(widget.filter)) {
                                return SizedBox(
                                  width: 3,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: height,
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: e.itemClassColorID == 999
                                              ? colorStore.getColorByID(widget
                                                  .classMaster.itemClassColorID)
                                              : colorStore.getColorByID(
                                                  e.itemClassColorID),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                              return Flexible(
                                key: UniqueKey(),
                                child: GestureDetector(
                                  onTap: () {
                                    if (state.state.demoInstance.itemMasterID ==
                                        999) {
                                      widget.openCallback(
                                          true, element, element.indexOf(e));
                                    } else {
                                      destroyTTCFlow();
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // SizedBox(
                                      //   height: height,
                                      // ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      topRight:
                                                          Radius.circular(5)),
                                              color: e.itemClassColorID == 999
                                                  ? colorStore.getColorByID(
                                                      widget.classMaster
                                                          .itemClassColorID)
                                                  : colorStore.getColorByID(
                                                      e.itemClassColorID),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                    top: 16,
                                                    left: 0,
                                                    right: 0,
                                                    child: Text(
                                                      e.dataInstances,
                                                      maxLines: 8,
                                                      style: TextStyle(
                                                          fontSize: fontSize),
                                                    )),
                                                if (e.userStore.photoURL
                                                    .isNotEmpty)
                                                  Positioned(
                                                    right: 4,
                                                    top: 1,
                                                    left: 0,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        if (e.instancesTime <
                                                            DateTime.parse(DateTime.fromMillisecondsSinceEpoch(widget
                                                                            .today)
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10) +
                                                                    " 00:00:00.000")
                                                                .millisecondsSinceEpoch)
                                                          const Text(
                                                            "#unfinished  ",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        if (widget.filter < 3)
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 9,
                                                            child: CircleAvatar(
                                                              radius: 8,
                                                              backgroundImage:
                                                                  NetworkImage(e
                                                                      .userStore
                                                                      .photoURL),
                                                            ),
                                                          )
                                                      ],
                                                    ),
                                                  )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                    ],
                  ),
                );
              }).toList()),
            ),
          );
        });
  }

  void modifyTodayInstance(int index) {
    if (state.state.demoInstance.userStore.dateViewPreference !=
            widget.columnName &&
        index == indexToRemove &&
        indexToRemove != -1) {
      if (todayInstance.elementAt(indexToRemove).isNotEmpty) {
        todayInstance.elementAt(indexToRemove).removeAt(0);
        indexToRemove = -1;
      }
    }
    int initial = DateTime.parse(
            DateTime.fromMillisecondsSinceEpoch(widget.today)
                    .toString()
                    .substring(0, 10) +
                " 00:00:00.000")
        .millisecondsSinceEpoch;
    if (state.state.demoInstance.instancesTime != 999 &&
        state.state.demoInstance.instancesStatus == index &&
        state.state.demoInstance.instancesTime <=
            (initial + (3600000 * index)) &&
        state.state.demoInstance.instancesTime >= (initial - (3600000))) {
      List<ClassDataInstanceMaterDuplicate> localTodayInstance = [];
      if (todayInstance[index - 1].isNotEmpty &&
          todayInstance[index - 1].elementAt(0).dataInstanceID ==
              state.state.demoInstance.dataInstanceID) {
        todayInstance
            .elementAt(index - 1)
            .replaceRange(0, 1, [state.state.demoInstance]);
      } else {
        // todayInstance.elementAt(index-1).removeAt(0);
        localTodayInstance.add(state.state.demoInstance);
      }
      localTodayInstance.addAll(todayInstance.elementAt(index - 1));
      todayInstance[index - 1] = localTodayInstance;
      indexToRemove = index - 1;
    }
  }

  void destroyTTCFlow() {
    state.dispatch(DEMODataInstance(demoInstanceLocal));
  }

  void createTTCFlow(int index) {
    int initial = DateTime.parse(
            DateTime.fromMillisecondsSinceEpoch(widget.today)
                    .toString()
                    .substring(0, 10) +
                " 00:00:00.000")
        .millisecondsSinceEpoch;
    initial += (3600000 * index);
    ClassDataInstanceMaterDuplicate demoInstance =
        ClassDataInstanceMaterDuplicate(
            dataInstanceID: Random().nextInt(3000),
            itemMasterID: widget.classMaster.itemMasterID!,
            dataInstances: "[remainder]:",
            instancesTime: initial,
            itemClassColorID: widget.classMaster.itemClassColorID,
            instancesStatus: index,
            userStore: UserStore(
                userStoreID: state.state.userStoreID,
                linkedEmail: '',
                linkedPhone: '',
                photoURL: '',
                userName: '',
                dateViewPreference: widget.columnName));

    if (state.state.demoInstance.itemMasterID == 999) {
      state.dispatch(DEMODataInstance(demoInstance));
      modifyTodayInstance(index);
    } else {
      indexToRemove = index - 1;
      destroyTTCFlow();
    }
  }

  void getTodayInstance(int sampletoday) async {
    // final database =
    //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // final dataInstanceMasterDao = database.dataInstanceMasterDao;
    // final ClassMasterDao = database.classMasterDao;

    var state = StoreProvider.of<AppStore>(context);
    projectStoreID = state.state.projectStoreID;

    int initial = DateTime.parse(
            DateTime.fromMillisecondsSinceEpoch(widget.today)
                    .toString()
                    .substring(0, 10) +
                " 00:00:00.000")
        .millisecondsSinceEpoch;

    int end = DateTime.parse(
            DateTime.fromMillisecondsSinceEpoch(widget.today + 86400000)
                    .toString()
                    .substring(0, 10) +
                " 00:00:00.000")
        .millisecondsSinceEpoch;
    //cloud migration
    if (widget.graphType == 1) {
      if (widget.viewType == 0) {
        _cancelableOperation = CancelableOperation.fromFuture(
          DataInstanceMasterCloud().findDataInstanceByOneInterval(
              initial, end, widget.classMaster.itemMasterID!, projectStoreID),
          onCancel: () => [],
        );
        // commentCopy = await DataInstanceMasterCloud()
        //     .findDataInstanceByOneInterval(
        //         initial, end, widget.classMaster.itemMasterID!, projectStoreID);
        // commentCopy = await dataInstanceMasterDao.findDataInstanceByOneInterval(
        //     initial, end, widget.classMaster.itemMasterID!,projectStoreID);
      } else {
        // commentCopy = await DataInstanceMasterCloud()
        //     .findDataInstanceByOneIntervalV1(
        //         initial,
        //         end,
        //         widget.classMaster.itemMasterID!,
        //         widget.viewType,
        //         projectStoreID);
        _cancelableOperation = CancelableOperation.fromFuture(
          DataInstanceMasterCloud().findDataInstanceByOneIntervalV1(
              initial,
              end,
              widget.classMaster.itemMasterID!,
              widget.viewType,
              projectStoreID),
          onCancel: () => [],
        );
        // commentCopy =
        //     await dataInstanceMasterDao.findDataInstanceByOneIntervalV1(initial,
        //         end, widget.classMaster.itemMasterID!, widget.viewType,projectStoreID);
      }
    } else {
      //commentCopy = await dataInstanceMasterDao.findDataInstanceByInterval(initial,end);

      //join is a wrong methodology for this action, use single query for this, using itemMasterID
      if (widget.viewType == 0) {
        // commentCopy = await DataInstanceMasterCloud()
        //     .findDataInstanceByIntervalWithClassMaster(
        //         initial, end, projectStoreID);
        _cancelableOperation = CancelableOperation.fromFuture(
          DataInstanceMasterCloud().findDataInstanceByIntervalWithClassMaster(
              initial, end, projectStoreID),
          onCancel: () => [],
        );
        // commentCopy = await dataInstanceMasterDao
        //     .findDataInstanceByIntervalWithClassMaster(initial, end,projectStoreID);
      } else {
        // commentCopy = await DataInstanceMasterCloud()
        //     .findDataInstanceByIntervalWithClassMasterV1(
        //         initial, end, widget.viewType, projectStoreID);
        _cancelableOperation = CancelableOperation.fromFuture(
          DataInstanceMasterCloud().findDataInstanceByIntervalWithClassMasterV1(
              initial, end, widget.viewType, projectStoreID),
          onCancel: () => [],
        );
        //  commentCopy = await dataInstanceMasterDao
        //     .findDataInstanceByIntervalWithClassMasterV1(
        //         initial, end, widget.viewType,projectStoreID);
      }
    }

    final value = await _cancelableOperation?.value;
    // if (!eq(commentCopy, value as List<ClassDataInstanceMaterDuplicate>?)) {
    commentCopy = value;
    processTodayData();
    // } else {
    //   print("same data");
    // }
  }

  //1/28/2023 : Balaji: adding getDataCallBack for quick view cleanup on commentCopy.isEmpty
  processTodayData() {
    //added mounted for cloud migration
    indexToRemove = -1;
    if (mounted) {
      setState(() {
        if (null != commentCopy &&
            commentCopy!.isNotEmpty &&
            _cancelableOperation!.isCompleted) {
          widget.getDataCallBack(widget.columnName, commentCopy!);
          todayInstance = List.generate(24, (index) => []);
          for (var element in commentCopy!) {
            var timeInstance =
                DateTime.fromMillisecondsSinceEpoch(element.instancesTime);

            todayInstance
                .elementAt(timeInstance.hour == 00 ? 0 : timeInstance.hour - 1)
                .add(element);
          }
        } else {
          widget.getDataCallBack(widget.columnName, []);
          todayInstance = List.generate(24, (index) => []);
        }
      });
    }
  }
}
