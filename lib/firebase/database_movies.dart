import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseMovies {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? collectionReference;

  DatabaseMovies() {
    collectionReference = firebaseFirestore.collection('movies');
  }

  Future<bool> insertar(Map<String, dynamic> movies) async {
    try {
      collectionReference!.doc().set(movies);
      return true;
    } catch (e) {
      kDebugMode ? print('ERROR AL INSERTAR: ${e.toString()}') : '';
    }

    return false;
  }

  Future<void> eliminar(String UId) async {
    return collectionReference!.doc(UId).delete();
  }

  Future<bool> Update(Map<String, dynamic> movies, String id) async {
    try {
      collectionReference!.doc(id).update(movies);
      return true;
    } catch (e) {
      kDebugMode ? print('ERROR AL ACTUALZAR: ${e.toString()}') : '';
    }

    return false;
  }

  Stream<QuerySnapshot> Select() {
    return collectionReference!.snapshots();
  }
}
