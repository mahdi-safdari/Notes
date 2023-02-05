import 'package:flutter/material.dart';
import 'package:notes/screen/add_update_note.dart';
import 'package:notes/screen/viewe_note.dart';
import './db/notes_database.dart';
import './models/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mahdi Safdari'),
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
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: notes?.length,
                      itemBuilder: (BuildContext context, int index) {
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
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Card(
                              color: Colors.blueGrey[100],
                              margin: const EdgeInsets.all(7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      notes![index]!.title.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      notes![index]!.description.toString(),
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
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddUpdateNote(),
            ),
          );
          refreshNote();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
