class UserModel {
 final int? id;
  final String login;
  final String senha;
  final String nome;
  final String cpf;
  final String email;
  final String dataNascimento;
  final String?foto;

  UserModel({
    this.id,
    required this.login,
    required this.senha,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.dataNascimento,
    this.foto,
  });

  //enviar para a API
  Map<String, dynamic> toJson(){
    return{
      
      "login":login,
      "senha":senha,
      "nome":nome,
      "cpf":cpf,
      "email":email,
      "data_nascimento":dataNascimento,
      "foto":foto
    };
  }
  //receba da API
  factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json["id"],
    login: json["login"] ?? "",
    senha: json["senha"] ?? "",
    nome: json["nome"] ?? "",
    cpf: json["cpf"] ?? "",
    email: json["email"] ?? "",
    dataNascimento: json["data_nascimento"] ?? "",
    foto: json["foto"],
  );
}
  
}