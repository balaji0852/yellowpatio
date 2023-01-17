import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/Pages/color_store.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/class_data_instanceMaster.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/graph/shim_drop_down.dart';

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
  final Function(bool, List<ClassDataInstanceMaterDuplicate>,int selectedIndex) openCallback;
  final List<ClassDataInstanceMaterDuplicate> hourlyDataInstance;
  @override
  graphDialogPage createState() {
    return graphDialogPage();
  }
}

class graphDialogPage extends State<GraphDialog> {
  List<String> viewCategory = [ "working","to-do","done" ];
  int selectedViewCategoryID = 0;
  late ClassDataInstanceMaterDuplicate selectedDataInstance;
  late int userStoreID;
  var currentViewDataInstance;
  var currentViewDataInstanceIndex = 0 ;
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
    currentViewDataInstanceIndex =  widget.selectedIndex;
    currentViewDataInstance =
            widget.hourlyDataInstance.elementAt(currentViewDataInstanceIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black87),
            color: colorStore.getColorByID(currentViewDataInstance.itemClassColorID),
            borderRadius: BorderRadius.circular(0)),
        height: 575,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CloseButton(
                  onPressed: () {
                    //print(openDialog);
                    widget.openCallback(false, widget.hourlyDataInstance,0);
                  },
                )
              ],
            ),
            SizedBox(
              height: 450,
              child:

                  //  ListView(
                  //   scrollDirection: Axis.horizontal,
                  //   children: widget.hourlyDataInstance.map((e) {
                  //     var classDataInstanceMaterDuplicateClone = e;
                  //     return
                  Padding(
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text("status"),
                                    ShimDropDown(
                                      classDataInstanceMaterDuplicate: currentViewDataInstance,
                                      callBack: (selected) {
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
                                      dropdownTitle: viewCategory
                                          .elementAt(currentViewDataInstance.instancesStatus - 1),
                                      viewCategory: viewCategory,
                                    )
                                  ],
                                ),
                                Text(
                                  currentViewDataInstance.itemName!,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(currentViewDataInstance.description!),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: colorStore
                                          .getColorByID(currentViewDataInstance.itemClassColorID),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(currentViewDataInstance.dataInstances),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(DateTime.fromMillisecondsSinceEpoch(
                                            currentViewDataInstance.instancesTime)
                                        .toString()
                                        .substring(0, 16))
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
                const Spacer(flex: 2,),
                if(currentViewDataInstanceIndex!=0)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      size: 28, color: Colors.black),
                  onPressed: () {
                     int index = currentViewDataInstanceIndex-1;
                                        changeView(index);

                  },
                ),
              
                                Spacer(flex: 3,),
if(currentViewDataInstanceIndex!=widget.hourlyDataInstance.length-1)
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios,
                      size: 28, color: Colors.black),
                  onPressed: () {
                    int index = currentViewDataInstanceIndex+1;
                                        changeView(index);

                  },
                ),                const Spacer(flex: 2,),

              ],
            )
          ],
        ),
      ),
    );
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
}
