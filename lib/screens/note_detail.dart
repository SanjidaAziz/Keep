import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep/db/notes_database.dart';
import 'package:keep/models/note.dart';
import 'package:keep/screens/add_edit_note.dart';
import 'package:keep/screens/notes_page.dart';

class NoteDetail extends StatefulWidget {
  final int noteId;

  const NoteDetail({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });
    note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () async {
              Navigator.of(context).pop();
            }),
        actions: [EditButton(), DeleteButton()],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Title on the left side
                        Expanded(
                          child: Text(
                            note.title,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        note.isImportant
                            ?  Icon(
                                  Icons.star,
                                  size: 30.0,
                                  color: Colors.teal[50],
                                )
                            : const SizedBox(width: 2),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Last Modified ${DateFormat.yMMMd().format(note.modifiedTime)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        note.description,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget EditButton() {
    return IconButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddOrEdit(note: note)),
          );
          refreshNote();
        },
        icon: const Icon(Icons.edit));
  }

  Widget DeleteButton() {
    return IconButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Confirm Delete"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await NotesDatabase.instance.delete(widget.noteId);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Delete"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                );
              });
        },
        icon: const Icon(Icons.delete));
  }
}
