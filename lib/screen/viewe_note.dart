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
        icon: const Icon(Icons.edit_outlined),
      );
  Widget deleteButton() => IconButton(
        onPressed: () async {
          final navigator = Navigator.of(context);
          await NotesDatabase.instance.deleteNote(widget.noteId);
          navigator.pop();
        },
        icon: const Icon(Icons.delete),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Viewe Note')),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(notes.title.toString()),
                  Text(notes.description.toString()),
                  Row(
                    children: [
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
