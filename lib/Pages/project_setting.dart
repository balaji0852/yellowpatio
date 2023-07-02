import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:planb/Pages/project_setting.dart';
import 'package:planb/cloud/project_setting_cloud.dart';
import 'package:planb/db/entity/project_setting.dart';
import 'package:planb/home.dart';
import 'package:planb/redux_state_store/appStore.dart';

class ProjectSettingW extends StatefulWidget {
  const ProjectSettingW({Key? key}) : super(key: key);

  @override
  projectSettingPage createState() => projectSettingPage();
}

class projectSettingPage extends State<ProjectSettingW> {
  bool darkMode = false;
  var projectSetting = ProjectSetting(
      projectSettingID: 1, projectStoreID: 1, carryForwardMyWork: false);
  var state;
  bool isCFMW = false;

  getPage() async {
    state ??= StoreProvider.of<AppStore>(context);

    int projectStoreID = state.state.projectStoreID;
    projectSetting =
        await projectSettingCloud().getProjectSetting(projectStoreID);
        setState(() {
          isCFMW = projectSetting.carryForwardMyWork;
        });
  }

  changeSetting(bool _isCFMW) async {
    ProjectSetting _projectSetting = ProjectSetting(
        projectSettingID: projectSetting.projectSettingID,
        projectStoreID: projectSetting.projectStoreID,
        carryForwardMyWork: _isCFMW);
    int status = await projectSettingCloud().putProjectSetting(_projectSetting);
    if ( status== 200) {
      setState(() {
        isCFMW = _isCFMW;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getPage();
  }

  @override
  void didUpdateWidget(covariant ProjectSettingW oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    state ??= StoreProvider.of<AppStore>(context);
    darkMode = state.state.darkMode;

    return Scaffold(
      backgroundColor: darkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: darkMode ? Colors.black : Colors.white,
        leading: BackButton(
          color: darkMode ? Colors.white : Colors.black,
          onPressed: (() {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          }),
        ),
        title: Text(
          'Project Management',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: darkMode ? Colors.white : Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                      value: isCFMW,
                      onToggle: (cfmw_Value) => {changeSetting(cfmw_Value)}),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      'Turning on CFMW (carry forward my work) will carry forward all the unfinished tasks to next day, For the entire project.',
                      style: TextStyle(
                          fontSize: 11,
                          color: darkMode ? Colors.white : Colors.black),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
