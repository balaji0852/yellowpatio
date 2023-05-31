import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/Pages/color_store.dart';
import 'package:yellowpatioapp/Pages/comment_section_page.dart';
import 'package:yellowpatioapp/Pages/insights_page.dart';
import 'package:yellowpatioapp/cloud/classMasterCloud.dart';
import 'package:yellowpatioapp/cloud/dataInstanceMasterCloud.dart';
import 'package:yellowpatioapp/cloud/directoryController.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/VO/DataInstanceMasterVO.dart';
import 'package:yellowpatioapp/db/entity/class_data_instanceMaster.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/db/entity/data_instances_master.dart';
import 'package:yellowpatioapp/db/entity/pinnedClass.dart';
import 'package:yellowpatioapp/db/entity/user_store.dart';
import 'package:yellowpatioapp/db/repository/data_instance_master_dao.dart';
import 'package:yellowpatioapp/graph/planner_graph.dart';
import 'package:yellowpatioapp/migation/migrations.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';

import '../SupportSystem/syncher.dart';
import '../redux_state_store/appStore.dart';

//1/21/2023 : add services object for ReSyncher
//1/25/2023 : adding mixin WidgetsBindingObserver and its observers,object, for ReSyncher use.
class homePage extends StatefulWidget {
  const homePage({Key? key, required this.changePage}) : super(key: key);

  //Balaji : 26/03/2023 - removing bottomNavigationBar, this method is abandoned for
  //                        bugs-4 and ui enhancement,
  final void Function(int, ClassMaster, bool) changePage;

  HomePageActivity createState() => HomePageActivity();
}

class HomePageActivity extends State<homePage> with WidgetsBindingObserver {
  // HomePageActivity({Key? key,this.changePage});

  // final void Function(int,ClassMaster)? changePage;
  final GlobalKey<PlannerGraphPage> plannerGraphKey = GlobalKey();
  ScrollController mainWidgetScrollController = ScrollController();
  var lastCommentsMap = {};

  static const text = "your tasks";
  late List<DataInstanceMasterVO> data = [];
  ColorStore colorStore = ColorStore();
  //singleTon
  static late var database;
  static late var classMaster;
  static late var dataInstanceMaster;
  //11/28/2022 : balaji , using local variable to set darkMode
  bool darkMode = false;
  var state;
  var services = ReSyncher(interval: 20);
  AppLifecycleState? _notification;
  int reKey = 0;

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

    //getNotes();
  }

  @override
  void didUpdateWidget(covariant homePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    services.isUIMounted = false;
    services = ReSyncher(interval: 20);
    getNotes();
    services.serverConnector(() => getNotes(), mounted);
    print("oop");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getNotes();
    services.serverConnector(() => getNotes(), mounted);

    // getNotes();
  }

  @override
  void dispose() {
    super.dispose();

    services.isUIMounted = false;
  }

  Future getNotes() async {
    //cloud migration
    //database =
    //await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    print(
        "***************************************************************************");
    var state = StoreProvider.of<AppStore>(context);
    int projectStoreID = state.state.projectStoreID;
    int userStoreID = state.state.userStoreID;
    //cloud migration
    //List<ClassMaster> dataCopy = await database.classMasterDao.findItemById(projectStoreID);
    List<DataInstanceMasterVO> dataCopy = await ClassMasterCloud()
        .getAllByProjectStoreID(projectStoreID, userStoreID);
    //dataInstanceMaster = database.dataInstanceMasterDao;
    // dataCopy.forEach((classMaster) async {
    //   lastCommentsMap.putIfAbsent(classMaster.itemMasterID, () => 'loading...');
    //   // Future.delayed(Duration(microseconds: 10000000),
    //   //     (() async =>
    //   await findLastComment(classMaster.itemMasterID!);
    //   // ));
    // });
    // TODO done- FOR MIGRATION
    //List<DataInstancesMaster> datas = await database.dataInstanceMasterDao.findAllDataInstance();
    //datas.forEach((DataInstancesMaster) async{
    //postDataInstanceMaster(DataInstancesMaster);
    //});
    //for migration
    if (mounted) {
      setState(() {
        data = dataCopy;
      });
    }
  }

  handleService(event) {
    print("***************hp*************");
    if (FGBGType.background == event) {
      print("***************hp-background*************");
      services.isUIMounted = false;
    } else if (FGBGType.foreground == event) {
      print("***************hp-foreground*************");
    }
  }

  Future<void> findLastComment(int itemMasterID) async {
    lastCommentsMap.putIfAbsent(itemMasterID, () => 'loading...');

    //cloud migration
    DataInstancesMaster? lastComment = await DataInstanceMasterCloud()
        .findDataInstanceByLastComment(itemMasterID);
    //var lastCommentForTheClass = lastComment.elementAt(0);
    if (mounted) {
      setState(() {
        if (null != lastComment) {
          lastCommentsMap.update(
              itemMasterID, (value) => lastComment.dataInstances);
        } else {
          lastCommentsMap.update(
              itemMasterID, (value) => 'no comments, yet...');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    state = StoreProvider.of<AppStore>(context);
    darkMode = state.state.darkMode;

    reKey++;

    return FGBGNotifier(
      onEvent: (event) {
        handleService(event);
      },
      child: StoreConnector<AppStore, bool>(
        converter: (store) => store.state.darkMode,
        builder: (context, _darkMode) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Scaffold(
              backgroundColor: _darkMode ? Colors.black : Colors.white,
              body: CustomScrollView(
                controller: mainWidgetScrollController,
                slivers: [
                  //container is not sLiver, so use sliverToBoxAdapter..
                  SliverToBoxAdapter(
                      child: PlannerGraph(
                          reKey: reKey,
                          MainWidgetScrollView: mainWidgetScrollController,
                          key: plannerGraphKey,
                          classMaster: ClassMaster(
                              itemName: "dummy",
                              categoryID: 1,
                              createdDate: 1,
                              userStore: UserStore(
                                  linkedEmail: "dummy",
                                  userName: "dummy",
                                  linkedPhone: "dummy",
                                  photoURL: "dummy"),
                              subCategoryID: 2,
                              itemClassColorID: 1,
                              itemPriority: 1,
                              isItemCommentable: 1,
                              carryForwardMyWork: false,
                              description: "dummy",
                              //TODO : 696969696969696969696 adding dummy prjid
                              projectStoreID: 1),
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
                                return Stack(children: [
                                  SizedBox(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 7),
                                      decoration: BoxDecoration(
                                          color: colorStore.getColorByID(
                                              e.classMaster.itemClassColorID),
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
                                                  e.classMaster.itemName,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 28,
                                                child: PopupMenuButton(
                                                  color: _darkMode
                                                      ? Colors.grey[900]
                                                      : Colors.white,
                                                  icon: const Icon(
                                                      Icons.more_vert),
                                                  itemBuilder:
                                                      (BuildContext context) =>
                                                          <PopupMenuEntry>[
                                                    PopupMenuItem(
                                                      child: ListTile(
                                                        title: Text(
                                                          'edit',
                                                          style: TextStyle(
                                                              color: _darkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => InsightsPage(
                                                                      classMaster: e
                                                                          .classMaster,
                                                                      editable:
                                                                          true)));
                                                        },
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      child: ListTile(
                                                        title: Text(
                                                          e.pinnedForCurrentUser
                                                              ? 'unpin'
                                                              : 'pin',
                                                          style: TextStyle(
                                                              color: _darkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                        onTap: () {
                                                          handlePin(e,
                                                              !e.pinnedForCurrentUser);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                        child: ListTile(
                                                      title: Text('delete',
                                                          style: TextStyle(
                                                              color: _darkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black)),
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
                                          Text(e.classMaster.description,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold),
                                              softWrap: false,
                                              maxLines: 3,
                                              overflow:
                                                  TextOverflow.ellipsis // new
                                              ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(1),
                                              child: GestureDetector(
                                                onTap: () {
                                                  commentButton(e.classMaster);
                                                  services.isUIMounted = false;
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: _darkMode
                                                          ? Colors.grey[850]
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: Text(
                                                    e.classDataInstanceMaterDuplicate
                                                        .dataInstances,
                                                    maxLines: 6,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 10,
                                                        color: _darkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (e.classDataInstanceMaterDuplicate
                                      .userStore.photoURL!="empty")
                                    Positioned(
                                        bottom: 0,
                                        right: 0.5,
                                        child: CircleAvatar(
                                          radius: 10.5,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 9,
                                            backgroundImage: NetworkImage(e
                                                .classDataInstanceMaterDuplicate
                                                .userStore
                                                .photoURL),
                                            backgroundColor: Colors.green,
                                          ),
                                        )),
                                ]);
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
                              Text(
                                "post you're task and work efficiently...",
                                style: TextStyle(
                                    fontSize: 20,
                                    color:
                                        darkMode ? Colors.white : Colors.black),
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
      ),
    );
  }

  commentButton(ClassMaster classMaster) {
    // Navigator.pop(context);

    state.dispatch(ChangeShowDialogState(false));

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CommentSectionPage(
                classMaster: classMaster,
              )),
    );
  }

  handlePin(DataInstanceMasterVO dataInstanceMasterVO, bool isPinned) async {
    var state = StoreProvider.of<AppStore>(context);
    int userStoreID = state.state.userStoreID;
    pinnedClass pin = pinnedClass(
        isPinned: isPinned,
        folderID: 2,
        userStoreID: userStoreID,
        classMaster: dataInstanceMasterVO.classMaster,
        pinID: 999);
    if (await directoryController().putPinClassMaster(pin) == 200) {
      getNotes();
    }
  }

  void deleteClass(DataInstanceMasterVO dataInstanceMasterVO) async {
    //need validations

    //cloud migration
    // final database =
    //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // final classMaster = database.classMasterDao;

    await ClassMasterCloud()
        .deleteItemById(dataInstanceMasterVO.classMaster.itemMasterID!)
        .then((value) {
      setState(() {
        data.remove(dataInstanceMasterVO);
        reKey++;
      });
      print("delete successfully");
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
