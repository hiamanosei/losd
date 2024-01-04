import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  //getting collection of notes
  CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  //CREAT
  //Add notes
  Future createNote(String text) async {
    return notes.add({"note": text, "timestamp": Timestamp.now()});
  }

  //READ
  //GET NOTES FROM DATABASE
  Stream<QuerySnapshot> readDateOrderd() {
    final noteStream = notes.orderBy('timestamp').snapshots();
    return noteStream;
  }

  //UPDATE
  //update a note given a userid
  Future updateNotes(String docId, String text) async {
    final updatenotes =
        notes.doc(docId).update({"note": text, "timestamp": Timestamp.now()});
    return updatenotes;
  }

  //DELETE
//delete a note using a user id
  Future deleteNote(
    String docId,
  ) async {
    return notes.doc(docId).delete();
  }
}
