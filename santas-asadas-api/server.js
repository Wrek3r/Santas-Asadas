require('dotenv').config();
const express = require('express');
const jwt     = require('jsonwebtoken');
const cors    = require('cors');
const helmet  = require('helmet');

const app = express();

// ─── HTTPS local ──────────────────────────────────────────────
// Para HTTPS local instala: npm i -g local-ssl-proxy
// Corre: local-ssl-proxy --source 3443 --target 3000
// Flutter apuntará a https://localhost:3443

// ─── CORS configurado ─────────────────────────────────────────
app.use(cors({
  origin: ['http://localhost', 'http://10.0.2.2'], // emulador Android
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// ─── Headers de seguridad básicos (Helmet) ────────────────────
app.use(helmet());                        // X-Content-Type-Options
                                          // X-Frame-Options
                                          // Strict-Transport-Security
                                          // etc.
app.use(express.json());

// ─── Middleware: verificar JWT ─────────────────────────────────
function verificarToken(req, res, next) {
  const auth = req.headers['authorization'];
  if (!auth || !auth.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Token requerido' });
  }
  try {
    req.usuario = jwt.verify(auth.split(' ')[1], process.env.JWT_SECRET);
    next();
  } catch (e) {
    return res.status(401).json({ error: 'Token inválido o expirado' });
  }
}

// ─── Ruta: Registro ───────────────────────────────────────────
app.post('/api/registro', (req, res) => {
  const { nombre, telefono, direccion, referencias } = req.body;

  if (!nombre || !telefono || !direccion) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  // Genera el JWT con los datos del usuario
  const token = jwt.sign(
    { nombre, telefono, direccion, referencias },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN }
  );

  res.json({ token });
});

// ─── Ruta: Pedido (protegida con JWT) ─────────────────────────
app.post('/api/pedido', verificarToken, (req, res) => {
  const { items, total } = req.body;
  const usuario = req.usuario; // datos del token

  console.log(`Pedido de ${usuario.nombre}:`, items);

  // Aquí guardarías en DB si tuvieras una
  res.json({ mensaje: 'Pedido recibido', cliente: usuario.nombre, total });
});

// ─── Ruta: Verificar sesión ────────────────────────────────────
app.get('/api/sesion', verificarToken, (req, res) => {
  res.json({ valido: true, usuario: req.usuario });
});

app.listen(process.env.PORT, '0.0.0.0', () => {
  console.log(`Servidor corriendo en http://localhost:${process.env.PORT}`);
});