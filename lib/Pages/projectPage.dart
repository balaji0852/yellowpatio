
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/Pages/AllProjectPage.dart';
import 'package:yellowpatioapp/cloud/projectStoreCloud.dart';
import 'package:yellowpatioapp/cloud/service_plan_store_cloud.dart';
import 'package:yellowpatioapp/db/entity/RegionStore.dart';
import 'package:yellowpatioapp/db/entity/ServicePlanStore.dart';
import 'package:yellowpatioapp/db/entity/project_store.dart';
import 'package:yellowpatioapp/db/repository/project_store_dao.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';
import 'package:yellowpatioapp/redux_state_store/appStore.dart';

import '../db/database.dart';
import '../home.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  ProjectPageState createState() => ProjectPageState();
}

class ProjectPageState extends State<ProjectPage> {
  bool loaded = true;
  TextEditingController projectTitleEditorController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();

  //balaji : 11/25/2022 : adding the list servicePlans of type servicePlanStore
  List<ServicePlanStore> servicePlans =
      List<ServicePlanStore>.empty(growable: true);
  //balaji : 11/25/2022 : adding flag isCreateProjecte, bool var
  bool isCreateProject = false;
  //balaji : 11/25/2022 : adding two int var to store the plans and region
  int serviceID = 1;
  int regionID = 1;
  //balaji : adding universal ServicePlanStore, to avoid unwanted wheres below
  late ServicePlanStore servicePlanStore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getServicePlansToLocal();
  }

  //balaji : 11/25/2022 : adding this function to make the server call...
  getServicePlansToLocal() async {
    var temp = await ServicePlanStoreCloud().getServicePlans();
    setState(() {
      servicePlans = temp;
      //added
      servicePlanStore = servicePlans.first;
    });
  }

  Container androidDropdown(
      int dropDownCode, Function(String?)? callBack, String dropdownTitle) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    if (dropDownCode == 0) {
      for (var e in servicePlans) {
        {
          if (dropdownItems
              .where((element) =>
                  element.value == e.regionStore.regionID.toString())
              .isEmpty) {
            dropdownItems.add(DropdownMenuItem(
                key: UniqueKey(),
                child: Text(e.regionStore.regionName,
                    style: const TextStyle(fontSize: 13)),
                value: e.serviceID.toString()));
          }
        }
      }
    } else {
      servicePlans
          .where((element) => element.regionStore.regionID == regionID)
          .forEach((e) => {
                dropdownItems.add(DropdownMenuItem(
                    key: UniqueKey(),
                    child: Text(e.serviceName,
                        style: const TextStyle(fontSize: 13)),
                    value: e.serviceID.toString()))
              });
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: DropdownButton<String>(
        hint: Text(
          dropdownTitle,
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.normal),
        ),
        items: dropdownItems,
        borderRadius: BorderRadius.circular(5),
        onChanged: callBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            leading: BackButton(
              onPressed: (() {
                navigateProject();
              }),
              color: Colors.black,
            ),
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Project creation',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
          ),
          if (!isCreateProject)
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          isCreateProject = servicePlans.isEmpty ? false : true;
                        });
                      },
                      height: 45,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      color: Colors.blueAccent,
                      child: const Text(
                        'New project',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isCreateProject = true;
                          });
                        },
                        icon: const Icon(Icons.arrow_left_sharp))
                  ],
                ),
              ),
            ),
          if (isCreateProject)
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     IconButton(
                    //       onPressed: () {
                    //         navigateProject();
                    //       },
                    //       icon: const Icon(Icons.arrow_back),
                    //       iconSize: 45,
                    //     ),
                    //     const Text(
                    //       //changing text
                    //       "Project Creation",
                    //       style: TextStyle(fontSize: 35),
                    //     ),
                    //   ],
                    // ),

                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.black)),
                      child: TextField(
                        controller: projectTitleEditorController,
                        maxLength: 35,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                            counterText: ' ',
                            hintText: "Project Title",
                            contentPadding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                            border: InputBorder.none),
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black, width: 1)),
                      child: TextField(
                          controller: projectDescriptionController,
                          maxLength: 255,
                          maxLines: 7,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                              counterText: ' ',
                              fillColor: Colors.green,
                              contentPadding: EdgeInsets.fromLTRB(4, 10, 0, 0),
                              hintText: "Description",
                              border: InputBorder.none),
                          style: const TextStyle(fontSize: 14)),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Text('Server region  '),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              androidDropdown(
                                  0,
                                  (mregionID) => {
                                        setState(() {
                                          regionID = int.tryParse(mregionID!)!;
                                          // ignore: unrelated_type_equality_checks

                                          //removing
                                          // serviceID = servicePlans
                                          //     .where((m1regionStore) =>
                                          //         m1regionStore
                                          //             .regionStore.regionID ==
                                          //         regionID)
                                          //     .first
                                          //     .serviceID!;

                                          servicePlanStore = servicePlans
                                              .where((m1regionStore) =>
                                                  m1regionStore
                                                      .regionStore.regionID ==
                                                  regionID)
                                              .first;
                                        })
                                      },
                                  // removing
                                  // servicePlans
                                  //     .where((mserviceStore) =>
                                  //         mserviceStore.regionStore.regionID ==
                                  //         regionID)
                                  //     .first
                                  //     .regionStore
                                  //     .regionName
                                  servicePlanStore.regionStore.regionName),
                              if (servicePlanStore
                                      .regionStore.regionDescription !=
                                  null)
                                Text(
                                    "Note \n" +
                                        servicePlanStore
                                            .regionStore.regionDescription!,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500))
                            ])
                      ],
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text('Service plan    '),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              androidDropdown(
                                  1,
                                  (mserviceID) => {
                                        setState(() {
                                          serviceID =
                                              int.tryParse(mserviceID!)!;
                                          //adding
                                          servicePlanStore = servicePlans
                                              .where((mserviceStore) =>
                                                  mserviceStore.serviceID ==
                                                  serviceID)
                                              .first;
                                        })
                                      },
                                  servicePlanStore.serviceName),
                              if (servicePlanStore.serviceDescription != null)
                                Text(
                                  "Note \n" +
                                      servicePlanStore.serviceDescription!,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                )
                            ],
                          )
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isCreateProject = false;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down_sharp)),
                        const Spacer(
                          flex: 4,
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (projectTitleEditorController.text.isNotEmpty) {
                              updateProjectEntity();
                            }
                          },
                          height: 45,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          color: Colors.blueAccent,
                          child: const Text(
                            'Create',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Projects',
                      style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
                    ),
                    AllProjectPage(loaded: loaded)
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  updateProjectEntity() async {
    var projectStore = createProjectEntity();

    //cloud migration
    // final database =
    //     await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // final projectStoreDao = database.projectStoreDao;
    projectStoreCloud().postProjectStore(projectStore, 2519).then((value) {
      print(value);
      setState(() {
        loaded = loaded;
      });
      projectTitleEditorController.clear();
      projectDescriptionController.clear();
    }).catchError((error) {});
  }

  createProjectEntity() {
    var state = StoreProvider.of<AppStore>(context);
    int userStoreID = state.state.userStoreID;
    ServicePlanStore choseServicePlan = servicePlans
        .where((servicePlan) => servicePlan.serviceID == serviceID)
        .first;
    RegionStore choseRegionStore = choseServicePlan.regionStore;
    return projectStore(
        projectName: projectTitleEditorController.text,
        projectDescription: projectDescriptionController.text,
        deactivateProject: false,
        userStoreID: userStoreID,
        servicePlanStore: ServicePlanStore(
            regionStore: RegionStore(
                regionName: choseRegionStore.regionName,
                regionDescription: choseRegionStore.regionDescription,
                regionID: choseRegionStore.regionID,
                server: choseRegionStore.server),
            serviceName: choseServicePlan.serviceName,
            serviceDescription: choseServicePlan.serviceDescription,
            serviceID: choseServicePlan.serviceID));
  }

  navigateProject() {
    var state = StoreProvider.of<AppStore>(context);
    int projectStoreID = state.state.selectedIndex;
    if (projectStoreID != 0) {
      Navigator.pop(context);
      state.dispatch(ChangeProjectStoreID(projectStoreID));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }
}
