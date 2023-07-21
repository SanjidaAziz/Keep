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
  const NotePage({super.key});

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
    notes = await NotesDatabase.instance.readAllNotes();

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
          backgroundColor: Colors.tealAccent[100],
          onPressed: () async {
            await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddOrEdit()));
            refreshNotes();
          },
          child: const Icon(Icons.add),
        ));
  }

  Widget getListView() {
    return MasonryGridView.builder(
      itemCount: notes.length,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        final note = notes[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => NoteDetail(noteId: note.id!)),
            );
            refreshNotes();
          },
          child: Container(
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Title on the left side
                    Expanded(
                      child: Text(
                        note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    note.isImportant
                        ? Icon(
                            Icons.star,
                            color: Colors.teal[800],
                          )
                        : const SizedBox(width: 2),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Last Modified: \n${DateFormat.yMMMd().add_jm().format(note.modifiedTime)}",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[850],
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  note.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: getLineNum(index),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
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
