import 'package:flutter/cupertino.dart';

class InsightsPage extends StatefulWidget {
  Insights createState() => Insights();
}

class Insights extends State<InsightsPage> {
  static const text = "insight";

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
