import 'package:flutter/material.dart';
import 'package:notes/screen/add_update_note.dart';
import '../db/notes_database.dart';
import '../models/note.dart';

class VieweNote extends StatefulWidget {
  final int? noteId;
  const VieweNote({super.key, required this.noteId});

  @override
  State<VieweNote> createState() => _VieweNoteState();
}

class _VieweNoteState extends State<VieweNote> {
  late Note notes;
  bool isLoading = false;
  @override
  void initState() {
    refreshNote();
    super.initState();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  Widget editButton() => IconButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddUpdateNote(notes: notes),
          ));
          refreshNote();
        },
        icon: const Icon(Icons.edit_note),
      );
  Widget deleteButton() => IconButton(
        onPressed: () async {
          final navigator = Navigator.of(context);
          await NotesDatabase.instance.deleteNote(widget.noteId);
          navigator.pop();
        },
        icon: const Icon(Icons.playlist_remove_outlined),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Viewe Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.black87,
            fontFamily: 'title2',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: <Widget>[
                  Text(
                    notes.title.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'iransans',
                    ),
                  ),
                  const Divider(thickness: 1.5, indent: 50, endIndent: 50),
                  Text(
                    notes.description.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'iransans',
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      editButton(),
                      deleteButton(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
