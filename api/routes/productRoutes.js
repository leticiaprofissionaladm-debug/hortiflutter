const router = require('express').Router();
const upload = require('../upload');
const controller =  require('../controllers/productController');


router.get('/',controller.listar);
router.post('/',upload.single('imagem'),controller.create);
router.put('/:id',upload.single('imagem'),controller.update);
router.delete('/:id',controller.delete);

module.exports = router;