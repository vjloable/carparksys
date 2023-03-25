import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class RTDBService {
  final databaseRef = FirebaseDatabase.instance.ref();
  final databaseDB = FirebaseDatabase.instance;
}

class FSService {
  final databaseDB = FirebaseFirestore.instance;
}

