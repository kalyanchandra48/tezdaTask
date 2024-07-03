import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tezda_task/pages/tezda_profile_page.dart';

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserIfNotExists(
      String userId, String userName, String userEmail) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userId).set({
          'name': userName,
          'email': userEmail,
          'uid': userId,
        });
        print('User added to Firestore');
      } else {
        print('User already exists in Firestore');
      }
    } catch (e) {
      print('Error checking or adding user: $e');
    }
  }

  Future<void> updateFields(String key, String value) async {
    try {
      String userUid = useruuid.value;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userUid).get();
      // if (userDoc.data()?.containsKey(key) ?? false) {
      //   print('Field exists');
      // }
      await _firestore.collection('users').doc(userUid).update({
        key: value,
      });
      print('Field updated');
    } catch (e) {
      print('Error updating field: $e');
    }
  }
}
