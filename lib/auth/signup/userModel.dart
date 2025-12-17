class UserModel {
  final String uid;
  final String email;
  final String name;
  final bool emailVerified;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.emailVerified,
  });

  // Convert Model → Map (Firestore save)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'emailVerified': emailVerified,
    };
  }

  // Convert Map → Model (Firestore read)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      emailVerified: map['emailVerified'] ?? false,
    );
  }
}
