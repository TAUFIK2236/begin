import 'package:test/test.dart';
import 'package:untitled/services/auth/auth_except.dart';
import 'package:untitled/services/auth/auth_provider.dart';
import 'package:untitled/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();


    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });


    test(
        "Cannot log out if not initialized",
        () {expect(
              provider.logOut(),
              throwsA(const TypeMatcher<NotInitializedException>()),
        );
        });


    test("Should be able to be initialized", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });


    test("User Should be null after  initialization", () async {
      await provider.initialize();
      expect(provider.currentUser,null);
    });


    test("Should be able to initialize in less then 2 seconds", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));


    test("Create user delegate to login function", () async {
      final badEmailUser = provider.createUser(
        email: "tau@gmail.com",
        password: "1313556",
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));


      final badPasswordUser = provider.createUser(
        email: "adasd@gmail.com",
        password: '1313',
      );

      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: "yooo",
        password: "booo",
      );
      expect(provider.currentUser,user);
      expect(user.isEmailVerified, false);
    });


    test("logged in user should be able to get verified", (){
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified,true);
    });

    test("Should be able to log out and log in again", ()async{
      await provider.logOut();
      await provider.logIn(
        email: "email",
        password: "password",
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  })  {
    if (!isInitialized) throw NotInitializedException();
    if (email == "tau@gmail.com") throw UserNotFoundAuthException();
    if (password == "1313") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: '', id: '');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }


  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: '', id: '');
    _user = newUser;
  }
}
