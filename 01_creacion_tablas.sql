-- ============================================================
-- GAME-HUB & SERVICES ECOSYSTEM - POSTGRESQL (Grupo 4)
-- ============================================================

-- ==========================================
-- 1. CREACIÓN DE TABLAS INDEPENDIENTES
-- ==========================================

CREATE TABLE IDIOMA (
    id_idioma   CHAR(20)    PRIMARY KEY,
    nombre      VARCHAR(40) NOT NULL UNIQUE,
    CONSTRAINT chk_idioma_nombre CHECK (nombre IN ('Español', 'Inglés'))
);

CREATE TABLE ROL (
    id_rol  CHAR(20)    PRIMARY KEY,
    nombre  VARCHAR(30) NOT NULL UNIQUE,
    CONSTRAINT chk_rol_nombre CHECK (nombre IN ('Administrador', 'Redactor', 'Colaborador', 'Suscriptor'))
);

CREATE TABLE EVENTO (
    id_evento   CHAR(20)    PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    descripcion TEXT        NOT NULL,
    fecha_inicio DATE       NOT NULL,
    fecha_fin   DATE       NOT NULL,
    CONSTRAINT chk_evento_fechas  CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT chk_evento_nombre  CHECK (LENGTH(nombre) >= 3)
);

CREATE TABLE CONTACTO (
    id_contacto CHAR(20)    PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL,
    tipo        VARCHAR(30) NOT NULL,
    asunto      TEXT        NOT NULL,
    mensaje     TEXT        NOT NULL,
    estado      VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    fecha       TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_contacto_email  CHECK (email LIKE '%@%.%'),
    CONSTRAINT chk_contacto_estado CHECK (estado IN ('Pendiente','En revisión','Respondido')),
    CONSTRAINT chk_contacto_tipo   CHECK (tipo  IN ('Soporte','Sugerencia','Publicidad','Otros'))
);

CREATE TABLE VIDEOJUEGO (
    id_videojuego       CHAR(20)        PRIMARY KEY,
    titulo              VARCHAR(100)    NOT NULL,
    descripcion         TEXT            NOT NULL,
    nota_prensa         INT             NULL,
    nota_comunidad      INT             NULL,
    fecha_lanzamiento   DATE            NULL,
    portada             VARCHAR(255)    NULL,
    CONSTRAINT chk_vj_nota_prensa    CHECK (nota_prensa    IS NULL OR (nota_prensa    >= 0 AND nota_prensa <= 100)),
    CONSTRAINT chk_vj_nota_comunidad CHECK (nota_comunidad IS NULL OR (nota_comunidad >= 0 AND nota_comunidad <= 100))
);

-- ==========================================
-- 2. TABLAS CON DEPENDENCIAS SIMPLES 
-- ==========================================

CREATE TABLE USUARIO (
    id_usuario  CHAR(20)        PRIMARY KEY,
    nombre      VARCHAR(20)     NOT NULL,
    username    VARCHAR(16)     NOT NULL UNIQUE,
    biografia   TEXT            NULL,
    email       VARCHAR(255)    NOT NULL UNIQUE,
    password    VARCHAR(255)    NOT NULL,
    foto_perfil VARCHAR(255)    NULL,
    id_idioma   CHAR(20)        NOT NULL,
    id_rol      CHAR(20)        NOT NULL,
    fecha_registro TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activo      BOOLEAN         NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_usuario_idioma FOREIGN KEY (id_idioma) REFERENCES IDIOMA(id_idioma) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_rol    FOREIGN KEY (id_rol)    REFERENCES ROL(id_rol)    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_usuario_email    CHECK (email LIKE '%@%.%'),
    CONSTRAINT chk_usuario_password CHECK (LENGTH(password) >= 8),
    CONSTRAINT chk_usuario_username CHECK (username ~ '^[a-zA-Z0-9_]+$')
);

CREATE TABLE RECURSO_MULTIMEDIA (
    id_recurso          CHAR(20)        NOT NULL,
    id_videojuego       CHAR(20)        NOT NULL,
    titulo              VARCHAR(100)    NOT NULL,
    tipo                VARCHAR(30)     NOT NULL,
    autor_externo       VARCHAR(100)    NULL,
    plataforma_origen   VARCHAR(50)     NULL,
    fecha_publicacion   DATE            NOT NULL,
    url_recurso         VARCHAR(255)    NOT NULL,
    PRIMARY KEY (id_recurso, id_videojuego),
    CONSTRAINT fk_recurso_vj FOREIGN KEY (id_videojuego) REFERENCES VIDEOJUEGO(id_videojuego) ON DELETE CASCADE,
    CONSTRAINT chk_recurso_tipo CHECK (tipo IN ('Imagen','Video','Trailer','Captura')),
    CONSTRAINT chk_recurso_url  CHECK (url_recurso LIKE 'http%'),
    CONSTRAINT chk_recurso_fecha CHECK (fecha_publicacion <= CURRENT_DATE)
);

CREATE TABLE GENERO (
    id_videojuego   CHAR(20)    NOT NULL,
    genero          VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_videojuego, genero),
    CONSTRAINT fk_genero_vj  FOREIGN KEY (id_videojuego) REFERENCES VIDEOJUEGO(id_videojuego) ON DELETE CASCADE,
    CONSTRAINT chk_genero    CHECK (genero IN ('Acción','Aventura','RPG','Shooter','Deportes','Estrategia','Simulación','Terror'))
);

-- ==========================================
-- 3. TABLAS CON MÚLTIPLES DEPENDENCIAS
-- ==========================================

CREATE TABLE PUBLICACION (
    id_publicacion      CHAR(20)        PRIMARY KEY,
    titulo              VARCHAR(200)    NOT NULL,
    contenido           TEXT            NOT NULL,
    tipo                VARCHAR(30)     NOT NULL,
    fecha_publicacion   DATE            NOT NULL,
    id_usuario          CHAR(20)        NOT NULL,
    imagen_portada      VARCHAR(255)    NULL,
    estado              VARCHAR(20)     NOT NULL DEFAULT 'publicado',
    CONSTRAINT fk_pub_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    CONSTRAINT chk_pub_tipo  CHECK (tipo IN ('Noticia','Artículo','Guía','Análisis','Blog')),
    CONSTRAINT chk_pub_fecha CHECK (fecha_publicacion <= CURRENT_DATE),
    CONSTRAINT chk_pub_titulo CHECK (LENGTH(titulo) >= 5),
    CONSTRAINT chk_pub_estado CHECK (estado IN ('publicado','borrador'))
);

CREATE TABLE COMENTARIO (
    id_comentario       CHAR(20)    NOT NULL,
    id_publicacion      CHAR(20)    NOT NULL,
    id_usuario          CHAR(20)    NOT NULL,
    contenido           TEXT        NOT NULL,
    fecha_publicacion   DATE        NOT NULL,
    moderado            BOOLEAN     NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id_comentario, id_publicacion),
    CONSTRAINT fk_com_pub     FOREIGN KEY (id_publicacion) REFERENCES PUBLICACION(id_publicacion) ON DELETE CASCADE,
    CONSTRAINT fk_com_usuario FOREIGN KEY (id_usuario)     REFERENCES USUARIO(id_usuario)         ON DELETE CASCADE,
    CONSTRAINT chk_com_contenido CHECK (LENGTH(contenido) >= 1),
    CONSTRAINT chk_com_fecha     CHECK (fecha_publicacion <= CURRENT_DATE)
);

-- ==========================================
-- 4. TABLAS INTERMEDIAS (Relaciones N:M)
-- ==========================================

CREATE TABLE INCLUYE (
    id_evento       CHAR(20) NOT NULL,
    id_videojuego   CHAR(20) NOT NULL,
    PRIMARY KEY (id_evento, id_videojuego),
    CONSTRAINT fk_incluye_evento FOREIGN KEY (id_evento)     REFERENCES EVENTO(id_evento)         ON DELETE CASCADE,
    CONSTRAINT fk_incluye_vj    FOREIGN KEY (id_videojuego)  REFERENCES VIDEOJUEGO(id_videojuego) ON DELETE CASCADE
);

CREATE TABLE VALORA (
    id_usuario      CHAR(20)    NOT NULL,
    id_videojuego   CHAR(20)    NOT NULL,
    valoracion      INT         NOT NULL,
    PRIMARY KEY (id_usuario, id_videojuego),
    CONSTRAINT fk_valora_usuario FOREIGN KEY (id_usuario)    REFERENCES USUARIO(id_usuario)       ON DELETE CASCADE,
    CONSTRAINT fk_valora_vj      FOREIGN KEY (id_videojuego) REFERENCES VIDEOJUEGO(id_videojuego) ON DELETE CASCADE,
    CONSTRAINT chk_valora_rango  CHECK (valoracion >= 0 AND valoracion <= 100)
);
