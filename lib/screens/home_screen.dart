import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';

import 'admin_dashboard.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'product_detail_screen.dart';



class HomeScreen extends StatefulWidget {
  final int userId;
  final String nome;

  const HomeScreen({Key? key, required this.userId, required this.nome})
    : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> produtos = [];
  bool loading = true;

  // Define o baseUrl dependendo da plataforma
  String get baseUrl => 
      kIsWeb ? "http://localhost:3000" : "http://127.0.0.1:3000";

  @override
  void initState() {
    super.initState();
    carregarProdutos();
  }

  Future<void> carregarProdutos() async {
    setState(() => loading = true);

    try {
      produtos = await ProductService.listar();
    } catch (e) {
      produtos = [];
      debugPrint("Erro ao carregar produtos: $e");
    }

    setState(() => loading = false);
  }

  // Recarrega a Home ao voltar de outra tela
  
  Future<void> navegarParaAdmin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminProductsScreen()),
    );
    await carregarProdutos(); // Atualiza lista depois que voltar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Olá, ${widget.nome}"), centerTitle: true),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : produtos.isEmpty
          ? const Center(child: Text("Nenhum produto encontrado"))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final p = produtos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(produto: p),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        Expanded(
                          child: (p.imagem.isNotEmpty)
                              ? Image.network(
                                  "$baseUrl/uploads/${p.imagem}",
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 80),
                                )
                              : const Icon(Icons.image, size: 80),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text(
                                p.nome,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("R\$ ${p.preco}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) async {
         if (index == 0) return; // Home
          if (index == 1) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          } else if (index == 2) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderScreen(userId: widget.userId),
              ),
            );
          } else if (index == 3) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProfileScreen(nome: widget.nome, userId: widget.userId),
              ),
            );
          } else if (index == 4) {
            await navegarParaAdmin(); // Admin
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Carrinho",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Pedidos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: "Admin",
          ),
        ],
      ),
    );
  }
}
