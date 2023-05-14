import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yellowpatioapp/redux_state_store/action/actions.dart';

import '../home.dart';
import '../redux_state_store/appStore.dart';

class ProjectManagement extends StatefulWidget {
  final MyInAppBrowser browser = MyInAppBrowser();
  final bool? isProjectCreation;
  ProjectManagement({Key? key,this.isProjectCreation}) : super(key: key);
  @override
  ProjectManagementState createState() => ProjectManagementState();
}

class ProjectManagementState extends State<ProjectManagement> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppStore,AppStore>(
        converter: (store) => store.state,
        builder: (context, state) {

          return Scaffold(
            appBar: AppBar(
              backgroundColor:state.darkMode? Colors.black:Colors.white,
              title:  Text("project management",
              style: TextStyle(
                color: !state.darkMode? Colors.black:Colors.white
              ),),
              actions: [
                // GestureDetector(
                //   onTap: (() {
                //     Navigator.pop(context);
                //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                //   }),
                //   child: const Text("skip",
                //     style: TextStyle(
                //       color: Colors.blue
                //     ),
                //   ),
                // )
              ],
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  icon: Icon(Icons.arrow_back_sharp,color: !state.darkMode? Colors.black:Colors.white,)),
            ),
            body: InAppWebView(
              initialOptions: InAppWebViewGroupOptions(
                
                android: AndroidInAppWebViewOptions(builtInZoomControls: false,
                forceDark: state.darkMode?AndroidForceDark.FORCE_DARK_ON:AndroidForceDark.FORCE_DARK_OFF,
                textZoom: 100),
                  crossPlatform: InAppWebViewOptions(supportZoom: false)),
              initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      "http://wark.fun/#/pm?themeid=${state.darkMode==true?1:0}&projectStoreID=${state.projectStoreID}&userStoreID=${state.userStoreID}")),
            ),
          );
        });
  }
}

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $url");
  }

  @override
  void onLoadError(url, code, message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }
}
