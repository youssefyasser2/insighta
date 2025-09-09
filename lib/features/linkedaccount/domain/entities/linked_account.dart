class LinkedAccount {
  final String id;
  final String name;
  final String username;
  final String? avatarImage;

  const LinkedAccount({
    required this.id,
    required this.name,
    required this.username,
    this.avatarImage,
  });
}