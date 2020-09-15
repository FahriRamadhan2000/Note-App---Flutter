import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:notes/models/parsing.dart';
import 'package:intl/intl.dart';

class Entry extends StatefulWidget {
  final ParseData note;
  Entry(this.note);
  @override
  _EntryState createState() => _EntryState(this.note);
}

class _EntryState extends State<Entry> {
  ParseData note;
  ZefyrController myText;
  FocusNode _focusNode;
  final myTitle = TextEditingController();
  String _defaultTitle = 'Your Title';
  _EntryState(this.note);

  NotusDocument _loadDocument() {
    if (this.note != null) {
      return NotusDocument.fromJson(jsonDecode(note.text));
    }
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  @override
  void initState() {
    super.initState();
    var document = _loadDocument();
    myText = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    //Load Title Jika Ada
    if (note != null) {
      _defaultTitle = note.title;
    }
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context, note);
                }),
            title: TextField(
              cursorColor: Colors.white,
              controller: myTitle..text = _defaultTitle,
              style: TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  enabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none)),
              autocorrect: false,
            ),
            actions: [
              Builder(builder: (BuildContext context) {
                return IconButton(
                    icon: Icon(Icons.save),
                    tooltip: "Save",
                    onPressed: () {
                      DateTime now = DateTime.now();
                      String myLastSaved =
                          DateFormat('d MMM yyyy kk:mm').format(now);
                      if (this.note != null) {
                        //Note Update
                        note = ParseData(this.note.id, myTitle.text,
                            jsonEncode(myText.document), myLastSaved);
                      } else {
                        //Create New Note
                        note = ParseData(null, myTitle.text,
                            jsonEncode(myText.document), myLastSaved);
                      }
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Note telah disimpan')));
                    });
              })
            ],
          ),
          body: Container(
            child: ZefyrScaffold(
              child: ZefyrEditor(
                padding: EdgeInsets.all(16),
                controller: myText,
                focusNode: _focusNode,
              ),
            ),
          ),
        ),
        onWillPop: _backButton);
  }

  Future<bool> _backButton() {
    Navigator.pop(context, note);
    //Nonaktifkan Back Button Default
    return Future.value(false);
  }
}
