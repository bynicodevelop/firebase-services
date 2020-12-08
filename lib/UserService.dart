import 'package:services/exceptions/AuthenticationException.dart';
import 'package:services/getaway/FirebaseAuthGtaway.dart';
import 'package:services/models/UserModel.dart';

class UserService {
  final FirebaseAuthGetaway firebaseAuthGetaway;

  const UserService({this.firebaseAuthGetaway});

  Stream<UserModel> get user {
    return firebaseAuthGetaway.user.asyncMap((e) async {
      if (e == null) return null;

      return UserModel(
        uid: e[UserModel.UID],
        email: e[UserModel.EMAIL],
        username: e[UserModel.USERNAME],
        status: e[UserModel.STATUS],
        avatarURL: e[UserModel.AVATAR_URL],
      );
    });
  }

  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      Map<String, dynamic> data =
          await firebaseAuthGetaway.signInWithEmailAndPassword(email, password);

      return UserModel(
        uid: data[UserModel.UID],
        email: data[UserModel.EMAIL],
      );
    } on AuthenticationException catch (e) {
      throw new AuthenticationException(code: e.code);
    }
  }

  Future<UserModel> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      Map<String, dynamic> data =
          await firebaseAuthGetaway.signUpWithEmailAndPassword(email, password);

      return UserModel(
        uid: data[UserModel.UID],
        email: data[UserModel.EMAIL],
      );
    } on AuthenticationException catch (e) {
      throw new AuthenticationException(code: e.code);
    }
  }

  Future<void> signOut() async {
    await firebaseAuthGetaway.signOut();
  }

  Future<void> delete() async {
    try {
      await firebaseAuthGetaway.delete();
    } on AuthenticationException catch (e) {
      throw new AuthenticationException(code: e.code);
    }
  }
}
