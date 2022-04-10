import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:yellowpatioapp/Pages/color_store.dart';
import 'package:yellowpatioapp/Pages/comment_section_page.dart';
import 'package:yellowpatioapp/Pages/insights_page.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key, required this.changePage}) : super(key: key);

  final void Function(int, ClassMaster, bool) changePage;

  HomePageActivity createState() => HomePageActivity();
}

class HomePageActivity extends State<homePage> {
  // HomePageActivity({Key? key,this.changePage});

  // final void Function(int,ClassMaster)? changePage;

  static const text = "your tasks";
  late List<ClassMaster> data = [];
  ColorStore colorStore = ColorStore();

  //singleTon
  static late var database;
  static late var classMaster;

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

  Future getNotes() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    print(
        "***************************************************************************");
    List<ClassMaster> dataCopy = await database.classMasterDao.findAllItems();
    setState(() {
      data = dataCopy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            //container is not sLiver, so use sliverToBoxAdapter..
            SliverToBoxAdapter(
              child: Container(
                height: 500,
                //placeholder for map component...
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0)),
            data.isNotEmpty
                ? SliverGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1,
                    children: data
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 7),
                            decoration: BoxDecoration(
                                color:
                                    colorStore.getColorByID(e.itemClassColorID),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //adding text inside expanded makes the text to spread out, otherwise it will overflow
                                    Expanded(
                                      child: Text(
                                        e.itemName,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 28,
                                      child: PopupMenuButton(
                                        icon: const Icon(Icons.more_vert),
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          PopupMenuItem(
                                            child: ListTile(
                                              title: Text('edit'),
                                              onTap: () {
                                                widget.changePage(1, e, true);
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                              child: ListTile(
                                            title: const Text('delete'),
                                            onTap: () {
                                              deleteClass(e);
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
                                        fontSize: 13,
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
                                          e.itemMasterID.toString() +
                                              " " +
                                              e.description +
                                              e.categoryID.toString() +
                                              e.subCategoryID.toString(),
                                          maxLines: 2,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )
                : SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text('loading'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  commentButton(ClassMaster classMaster) {
    Navigator.pop(context);
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

    setState(() {
      data.remove(classMasterItem);
    });

    await classMaster.deleteItemById(classMasterItem).then((value) {
      print("delete successfully");
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
