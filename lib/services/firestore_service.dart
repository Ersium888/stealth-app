import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart'; // For kDebugMode print statements

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Example: Add a 'move' document
  // Assumes 'data' contains fields like 'pickup', 'destination', 'createdAt', etc.
  Future<void> addMove(Map<String, dynamic> data) async {
    try {
      // It's good practice to add a server timestamp if not already present in data
      final dataWithTimestamp = {
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _db.collection('moves').add(dataWithTimestamp);
    } catch (e) {
      // if (kDebugMode) {
      //   print('Error adding move to Firestore: $e');
      // }
      rethrow; // Rethrow to be handled by UI or calling function
    }
  }

  // Example: Stream of 'moves' documents, ordered by creation time
  Stream<QuerySnapshot<Map<String, dynamic>>> getMovesStream() {
    return _db
        .collection('moves')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Example: Add a generic document to a specified collection
  Future<DocumentReference<Map<String, dynamic>>> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    try {
      final dataWithTimestamp = {
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      };
      return await _db.collection(collectionPath).add(dataWithTimestamp);
    } catch (e) {
      // if (kDebugMode) {
      //   print('Error adding document to $collectionPath: $e');
      // }
      rethrow;
    }
  }

  // Example: Get a stream of documents from a specified collection
  Stream<QuerySnapshot<Map<String, dynamic>>> getCollectionStream({
    required String collectionPath,
    String? orderByField,
    bool descending = false,
  }) {
    Query<Map<String, dynamic>> query = _db.collection(collectionPath);
    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }
    return query.snapshots();
  }
}
