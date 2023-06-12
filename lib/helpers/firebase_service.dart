import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String? userEmail,
  }) async {
    try {
      //Todo: check if user with phone already exist
      final querySnapshot =
          await _userCollection.where('phone', isEqualTo: phoneNumber).get();

      final userCount = querySnapshot.size;

      if (userCount != 0) {
        throw const HttpException(
            "User with phone already Exist. Please login");
      }

      final docRef = await _userCollection.add({
        "firstName": firstName,
        "lastName": lastName,
        "phone": phoneNumber,
        "email": userEmail,
      });

      final snapshot = await docRef.get();
      return {...snapshot.data() as Map<String, dynamic>, "id": docRef.id};
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> loginUser(String phone) async {
    try {
      Map<String, dynamic> resultMap = {};
      final querySnapshot =
          await _userCollection.where('phone', isEqualTo: phone).get();

      for (QueryDocumentSnapshot<Object?> documentSnapshot
          in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        resultMap = {...data, "id": documentSnapshot.id};
      }
      return resultMap;
    } catch (e) {
      rethrow;
    }
  }
}
