class UserDTO {
  final String id;
  final String name;
  final String email;
  final String photoUrl;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}