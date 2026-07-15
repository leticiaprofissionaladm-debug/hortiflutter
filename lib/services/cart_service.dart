import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';

class CartService {
  static const String key = "carrinho";
  static List<CartModel> _itens = [];

  static Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data != null) {
      try {
        List list = jsonDecode(data);
        _itens = list.map((e) => CartModel.fromJson(e)).toList();
      } catch (e) {
        _itens = [];
      }
    } else {
      _itens = [];
    }
  }

  static Future<void> salvar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      key,
      jsonEncode(_itens.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> add(CartModel item) async {
    int index = _itens.indexWhere((p) => p.id == item.id);

    if (index >= 0) {
      _itens[index].quantidade += item.quantidade;
    } else {
      _itens.add(item);
    }

    await salvar();
  }

  static Future<void> remover(int id) async {
    _itens.removeWhere((p) => p.id == id);
    await salvar();
  }

  static Future<void> alterarQuantidade(int id, int q) async {
    int index = _itens.indexWhere((p) => p.id == id);

    if (index >= 0) {
      if (q <= 0) {
        _itens.removeAt(index);
      } else {
        _itens[index].quantidade = q;
      }
    }

    await salvar();
  }

  static List<CartModel> getItens() {
    return List.from(_itens);
  }

  static double total() {
    return _itens.fold(
      0,
      (total, item) => total + (item.preco * item.quantidade),
    );
  }

  static Future<void> limpar() async {
    _itens.clear();
    await salvar();
  }
}