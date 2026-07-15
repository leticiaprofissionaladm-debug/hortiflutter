// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  List<ProductModel> produtos = [];

  @override
  void initState() {
    super.initState();
    carregarProdutos();
  }

  Future carregarProdutos() async {
    try {
      produtos = await ProductService.listar();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(
       
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar produtos: $e')));
    }
  }

  void abrirFormulario({ProductModel? produto}) {
    final nome = TextEditingController(text: produto?.nome ?? '');
    final preco = TextEditingController(text: produto?.preco.toString() ?? '');
    final descricao = TextEditingController(text: produto?.descricao ?? '');

    File? imagemFile;
    Uint8List? imagemBytes;
    String? imagemNome;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(produto == null ? "Novo Produto" : "Editar Produto"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nome,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              TextField(
                controller: preco,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Preço"),
              ),
              TextField(
                controller: descricao,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final XFile? img = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (img != null) {
                    if (kIsWeb) {
                      imagemBytes = await img.readAsBytes();
                      imagemNome = img.name;
                    } else {
                      imagemFile = File(img.path);
                    }
                  }
                },
                child: const Text("Selecionar Imagem"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                if (produto == null) {
                  await ProductService.createProduct(
                    nome: nome.text,
                    preco: preco.text,
                    descricao: descricao.text,
                    imagemPath: imagemFile?.path,
                    imagemBytes: imagemBytes,
                    imagemNome: imagemNome,
                  );
                } else {
                  await ProductService.updateProduct(
                    id: produto.id!,
                    nome: nome.text,
                    preco: preco.text,
                    descricao: descricao.text,
                    imagemPath: imagemFile?.path,
                    imagemBytes: imagemBytes,
                    imagemNome: imagemNome,
                  );
                }
                // ignore: duplicate_ignore
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                carregarProdutos();
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Erro: $e')));
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Produtos")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final p = produtos[index];
          return Card(
            child: ListTile(
              // ignore: unnecessary_null_comparison
              leading: p.imagem != null
                  ? Image.network(
                      "${kIsWeb ? ProductService.baseUrlWeb : ProductService.baseUrlMobile}/uploads/${p.imagem}",
                      width: 50,
                      // ignore: unnecessary_underscores
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    )
                  // ignore: dead_code
                  : const Icon(Icons.image),
              title: Text(p.nome),
              subtitle: Text("R\$ ${p.preco}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => abrirFormulario(produto: p),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        await ProductService.deleteProduct(p.id!);
                        carregarProdutos();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
