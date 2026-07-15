import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/cart_model.dart';

class OrderScreen extends StatefulWidget {
  final int userId;

  const OrderScreen({super.key, required this.userId});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  List pedidos = [];
  bool loading = true;

  // Simulação de carrinho
  List<CartModel> carrinho = [];

  // Controlador de animação
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutBack,
  );

  @override
  void initState() {
    super.initState();
    carregarPedidos();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  
  // CARREGAR PEDIDOS
 
  Future<void> carregarPedidos() async {
    setState(() => loading = true);

    try {
      final data = await OrderService.listarPedidos(widget.userId);
      setState(() {
        pedidos = data;
      });
    } catch (e) {
      print("Erro ao carregar pedidos: $e");
    }

    setState(() => loading = false);
  }

  
  //ENVIAR PEDIDO COM ANIMAÇÃO E BADGE

  Future<void> enviarPedido() async {
    if (carrinho.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Carrinho vazio!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    double total = 0;
    for (var item in carrinho) {
      total += item.preco * item.quantidade;
    }

    try {
      bool sucesso = await OrderService.criarPedido(
        widget.userId,
        carrinho,
        total,
      );

      if (sucesso) {
        // Adiciona pedido provisório na lista
        final novoPedido = {
          "id": DateTime.now().millisecondsSinceEpoch, // ID temporário
          "total": total,
          "status": "ENVIADO",
          "data_pedido": DateTime.now().toString(),
        };

        setState(() {
          pedidos.insert(0, novoPedido);
          carrinho.clear();
        });

        // Dispara a animação
        _controller.forward(from: 0);

        // SnackBar de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text("Pedido enviado com sucesso!"),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Atualiza a lista com dados reais do banco
        await carregarPedidos();
      } else {
        throw Exception("Erro ao enviar pedido");
      }
    } catch (e) {
      print("ERRO: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao enviar pedido"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  
  // VER ITENS
 
 
  void verItens(int pedidoId) async {
    final itens = await OrderService.listarItensPedido(pedidoId);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Itens do Pedido #$pedidoId"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: itens.length,
            itemBuilder: (_, i) {
              final item = itens[i];

              return ListTile(
                leading:
                    item["imagem"] != null &&
                        item["imagem"].toString().isNotEmpty
                    ? Image.network(
                        "http://10.0.2.2:3000/uploads/${item["imagem"]}",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported),
                      )
                    : const Icon(Icons.image),
                title: Text(item["nome"]),
                subtitle: Text(
                  "Qtd: ${item["quantidade"]} | R\$ ${item["preco"]}",
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  
  // ATUALIZAR STATUS
  
  void atualizarStatus(int id) async {
    try {
      await OrderService.atualizarStatus(id, "ENTREGUE");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Status atualizado!")));
      carregarPedidos();
    } catch (e) {
      print("Erro ao atualizar: $e");
    }
  }

 
  // DELETAR PEDIDO
 
  void deletarPedido(int id) async {
    try {
      await OrderService.deletarPedido(id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pedido deletado")));
      carregarPedidos();
    } catch (e) {
      print("Erro ao deletar: $e");
    }
  }

  
  // interface
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Pedidos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: carregarPedidos,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: enviarPedido,
        child: const Icon(Icons.send),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : pedidos.isEmpty
          ? const Center(child: Text("Nenhum pedido encontrado"))
          : ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (_, i) {
                final pedido = pedidos[i];
                final bool isNovoPedido = pedido["status"] == "ENVIADO";

                Widget card = Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Pedido #${pedido["id"]}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total: R\$ ${pedido["total"]}"),
                        Text("Status: ${pedido["status"]}"),
                        Text("Data: ${pedido["data_pedido"]}"),
                        if (isNovoPedido)
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "✅ Pedido cadastrado com sucesso!",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "itens")
                          // ignore: curly_braces_in_flow_control_structures
                          verItens(pedido["id"]);
                        else if (value == "status")
                          // ignore: curly_braces_in_flow_control_structures
                          atualizarStatus(pedido["id"]);
                        else if (value == "delete")
                          // ignore: curly_braces_in_flow_control_structures
                          deletarPedido(pedido["id"]);
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: "itens", child: Text("Ver Itens")),
                        PopupMenuItem(
                          value: "status",
                          child: Text("Marcar como ENTREGUE"),
                        ),
                        PopupMenuItem(value: "delete", child: Text("Deletar")),
                      ],
                    ),
                  ),
                );

                if (isNovoPedido) {
                  return ScaleTransition(scale: _scaleAnimation, child: card);
                } else {
                  return card;
                }
              },
            ),
    );
  }
}

