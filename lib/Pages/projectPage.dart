import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/Pages/AllProjectPage.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      navigateProject();
                    },
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 45,
                  ),
                  const Text(
                    "Project Creation",
                    style: TextStyle(fontSize: 35),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 57,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                    controller: projectTitleEditorController,
                    maxLength: 35,
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                        counterText: ' ',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 9, horizontal: 9),
                        border: InputBorder.none),
                    style: const TextStyle(fontSize: 25)),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                    controller: projectDescriptionController,
                    maxLength: 255,
                    maxLines: 5,
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                        counterText: ' ',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 9, horizontal: 9),
                        border: InputBorder.none),
                    style: const TextStyle(fontSize: 15)),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () {
                  if (projectTitleEditorController.text.isNotEmpty) {
                    updateProjectEntity();
                  }
                },
                height: 45,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.blueAccent,
                child: const Text(
                  'Create',
                  style: TextStyle(fontSize: 19),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AllProjectPage(loaded: loaded)
            ],
          ),
        ),
      ),
    );
  }

  updateProjectEntity() async {
    var projectStore = createProjectEntity();
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final projectStoreDao = database.projectStoreDao;
    projectStoreDao.insertProject(projectStore).then((value) {
      print("pass");
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
    return projectStore(
        projectName: projectTitleEditorController.text,
        projectDescription: projectDescriptionController.text,
        deactivateProject: false,
        userStoreID: userStoreID);
  }

  navigateProject() {
    var state = StoreProvider.of<AppStore>(context);
    int projectStoreListLength = state.state.selectedIndex;
    if (projectStoreListLength >= 1) {
      Navigator.pop(context);
      state.dispatch(ChangeProjectStoreID(1));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }
}
