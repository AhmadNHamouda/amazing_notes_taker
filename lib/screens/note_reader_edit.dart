import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../style/app_style.dart';

class NoteReaderEditScreen extends StatefulWidget {
  NoteReaderEditScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<NoteReaderEditScreen> createState() => _NoteReaderEditScreenState();
}

class _NoteReaderEditScreenState extends State<NoteReaderEditScreen> {
  final CollectionReference profileList =
      FirebaseFirestore.instance.collection("Notes");
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  String date = DateTime.now().toString();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.doc["note_title"];
    _mainController.text = widget.doc["note_content"];

    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Add new Note",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              var id = widget.doc.id;
              deleteNote(id).then((value) {
                print(value);
                Navigator.pop(context);
              }).catchError(
                  (error) => print("Failed to add new Note due to $error"));
            },
          ),
          // add more IconButton
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Note Title'),
              style: AppStyle.mainTitle,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              date,
              style: AppStyle.dateTitle,
            ),
            SizedBox(
              height: 28.0,
            ),
            TextField(
              controller: _mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Note Content'),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.accentColor,
        onPressed: () async {
          var id = widget.doc.id;
          updateNotes(_titleController.text, _mainController.text, id)
              .then((value) {
            print(value);
            Navigator.pop(context);
          }).catchError(
                  (error) => print("Failed to add new Note due to $error"));
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Future updateNotes(String title, String content, String uid) async {
    return await profileList
        .doc(uid)
        .update({'note_title': title, 'note_content': content});
  }

  Future deleteNote(String uid) async {
    return await profileList.doc(uid).delete();
  }
}
