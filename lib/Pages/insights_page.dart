// ignore_for_file: unnecessary_import

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:planb/Pages/category_store.dart';
import 'package:planb/Pages/color_store.dart';
import 'package:planb/cloud/classMasterCloud.dart';
import 'package:planb/db/database.dart';
import 'package:planb/db/entity/class_master.dart';
import 'package:planb/db/entity/user_store.dart';
import 'package:planb/home.dart';

import '../redux_state_store/appStore.dart';

class InsightsPage extends StatefulWidget {
  //theres no optional keyword, use nullable variable..
  //primitive(bool) value defaults to null...
  //constructor , if needs to be const then all objects should be final...
  //single quote string and double quote string are making difference...
  InsightsPage(
      {Key? key, this.classMaster, required this.editable, this.changePage})
      : super(key: key);

  final void Function(int, ClassMaster, bool)? changePage;

  final ClassMaster? classMaster;

  bool editable;

  @override
  Insights createState() => Insights();
}

//use 'widget' to use parent data
//adding a copy contructor
class Insights extends State<InsightsPage> {
  static const text = "insight";
  TextEditingController labelName = TextEditingController();
  late ClassMaster classMaster;
  GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');
  bool editables = false;
  //sig 30: added for topology
  bool callingServer = false;
  ColorStore colorStore = ColorStore();

  // Insights(){

  //   //classMaster = widget.classMaster!;
  // }

  // ignore: non_constant_identifier_names
  List<ColorPicker> colorsList = [
    ColorPicker(color: Colors.red, colorName: 'red'),
    ColorPicker(color: Colors.purple, colorName: 'purple'),
    ColorPicker(color: Colors.yellow, colorName: 'yellow'),
    ColorPicker(color: Colors.blue, colorName: 'blue'),
    ColorPicker(color: Colors.green, colorName: 'green'),
    ColorPicker(color: Colors.lime, colorName: 'lime'),
    ColorPicker(color: Colors.blueAccent, colorName: 'blueAccent'),
    ColorPicker(color: Colors.yellowAccent, colorName: 'yellowAccent'),
    ColorPicker(color: Colors.pink, colorName: 'pink'),
    ColorPicker(color: Colors.deepPurple, colorName: 'deepPurple')
  ];
  String selectedColor = 'red';
  String selectedSubCategory = 'default', selectedCategory = 'default';
  String? classTitle, descriptionString;
  TextEditingController classTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoryStore categorystore = CategoryStore();
  String updateButtonName = "add space";
  //11/28/2022 : balaji , using local variable to set darkMode
  bool darkMode = false;
  var state;
  bool isCFMW = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('#############');
    print(widget.editable);
    setPageForEditing();
  }

  Container androidDropdown(
      List<String> items, Function(String?)? callBack, String dropdownTitle) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String item in items) {
      var newItem = DropdownMenuItem(
        key: UniqueKey(),
        child: Text(item, style: const TextStyle(fontSize: 15)),
        value: item,
      );
      dropdownItems.add(newItem);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: DropdownButton<String>(
        hint: Text(
          dropdownTitle,
          style: const TextStyle(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500),
        ),
        items: dropdownItems,
        borderRadius: BorderRadius.circular(25),
        onChanged: callBack,
      ),
    );
  }

  ListView colorPicker(bool mode) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: colorsList
          .map(
            (ele) => Padding(
              child: ChoiceChip(
                onSelected: (bool selected) {
                  setState(() {
                    selectedColor = ele.colorName;
                    // colorStore.setColorStore = selectedColor;
                  });
                },
                label: const Text(
                  "eeee",
                  style: TextStyle(color: Colors.transparent),
                ),
                shape: ele.colorName == selectedColor
                    ? StadiumBorder(
                        side: BorderSide(width: 3, color:mode?Colors.white: Colors.black))
                    : const StadiumBorder(),
                backgroundColor: ele.color,
                selected: false,
              ),
              padding: const EdgeInsets.all(5),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppStore, bool>(
        converter: (store) => store.state.darkMode,
        builder: (context, _darkMode) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: _darkMode ? Colors.black : Colors.white,
              leading: BackButton(
                color: _darkMode ? Colors.white : Colors.black,
                onPressed: (() {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                }),
              ),
              title: Text(
                'new space',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: _darkMode ? Colors.white : Colors.black),
              ),
            ),
            backgroundColor: _darkMode ? Colors.black : Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //Balaji: No crossAxisAlignment required for the first container, since containers
                  //fills themselves to fill the parent width...
                  //height is the key : if height is present container fills to body parent width..
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                     Container(
                      height: 55,
                      decoration: BoxDecoration(
                          color: _darkMode ? Colors.grey[900] : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1,
                              color: _darkMode ? Colors.white : Colors.black)),
                      child: TextField(
                        controller: classTitleController,
                        maxLength: 15,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                            counterText: ' ',
                            hintText: "space title",
                            hintStyle: TextStyle(
                                color: _darkMode ? Colors.white : Colors.black),
                            contentPadding:
                                const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            border: InputBorder.none),
                        style: TextStyle(
                            fontSize: 22,
                            color: _darkMode ? Colors.white : Colors.black),
                      ),
                    ),
                    
                    const SizedBox(
                      height: 10,
                    ),
                    // androidDropdown(categorystore.getCategoryList, (value) {
                    //   setState(() {
                    //     selectedCategory = value!;
                    //     categorystore.setSubCategoryList = selectedCategory;
                    //     selectedSubCategory =
                    //         categorystore.getSubCategoryList.elementAt(0);
                    //   });
                    // }, selectedCategory),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // androidDropdown(categorystore.getSubCategoryList, (value) {
                    //   setState(() {
                    //     selectedSubCategory = value!;
                    //   });
                    // }, selectedSubCategory),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    SizedBox(
                      height: 50,
                      child: colorPicker(_darkMode),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        FlutterSwitch(
                            padding: 3,
                            width: 55,
                            height: 27,
                            showOnOff: true,
                            valueFontSize: 9,
                            activeColor:
                                colorStore.getColorByName(selectedColor),
                            value: isCFMW,
                            onToggle: (cfmw_Value) => {
                                  setState(() {
                                    isCFMW = cfmw_Value;
                                  })
                                }),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            'Turning on CFMW (carry forward my work) will carry forward all the unfinished tasks to next day.',
                            style: TextStyle(
                                fontSize: 11,
                                color: _darkMode ? Colors.white : Colors.black),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color: _darkMode ? Colors.grey[900] : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: _darkMode ? Colors.white : Colors.black,
                              width: 1)),
                      child: TextField(
                          controller: descriptionController,
                          maxLength: 10000,
                          maxLines: 7,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                              counterText: ' ',
                              fillColor: Colors.green,
                              hintStyle: TextStyle(
                                  color:
                                      _darkMode ? Colors.white : Colors.black),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(4, 10, 0, 0),
                              hintText: "description",
                              border: InputBorder.none),
                          style: TextStyle(
                              fontSize: 14,
                              color: _darkMode ? Colors.white : Colors.black)),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (classTitleController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty &&
                            !callingServer) {
                          //sep 25-2022, sig -30
                          callingServer = true;
                          if (widget.editable) {
                            updateDataToDatabase();
                          } else {
                            addDataToDb();
                          }
                        }
                      },
                      height: 45,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)),
                      color: Colors.lightBlueAccent,
                      child: Text(
                        updateButtonName,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    //balaji : sig-50 adding below line...
    // widget.changePage!(0, widget.classMaster!, false);
  }

  void addDataToDb() async {
    // cloud migration
    //need validations
    // final database =
    //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // final classMasterDao = database.classMasterDao;
    var state = StoreProvider.of<AppStore>(context);
    int projectStoreID = state.state.projectStoreID;
    int userStoreID = state.state.userStoreID;

    //cfmw should be dynamice, based on input
    ClassMaster classMasterItem = ClassMaster(
        itemName: classTitleController.text,
        categoryID: 0,
        subCategoryID: 0,
     //Balaji : 11/6/2023 : commenting down below lines for self chat development
     //   categoryID: categorystore.getCategoryList.indexOf(selectedCategory),
     //   subCategoryID:
           // categorystore.getSubCategoryList.indexOf(selectedSubCategory),
        itemClassColorID: colorsList
            .indexWhere((element) => element.colorName == selectedColor),
        itemPriority: 1,
        carryForwardMyWork: isCFMW,
        isItemCommentable: 1,
        createdDate: DateTime.now().millisecondsSinceEpoch,
        userStore: UserStore(
            userStoreID: userStoreID,
            linkedEmail: "dummy",
            linkedPhone: "dummy",
            userName: "dummy",
            photoURL: "dummy"),
        description: descriptionController.text,
        projectStoreID: projectStoreID);

    // ignore: avoid_print
    await ClassMasterCloud()
        .postClassMasterMaster(classMasterItem)
        .then((value) {
      if (value == 200) {
        //sig-30
        callingServer = !callingServer;
        print("inserted successfully");
        classTitleController.clear();
        descriptionController.clear();
        setState(() {
          selectedCategory = 'default';
          selectedSubCategory = 'default';
          selectedColor = 'red';
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        });
      }
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  //unused func, for removal...
  // getLabel() async {
  //   database =
  //       await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  //   labelMasterDao = database.labelMasterDao;

  //   // print(database.personDao.findAllPersons());

  //   print(
  //       "***************************************************************************");

  //   List<Label> data = await database.labelMasterDao.findAllLabel();

  //   setState(() {
  //     label = data;
  //   });
  // }

  // addLabel() async {
  //   var labelEntity = Label(labelName: labelName.text);
  //   await labelMasterDao.insertLabel(labelEntity).then((value) {
  //     print("inserted successfully");
  //     labelName.clear();
  //   });
  //   List<Label> data = await database.labelMasterDao.findAllLabel();
  //   setState(() {
  //     label = data;
  //   });
  // }

  setPageForEditing() {
    if (widget.editable) {
      updateButtonName = "update";
      classTitleController.text = widget.classMaster!.itemName;
      descriptionController.text = widget.classMaster!.description;
      selectedCategory = categorystore.getCategoryList
          .elementAt(widget.classMaster!.categoryID);
      isCFMW = widget.classMaster!.carryForwardMyWork;
      //need to add another getter, for handing the 2D array...
      //adjustments for now...
      categorystore.setSubCategoryList = selectedCategory;
      selectedSubCategory = categorystore.getSubCategoryList
          .elementAt(widget.classMaster!.subCategoryID);
      selectedColor =
          colorsList.elementAt(widget.classMaster!.itemClassColorID).colorName;
      print(selectedCategory + selectedSubCategory);
    }
  }

  updateDataToDatabase() async {
    // ignore: avoid_print
    //TODO : 696969696969696969696 adding dummy prjid
    var state = StoreProvider.of<AppStore>(context);
    int projectStoreID = state.state.projectStoreID;
    ClassMaster classMasterItem = ClassMaster(
        itemMasterID: widget.classMaster!.itemMasterID,
        itemName: classTitleController.text,
        carryForwardMyWork: isCFMW,
        categoryID: categorystore.getCategoryList.indexOf(selectedCategory),
        subCategoryID:
            categorystore.getSubCategoryList.indexOf(selectedSubCategory),
        itemClassColorID: colorsList
            .indexWhere((element) => element.colorName == selectedColor),
        itemPriority: 1,
        createdDate: widget.classMaster!.createdDate,
        userStore: widget.classMaster!.userStore,
        isItemCommentable: 1,
        description: descriptionController.text,
        projectStoreID: projectStoreID);

    print("-" + classMasterItem.categoryID.toString());
    print("-" +
        categorystore.getCategoryList.indexOf(selectedCategory).toString());
    print("-" + classMasterItem.subCategoryID.toString());
    print("-" +
        categorystore.getSubCategoryList
            .indexOf(selectedSubCategory)
            .toString());

    //cloud migration
    // final database =
    //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // final classMasterDao = database.classMasterDao;
    await ClassMasterCloud()
        .putClassMasterMaster(classMasterItem)
        .then((value) {
      if (value == 200) {
        print(classMasterItem.itemMasterID);
        print("inserted successfully1");
        classTitleController.clear();
        descriptionController.clear();
        //sig-30
        callingServer = !callingServer;

        setState(() {
          selectedCategory = 'default';
          categorystore.setSubCategoryList = selectedCategory;
          selectedSubCategory = 'default';
          selectedColor = 'red';
          updateButtonName = 'add';
          //Balaji : 26/03/2023 - removing bottomNavigationBar, this method is abandoned for
          //                        bugs-4 and ui enhancement
          //                        widget.changePage!(0, widget.classMaster!, false);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        });
      }
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}

class ColorPicker {
  final String colorName;

  final Color color;

  ColorPicker({required this.colorName, required this.color});
}
