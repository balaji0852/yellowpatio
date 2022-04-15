import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'package:yellowpatioapp/graph/time_instance_widget.dart';

//having a listview with a fiexed height container is good, but having a
//column and a listview inside the box
class PlannerGraph extends StatefulWidget {
  final ClassMaster classMaster;
  const PlannerGraph({Key? key, required this.classMaster}) : super(key: key);

  @override
  PlannerGraphPage createState() {
    return PlannerGraphPage();
  }
}

class PlannerGraphPage extends State<PlannerGraph> {
  final GlobalKey<TimeInstancePage> _key1 = GlobalKey();
  final GlobalKey<TimeInstancePage> _key2 = GlobalKey();
  final GlobalKey<TimeInstancePage> _key3 = GlobalKey();

  int day1 = DateTime.now().millisecondsSinceEpoch;
  int day2 = DateTime.now().millisecondsSinceEpoch + 86400000;
  int day3 = DateTime.now().millisecondsSinceEpoch + 2 * 86400000;
  static List<String> time = List.generate(
      24,
      (index) =>
          index <= 11 ? (index+1).toString() + "am" : (index+1).toString() + "pm");
  late List<String> dates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateSetter();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 425,
          color: Colors.white,
          child: ListView(
            children: [
              Column(
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(
                      width: 40,
                      // ignore: prefer_const_literals_to_create_immutables
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: time
                              .map((e) => SizedBox(
                                    height: 50,
                                    child: Text(e),
                                  ))
                              .toList()),
                    ),
                    SizedBox(
                      height: 1250,
                      width: 2,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                    //Dates are provided to TimeIntanceWidget, they query it and save in 24-List, type 2D...
                    //TimeIntanceWidget makes the query for a day, or based csp(comment section page) view
                    //csp will provide the 2D List, classmaster object is provided. plannerGraph->timeInstanceWidget...
                    //set the color of widget as per ClassMaster object.
                    TimeInstanceWidget(
                      //1 day view
                      //today:day1
                      today: DateTime.parse(dates[0]).millisecondsSinceEpoch,
                      key: _key1,
                      classMaster: widget.classMaster,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    TimeInstanceWidget(
                        //1 day view
                        //today:day1
                        today: day2,
                        key: _key2,
                        classMaster: widget.classMaster),
                    const SizedBox(
                      width: 2,
                    ),

                    TimeInstanceWidget(
                        today: day3,
                        key: _key3,
                        classMaster: widget.classMaster),
                    const SizedBox(
                      width: 2,
                    ),

                    // Container(
                    //   height: 1250,
                    //   width: (MediaQuery.of(context).size.width - 50) / 5,
                    //   color: Colors.white,
                    //   child: Column(),
                    // ),
                    // Container(
                    //   height: 1250,
                    //   width: (MediaQuery.of(context).size.width - 50) / 5,
                    //   color: Colors.white,
                    //   child: Column(
                    //     children: [],
                    //   ),
                    // ),
                  ]),
                  Row(
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      SizedBox(
                        height: 2,
                        width: MediaQuery.of(context).size.width - 50,
                        child: Container(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        Row(
          children: [
            const SizedBox(
              width: 40,
            ),
            SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width - 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: dates.isNotEmpty
                      ? dates.map((e) => Text(e.substring(5, 10))).toList()
                      : const [Text(" ")],
                )),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 3,
            ),
            const Text('View',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            androidDropdown(['day', 'month', 'year'], (p0) => {}, 'month'),
            const Spacer(
              flex: 1,
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_left,
                size: 35,
              ),
              onPressed: () {
                decrementDate();
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_right,
                size: 35,
              ),
              onPressed: () {
                incrementDate();
              },
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ],
    );
  }

  Container androidDropdown(
      List<String> items, Function(String?)? callBack, String dropdownTitle) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String item in items) {
      var newItem = DropdownMenuItem(
        key: UniqueKey(),
        child: Text(item, style: const TextStyle(fontSize: 13)),
        value: item,
      );
      dropdownItems.add(newItem);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: DropdownButton<String>(
        hint: Text(
          dropdownTitle,
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
        ),
        items: dropdownItems,
        borderRadius: BorderRadius.circular(25),
        onChanged: callBack,
      ),
    );
  }

  incrementDate() {
    //1 day view
    //day1 = day1 + 86400000;

    day1 = day1 + 3 * 86400000;
    day2 = day1 + 86400000;
    day3 = day2 + 86400000;

    print('00000000000000000000000000000000');
    dateTest(day1);
    dateTest(day2);
    dateTest(day3);
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    dateSetter();
    calls();
  }

  decrementDate() {
    //1 day view
    //day1 = day1 - 86400000;
    day1 = day1 - 3 * 86400000;
    day2 = day1 + 86400000;
    day3 = day2 + 86400000;
    print("---------------------------------");
    dateTest(day1);
    dateTest(day2);
    dateTest(day3);
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    dateSetter();
    calls();
  }

  dateTest(int epoch) {
    print("dateTest");
    print(DateTime.fromMillisecondsSinceEpoch(epoch));
  }

  dateSetter() {
    setState(() {
      dates = [
        DateTime.fromMillisecondsSinceEpoch(day1).toString(),
        DateTime.fromMillisecondsSinceEpoch(day2).toString(),
        DateTime.fromMillisecondsSinceEpoch(day3).toString()
      ];
    });
  }

  calls() {
    print("--planner_graph:calls");
    print(day1);
    print(day2);
    print(day3);

    _key1.currentState!.getTodayInstance(day1);
    _key2.currentState!.getTodayInstance(day2);
    _key2.currentState!.getTodayInstance(day3);
  }
}


class test extends StatelessWidget{

  test({Key? key,required this.text,}): super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(text);
  }
  
}