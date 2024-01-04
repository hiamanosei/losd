import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:losd/services/store_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _noteController = TextEditingController();
  void createNote({String? docId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: _noteController,
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  if (docId == null) {
                    StoreServices().createNote(_noteController.text.trim());
                  } else {
                    StoreServices()
                        .updateNotes(docId, _noteController.text.trim());
                  }

                  _noteController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('N O T E S'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        onPressed: createNote,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: StreamBuilder(
        stream: StoreServices().readDateOrderd(),
        builder: (context, snapshot) {
          //get documents

          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documents = noteList[index];
                String docId = documents.id;
                Map<String, dynamic> data =
                    documents.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(
                    data['note'],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          createNote(docId: docId);
                        },
                        icon: const Icon(Icons.settings_sharp),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () => StoreServices().deleteNote(docId),
                        icon: const Icon(Icons.delete_forever),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Text('Loading');
        },
      ),
    );
  }
}
