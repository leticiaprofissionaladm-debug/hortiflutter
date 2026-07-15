import 'package:hortiflutter/screens/cart_screen.dart';
import 'package:hortiflutter/screens/orders_screen.dart';
import 'package:flutter/material.dart';

import 'admin_dashboard.dart';

class ProfileScreen extends StatelessWidget {
  final String nome;
  final int userId;
  final String? email;
  final String? foto;

  const ProfileScreen({
    super.key,
    required this.nome,
    required this.userId,
    this.email,
    this.foto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perfil"), centerTitle: true),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // FOTO
            CircleAvatar(
              radius: 50,
              backgroundImage: foto != null
                  ? NetworkImage("http://127.0.0.1:3000/uploads/$foto")
                  : null,
              child: foto == null ? const Icon(Icons.person, size: 50) : null,
            ),

            const SizedBox(height: 10),

            // NOME
            Text(
              nome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // EMAIL
            if (email != null)
              Text(email!, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            const Divider(),

            // PEDIDOS
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("Meus Pedidos"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderScreen(userId: userId),
                  ),
                );
              },
            ),

            // CARRINHO
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Meu Carrinho"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),

            // ADMIN
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text("Painel Admin"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminProductsScreen()),
                );
              },
            ),

            const Divider(),

            // LOGOUT
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Sair", style: TextStyle(color: Colors.red)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Sair"),
                    content: const Text("Deseja sair da conta?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar"),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          );
                        },
                        child: const Text("Sair"),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
