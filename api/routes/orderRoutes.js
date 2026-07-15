const express = require('express');
const router = express.Router();
const controller = require('../controllers/orderController'); 

// Criar pedido
router.post('/', controller.create);

// Listar pedidos de um usuário
router.get('/:usuarioId', controller.listar);

// Atualizar status
router.put('/:id', controller.atualizarStatus);

// Deletar pedido
router.delete('/:id', controller.deletar);


// inserir dados em memória
let pedidos = [];
let itensPedidos = [];
let pedidoId = 1;


// CRIAR PEDIDO

router.post('/', (req, res) => {
  const { usuario_id, total, itens } = req.body;

  if (!usuario_id || !itens || itens.length === 0) {
    return res.status(400).json({ erro: 'Dados inválidos' });
  }

  const novoPedido = {
    id: pedidoId++,
    usuario_id,
    total,
    status: "PENDENTE",
    data: new Date().toISOString(),
  };

  pedidos.push(novoPedido);

  itens.forEach((item) => {
    itensPedidos.push({
      pedido_id: novoPedido.id,
      produto_id: item.produto_id,
      nome: item.nome,
      imagem: item.imagem,
      quantidade: item.quantidade,
      preco: item.preco,
    });
  });

  console.log("PEDIDO CRIADO:", novoPedido);

  res.status(201).json(novoPedido);
});



// LISTAR PEDIDOS DO USUÁRIO

router.get('/:usuarioId', (req, res) => {
  const usuarioId = parseInt(req.params.usuarioId);

  const lista = pedidos.filter(p => p.usuario_id === usuarioId);

  res.json(lista);
});


// BUSCAR PEDIDO POR ID

router.get('/detalhe/:id', (req, res) => {
  const id = parseInt(req.params.id);

  const pedido = pedidos.find(p => p.id === id);

  if (!pedido) {
    return res.status(404).json({ erro: "Pedido não encontrado" });
  }

  res.json(pedido);
});



// LISTAR ITENS DO PEDIDO

router.get('/itens/:pedidoId', (req, res) => {
  const pedidoId = parseInt(req.params.pedidoId);

  const itens = itensPedidos.filter(i => i.pedido_id === pedidoId);

  res.json(itens);
});



// ATUALIZAR STATUS DO PEDIDO


router.put('/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const { status } = req.body;

  console.log("PUT RECEBIDO:", id, status);

  const pedido = pedidos.find(p => p.id === id);

  if (!pedido) {
    return res.status(404).json({ erro: "Pedido não encontrado" });
  }

  pedido.status = status || pedido.status;

  res.status(200).json(pedido);
});

router.put('/:id', controller.atualizarStatus);



// DELETAR PEDIDO

router.delete('/:id', (req, res) => {
  const id = parseInt(req.params.id);

  pedidos = pedidos.filter(p => p.id !== id);
  itensPedidos = itensPedidos.filter(i => i.pedido_id !== id);

  console.log("PEDIDO DELETADO:", id);

  res.json({ mensagem: "Pedido deletado com sucesso" });
});


router.put('/pedidos/:id', (req, res) => {
  console.log("REQ PARAMS:", req.params);
  console.log("REQ BODY:", req.body);

  const { id } = req.params;
  const { status } = req.body;

  const sql = "UPDATE pedidos SET status = ? WHERE id = ?";

  db.query(sql, [status, id], (err, result) => {
    if (err) {
      console.log("ERRO SQL:", err);
      return res.status(500).json(err);
    }

    console.log("RESULT:", result);

    res.json({ ok: true });
  });
});



module.exports = router;