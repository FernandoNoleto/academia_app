import 'package:academiaapp/common/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';



class AuthProvider{

  final FirebaseAuth _auth = FirebaseAuth.instance;


  //create user object based on FirebaseUser
  // UserProvider _userFromFirebaseUser(User user) {
  //   return user != null ? UserProvider(uid: user.uid) : null;
  // }


}