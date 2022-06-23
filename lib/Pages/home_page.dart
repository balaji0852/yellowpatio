import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/Pages/color_store.dart';
import 'package:yellowpatioapp/Pages/comment_section_page.dart';
import 'package:yellowpatioapp/Pages/insights_page.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/class_data_instanceMaster.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/db/repository/data_instance_master_dao.dart';
import 'package:yellowpatioapp/graph/planner_graph.dart';
import 'package:yellowpatioapp/migation/migrations.dart';

import '../redux_state_store/appStore.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key, required this.changePage}) : super(key: key);

  final void Function(int, ClassMaster, bool) changePage;

  HomePageActivity createState() => HomePageActivity();
}

class HomePageActivity extends State<homePage> {
  // HomePageActivity({Key? key,this.changePage});

  // final void Function(int,ClassMaster)? changePage;
  final GlobalKey<PlannerGraphPage> plannerGraphKey = GlobalKey();
  ScrollController mainWidgetScrollController = ScrollController();
  var lastCommentsMap = {};

  static const text = "your tasks";
  late List<ClassMaster> data = [];
  ColorStore colorStore = ColorStore();
  //singleTon
  static late var database;
  static late var classMaster;
  static late var dataInstanceMaster;

  getInstance() async {
    //singleton wrong implementation
    if (null == database) {
      print('getInstance : singleton');
      database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      classMaster = database.classMasterDao;
    }
  }

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  void didUpdateWidget(covariant homePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    print("oop");
  }



  Future getNotes() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    print(
        "***************************************************************************");
    List<ClassMaster> dataCopy = await database.classMasterDao.findAllItems();
    dataInstanceMaster = database.dataInstanceMasterDao;
    dataCopy.forEach((classMaster) async {
      lastCommentsMap.putIfAbsent(classMaster.itemMasterID, () => 'loading...');
      // Future.delayed(Duration(microseconds: 10000000),
      //     (() async =>
      await findLastComment(classMaster.itemMasterID!); 
     // ));
    });
    // TODO done- FOR MIGRATION
    //List<DataInstancesMaster> datas = await database.dataInstanceMasterDao.findAllDataInstance();
    //datas.forEach((DataInstancesMaster) async{
    //postDataInstanceMaster(DataInstancesMaster);
    //});
    //for migration

    setState(() {
      data = dataCopy;
    });
  }

  Future<void> findLastComment(int itemMasterID) async {
    lastCommentsMap.putIfAbsent(itemMasterID, () => 'loading...');
    DataInstancesMaster? lastComment =
        await dataInstanceMaster.findDataInstanceByLastComment(itemMasterID);
    //var lastCommentForTheClass = lastComment.elementAt(0);
    setState(() {
      if (null != lastComment) {
      lastCommentsMap.update(
          itemMasterID, (value) => lastComment.dataInstances);
    }else{
      lastCommentsMap.update(
          itemMasterID, (value) => 'no comments, yet...');
    }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppStore, int>(
      converter: (store) => store.state.dateViewPreference,
      builder: (context, userDateViewPreference) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              controller: mainWidgetScrollController,
              slivers: [
                //container is not sLiver, so use sliverToBoxAdapter..
                SliverToBoxAdapter(
                    child: PlannerGraph(
                        MainWidgetScrollView: mainWidgetScrollController,
                        key: plannerGraphKey,
                        classMaster: ClassMaster(
                          itemName: "dummy",
                          categoryID: 1,
                          subCategoryID: 2,
                          itemClassColorID: 1,
                          itemPriority: 1,
                          isItemCommentable: 1,
                          description: "dummy",
                        ),
                        graphType: 2)
                    // Container(
                    //   height: 500,
                    //   //placeholder for map component...
                    //   decoration: BoxDecoration(
                    //       color: Colors.blue,
                    //       borderRadius: BorderRadius.circular(10)),
                    // ),
                    ),

                data.isNotEmpty
                    ? SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        sliver: SliverGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 1,
                          children: data.map(
                            (e) {
                              // findLastComment(e.itemMasterID!);
                              // DataInstancesMaster comment = findLastComment(e.itemMasterID!);
                              return SizedBox(
                                child:Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 7),
                                decoration: BoxDecoration(
                                    color: colorStore
                                        .getColorByID(e.itemClassColorID),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25))),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //adding text inside expanded makes the text to spread out, otherwise it will overflow
                                        Expanded(
                                          child: Text(
                                            e.itemName,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 30,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 28,
                                          child: PopupMenuButton(
                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry>[
                                              PopupMenuItem(
                                                child: ListTile(
                                                  title: Text('edit'),
                                                  onTap: () {
                                                    widget.changePage(
                                                        1, e, true);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              PopupMenuItem(
                                                  child: ListTile(
                                                title: const Text('delete'),
                                                onTap: () {
                                                  deleteClass(e);
                                                  Navigator.pop(context);
                                                },
                                              )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(e.description,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                        softWrap: false,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis // new
                                        ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: GestureDetector(
                                          onTap: () {
                                            commentButton(e);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: const EdgeInsets.all(3),
                                            child: Text(
                                              lastCommentsMap[e.itemMasterID],
                                              maxLines: 6,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              );
                            },
                          ).toList(),
                        ))
                    : SliverToBoxAdapter(
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Image.asset(
                              "assets/women_working_on_task.jpg",
                              scale: 0.9,
                              width: 300,
                              height: 250,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "post you're task and work efficiently...",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ]),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  commentButton(ClassMaster classMaster) {
    // Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CommentSectionPage(
                classMaster: classMaster,
              )),
    );
  }

  void deleteClass(ClassMaster classMasterItem) async {
    //need validations
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final classMaster = database.classMasterDao;

    await classMaster.deleteItemById(classMasterItem).then((value) {
      setState(() {
        data.remove(classMasterItem);
        data = data;
      });
      print("delete successfully");
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
