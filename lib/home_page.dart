import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  home createState() => home();
}

class home extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('yellow patio'),
      ),
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          "home page",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
