
abstract class AuthEvent{
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventlogIn extends AuthEvent{
  final String email;
  final String password;
  const AuthEventlogIn(this.email,this.password);
}

class AuthEventRegister extends AuthEvent{
  final String email;
  final String password;
  AuthEventRegister(this.email, this.password);
}


class AuthEventShouldRegister extends AuthEvent{
  const AuthEventShouldRegister();
}

class AuthEventLogOut extends AuthEvent{
  const AuthEventLogOut();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}