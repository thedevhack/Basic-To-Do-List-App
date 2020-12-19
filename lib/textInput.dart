import 'package:flutter/material.dart';

class TxtIn extends StatefulWidget {
  final String actualTask;
  TxtIn({this.actualTask});
  @override
  _TxtInState createState() => _TxtInState();
}

class _TxtInState extends State<TxtIn> {
  TextEditingController text1 = new TextEditingController();
  String text2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: TextField(
                controller: text1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Task',
                  hintText: 'for eg: Water the plants',
                  isDense: true,
                ),
              ),
            ),
          ),
          RaisedButton(
              color: Colors.blue,
              onPressed: () {
                setState(() {
                  text2 = text1.text;

                  Navigator.of(context).pop(text2);
                });
              },
              child: Text(
                "Add",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              )),
        ],
      ),
    );
  }
}
