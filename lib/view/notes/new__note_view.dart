

import "package:flutter/material.dart";
import 'package:untitled/services/Crud/notes_service.dart';
import 'package:untitled/services/auth/auth_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerlistener() async{
    final note = _note;
    if(note == null){
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(note, text);
  }
  
  void _setupTextControllerListener(){
    _textController.removeListener(_textControllerlistener);
    _textController.addListener(_textControllerlistener);
  }
  

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(note.id);
    }
  }

  void _saveNoteifTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note,
        text,
      );
    }
  }

  void dispose (){
    _deleteNoteIfTextIsEmpty();
    _saveNoteifTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("new note"),
      ),
      body: FutureBuilder(
        future: createNewNote() ,
        builder:(context,snapshot){

          switch(snapshot.connectionState){

            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote;
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
              );
            default: return CircularProgressIndicator();

          }
        },
      ),
    );
  }
}
