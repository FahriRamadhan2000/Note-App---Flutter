import 'package:flutter/material.dart';
//letak package folder flutter
import 'package:notes/helpers/dbhelper.dart';
import 'package:notes/models/parsing.dart';
import 'entry.dart';
import 'package:sqflite/sqflite.dart';
//untuk memanggil fungsi yg terdapat di daftar pustaka sqflite
import 'dart:async';
//pendukung program asinkron

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<ParseData> noteList;

  @override
  Widget build(BuildContext context) {
    updateListView();
    if (noteList == null) {
      noteList = List<ParseData>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('My Fav Notes'),
        backgroundColor: Colors.indigo,
      ),
      body: createListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
        tooltip: 'Tambah Data',
        onPressed: () async {
          var note = await navigateToEntryNote(context, null);
          if (note != null) addNote(note);
        },
      ),
    );
  }

  Future<ParseData> navigateToEntryNote(
      BuildContext context, ParseData note) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return Entry(note);
    }));
    return result;
  }

  // untuk membuat ListView dan load data pada menu utama jika ada
  ListView createListView() {
    return ListView.separated(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            this.noteList[index].title,
            style: TextStyle(fontSize: 19),
          ),
          subtitle: Text('Last saved: ' + this.noteList[index].time.toString()),
          trailing: GestureDetector(
            child: Icon(
              Icons.delete,
              color: Colors.red[300],
            ),
            onTap: () {
              _showAlertDialog().then((value) {
                if (value) {
                  deleteNote(noteList[index]);
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Note telah dihapus')));
                }
              });
            },
          ),
          onTap: () async {
            var note = await navigateToEntryNote(context, this.noteList[index]);
            if (note != null) editNote(note);
          },
        );
      },
      separatorBuilder: (context, index) => Divider(
        height: 1.0,
        indent: 10.0,
        endIndent: 10.0,
        thickness: 1.0,
      ),
    );
  }

  //buat note baru
  void addNote(ParseData object) async {
    int result = await dbHelper.insert(object);
    if (result > 0) {
      updateListView();
    }
  }

  //edit note yang ditekan
  void editNote(ParseData object) async {
    int result = await dbHelper.update(object);
    if (result > 0) {
      updateListView();
    }
  }

  //delete note di dalam list
  void deleteNote(ParseData object) async {
    int result = await dbHelper.delete(object.id);
    if (result > 0) {
      updateListView();
    }
  }

  //update listview note
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<ParseData>> noteListFuture = dbHelper.getParseDataList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  Future<bool> _showAlertDialog() async {
    bool result = false;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hapus note'),
            content: Text('Apakah kamu yakin ingin hapus note ini?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('Close'),
                textColor: Colors.indigo,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Hapus'),
                textColor: Colors.indigo,
              ),
            ],
          );
        }).then((value) {
      if (value == null) {
        result = false;
      }
      result = value;
    });
    return result;
  }
}
