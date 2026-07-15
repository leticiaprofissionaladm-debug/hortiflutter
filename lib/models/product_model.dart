class ProductModel {
  final int? id;
  final String nome;
  final double preco;
  final String descricao;
  final String imagem;

  ProductModel({
    required this.id,
    required this.nome,
    required this.preco,
    required this.descricao,
    required this.imagem
  });

  factory ProductModel.fromJson(Map json){
    return ProductModel(
      id: json["id"], 
      nome:json["nome"], 
      preco: double.parse(json["preco"].toString()), 
      descricao:json["descricao"], 
      imagem: json["imagem"]);
  }
}