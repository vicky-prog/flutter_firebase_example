import 'package:firebase_database/firebase_database.dart';

class FirebaseUserDatasource {
  final DatabaseReference _dbRef;
  FirebaseUserDatasource() : _dbRef = FirebaseDatabase.instance.ref();

  Future<void> addUserData({required String userId,required Map<String, dynamic> data}) async {
    try {
      await _dbRef.child("users/$userId").set(data);
    } catch (e) {
      // Handle errors here, e.g., log or rethrow custom exceptions.
      throw Exception("Failed to set user data: $e");
    }
  }

   Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final snapshot = await _dbRef.child("users/$userId").get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null; // User data not found
    } catch (e) {
      throw Exception("Failed to fetch user data: $e");
    }
  }
}
