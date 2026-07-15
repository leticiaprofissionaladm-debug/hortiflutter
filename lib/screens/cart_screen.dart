// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    await CartService.carregar();
    setState(() {
      loading = false;
    });
  }

  Future<void> finalizarPedido() async {
    final itens = CartService.getItens();

    print("BOTÃO CLICADO");
    print("ITENS: ${itens.length}");

    if (itens.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Carrinho vazio")));
      return;
    }

    bool sucesso = await OrderService.criarPedido(
      1,
      itens,
      CartService.total(),
    );

    if (sucesso) {
      await CartService.limpar();
      await carregar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pedido realizado com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao enviar pedido")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final itens = CartService.getItens();

    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Carrinho")),
      body: Column(
        children: [
          Expanded(
            child: itens.isEmpty
                ? const Center(child: Text("Carrinho vazio"))
                : ListView.builder(
                    itemCount: itens.length,
                    itemBuilder: (_, i) {
                      final item = itens[i];

                      return ListTile(
                        title: Text(item.nome),
                        subtitle: Text("R\$ ${item.preco}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () async {
                                int q = item.quantidade - 1;

                                if (q <= 0) {
                                  await CartService.remover(item.id);
                                } else {
                                  await CartService.alterarQuantidade(
                                    item.id,
                                    q,
                                  );
                                }

                                await carregar();
                              },
                            ),
                            Text(item.quantidade.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () async {
                                await CartService.alterarQuantidade(
                                  item.id,
                                  item.quantidade + 1,
                                );
                                await carregar();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 10),

          Text("Total: R\$ ${CartService.total().toStringAsFixed(2)}"),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: finalizarPedido,
            child: const Text("Finalizar Pedido"),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
