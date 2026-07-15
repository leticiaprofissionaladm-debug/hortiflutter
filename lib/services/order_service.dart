import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_model.dart';

class OrderService {
  static String get baseUrl => "http://127.0.0.1:3000";
  static String get url => "$baseUrl/pedidos";

  // ==============================
  // CRIAR PEDIDO
  // ==============================
  static Future<bool> criarPedido(
    int usuarioId,
    List<CartModel> carrinho,
    double total,
  ) async {
    final itens = carrinho
        .map(
          (p) => {
            "produto_id": p.id,
            "nome": p.nome,
            "imagem": p.imagem,
            "quantidade": p.quantidade,
            "preco": p.preco,
          },
        )
        .toList();

    final body = {"usuario_id": usuarioId, "total": total, "itens": itens};


    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );


    return response.statusCode == 200 || response.statusCode == 201;
  }

  // ==============================
  // LISTAR PEDIDOS
  // ==============================
  static Future<List<dynamic>> listarPedidos(int usuarioId) async {
    final response = await http.get(Uri.parse("$url/$usuarioId"));


    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro pedidos");
    }
  }

  // ==============================
  // ITENS DO PEDIDO
  // ==============================
  static Future<List<dynamic>> listarItensPedido(int pedidoId) async {
    final response = await http.get(Uri.parse("$url/itens/$pedidoId"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro itens");
    }
  }

  // ATUALIZAR STATUS
  static Future<void> atualizarStatus(int id, String status) async {
    final response = await http.put(
      Uri.parse("$url/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": status}),
    );

    // ignore: avoid_print
    print("STATUS CODE: ${response.statusCode}");
    // ignore: avoid_print
    print("BODY: ${response.body}");

    if (response.statusCode != 200) {
      // ignore: avoid_print
      print("ERRO COMPLETO: ${response.body}");
      throw Exception("Erro: ${response.statusCode}");
    }
  }

  // DELETAR
  static Future<void> deletarPedido(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));

    if (response.statusCode != 200) {
      throw Exception("Erro ao deletar pedido");
    }
  }
}
