class Usuario {
  final int? id;
  final String email;
  final String nombre;
  final String? password;

  Usuario({
    this.id,
    required this.email,
    required this.nombre,
    this.password,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      email: json['email'],
      nombre: json['nombre'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'nombre': nombre,
    };
    if (password != null) {
      data['password'] = password;
    }
    return data;
  }
}
