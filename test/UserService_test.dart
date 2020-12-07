import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:services/UserService.dart';
import 'package:services/exceptions/AuthenticationException.dart';
import 'package:services/getaway/FirebaseAuthGtaway.dart';
import 'package:services/models/UserModel.dart';

main() {
  group('UserService.user', () {
    test('Should return a Stream with an UserModel', () async {
      // ARRANGE
      final _FirebaseAuthGetaway firebaseAuthGetaway = _FirebaseAuthGetaway();

      when(firebaseAuthGetaway.user).thenAnswer(
        (_) => Stream.fromFuture(
          Future.value({
            'uid': 'uid',
            'email': 'email',
            // 'username': 'username',
            // 'status': 'status',
            // 'avatarURL': 'avatarURL',
          }),
        ),
      );

      final UserService userService = UserService(
        firebaseAuthGetaway: firebaseAuthGetaway,
      );

      // ACT
      Stream<UserModel> stream = userService.user;

      UserModel userModel = await stream.first;

      // ASSERT
      expect(userModel, isInstanceOf<UserModel>());

      expect(userModel.uid, 'uid');
      expect(userModel.email, 'email');
      // expect(userModel.username, 'username');
      // expect(userModel.status, 'status');
      // expect(userModel.avatarURL, 'avatarURL');
    });

    test('Should return a Stream with an null value when user is logout',
        () async {
      // ARRANGE
      final _FirebaseAuthGetaway firebaseAuthGetaway = _FirebaseAuthGetaway();

      when(firebaseAuthGetaway.user)
          .thenAnswer((_) => Stream.fromFuture(Future.value(null)));

      final UserService userService = UserService(
        firebaseAuthGetaway: firebaseAuthGetaway,
      );

      // ACT
      Stream<UserModel> stream = userService.user;

      // ASSERT
      expect(await stream.first, null);
    });
  });

  group('UserService signInWithEmailAndPassword', () {
    test('Should authenticated with success', () async {
      // ARRANGE
      final String uid = '1234567';
      final String email = 'john.doe@domain.tld';
      final String password = '123456';
      final _FirebaseAuthGetaway firebaseAuthGetaway = _FirebaseAuthGetaway();

      when(firebaseAuthGetaway.signInWithEmailAndPassword(email, password))
          .thenAnswer(
        (_) => Future.value({
          'uid': uid,
          'email': email,
        }),
      );

      final UserService userService = UserService(
        firebaseAuthGetaway: firebaseAuthGetaway,
      );

      // ACT
      final UserModel userModel =
          await userService.signInWithEmailAndPassword(email, password);

      // ASSERT
      verify(firebaseAuthGetaway.signInWithEmailAndPassword(email, password));

      expect(userModel.uid, uid);
      expect(userModel.email, email);
    });

    test('Should expected an AuthenticationException (wrong credential)',
        () async {
      // ARRANGE
      final String email = 'john.doe@domain.tld';
      final String password = '123456';
      final _FirebaseAuthGetaway firebaseAuthGetaway = _FirebaseAuthGetaway();

      when(firebaseAuthGetaway.signInWithEmailAndPassword(email, password))
          .thenThrow(AuthenticationException(
              code: AuthenticationException.WRONG_CREDENTIALS));

      final UserService userService = UserService(
        firebaseAuthGetaway: firebaseAuthGetaway,
      );

      // ACT && EXPECT
      expect(
        () async =>
            await userService.signInWithEmailAndPassword(email, password),
        throwsA(
          allOf(
            isInstanceOf<AuthenticationException>(),
            predicate(
                (f) => f.code == AuthenticationException.WRONG_CREDENTIALS),
          ),
        ),
      );
    });

    test('Should expected an Authentication exception (user not found)',
        () async {
      // ARRANGE
      final String email = 'john.doe@domain.tld';
      final String password = '123456';
      final _FirebaseAuthGetaway firebaseAuthGetaway = _FirebaseAuthGetaway();

      when(firebaseAuthGetaway.signInWithEmailAndPassword(email, password))
          .thenThrow(AuthenticationException(
              code: AuthenticationException.USER_NOT_FOUND));

      final UserService userService = UserService(
        firebaseAuthGetaway: firebaseAuthGetaway,
      );

      // ACT && EXPECT
      expect(
        () async =>
            await userService.signInWithEmailAndPassword(email, password),
        throwsA(
          allOf(
            isInstanceOf<AuthenticationException>(),
            predicate((f) => f.code == AuthenticationException.USER_NOT_FOUND),
          ),
        ),
      );
    });

    test('Should expected an Authentication exception (to many request)',
        () async {
      // ARRANGE
      final String email = 'john.doe@domain.tld';
      final String password = '123456';
      final _FirebaseAuthGetaway firebaseAuthGetaway = _FirebaseAuthGetaway();

      when(firebaseAuthGetaway.signInWithEmailAndPassword(email, password))
          .thenThrow(AuthenticationException(
              code: AuthenticationException.TOO_MANY_REQUEST));

      final UserService userService = UserService(
        firebaseAuthGetaway: firebaseAuthGetaway,
      );

      // ACT && EXPECT
      expect(
        () async =>
            await userService.signInWithEmailAndPassword(email, password),
        throwsA(
          allOf(
            isInstanceOf<AuthenticationException>(),
            predicate(
                (f) => f.code == AuthenticationException.TOO_MANY_REQUEST),
          ),
        ),
      );
    });
  });

  group('UserService signUpWithEmailAndPassword', () {
    test('Should create a user with success', () async {
      // ARRANGE
      final String uid = '1234567';
      final String email = 'john.doe@domain.tld';
      final String password = '123456';
      final _FirebaseAuthGetaway firebaseAuthGetaway = _FirebaseAuthGetaway();

      when(firebaseAuthGetaway.signUpWithEmailAndPassword(email, password))
          .thenAnswer(
        (_) => Future.value({
          'uid': uid,
          'email': email,
        }),
      );

      final UserService userService = UserService(
        firebaseAuthGetaway: firebaseAuthGetaway,
      );

      // ACT
      UserModel userModel =
          await userService.signUpWithEmailAndPassword(email, password);

      // ASSERT
      expect(userModel.uid, uid);
      expect(userModel.email, email);
    });

    test('Should expect an AuthenticationException (user-already-exist)',
        () async {
      // ARRANGE
      final String email = 'john.doe@domain.tld';
      final String password = '123456';
      final _FirebaseAuthGetaway firebaseAuthGetaway = _FirebaseAuthGetaway();

      when(firebaseAuthGetaway.signUpWithEmailAndPassword(email, password))
          .thenThrow(
        AuthenticationException(
          code: AuthenticationException.USER_ALREADY_IN_EXISTS,
        ),
      );

      final UserService userService = UserService(
        firebaseAuthGetaway: firebaseAuthGetaway,
      );

      // ACT & ASSERT
      expect(
        () async =>
            await userService.signUpWithEmailAndPassword(email, password),
        throwsA(
          allOf(
            isInstanceOf<AuthenticationException>(),
            predicate((f) =>
                f.code == AuthenticationException.USER_ALREADY_IN_EXISTS),
          ),
        ),
      );
    });
  });
}

class _FirebaseAuthGetaway extends Mock implements FirebaseAuthGetaway {}
