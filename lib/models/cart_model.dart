class CartModel {
  int id;
  String nome;
  double preco;
  String imagem;
  int quantidade;

  CartModel({
    required this.id,
    required this.nome,
    required this.preco,
    required this.imagem,
    required this.quantidade
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json["id"],
      nome: json["nome"],
      preco: double.parse(json["preco"].toString()),
      imagem: json["imagem"],
      quantidade: json["quantidade"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "preco": preco,
    "imagem": imagem,
    "quantidade": quantidade,
  };

}