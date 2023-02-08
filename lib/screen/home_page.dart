import 'package:flutter/material.dart';

import '../db/notes_database.dart';
import '../models/note.dart';
import 'add_update_note.dart';
import 'viewe_note.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note?>? notes;
  bool isLoading = false;

  @override
  void initState() {
    refreshNote();
    super.initState();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    NotesDatabase.instance.readAllNote().then((value) => notes = value);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notes',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.black87,
              fontFamily: 'title2'),
        ),
      ),
      body: FutureBuilder(
        future: NotesDatabase.instance.readAllNote(),
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return isLoading
              ? const CircularProgressIndicator()
              : notes!.isEmpty
                  ? const Center(
                      child: Text('NO DATA'),
                    )
                  : ListView.builder(
                      itemCount: notes?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final title = notes![index]!.title ?? "No title";
                        final description =
                            notes![index]!.description ?? "No description";
                        final fnTitle = title.codeUnits.first > 122;
                        final fnDescription = description.codeUnits.first > 122;
                        final time = notes![index]!.time;

                        return InkWell(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VieweNote(
                                  noteId: notes![index]!.id,
                                ),
                              ),
                            );
                            refreshNote();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text(
                                      notes![index]!.title.toString(),
                                      maxLines: 1,
                                      textAlign: fnTitle
                                          ? TextAlign.right
                                          : TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'iransans',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      notes![index]!.description.toString(),
                                      textAlign: fnDescription
                                          ? TextAlign.right
                                          : TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'iransans',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      time!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        elevation: 0,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddUpdateNote(),
            ),
          );
          refreshNote();
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
