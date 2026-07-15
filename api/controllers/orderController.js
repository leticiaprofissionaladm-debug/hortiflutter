const db = require('../db');

exports.create = (req,res) => {
    const { usuario_id, total,itens } = req.body;
    
    const sqlPedido = "insert into pedidos (usuario_id, total, status, data_pedido) "
    +" values(?,?,'pendente',now())";

    db.query(sqlPedido, [usuario_id,total], (err,result) =>{
        if(err) return res.status(500).json(err);
        const pedidoId = result.insertId;
        itens.forEach(item => {
            db.query("insert into pedido_itens(pedido_id,produto_id,quantidade,preco) "+
                " values(?,?,?,?)",[pedidoId,item.produto_id,item.quantidade,item.preco]);
        });
        res.json({ message: "Pedido Criado",pedidoId});
    });
};
//inserir aquiii
// Listar pedidos
exports.listar = (req, res) => {
  db.query("SELECT * FROM pedidos", (err, result) => {
    if (err) return res.status(500).json(err);
    res.json(result);
  });
};

// Atualizar status do pedido
exports.atualizarStatus = (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  const sql = "UPDATE pedidos SET status = ? WHERE id = ?";
  db.query(sql, [status, id], (err, result) => {
    if (err) return res.status(500).json({ erro: err });

    res.json({ mensagem: "Status atualizado com sucesso" });
  });
};

// Deletar pedido
exports.deletar = (req, res) => {
  const { id } = req.params;

  db.query("DELETE FROM pedidos WHERE id = ?", [id], (err, result) => {
    if (err) return res.status(500).json({ erro: err });

    db.query("DELETE FROM pedido_itens WHERE pedido_id = ?", [id], (err2) => {
      if (err2) return res.status(500).json({ erro: err2 });
      res.json({ mensagem: "Pedido deletado com sucesso" });
    });
  });
};