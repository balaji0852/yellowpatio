import 'package:flutter/cupertino.dart';
import 'package:yellowpatioapp/Pages/color_store.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/db/repository/data_instance_master_dao.dart';

class TimeView extends StatefulWidget {
  final ColorStore colorStore;
  final ClassMaster classMaster;
  final List<DataInstancesMaster> dataInstanceList;

  const TimeView(
      {Key? key,
      required this.colorStore,
      required this.classMaster,
      required this.dataInstanceList})
      : super(key: key);

  @override
  TimeViewPage createState() => TimeViewPage();
}

class TimeViewPage extends State<TimeView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Flex(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        key: UniqueKey(),
        direction: Axis.horizontal,
        children: widget.dataInstanceList.map((e) {
          index++;
          double height = (int.parse(DateTime.fromMillisecondsSinceEpoch(e.instancesTime).toString().substring(14,16))/15)*10;
          return Flexible(
            key: UniqueKey(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 SizedBox(
                  height: height,
                ),
                if (index <= 3)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                        color: widget.colorStore
                          .getColorByID(widget.classMaster.itemClassColorID),),
                   
                      child: Text(
                        e.dataInstances,
                        maxLines: 3,
                      ),
                    ),
                  )
                else if (index > 3 && index < 5)
                  SizedBox(
                    width: 1,
                    child: Container(
                      color: widget.colorStore
                          .getColorByID(widget.classMaster.itemClassColorID),
                      child: Text(" "),
                    ),
                  )
              ],
            ),
          );

          // Expanded(
          //   key: UniqueKey(),
          //   child: Container(
          //       color: colorStore.getColorByID(
          //           widget.classMaster.itemClassColorID),
          //       child: Text(e.dataInstances +
          //           MediaQuery.of(context)
          //               .size
          //               .height
          //               .toString())),
          // ),
        }).toList());
  }
}
