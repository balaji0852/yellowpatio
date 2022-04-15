import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yellowpatioapp/Pages/color_store.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';

class TimeInstanceWidget extends StatefulWidget {
  final ClassMaster classMaster;
  final int today;

  const TimeInstanceWidget(
      {Key? key, required this.classMaster, required this.today})
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
    print('-initState:tiw');
    print(DateTime.fromMillisecondsSinceEpoch(widget.today));
    getTodayInstance(widget.today);
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();

  //   // print("tiw --- dcp");
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1250,
      width: (MediaQuery.of(context).size.width - 50) / 3,
      color: Colors.white,
      child: Column(
          children: todayInstance
              .map((element) => SizedBox(
                    height: 50,
                    child: Flex(
                        key: UniqueKey(),
                        direction: Axis.horizontal,
                        children: element
                            .map(
                              (e) => Expanded(
                                key: UniqueKey(),
                                child: Container(
                                    color: colorStore.getColorByID(
                                        widget.classMaster.itemClassColorID),
                                    child: Text(e.dataInstances)),
                              ),
                            )
                            .toList()),
                  ))
              .toList()),
    );
  }

  getTodayInstance(int sampletoday) async {
    print('-getTodayInstance:widget.today');
    print(DateTime.fromMillisecondsSinceEpoch(widget.today));
    print('-getTodayInstance:sampletoday');
    print(DateTime.fromMillisecondsSinceEpoch(sampletoday));

    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final dataInstanceMasterDao = database.dataInstanceMasterDao;

    int now = DateTime.parse(DateTime.fromMillisecondsSinceEpoch(sampletoday)
                .toString()
                .substring(0, 10) +
            " 00:00:00.000")
        .millisecondsSinceEpoch;

    int dayStart = DateTime.parse(
            DateTime.fromMillisecondsSinceEpoch(sampletoday+ 86400000)
                    .toString()
                    .substring(0, 10) +
                " 00:00:00.000")
        .millisecondsSinceEpoch;

    print("query:now"+DateTime.fromMillisecondsSinceEpoch(sampletoday).toString());
    print("query:nextnow"+
        DateTime.fromMillisecondsSinceEpoch(sampletoday+ 86400000).toString());
    commentCopy = await dataInstanceMasterDao.findDataInstanceByOneInterval(
        dayStart, now, widget.classMaster.itemMasterID!);

    setState(() {
      processTodayData();
    });
  }

  processTodayData() {
    if (commentCopy!.isNotEmpty) {
      todayInstance = List.generate(24, (index) => []);
      for (var element in commentCopy!) {
        print(
            "critical - ${DateTime.fromMillisecondsSinceEpoch(element.instancesTime)}" +
                element.dataInstances);
        var timeInstance =
            DateTime.fromMillisecondsSinceEpoch(element.instancesTime);

        todayInstance
            .elementAt(
                int.parse(timeInstance.toString().substring(11, 13)) == 00
                    ? 0
                    : int.parse(timeInstance.toString().substring(11, 13))-1)
            .add(element);
        // print(todayInstance.elementAt(
        //     int.parse(timeInstance.toString().substring(11, 13)) - 1));
      }
    } else {
      todayInstance = List.generate(24, (index) => []);
    }
  }
}
