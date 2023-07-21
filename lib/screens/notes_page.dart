//import 'package:keep/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:keep/db/notes_database.dart';
import 'package:keep/models/note.dart';
import 'package:keep/screens/add_edit_note.dart';
import 'package:keep/screens/note_detail.dart';

final _lightColors = [
  Colors.blue.shade100,
  Colors.lightGreen.shade200,
  Colors.teal.shade200,
  Colors.red.shade100,
  Colors.indigo.shade200,
  Colors.amber.shade200,
];

class NotePage extends StatefulWidget {
  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Notes"),
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text("No Notes")
                  : getListView(),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddOrEdit()));
            refreshNotes();
          },
        ));
  }

  Widget getListView() {
    return MasonryGridView.builder(
      itemCount: notes.length,
      gridDelegate:
          SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        final note = notes[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NoteDetail(noteId: note.id!)),
            );
            refreshNotes();
          },
          child: Container(
            //alignment: Alignment.topLeft,
            height: getMinHeight(index),
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: _lightColors[index % 6],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                Row(
                  children: [
                    // Title on the left side
                    Expanded(
                      child: Text(
                        note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    note.isImportant
                        ? Icon(
                            Icons.star,
                            color: Colors.black54,
                          )
                        : SizedBox(
                            width: 2,
                          ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Last Modified ${DateFormat.yMMMd().add_jm().format(note.modifiedTime)}",
                  //textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[850],
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  note.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: getLineNum(index),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,

                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// To return different height for different widgets
double getMinHeight(int index) {
  switch (index % 4) {
    case 0:
      return 160;
    case 1:
      return 140;
    case 2:
      return 200;
    case 3:
      return 120;
    default:
      return 100;
  }
}

int getLineNum(int index) {
  switch (index % 4) {
    case 0:
      return 4;
    case 1:
      return 3;
    case 2:
      return 6;
    case 3:
      return 2;
    default:
      return 3;
  }
}
