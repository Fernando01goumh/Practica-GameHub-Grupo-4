const pool = require('../config/db');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const crypto = require('crypto');

// Función auxiliar para generar IDs únicos como hacían tus compis
const generarId = (prefijo) => prefijo + crypto.randomBytes(4).toString('hex');

// CU-02: INICIAR SESIÓN (LOGIN)
const login = async (req, res) => {
    const { email, password } = req.body;
    try {
        const query = `
            SELECT u.id_usuario, u.password, r.nombre as rol 
            FROM USUARIO u 
            JOIN ROL r ON u.id_rol = r.id_rol 
            WHERE u.email = $1`;
        const result = await pool.query(query, [email]);
        
        if (result.rows.length === 0) return res.status(404).json({ error: 'Usuario no encontrado' });

        const usuario = result.rows[0];

        // En un login real compararíamos con bcrypt. Para los usuarios de prueba directos de SQL:
        const passValida = password === usuario.password || await bcrypt.compare(password, usuario.password);
        if (!passValida) return res.status(401).json({ error: 'Contraseña incorrecta' });

        const token = jwt.sign({ id: usuario.id_usuario, rol: usuario.rol }, process.env.JWT_SECRET, { expiresIn: '2h' });
        res.json({ mensaje: 'Login exitoso', token, rol: usuario.rol });
    } catch (error) {
        res.status(500).json({ error: 'Error interno del servidor' });
    }
};

// CU-01: REGISTRO DE USUARIO
const registro = async (req, res) => {
    const { nombre, username, email, password, password2, id_idioma = 'idioma_es' } = req.body;
    try {
        if (!nombre || !username || !email || !password) {
            return res.status(400).json({ error: 'Todos los campos son obligatorios.' });
        }
        if (password !== password2) {
            return res.status(400).json({ error: 'Las contraseñas no coinciden.' });
        }
        if (password.length < 8) {
            return res.status(400).json({ error: 'La contraseña debe tener al menos 8 caracteres.' });
        }

        const userCheck = await pool.query('SELECT * FROM USUARIO WHERE email = $1 OR username = $2', [email, username]);
        if (userCheck.rows.length > 0) {
            return res.status(400).json({ error: 'El email o el nombre de usuario ya están en uso.' });
        }

        const idUsuario = generarId('usr_');
        const salt = await bcrypt.genSalt(10);
        const hashPassword = await bcrypt.hash(password, salt);
        const rolSuscriptor = 'rol_sus';

        const insertQuery = `
            INSERT INTO USUARIO (id_usuario, nombre, username, email, password, id_idioma, id_rol) 
            VALUES ($1, $2, $3, $4, $5, $6, $7)
        `;
        await pool.query(insertQuery, [idUsuario, nombre, username, email, hashPassword, id_idioma, rolSuscriptor]);

        const token = jwt.sign({ id: idUsuario, rol: 'Suscriptor' }, process.env.JWT_SECRET, { expiresIn: '2h' });
        res.status(201).json({ mensaje: `Bienvenido/a, ${nombre}. Cuenta creada.`, token, rol: 'Suscriptor' });
    } catch (error) {
        res.status(500).json({ error: 'Error interno del servidor' });
    }
};

module.exports = { login, registro };