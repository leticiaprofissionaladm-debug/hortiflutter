const db = require('../db');

exports.listar = (req, res) => {
    db.query("select * from produtos", (err, result) => {
        if (err) return res.status(500).json(err);
        res.json(result);
    });
}
exports.create = (req, res) => {
    const { nome, preco, descricao } = req.body;
    const imagem = req.file ? req.file.filename : null;

    const sql = "insert into produtos (nome, preco, descricao,imagem) " +
        " values (?,?,?,?)";

    db.query(sql, [nome, preco, descricao, imagem], (err) => {
        if (err) return res.status(500).json(err);
        res.json({ message: "Produto Criado" });
    });
};
exports.update = (req, res) => {

  const { id } = req.params;
  const { nome, preco, descricao } = req.body;
  const imagem = req.file ? req.file.filename : null;

  const sql = imagem
    ? "UPDATE produtos SET nome=?,preco=?,descricao=?,imagem=? WHERE id=?"
    : "UPDATE produtos SET nome=?,preco=?,descricao=? WHERE id=?";

  const values = imagem
    ? [nome, preco, descricao, imagem, id]
    : [nome, preco, descricao, id];

  db.query(sql, values, (err) => {
    if (err) return res.status(500).json(err);
    res.json({ message: "Produto atualizado" });
  });
};

exports.delete = (req, res) => {
  db.query("DELETE FROM produtos WHERE id=?", [req.params.id], (err) => {
    if (err) return res.status(500).json(err);
    res.json({ message: "Deletado" });
  });
};