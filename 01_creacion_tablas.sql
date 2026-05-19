-- Crear la base de datos y usarla
create database if not exists GameHubDB;
use GameHubDB;

-- ==========================================
-- 1. CREACIÓN DE TABLAS INDEPENDIENTES
-- ==========================================

create table if not exists IDIOMA(
	id_idioma CHAR(20) primary key,
    nombre VARCHAR(40) not null unique check( nombre in ('Español', 'Inglés'))
);

create table if not exists ROL(
	id_rol CHAR(20) primary key,
    nombre VARCHAR(40) not null unique check( nombre in  ('Administrador', 'Redactor', 'Suscriptor','Colaborador'))
);

CREATE TABLE IF NOT EXISTS EVENTO (
    id_evento CHAR(20) PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL CHECK (LENGTH(nombre) >= 3),
    descripcion TEXT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    CHECK (fecha_fin >= fecha_inicio)
);

CREATE TABLE IF NOT EXISTS CONTACTO (
    id_contacto CHAR(20) PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL CHECK (email LIKE '%@%.%'),
    tipo VARCHAR(30) NOT NULL CHECK (tipo IN ('Soporte', 'Sugerencia', 'Publicidad', 'Otros')),
    asunto TEXT NOT NULL,
    mensaje TEXT NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Pendiente', 'En revisión', 'Respondido'))
);

CREATE TABLE IF NOT EXISTS VIDEOJUEGO (
    id_videojuego CHAR(20) PRIMARY KEY,
    titulo VARCHAR(30) NOT NULL,
    descripcion TEXT NOT NULL,
    nota_prensa INT(3) NULL CHECK (nota_prensa BETWEEN 0 AND 100),
    nota_comunidad INT(3) NULL CHECK (nota_comunidad BETWEEN 0 AND 100),
    fecha_lanzamiento DATE NULL,
    portada VARCHAR(255) NULL
);

-- ==========================================
-- 2. TABLAS CON DEPENDENCIAS SIMPLES 
-- ==========================================

CREATE TABLE IF NOT EXISTS USUARIO (
    id_usuario CHAR(20) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    username VARCHAR(16) NOT NULL UNIQUE CHECK (username REGEXP '^[a-zA-Z0-9]+$'),
    biografia TEXT NULL,
    email VARCHAR(255) NOT NULL UNIQUE CHECK (email LIKE '%@%.%'),
    password VARCHAR(50) NOT NULL CHECK (LENGTH(password) >= 8),
    foto_perfil VARCHAR(255) NULL,
    id_idioma CHAR(20) NOT NULL,
    id_rol CHAR(20) NOT NULL,
    FOREIGN KEY (id_idioma) REFERENCES IDIOMA(id_idioma) ON DELETE RESTRICT,
    FOREIGN KEY (id_rol) REFERENCES ROL(id_rol) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS RECURSO_MULTIMEDIA (
    id_recurso CHAR(20),
    id_videojuego CHAR(20),
    titulo VARCHAR(30) NOT NULL,
    tipo VARCHAR(30) NOT NULL CHECK (tipo IN ('Imagen', 'Video', 'Trailer', 'Captura')),
    autor_externo VARCHAR(30) NULL,
    plataforma_origen VARCHAR(30) NULL,
    fecha_publicacion DATE NOT NULL,
    url_recurso VARCHAR(255) NOT NULL CHECK (url_recurso LIKE 'http%'),
    PRIMARY KEY (id_recurso, id_videojuego),
    FOREIGN KEY (id_videojuego) REFERENCES VIDEOJUEGO(id_videojuego) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS GENERO (
    id_videojuego CHAR(20),
    genero VARCHAR(30) CHECK (genero IN ('Acción', 'Aventura', 'RPG', 'Shooter', 'Deportes', 'Estrategia', 'Simulación', 'Terror')),
    PRIMARY KEY (id_videojuego, genero),
    FOREIGN KEY (id_videojuego) REFERENCES VIDEOJUEGO(id_videojuego) ON DELETE CASCADE
);

-- ==========================================
-- 3. TABLAS CON MÚLTIPLES DEPENDENCIAS
-- ==========================================

CREATE TABLE IF NOT EXISTS PUBLICACION (
    id_publicacion CHAR(20) PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL CHECK (LENGTH(titulo) >= 5),
    contenido TEXT NOT NULL,
    tipo VARCHAR(30) NOT NULL CHECK (tipo IN ('Noticia', 'Artículo', 'Guía', 'Análisis')),
    fecha_publicacion DATE NOT NULL,
    id_usuario CHAR(20) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS COMENTARIO (
    id_comentario CHAR(20),
    id_publicacion CHAR(20),
    id_usuario CHAR(20),
    contenido TEXT NOT NULL CHECK (LENGTH(contenido) >= 1),
    fecha_publicacion DATE NOT NULL,
    PRIMARY KEY (id_comentario, id_publicacion, id_usuario),
    FOREIGN KEY (id_publicacion) REFERENCES PUBLICACION(id_publicacion) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- ==========================================
-- 4. TABLAS INTERMEDIAS (Relaciones N:M)
-- ==========================================

CREATE TABLE IF NOT EXISTS INCLUYE (
    id_videojuego CHAR(20),
    id_evento CHAR(20),
    PRIMARY KEY (id_videojuego, id_evento),
    FOREIGN KEY (id_videojuego) REFERENCES VIDEOJUEGO(id_videojuego) ON DELETE CASCADE,
    FOREIGN KEY (id_evento) REFERENCES EVENTO(id_evento) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS VALORA (
    id_videojuego CHAR(20),
    id_usuario CHAR(20),
    valoracion INT(3) NULL CHECK (valoracion BETWEEN 0 AND 100),
    PRIMARY KEY (id_videojuego, id_usuario),
    FOREIGN KEY (id_videojuego) REFERENCES VIDEOJUEGO(id_videojuego) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);