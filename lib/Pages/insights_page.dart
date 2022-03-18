import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:yellowpatioapp/db/database.dart';
import 'package:yellowpatioapp/db/entity/label_master.dart';
import 'package:yellowpatioapp/db/repository/labelmaster_dao.dart';

class InsightsPage extends StatefulWidget {
  Insights createState() => Insights();
}

class Insights extends State<InsightsPage> {
  static const text = "insight";
  List<Label>? label;
  TextEditingController labelName = TextEditingController();
  var database;
  var labelMasterDao;

  // ignore: non_constant_identifier_names
  List<ColorPicker> colorsList = [ColorPicker(color:Colors.red, colorName: 'red'),
  ColorPicker(color:Colors.purple, colorName: 'purple'),
  ColorPicker(color:Colors.yellow, colorName: 'yellow'),
  ColorPicker(color:Colors.blue, colorName: 'blue'),
  ColorPicker(color:Colors.green, colorName: 'green'),
  ColorPicker(color:Colors.lime, colorName: 'lime'),
  ColorPicker(color:Colors.blueAccent, colorName: 'blueAccent'),
  ColorPicker(color:Colors.yellowAccent, colorName: 'yellowAccent'),
  ColorPicker(color:Colors.pink, colorName: 'pink'),
  ColorPicker(color:Colors.deepPurple, colorName: 'deepPurple')];
  List<String> categories = ['category 1','category 2','category 3','category 4'];
  List<String> subCategories = ['category 1','category 2','category 3','category 4'];
  String selectedColor = 'red';
  String selectedSubCategory = 'category 1',selectedCategory = 'category 1';
  bool openSubCategory = false, openCategory = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getLabel();
  }

   DropdownButton<String> androidDropdown(List<String> items,String? selectedItem,bool openDropdownFlag) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String item in items) {
      var newItem = DropdownMenuItem(
        key: UniqueKey(),
        child: ChoiceChip(
          key: UniqueKey(),
          backgroundColor: Colors.black,
          labelPadding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          selected: true,
          label:Text(item,style: TextStyle(fontSize: 19))),
        value: item,
        onTap: (){
          setState(() {
          openCategory = true;
        });
        },
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedItem,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          openCategory = false;
          selectedItem = value;
        });
      },
    );
  }

   ListView coloPicker(){
      return ListView(
        scrollDirection: Axis.horizontal,
        children: colorsList.map((ele) =>  
          Padding(child: 
            ChoiceChip(
              onSelected: (bool selected){
                setState(() {
                  selectedColor = ele.colorName;
                });
              },
              label: const Text("eeee",
                style: TextStyle(
                  color: Colors.transparent
                  ),
                ),  
              shape: ele.colorName==selectedColor? const StadiumBorder(side: BorderSide(width: 3,color: Colors.black)):const StadiumBorder(side: BorderSide(width: 1,color: Colors.transparent)),   
              backgroundColor: ele.color, 
              selected: false,
              ),
            padding: const EdgeInsets.all(5),
          ),
        ).toList(),
      );
    }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        //Balaji: No crossAxisAlignment required for the first container, since containers
        //fills themselves to fill the parent width...
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(25)
            ),
            // width: MediaQuery.of(context).size.width-20,
            height: 100,
            alignment: Alignment.center,
            child: const TextField(
              maxLength: 15,
              decoration: InputDecoration(
                counterText: ' ',
                contentPadding: EdgeInsets.symmetric(vertical: 7,horizontal: 7),
                border: InputBorder.none
              ),
              style: TextStyle(
                fontSize: 47
              ),
            ),
          ),
          const SizedBox(height: 10,),
          if(openCategory)
          androidDropdown(categories, selectedCategory, openCategory),
          if(!openCategory)
          MaterialButton(onPressed: (){
            setState(() {
              openCategory = true;
            });
          },
          height: 50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.lightBlueAccent,
          child:const Text("+ Category",style: TextStyle(fontSize: 19),),
          ),
           const SizedBox(height: 10,),
          MaterialButton(onPressed: (){
              setState(() {
              openSubCategory = true;
            });
          },
          height: 50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.lightBlueAccent,
          child:const Text("+ Sub-Category",style: TextStyle(fontSize: 19),),
          ),
          const SizedBox(height: 10,),
          SizedBox(
            height: 50,
            child: coloPicker(),
          ),
          const SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(25)
            ),
            // width: MediaQuery.of(context).size.width-20,
            height: 150,
            alignment: Alignment.topLeft,
            child: const TextField(
              maxLength: 200,
              maxLines: 9,
              decoration: InputDecoration(
                counterText: ' ',
                contentPadding: EdgeInsets.symmetric(vertical: 9,horizontal: 9),
                border: InputBorder.none
              ),
              style: TextStyle(
                fontSize: 14
              ),
            ),
          ),
           const SizedBox(height: 50,),
          MaterialButton(onPressed: (){},
          height: 45,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.lightBlueAccent,
          child:const Text("add",style: TextStyle(fontSize: 19),),
          ),

        ],
      ),),
    );


   
  }





































  Widget build1(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Container(
            height: 150,
            color: Colors.yellow,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    onChanged: (value) {},
                    controller: labelName,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (labelName.text.isNotEmpty) {
                          //add label func
                          addLabel();
                        }
                      },
                      child: const Text('add label'))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          null != label
              ?
              // ListView(
              //     children:
              Wrap(
                  children: label!
                      .map((e) => Chip(
                            label: Text(
                              e.labelName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.yellow,
                          ))
                      .toList())
              : const Text(" "),
        ]),
      ),
    );
  }

  getLabel() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    labelMasterDao = database.labelMasterDao;

    // print(database.personDao.findAllPersons());

    print(
        "***************************************************************************");

    List<Label> data = await database.labelMasterDao.findAllLabel();

    setState(() {
      label = data;
    });
  }

  addLabel() async {
    var labelEntity = Label(labelName: labelName.text);
    await labelMasterDao.insertLabel(labelEntity).then((value) {
      print("inserted successfully");
      labelName.clear();
    });
    List<Label> data = await database.labelMasterDao.findAllLabel();
    setState(() {
      label = data;
    });
  }


  

  
}



class ColorPicker{
  final String colorName;

  final Color color;

  ColorPicker({
    required this.colorName,
    required this.color
  });

}