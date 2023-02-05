import 'package:flutter/material.dart';
import '../db/notes_database.dart';
import '../models/note.dart';

class AddUpdateNote extends StatefulWidget {
  final Note? notes;
  const AddUpdateNote({super.key, this.notes});

  @override
  State<AddUpdateNote> createState() => _AddUpdateNoteState();
}

class _AddUpdateNoteState extends State<AddUpdateNote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void initState() {
    title = widget.notes?.title ?? '';
    description = widget.notes?.description ?? '';

    super.initState();
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ElevatedButton(
        onPressed: addOrUpdateNote,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid ? null : Colors.grey.shade500,
        ),
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();
    final navigator = Navigator.of(context).pop();

    if (isValid) {
      final isUpdating = widget.notes != null;
      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
      navigator;
    }
  }

  Future addNote() async {
    final note = Note(
      title: title,
      description: description,
    );
    await NotesDatabase.instance.create(note);
  }

  Future updateNote() async {
    final note = widget.notes!.copy(
      title: title,
      description: description,
    );

    await NotesDatabase.instance.updateNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add or edite note'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: title,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  validator: (title) {
                    title != null && title.isEmpty
                        ? 'The Title Cannot be Empty'
                        : null;
                  },
                  onChanged: (String title) {
                    setState(() {
                      this.title = title;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: description,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  validator: (description) {
                    description != null && description.isEmpty
                        ? 'The Description Cannot be Empty'
                        : null;
                  },
                  onChanged: (String description) {
                    setState(() {
                      this.description = description;
                    });
                  },
                ),
              ),
              buildButton(),
            ],
          ),
        ),
      ),
    );
  }
}
