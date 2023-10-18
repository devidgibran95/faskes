import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faskes/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // login to firebase using email provider
  signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      UserCredential userCredential = credential;
      final userDoc = getUser(userCredential.user!.uid);

      return userDoc;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  signUp(UserModel user) async {
    // sign up to firebase using email provider
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);

      UserCredential userCredential = credential;

      UserModel userData = UserModel(
        id: userCredential.user!.uid,
        email: user.email,
        password: user.password,
        name: user.name,
        phone: user.phone,
        address: user.address,
        role: user.role,
      );

      await _firestore
          .collection('users')
          .doc(userData.id)
          .set(userData.toJson());

      final userDoc = getUser(userCredential.user!.uid);

      return userDoc;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<UserModel> getUser(String id) async {
    try {
      final userDoc = await _firestore.collection('users').doc(id).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      final userModel = UserModel.fromJson(userData);
      return userModel;
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // get list of users
  Future<List<UserModel>> getUsers() async {
    try {
      final users = await _firestore.collection('users').get();
      final userList =
          users.docs.map((user) => UserModel.fromJson(user.data())).toList();
      return userList;
    } catch (e) {
      print('Error getting users: $e');
      rethrow;
    }
  }

  // get user count
  Future<int> getUserCount() async {
    try {
      final users = await _firestore.collection('users').get();
      final userList =
          users.docs.map((user) => UserModel.fromJson(user.data())).toList();
      return userList.length;
    } catch (e) {
      print('Error getting users: $e');
      rethrow;
    }
  }
}
