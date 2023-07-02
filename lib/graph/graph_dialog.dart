import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:planb/Pages/color_store.dart';
import 'package:planb/db/database.dart';
import 'package:planb/db/entity/class_data_instanceMaster.dart';
import 'package:planb/db/entity/class_master.dart';
import 'package:planb/db/entity/data_instances_master.dart';
import 'package:planb/graph/shim_drop_down.dart';

import '../redux_state_store/appStore.dart';
import 'dropwdown.dart';

class GraphDialog extends StatefulWidget {
  const GraphDialog(
      {Key? key,
      required this.selectedIndex,
      required this.openCallback,
      required this.hourlyDataInstance,
      required this.classMaster})
      : super(key: key);

  //balaji : 1/16/2023 - adding the param selectedIndex, <- ft from confluence
  final int selectedIndex;
  final ClassMaster classMaster;
  final Function(bool, List<ClassDataInstanceMaterDuplicate>, int selectedIndex)
      openCallback;
  final List<ClassDataInstanceMaterDuplicate> hourlyDataInstance;
  @override
  graphDialogPage createState() {
    return graphDialogPage();
  }
}

class graphDialogPage extends State<GraphDialog> {
  List<String> viewCategory = ["working", "to-do", "done"];
  int selectedViewCategoryID = 0;
  late ClassDataInstanceMaterDuplicate selectedDataInstance;
  late int userStoreID;
  var currentViewDataInstance;
  var currentViewDataInstanceIndex = 0;
  ColorStore colorStore = ColorStore();

  changeView(int _currentViewDataInstanceIndex) {
    if (_currentViewDataInstanceIndex >= 0 &&
        _currentViewDataInstanceIndex < widget.hourlyDataInstance.length) {
      setState(() {
        currentViewDataInstanceIndex = _currentViewDataInstanceIndex;
        currentViewDataInstance =
            widget.hourlyDataInstance.elementAt(_currentViewDataInstanceIndex);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // currentViewDataInstance = widget.hourlyDataInstance.elementAt(0);

    //balaji : 1/16/2023 - adding the param selectedIndex, <- ft from confluence
    currentViewDataInstanceIndex = widget.selectedIndex;
    currentViewDataInstance =
        widget.hourlyDataInstance.elementAt(currentViewDataInstanceIndex);
  }

  @override
  void didUpdateWidget(covariant GraphDialog oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  //balaji: 2/18/2023 adaptable pg dev-bug 3
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppStore, bool>(
        converter: (store) => store.state.darkMode,
        builder: (context, darkMode) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87),
                  color: darkMode ? Colors.grey[900] : Colors.white,
                  // color: colorStore.getColorByID(currentViewDataInstance.itemClassColorID),
                  borderRadius: BorderRadius.circular(0)),
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? (MediaQuery.of(context).size.height * 0.7)
                  : (MediaQuery.of(context).size.height * 0.6) * 0.9,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CloseButton(
                        onPressed: () {
                          //print(openDialog);
                          widget.openCallback(
                              false, widget.hourlyDataInstance, 0);
                        },
                        color: darkMode ? Colors.white : Colors.black,
                      )
                    ],
                  ),
                  SizedBox(
                    //height:(MediaQuery.of(context).size.height*0.7)*0.8,
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? (MediaQuery.of(context).size.height * 0.7) * 0.8
                        : (MediaQuery.of(context).size.height * 0.3) * 0.9,
                    child:

                        //  ListView(
                        //   scrollDirection: Axis.horizontal,
                        //   children: widget.hourlyDataInstance.map((e) {
                        //     var classDataInstanceMaterDuplicateClone = e;
                        //     return
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 70,
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'comments',
                                        style: TextStyle(
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "status",
                                            style: TextStyle(
                                                color: darkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                            
                                          ShimDropDown(
                                            classDataInstanceMaterDuplicate:
                                                currentViewDataInstance,
                                            callBack: (selected) {
                                              updateStatusToUI(selected);
                                              // setState(() {
                                              //   selectedDataInstance =
                                              //       classDataInstanceMaterDuplicateClone;
                                              //   selectedViewCategoryID =
                                              //       viewCategory.indexOf(selected!) + 1;
                                              //   updateCommentStatus(
                                              //           classDataInstanceMaterDuplicateClone)
                                              //       .then((value) {
                                              //     classDataInstanceMaterDuplicateClone =
                                              //         value;
                                              //   });
                                              // });
                                            },
                                            dropdownTitle:
                                                viewCategory.elementAt(
                                                    currentViewDataInstance
                                                            .instancesStatus -
                                                        1),
                                            darkMode: darkMode,
                                            color: Colors.grey[900]!,
                                            viewCategory: viewCategory,
                                          )
                                        ],
                                      ),
                                      Text(
                                        currentViewDataInstance.itemName!,
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        currentViewDataInstance.description!,
                                        style: TextStyle(
                                          color: darkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              // color: colorStore
                                              //     .getColorByID(currentViewDataInstance.itemClassColorID),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: 16,
                                                    child: CircleAvatar(
                                                      radius: 15,
                                                      backgroundImage: NetworkImage(
                                                          currentViewDataInstance
                                                              .userStore
                                                              .photoURL),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    currentViewDataInstance
                                                        .userStore.userName,
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: darkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                currentViewDataInstance
                                                    .dataInstances,
                                                style: TextStyle(
                                                  color: darkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    currentViewDataInstance
                                                        .instancesTime)
                                                .toString()
                                                .substring(0, 16),
                                            style: TextStyle(
                                              color: darkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                            //     );
                            //   }).toList(),
                            // ),
                            ),
                  ),
                  Row(
                    children: [
                      const Spacer(
                        flex: 2,
                      ),
                      if (currentViewDataInstanceIndex != 0)
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            size: 28,
                            color: darkMode ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            int index = currentViewDataInstanceIndex - 1;
                            changeView(index);
                          },
                        ),
                      const Spacer(
                        flex: 3,
                      ),
                      if (currentViewDataInstanceIndex !=
                          widget.hourlyDataInstance.length - 1)
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 28,
                            color: darkMode ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            int index = currentViewDataInstanceIndex + 1;
                            changeView(index);
                          },
                        ),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<ClassDataInstanceMaterDuplicate> updateCommentStatus(
      ClassDataInstanceMaterDuplicate classDataInstanceMaterDuplicate) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final dataInstanceMasterDao = database.dataInstanceMasterDao;

    var state = StoreProvider.of<AppStore>(context);
    userStoreID = state.state.selectedIndex;

    DataInstancesMaster dataInstancesMaster = DataInstancesMaster(
        userStore: selectedDataInstance.userStore,
        dataInstanceID: selectedDataInstance.dataInstanceID,
        itemMasterID: selectedDataInstance.itemMasterID,
        dataInstances: selectedDataInstance.dataInstances,
        instancesStatus: selectedViewCategoryID,
        instancesTime: selectedDataInstance.instancesTime);

    ClassDataInstanceMaterDuplicate classDataInstanceMaterDuplicateClone =
        ClassDataInstanceMaterDuplicate(
      userStore: selectedDataInstance.userStore,
      dataInstanceID: selectedDataInstance.dataInstanceID,
      itemMasterID: selectedDataInstance.itemMasterID,
      dataInstances: selectedDataInstance.dataInstances,
      instancesStatus: selectedViewCategoryID,
      instancesTime: selectedDataInstance.instancesTime,
      itemClassColorID: classDataInstanceMaterDuplicate.itemClassColorID,
    );
    //postDataInstanceMaster(dataInstancesMaster);
    await dataInstanceMasterDao
        .updateDataInstanceByEntity(dataInstancesMaster)
        .then((value) {
      return classDataInstanceMaterDuplicateClone;
    }).onError((error, stackTrace) {
      selectedViewCategoryID = 0;
      print(error);
      ClassDataInstanceMaterDuplicate classDataInstanceMaterDuplicateClone =
          ClassDataInstanceMaterDuplicate(
              userStore: selectedDataInstance.userStore,
              dataInstanceID: selectedDataInstance.dataInstanceID,
              itemMasterID: selectedDataInstance.itemMasterID,
              dataInstances: selectedDataInstance.dataInstances,
              instancesStatus: selectedDataInstance.instancesStatus,
              instancesTime: selectedDataInstance.instancesTime,
              itemClassColorID:
                  classDataInstanceMaterDuplicate.itemClassColorID);
      return classDataInstanceMaterDuplicateClone;
    });

    return classDataInstanceMaterDuplicateClone;
  }

  updateStatusToUI(int status) {
    var localCurrentViewDataInstance =
        widget.hourlyDataInstance.elementAt(currentViewDataInstanceIndex);
    ClassDataInstanceMaterDuplicate temp = ClassDataInstanceMaterDuplicate(
        itemMasterID: localCurrentViewDataInstance.itemMasterID,
        dataInstances: localCurrentViewDataInstance.dataInstances,
         //Balaji: 02/07/2023: done and working task will get current time update.
      instancesTime:status + 1!=2? DateTime.now().millisecondsSinceEpoch: localCurrentViewDataInstance.instancesTime,
        itemClassColorID: localCurrentViewDataInstance.itemClassColorID,
        dataInstanceID: localCurrentViewDataInstance.dataInstanceID,
        itemName: localCurrentViewDataInstance.itemName,
        description: localCurrentViewDataInstance.description,
        instancesStatus: status,
        userStore: localCurrentViewDataInstance.userStore);

    widget.hourlyDataInstance.replaceRange(
        currentViewDataInstanceIndex, currentViewDataInstanceIndex + 1, [temp]);
  }
}
