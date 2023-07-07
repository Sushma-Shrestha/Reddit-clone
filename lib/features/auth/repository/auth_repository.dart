import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider)));

class AuthRepository {
  FirebaseFirestore _firestore;
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      late UserModel usermodel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        usermodel = UserModel(
            name: userCredential.user!.displayName ?? 'Anonymous',
            profilepic:
                userCredential.user!.photoURL ?? Constants.avatarDefault,
            banner: Constants.bannerDefault,
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            karma: 0,
            awards: [
              'til',
              'awesomeAns',
              'gold',
              'platimun',
              'helpful',
              'plusone',
              'rocket',
              'thankyou'
            ]);
        await users.doc(userCredential.user!.uid).set(usermodel.toMap());
      } else {
        // final user = await users.doc(userCredential.user!.uid).get();
        // usermodel = UserModel.fromMap(user.data() as Map<String, dynamic>);
        // Stream is a bunch of data that is coming in the future
        // like a river of data
        usermodel = await getUserData(userCredential.user!.uid).first;
      }
      return right(usermodel);
    } on FirebaseAuthException catch (e) {
      // return left(Failure(message: e.message ?? ''));
      // return left(Failure(e.message ?? ''));
      throw e.message ?? '';
    } catch (E) {
      print(E);
      return left(Failure(E.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
