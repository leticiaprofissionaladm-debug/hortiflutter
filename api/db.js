const mysql = require('mysql2');
const db = mysql.createConnection({
    host:'localhost',
   
    user:'root',
    password: '',
    database:'sistema_login'
});
db.connect((err)=> {
    if (err) {
        console.log("erro ao conectar",err);
    }else{
        console.log("Conectado ao MYSQL");
    }
});
module.exports = db;