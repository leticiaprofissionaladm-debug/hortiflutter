import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../services/cart_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel produto;

  const ProductDetailScreen({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(produto.nome)),

      body: Column(
        children: [
          Image.network("http://127.0.0.1:3000/uploads/${produto.imagem}"),

          Text(produto.nome, style: const TextStyle(fontSize: 20)),
          Text("R\$ ${produto.preco}"),

          ElevatedButton(
            onPressed: () async {
              await CartService.add(
                CartModel(
                  id: produto.id!,
                  nome: produto.nome,
                  preco: produto.preco,
                  imagem: produto.imagem,
                  quantidade: 1,
                ),
              );

              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Adicionado ao carrinho")),
              );
            },
            child: const Text("Adicionar ao carrinho"),
          ),
        ],
      ),
    );
  }
}
