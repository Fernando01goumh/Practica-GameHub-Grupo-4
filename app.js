const express = require('express');
require('dotenv').config();
const { login, registro } = require('./controllers/authController');

const app = express();

app.use(express.json());

app.post('/api/login', login);
app.post('/api/registro', registro);

app.get('/', (req, res) => {
    res.json({ mensaje: '¡El backend de Game-Hub está funcionando perfectamente con Base de Datos!' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(` Servidor Game-Hub corriendo en http://localhost:${PORT}`);
});