import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:yellowpatioapp/Pages/color_store.dart';
import 'package:yellowpatioapp/db/entity/class_data_instanceMaster.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';

class GraphDialog extends StatefulWidget {
  const GraphDialog(
      {Key? key, required this.openCallback, required this.hourlyDataInstance, required this.classMaster})
      : super(key: key);

  final ClassMaster classMaster;
  final Function(bool, List<ClassDataInstanceMaterDuplicate>) openCallback;
  final List<ClassDataInstanceMaterDuplicate> hourlyDataInstance;

  @override
  graphDialogPage createState() {
    return graphDialogPage();
  }
}

class graphDialogPage extends State<GraphDialog> {

  ColorStore colorStore = ColorStore();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white54, borderRadius: BorderRadius.circular(20)),
        height: 450,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CloseButton(
                  onPressed: () {
                    //print(openDialog);
                    widget.openCallback(false, widget.hourlyDataInstance);
                  },
                )
              ],
            ),
            SizedBox(
              height: 390,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: widget.hourlyDataInstance
                    .map((e) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'comments',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colorStore.getColorByID(e.itemClassColorID),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Text(e.dataInstances),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(DateTime.fromMillisecondsSinceEpoch(
                                              e.instancesTime)
                                          .toString().substring(0,16))
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),                        )))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
