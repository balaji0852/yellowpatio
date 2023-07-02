import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:planb/cloud/dataInstanceMasterCloud.dart';
import 'package:planb/graph/dropwdown.dart';

import '../db/database.dart';
import '../db/entity/class_data_instanceMaster.dart';
import '../db/entity/data_instances_master.dart';
import '../redux_state_store/appStore.dart';

class ShimDropDown extends StatefulWidget {
  final List<String> viewCategory;
  final Function(int)? callBack;
  final String dropdownTitle;
  final ClassDataInstanceMaterDuplicate classDataInstanceMaterDuplicate;
  final bool darkMode;
  final Color color;

  const ShimDropDown(
      {Key? key,
      required this.viewCategory,
      this.callBack,
      required this.dropdownTitle,
      required this.classDataInstanceMaterDuplicate,
      required this.darkMode,
      required this.color})
      : super(key: key);

  @override
  ShimDropDownWidget createState() => ShimDropDownWidget();
}

class ShimDropDownWidget extends State<ShimDropDown> {
  String shimDropDownTitle = "loading";
  List<String> viewCategory = ["working", "to-do", "done"];
  late int userStoreID;

  @override
  void initState() {
    super.initState();
    shimDropDownTitle = widget.dropdownTitle;
  }

  @override
  void didUpdateWidget(covariant ShimDropDown oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    shimDropDownTitle = widget.dropdownTitle;
  }

  @override
  Widget build(BuildContext context) {
    return DropDown(
        color: widget.color,
        darkMode: widget.darkMode,
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
      userStore: widget.classDataInstanceMaterDuplicate.userStore,
      dataInstanceID: widget.classDataInstanceMaterDuplicate.dataInstanceID,
      itemMasterID: widget.classDataInstanceMaterDuplicate.itemMasterID,
      dataInstances: widget.classDataInstanceMaterDuplicate.dataInstances,
      instancesStatus: viewCategory.indexOf(selectedCategory!) + 1,
      //Balaji: 02/07/2023: done and working task will get current time update.
      instancesTime:viewCategory.indexOf(selectedCategory) + 1!=2? DateTime.now().millisecondsSinceEpoch:widget.classDataInstanceMaterDuplicate.instancesTime,
    );

    await DataInstanceMasterCloud()
        .putDataInstanceMaster(dataInstancesMaster)
        .then((value) {
      if (value == 200 && mounted) {
        //22/03/2023 : balaji -  bug 24, using exisitng callback to update the parent with status change
        widget.callBack!(viewCategory.indexOf(selectedCategory) + 1);
        setState(() {
          shimDropDownTitle = selectedCategory;
        });
        print("inserted");
      }
    }).onError((error, stackTrace) {
      if (mounted) {
        setState(() {
          shimDropDownTitle = shimDropDownTitle;
        });
      }
    });
  }
}
