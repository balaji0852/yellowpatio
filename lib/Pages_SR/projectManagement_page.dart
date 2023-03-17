import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../home.dart';

class ProjectManagement extends StatefulWidget {
  final MyInAppBrowser browser = MyInAppBrowser();

  ProjectManagement({Key? key}) : super(key: key);
  @override
  ProjectManagementState createState() => ProjectManagementState();
}

class ProjectManagementState extends State<ProjectManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("project management"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
            icon: const Icon(Icons.arrow_back_sharp)),
      ),
      body: InAppWebView(
       initialOptions:InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(supportZoom: false)),
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://edmsadmin.azurewebsites.net/#/pm?themeid=1&projectStoreID=3363&userStoreID=2519")),
      ),
    );
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
