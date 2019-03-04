import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class crudMethods {

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    }
    else {
      return false;
    }
  }

  Future<void> addData(userData) async {
    if (isLoggedIn()) {
      Firestore.instance.collection("Users").add(userData).catchError((e) {
        print(e);
      });
    }
    else {
      print("User not logged in\n");
    }
  }

  Future<void> addRide(rideData) async {
    //if (isLoggedIn()) {
      Firestore.instance.collection("Rides").add(rideData).catchError((e) {
        print(e);
      });
    //}
  }
}