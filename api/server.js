
const express = require('express');
const cors = require('cors');
const userRoutes = require('./routes/userRoutes');
const path = require('path');
const multer = require('multer');

const app = express();

app.use(cors());
app.use(express.json());


// UPLOAD de uma imagem

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    const nomeArquivo = Date.now() + path.extname(file.originalname);
    cb(null, nomeArquivo);
  },
});

const upload = multer({ storage });

// SERVIR IMAGENS
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));


// ROTAS BASE

app.use('/usuarios', userRoutes);
app.use('/produtos', require('./routes/productRoutes'));


// BANCO EM MEMÓRIA

let produtos = [];
let pedidos = [];
let itensPedidos = [];
let pedidoId = 1;

// PRODUTOS

app.get('/produtos', (req, res) => {
  res.json(produtos);
});

app.post('/produtos', upload.single('imagem'), (req, res) => {
  const { nome, preco, descricao } = req.body;

  const produto = {
    id: Date.now(),
    nome,
    preco,
    descricao,
    imagem: req.file ? req.file.filename : "",
  };

  produtos.push(produto);

  res.status(201).json(produto);
});



// CRIAR PEDIDO
app.use('/pedidos', require('./routes/orderRoutes')); // novo código para usar as rotas de pedidos
app.post('/pedidos', (req, res) => {
  const { usuario_id, total, itens } = req.body;

  const novoPedido = {
    id: pedidoId++,
    usuario_id,
    total,
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

  res.status(201).json(novoPedido);
});

// LISTAR PEDIDOS
app.get('/pedidos/:usuarioId', (req, res) => {
  const usuarioId = parseInt(req.params.usuarioId);

  const resultado = pedidos.filter(
    (p) => p.usuario_id === usuarioId
  );

  res.json(resultado);
});

// ITENS DO PEDIDO
app.get('/pedidos/itens/:pedidoId', (req, res) => {
  const pedidoIdParam = parseInt(req.params.pedidoId);

  const resultado = itensPedidos.filter(
    (i) => i.pedido_id === pedidoIdParam
  );

  res.json(resultado);
});


//teste de rota para verificar se o servidor está funcionando

app.get('/', (req, res) => {
  res.send('API funcionando');
});


app.post('/pedidos', (req, res) => {
  console.log("BODY RECEBIDO:", req.body);
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Servidor rodando em http://127.0.0.1:3000');
});