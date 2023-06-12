class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String phone;
  final String? email;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  factory User.fromData(Map<String, dynamic> data) {
    return User(
        userId: data['id'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        phone: data['phone'],
        email: data['email']);
  }
}
