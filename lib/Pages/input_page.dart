import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  Add createState() => Add();
}

class Add extends State<AddPage> {
  static const text = "add new tasks";
  static const micText =
      'Tap Microphone to record prompt. Say "ding" when done.';
  static const SayMessageText = 'Say "ding" when done.';
  // final SpeechToText speech = SpeechToText();
  bool isListening = false;
  String InputMessage = "";
  static const TextFieldPrompt = "You con type in your prompt";
  TextEditingController tec = new TextEditingController();

  TextStyle ts = const TextStyle(
      fontSize: 17,
      color: Colors.black,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold);
  OutlineInputBorder op = OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.white10,
      ));
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                micText,
                style: ts,
              ),
              MaterialButton(
                child: Image.asset("assets/mic.png"),
                onPressed: () {
                  // listen
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(isListening ? "listening..." : "stopped..."),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Text(InputMessage, style: ts),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text((InputMessage.split(" ").length - 1).toString() + "/30")
                ],
              ),
              SizedBox(
                height: 2,
                child: Container(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: tec,
                maxLines: 5,
                decoration: InputDecoration(
                    focusedBorder: op,
                    enabledBorder: op,
                    hintText: "type here..."),
                onChanged: (value) {
                  if (InputMessage.split(" ").length < 30) {
                    setState(() {
                      InputMessage = value;
                    });
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    // if (!isListening && InputMessage.isNotEmpty) {
                    // saveNotes();
                    // }
                  },
                  child: Text("add"))
            ],
          ),
        ),
      ),
    );
  }

  // void listen() async {
  //   if (!isListening) {
  //     bool available = await speech.initialize(
  //       onStatus: (val) => print('onStatus: $val'),
  //       onError: (val) => print('onError: $val'),
  //     );
  //     if (available) {
  //       setState(() => isListening = true);
  //       speech.listen(
  //         onResult: (val) => setState(() {
  //           if (InputMessage.split(" ").length < 30 &&
  //               !InputMessage.split(" ").contains("ding")) {
  //             InputMessage = val.recognizedWords;
  //             tec.text = InputMessage;
  //           } else {
  //             speech.stop();
  //             isListening = false;
  //           }
  //         }),
  //       );
  //     }
  //   } else {
  //     setState(() => isListening = false);
  //     speech.stop();
  //   }
  // }

  // Future saveNotes() async {
  //   final database =
  //       await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  //   final personDao = database.personDao;

  //   final person = new Person(0, InputMessage);

  //   print(database.personDao.findAllPersons());
  //   // Note note = new Note(1, InputMessage, 1, 1);

  //   await personDao.insertPerson(person).then((value) {
  //     print("inserted successfully");
  //   }).onError((error, stackTrace) {
  //     print(error);
  //   });
  // }
}
