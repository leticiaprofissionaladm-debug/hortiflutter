const express = require('express');
const router = express.Router();
const db = require('../db');

// REGISTER
router.post('/register', (req, res) => {
  const { login, senha, nome, cpf, email, data_nascimento, foto } = req.body;

  const sql = `
    INSERT INTO usuarios 
    (login, senha, nome, cpf, email, data_nascimento, foto) 
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(sql, [login, senha, nome, cpf, email, data_nascimento, foto], (err, result) => {
    if (err) {
      console.log(err);
      return res.status(500).json({ erro: err });
    }

    res.status(201).json({ message: "Usuário cadastrado com sucesso" });
  });
});

// LOGIN
router.post('/login', (req, res) => {
  const { login, senha } = req.body;

  const sql = "SELECT * FROM usuarios WHERE login = ? AND senha = ?";

  db.query(sql, [login, senha], (err, results) => {
    if (err) {
      return res.status(500).json({ erro: err });
    }

    if (results.length > 0) {
      res.json(results[0]);
    } else {
      res.status(401).json({ message: "Credenciais inválidas" });
    }
  });
});

module.exports = router;
