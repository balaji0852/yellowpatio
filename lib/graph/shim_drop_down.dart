import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/cloud/dataInstanceMasterCloud.dart';
import 'package:yellowpatioapp/graph/dropwdown.dart';

import '../db/database.dart';
import '../db/entity/class_data_instanceMaster.dart';
import '../db/entity/data_instances_master.dart';
import '../redux_state_store/appStore.dart';

class ShimDropDown extends StatefulWidget {
  final List<String> viewCategory;
  final Function(String?)? callBack;
  final String dropdownTitle;
  final ClassDataInstanceMaterDuplicate classDataInstanceMaterDuplicate;

  const ShimDropDown(
      {Key? key,
      required this.viewCategory,
      this.callBack,
      required this.dropdownTitle,
      required this.classDataInstanceMaterDuplicate})
      : super(key: key);

  @override
  ShimDropDownWidget createState() => ShimDropDownWidget();
}

class ShimDropDownWidget extends State<ShimDropDown> {
  String shimDropDownTitle = "loading";
  List<String> viewCategory = ["done", "to-do", "working"];
  late int userStoreID;

  @override
  void initState() {
    super.initState();
    shimDropDownTitle = widget.dropdownTitle;
  }

  @override
  Widget build(BuildContext context) {
    return DropDown(
        darkMode: false,
        callBack: updateCommentStatus,
        dropdownTitle: shimDropDownTitle,
        viewCategory: widget.viewCategory);
  }

  updateCommentStatus(String? selectedCategory) async {
    //cloud migration
    // final database =
    //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // final dataInstanceMasterDao = database.dataInstanceMasterDao;
    var state = StoreProvider.of<AppStore>(context);
    userStoreID = state.state.selectedIndex;
    print(selectedCategory);
    DataInstancesMaster dataInstancesMaster = DataInstancesMaster(
      dataInstanceID: widget.classDataInstanceMaterDuplicate.dataInstanceID,
      itemMasterID: widget.classDataInstanceMaterDuplicate.itemMasterID,
      dataInstances: widget.classDataInstanceMaterDuplicate.dataInstances,
      instancesStatus: viewCategory.indexOf(selectedCategory!) + 1,
      instancesTime: widget.classDataInstanceMaterDuplicate.instancesTime,
    );

    await DataInstanceMasterCloud()
        .putDataInstanceMaster(dataInstancesMaster)
        .then((value) {
      if (value == 200) {
        setState(() {
          shimDropDownTitle = selectedCategory;
        });
        print("inserted");
      }
    }).onError((error, stackTrace) {
      setState(() {
        shimDropDownTitle = widget.dropdownTitle;
      });
    });
  }
}
