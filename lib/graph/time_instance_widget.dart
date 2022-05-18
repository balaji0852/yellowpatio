import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yellowpatioapp/Pages/color_store.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/graph/time_view_widget.dart';

// didChangeDependencies is called exactly after initstate for the first time
// didUpdateWidget on parent data change, then post this method build is called
//when Flex is set direction horizontal, and want the children widget to expand vertically, crossaxis stretch not the main, :)
class TimeInstanceWidget extends StatefulWidget {
  final ClassMaster classMaster;
  final int today;
  final Function(bool, List<DataInstancesMaster>) openCallback;
  final int viewType;
  final int graphType;
  const TimeInstanceWidget(
      {Key? key,
      required this.classMaster,
      required this.today,
      required this.openCallback, required this.viewType, required this.graphType,})
      : super(key: key);

  @override
  TimeInstancePage createState() {
    return TimeInstancePage();
  }
}

class TimeInstancePage extends State<TimeInstanceWidget> {
  ColorStore colorStore = ColorStore();
  List<DataInstancesMaster>? commentCopy = [];
  List<List<DataInstancesMaster>> todayInstance =
      List.generate(24, (index) => []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print('-initState:tiw');
    // print(DateTime.fromMillisecondsSinceEpoch(widget.today));
    // getTodayInstance(widget.today);
    getTodayInstance(widget.today);
  }

  @override
  void didUpdateWidget(covariant TimeInstanceWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    getTodayInstance(widget.today);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2400,
      // width: 30,
      width: (MediaQuery.of(context).size.width - 50)/widget.viewType ,
      color: Colors.white,
      child: Column(
          children: todayInstance.map((element) {
        int index = 0;
        print(element.length > 5);
        print(element.map((e) => e));
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
                  index++;
                  double height = (int.parse(
                              DateTime.fromMillisecondsSinceEpoch(
                                      e.instancesTime)
                                  .toString()
                                  .substring(14, 16)) /
                          60) *
                      90;
                  print(index);
                  if (index > 3) {
                    return SizedBox(
                      width: 3,
                      child: Column(
                        children: [
                          SizedBox(
                            height: height,
                          ),
                          Expanded(
                            child: Container(
                              color: colorStore.getColorByID(
                                  widget.classMaster.itemClassColorID),
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                         color: colorStore.getColorByID(
                                  widget.classMaster.itemClassColorID),),
                             
                              child: Text(
                                e.dataInstances,
                                maxLines: 8,
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

  getTodayInstance(int sampletoday) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final dataInstanceMasterDao = database.dataInstanceMasterDao;

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

        if(widget.graphType==1){
    commentCopy = await dataInstanceMasterDao.findDataInstanceByOneInterval(
         initial,end, widget.classMaster.itemMasterID!);
        }else{
            commentCopy = await dataInstanceMasterDao.findDataInstanceByInterval(initial,end);
        }
    processTodayData();
  }

  processTodayData() {
    setState(() {
      if (commentCopy!.isNotEmpty) {
        todayInstance = List.generate(24, (index) => []);
        for (var element in commentCopy!) {
          var timeInstance =
              DateTime.fromMillisecondsSinceEpoch(element.instancesTime);

          todayInstance
              .elementAt(int.parse(timeInstance.toString().substring(11, 13)) ==
                      00
                  ? 0
                  : int.parse(timeInstance.toString().substring(11, 13)) - 1)
              .add(element);
        }
      } else {
        todayInstance = List.generate(24, (index) => []);
      }
    });
  }
}
