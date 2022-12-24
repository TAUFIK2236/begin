import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/services/Crud/notes_service.dart';
import 'package:untitled/services/auth/auth_service.dart';
import 'package:untitled/services/auth/bloc/auth_bloc.dart';
import 'package:untitled/services/auth/bloc/auth_event.dart';
import 'package:untitled/services/cloud/cloud_note.dart';
import 'package:untitled/services/cloud/firebase_cloud_storage.dart';
import 'package:untitled/view/notes/notes_list_view.dart';
import '../../Constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';

//import 'package:firebase_auth/firebase_auth.dart';
class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
   // _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("$userId+ this is User Email" );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                   context.read<AuthBloc>().add(AuthEventLogOut(),);

                  }
                  // devtools.log(shouldLogout.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("logOut"),
                )
              ];
            },
          )
        ],
      ),
      body:StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context,snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) async {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
                // print(allNotes);

              } else {
                return CircularProgressIndicator();
              }
            default:
              return CircularProgressIndicator();
          }
        },
      )
    );
  }
}
