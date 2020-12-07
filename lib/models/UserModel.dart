class UserModel {
  static const String UID = 'uid';
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';
  static const String USERNAME = 'username';
  static const String STATUS = 'status';
  static const String AVATAR_URL = 'avatarURL';
  // static const String DOCUMENT_REFERENCE = 'documentReference';

  final String uid;
  final String email;
  final String password;
  final String username;
  final String status;
  // final DocumentReference documentReference;

  String avatarURL;

  UserModel({
    this.uid,
    this.email,
    this.password,
    this.username,
    this.status,
    this.avatarURL,
    // this.documentReference,
  });

  set avatar(String value) => avatarURL = value;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    uid: json[UserModel.UID] as String,
    email: json[UserModel.EMAIL] as String,
    username: json[UserModel.USERNAME] as String,
    status: json[UserModel.STATUS] as String,
    avatarURL: json[UserModel.AVATAR_URL] as String,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      UserModel.UID: instance.uid,
      UserModel.EMAIL: instance.email,
      UserModel.USERNAME: instance.username,
      UserModel.STATUS: instance.status,
      UserModel.AVATAR_URL: instance.avatarURL,
    };
