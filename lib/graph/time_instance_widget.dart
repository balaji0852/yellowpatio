import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/Pages/color_store.dart';
import 'package:yellowpatioapp/cloud/dataInstanceMasterCloud.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/class_data_instanceMaster.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/graph/time_view_widget.dart';

import '../redux_state_store/appStore.dart';

// didChangeDependencies is called exactly after initstate for the first time
// didUpdateWidget on parent data change, then post this method build is called
//when Flex is set direction horizontal, and want the children widget to expand vertically, crossaxis stretch not the main, :)
class TimeInstanceWidget extends StatefulWidget {
  final ClassMaster classMaster;
  final int today;
  final Function(bool, List<ClassDataInstanceMaterDuplicate>) openCallback;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //updateStoreValue();
    //getTodayInstance(widget.today);
  }

  //balaji : 12/3/22 - r
  // void updateStoreValue() {
  //   var state = StoreProvider.of<AppStore>(context);
  //   viewType = state.state.dateViewPreference;
  // }

  @override
  void didUpdateWidget(covariant TimeInstanceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    //balaji : 11/30/2022 adding this if case for quick view impl
    if (oldWidget.today != widget.today || oldWidget.filter!=widget.filter 
    || oldWidget.viewType!=widget.viewType || oldWidget.reKey!=widget.reKey) {
      print(oldWidget.today.toString()+" "+widget.today.toString());
      //balaji : 12/4/2022, adding below cleanup, as per pg.1.1
      todayInstance = List.generate(24, (index) => []);
      _cancelableOperation!.cancel();
      getTodayInstance(widget.today);
     }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // updateStoreValue();
    getTodayInstance(widget.today);
  }

  @override
  Widget build(BuildContext context) {

    state = StoreProvider.of<AppStore>(context);
    darkMode = state.state.darkMode;

    return Container(
      height: 2402,
      width: (MediaQuery.of(context).size.width - 20) / widget.filter,
      color: darkMode ? Colors.black : Colors.white,
      child: Column(
          children: todayInstance.map((element) {
        int index = 0;
        // print(element.length > 5);
        // print(element.map((e) => e));
        //element = element.length>=5?element.sublist(0,3):element;
        return SizedBox(
          height: 100,
          child: GestureDetector(
            onTap: () {
              widget.openCallback(true, element);
            },
            child: Flex(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                key: UniqueKey(),
                direction: Axis.horizontal,
                children: element.map((e) {
                  int viewSetterValues =
                      ViewChangesHelper().viewSetterForType(widget.filter);
                  double fontSize = viewSetterValues == 1
                      ? 9
                      : viewSetterValues == 2
                          ? 10
                          : 11;
                  index++;

                  double height =
                      (DateTime.fromMillisecondsSinceEpoch(e.instancesTime)
                                  .minute /
                              60) *
                          20;
                  if (index > ViewChangesHelper().viewSetterForType(widget.filter)) {
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
                                  ? colorStore.getColorByID(
                                      widget.classMaster.itemClassColorID)
                                  : colorStore.getColorByID(e.itemClassColorID),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Flexible(
                      key: UniqueKey(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: height,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                
                                color: e.itemClassColorID == 999
                                    ? colorStore.getColorByID(
                                        widget.classMaster.itemClassColorID)
                                    : colorStore
                                        .getColorByID(e.itemClassColorID),
                              ),
                              child: Text(
                                e.dataInstances,
                                maxLines: 8,
                                style: TextStyle(fontSize: fontSize),
                              ),
                            ),
                          )
                        ],
                      ));
                }).toList()),
          ),
        );
      }).toList()),
    );
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

         _cancelableOperation = CancelableOperation.fromFuture(DataInstanceMasterCloud()
            .findDataInstanceByOneInterval(
                initial, end, widget.classMaster.itemMasterID!, projectStoreID),onCancel: () => [],);
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
          _cancelableOperation = CancelableOperation.fromFuture(DataInstanceMasterCloud()
            .findDataInstanceByOneIntervalV1(
                initial,
                end,
                widget.classMaster.itemMasterID!,
                widget.viewType,
                projectStoreID),onCancel: () => [],);
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
         _cancelableOperation = CancelableOperation.fromFuture(DataInstanceMasterCloud()
            .findDataInstanceByIntervalWithClassMaster(
                initial, end, projectStoreID),onCancel: () => [],);
        // commentCopy = await dataInstanceMasterDao
        //     .findDataInstanceByIntervalWithClassMaster(initial, end,projectStoreID);
      } else {
        // commentCopy = await DataInstanceMasterCloud()
        //     .findDataInstanceByIntervalWithClassMasterV1(
        //         initial, end, widget.viewType, projectStoreID);
         _cancelableOperation = CancelableOperation.fromFuture(DataInstanceMasterCloud()
            .findDataInstanceByIntervalWithClassMasterV1(
                initial, end, widget.viewType, projectStoreID),onCancel: () => [],);
        //  commentCopy = await dataInstanceMasterDao
        //     .findDataInstanceByIntervalWithClassMasterV1(
        //         initial, end, widget.viewType,projectStoreID);
      }
    }
  
    final value = await _cancelableOperation?.value;
    commentCopy  = value as List<ClassDataInstanceMaterDuplicate>?;

    processTodayData();
  }

  processTodayData() {
    //added mounted for cloud migration
    if (mounted) {
      setState(() {
        if (null != commentCopy && commentCopy!.isNotEmpty && _cancelableOperation!.isCompleted) {
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
          todayInstance = List.generate(24, (index) => []);
        }
      });
    }
  }
}
