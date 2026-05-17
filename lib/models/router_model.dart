class RouterModel {
  final String name;
  final String host;
  final String username;
  final String password;
  final int port;

  RouterModel({
    required this.name,
    required this.host,
    required this.username,
    required this.password,
    this.port = 8728,
  });
}
