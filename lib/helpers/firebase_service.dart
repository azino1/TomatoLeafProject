import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference _virusCollection =
      FirebaseFirestore.instance.collection('Virus');

  ///This function is used to register user with phone number, first name, last name while email is optional
  ///
  ///It saves this data on the user collection in firestore
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

  ///This function is used to login user with phone number
  ///It takes phone number as parameter and returns a map of user data
  ///
  ///It works by comparing the phone number passed in with the phone number in the firestore
  ///If the phone number is found, it returns the user data
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

  Future<List<Map<String, dynamic>>> getVirusesData() async {
    try {
      List<Map<String, dynamic>> virusDoc = [];
      final virusSnapshot = await _virusCollection.get();

      for (QueryDocumentSnapshot<Object?> documentSnapshot
          in virusSnapshot.docs) {
        print('sdfsdf');
        final data = documentSnapshot.data() as Map<String, dynamic>;

        virusDoc.add(data);
      }

      return virusDoc;
    } catch (e) {
      rethrow;
    }
  }
}
