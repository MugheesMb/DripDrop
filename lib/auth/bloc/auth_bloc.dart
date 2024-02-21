// ignore_for_file: avoid_print

// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitialState()) {
    
    on<RequestRegEvent>((event, emit) async {
      bool userExist = await doesEmailExist(event.user.email);
      try{
        if(!userExist){
        await FirebaseFirestore.instance
            .collection('usersReq')
            .add({
          "firstName": event.user.firstName,
          "lastName": event.user.lastName,
          "email": event.user.email,
        });
        String notId = "${DateTime.now().millisecond}${DateTime.now().second}";
        await FirebaseFirestore.instance.collection("AdminNotifications").doc(notId).set({
          "id" : notId,
          "msg":"A new user has requested registration",
          "read":false,

        });
      emit(AuthRequestedState());
      }else{
        emit(AuthAlreadyReqState());
      }
      }catch(e){
        emit(AuthErrorState(e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      try {
        await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        //Map<String, dynamic>? matchedUser = await getUserByEmail(event.email);
        //AppUser user = AppUser.fromJson(matchedUser as Map<String, dynamic>);
        //saveUserType(user.role);
        emit(AuthLoggedInState(AppUser(createdAt: DateTime.now(), email: event.email, firstName: "firstName", lastName: "lastName", password: "password")));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<SignUpEvent>((event, emit) async {
      try {
        UserCredential authResult = await _auth
            .createUserWithEmailAndPassword(
          email: event.appUser.email,
          password: event.appUser.password,
        )
            .then((value) {
          value.user?.updateDisplayName(
              "${event.appUser.firstName} ${event.appUser.lastName}");
          value.user?.updateEmail(
            event.appUser.email,
          );
          return value;
        });
        String profilePictureUrl = '';
        // profilePictureUrl = await _uploadProfilePicture(
        //     event.appUser.profilePicture, authResult.user!.uid);
        authResult.user?.updatePhotoURL(profilePictureUrl);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          "first_name": event.appUser.firstName,
          "last_name": event.appUser.lastName,
          "email": event.appUser.email,
          "uid": authResult.user!.uid,
          "create_at": event.appUser.createdAt,
          "status": "pending",
        });
        //saveUserType(event.appUser.role);
        emit(AuthLoggedInState(event.appUser));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });
  }
}

// Future<String> _uploadProfilePicture(File profilePicture, String userId) async {
//   try {
//     final storageReference = firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('profilePictures/$userId.jpg');
//     final uploadTask = storageReference.putFile(profilePicture);
//     await uploadTask.whenComplete(() {});
//     final downloadUrl = await storageReference.getDownloadURL();
//     return downloadUrl;
//   } catch (e) {
//     return '';
//   }
// }

Future<bool> doesEmailExist(String email) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usersReq')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking email existence: $e');
    return false;
  }
}

Future<Map<String, dynamic>?> getUserByEmail(String email) async {
  try {
    // Reference to the 'users' collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Get all documents from the 'users' collection
    QuerySnapshot querySnapshot = await users.get();

    // Loop through each document to find the matching email
    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      // Retrieve the document data as a map
      Map<String, dynamic> userData =
          docSnapshot.data() as Map<String, dynamic>;

      // Check if the 'email' field matches the given email
      if (userData['email'] == email) {
        return userData; // Return the document data if the email matches
      }
    }

    return null; // Return null if no match is found
  } catch (e) {
    print('Error fetching user: $e');
    return null; // Return null in case of an error
  }
}

