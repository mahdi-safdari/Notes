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
  late String? title;
  late String? description;
  late String? time;
  late bool fnTitle = title!.codeUnits.first > 122;
  late bool fnDescription = description!.codeUnits.first > 122;

  @override
  void initState() {
    title = widget.notes?.title ?? " ";
    description = widget.notes?.description ?? " ";
    final date = DateTime.now();
    final timee =
        "${date.hour}:${date.minute}   ${date.year}-${date.month}-${date.day}";
    time = widget.notes?.time ?? timee;

    super.initState();
  }

  Widget buildButton() {
    final isFormValid = title!.isNotEmpty && description!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
        ),
        onPressed: isFormValid ? addOrUpdateNote : null,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();
    final navigator = Navigator.of(context).pop();
    final date = DateTime.now();
    final time =
        "${date.hour}:${date.minute}   ${date.year}-${date.month}-${date.day}";

    if (isValid) {
      final isUpdating = widget.notes != null;
      if (isUpdating) {
        await updateNote(time);
      } else {
        _formKey.currentState!.reset();
        await addNote(time);
      }
      navigator;
    }
  }

  Future addNote(String time) async {
    _formKey.currentState!.reset();
    final note = Note(
      title: title,
      description: description,
      time: time,
    );
    await NotesDatabase.instance.create(note);
  }

  Future updateNote(String time) async {
    final note = widget.notes!.copy(
      title: title,
      description: description,
      time: time,
    );

    await NotesDatabase.instance.updateNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edite',
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
        actions: const <Widget>[
          SizedBox(width: 30),
          Icon(Icons.ios_share),
          SizedBox(width: 30),
          Icon(Icons.spa_outlined),
          SizedBox(width: 30),
          Icon(Icons.more_vert_outlined),
          SizedBox(width: 30),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  maxLines: 3,
                  style: const TextStyle(fontSize: 18),
                  initialValue: title,
                  textAlign: fnTitle ? TextAlign.right : TextAlign.left,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title...',
                  ),
                  validator: (String? title) {
                    if (title!.isEmpty) {
                      return 'The Title Cannot be Empty';
                    }
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
                child: Text(
                  time!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  maxLines: 15,
                  style: const TextStyle(fontSize: 18),
                  textAlign: fnDescription ? TextAlign.right : TextAlign.left,
                  initialValue: description,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description...',
                  ),
                  validator: (description) {
                    if (description!.isEmpty) {
                      return 'The Title Cannot be Empty';
                    }
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
