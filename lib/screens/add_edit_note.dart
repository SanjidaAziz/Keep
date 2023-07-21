
import 'package:flutter/material.dart';
import 'package:keep/db/notes_database.dart';
import 'package:keep/models/note.dart';
import 'package:keep/screens/note_detail.dart';

class AddOrEdit extends StatefulWidget {
  final Note? note;
  const AddOrEdit({
    Key? key,
    this.note
  }): super(key: key);
  @override
  State<AddOrEdit> createState() => _AddOrEditState();
}

class _AddOrEditState extends State<AddOrEdit> {
  final formKey = GlobalKey<FormState>();
  late bool isImportantNow;
  late String titleNow;
  late String descriptionNow;
  late DateTime modifiedTimeNow;

  @override
  void initState() {
    super.initState();
    isImportantNow = widget.note?.isImportant?? false;
    titleNow = widget.note?.title ?? 'Untitled';
    descriptionNow = widget.note?.description ?? '';
    modifiedTimeNow = widget.note?.modifiedTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.note == null
            ? Text("Add Note")
            : Text("Edit note"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: (){
            Navigator.of(context).pop();
          },

        ),
        actions: [StarButton(),SaveButton()],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                onChanged: (value){
                  titleNow=value;
                },
                maxLines: 1,
                initialValue: titleNow,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                validator: (title) =>
                title != null && title.isEmpty ? 'The title cannot be empty' : null,
                //onChanged: ,
              ),
              TextFormField(
                onChanged: (value){
                  descriptionNow=value;
                },
                maxLines: 13,
                initialValue: descriptionNow,
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type something...',
                  hintStyle: TextStyle(color: Colors.white60),
                ),
                validator: (title) => title != null && title.isEmpty
                    ? 'The description cannot be empty'
                    : null,
               // onChanged: onChangedDescription,
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget SaveButton() {
    return IconButton(
        onPressed: () async{
          await addOrEditNote();
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.save));
  }
  Widget StarButton() {
    return IconButton(
        onPressed: ()async{
           // isImportantNow
            //    ? isImportantNow=false
              //  : isImportantNow=true;
        },
       // icon:Icon(Icons.star),
        icon: isImportantNow? Icon(Icons.star): Icon(Icons.star_border),
    );
  }
  Future addOrEditNote()async{
    final isValid=formKey.currentState!.validate();
    bool isUpdating;
    if(isValid){
      if(widget.note == null){
        isUpdating=false;
        await AddNote();
      }
      else {
        isUpdating=true;
        await UpdateNote();
      }
    }
  }

  Future AddNote() async{
    final note = Note(
      title: titleNow,
      description: descriptionNow,
      isImportant: isImportantNow,
      modifiedTime: DateTime.now(),
    );
    await NotesDatabase.instance.create(note);
  }
  Future UpdateNote() async{
    final note = widget.note!.copy(
      title: titleNow,
      description: descriptionNow,
      isImportant: isImportantNow,
      modifiedTime: DateTime.now(),
    );
    await NotesDatabase.instance.update(note);
  }
}
