USE GameHubDB;

-- Insertar Idiomas (Solo Español e Inglés según el CHECK)
insert into idioma (id_idioma, nombre) values
('ID_ESP', 'Español'),
('ID_ENG', 'Inglés');

-- Insertar Roles (Según el CHECK)
INSERT INTO ROL (id_rol, nombre) VALUES 
('ROL_ADMIN', 'Administrador'),
('ROL_REDAC', 'Redactor'),
('ROL_COLAB', 'Colaborador'),
('ROL_SUSCR', 'Suscriptor');

-- Insertar Eventos (fecha_fin >= fecha_inicio)
INSERT INTO EVENTO (id_evento, nombre, descripcion, fecha_inicio, fecha_fin) VALUES 
('EV_E3_2026', 'E3 2026', 'La feria de videojuegos más grande del mundo.', '2026-06-09', '2026-06-12'),
('EV_GAMEA_25', 'The Game Awards', 'Premios a los mejores juegos del año.', '2025-12-10', '2025-12-10');

-- Insertar Contactos (email válido, tipo y estado según el CHECK)
INSERT INTO CONTACTO (id_contacto, nombre, email, tipo, asunto, mensaje, estado) VALUES 
('CONT_001', 'Carlos', 'carlos@email.com', 'Soporte', 'Error al hacer login', 'No me deja acceder a mi cuenta desde ayer.', 'Pendiente'),
('CONT_002', 'Lucía', 'lucia@email.com', 'Sugerencia', 'Añadir más juegos retro', 'Estaría genial una sección de juegos de la SNES.', 'En revisión');

-- Insertar Videojuegos (notas entre 0 y 100)
INSERT INTO VIDEOJUEGO (id_videojuego, titulo, descripcion, nota_prensa, nota_comunidad, fecha_lanzamiento, portada) VALUES 
('VJ_ZELDA_TOTK', 'Zelda: Tears of the Kingdom', 'Secuela de Breath of the Wild.', 96, 92, '2023-05-12', 'https://sm.ign.com/ign_latam/cover/t/the-legend/the-legend-of-zelda-tears-of-the-kingdom_p893.jpg'),
('VJ_CYBERPUNK', 'Cyberpunk 2077', 'Juego de rol futurista en Night City.', 86, 80, '2020-12-10', 'https://upload.wikimedia.org/wikipedia/en/thumb/9/9f/Cyberpunk_2077_box_art.jpg/250px-Cyberpunk_2077_box_art.jpg'),
('VJ_ELDENRING', 'Elden Ring', 'Juego de rol de acción de FromSoftware.', 96, 95, '2022-02-25', 'https://upload.wikimedia.org/wikipedia/en/thumb/b/b9/Elden_Ring_Box_art.jpg/250px-Elden_Ring_Box_art.jpg'),
('VJ_RE2_REMAKE', 'Resident Evil 2 Remake', 'Remake del clásico survival horror de Capcom en Raccoon City.', 91, 90, '2019-01-25', 'https://upload.wikimedia.org/wikipedia/en/f/fd/Resident_Evil_2_Remake.jpg');

-- Insertar Usuarios (username alfanumérico, email válido, password >= 8 chars)
INSERT INTO USUARIO (id_usuario, nombre, username, biografia, email, password, foto_perfil, id_idioma, id_rol) VALUES 
('USR_001', 'Ana López', 'analopez88', 'Apasionada de los RPG.', 'ana@gamehub.com', 'AdminPass123', 'https://ui-avatars.com/api/?name=Ana+Lopez', 'ID_ESP', 'ROL_ADMIN'),
('USR_002', 'David Ruiz', 'davidGamer', 'Me encantan los shooters.', 'david@email.com', 'PasswordSegura', 'https://ui-avatars.com/api/?name=David+Ruiz', 'ID_ESP', 'ROL_REDAC'),
('USR_003', 'Michael Smith', 'mikeGamer99', 'English speaker, love RPGs.', 'michael@email.com', 'Mike12345678', 'https://ui-avatars.com/api/?name=Michael+Smith', 'ID_ENG', 'ROL_SUSCR');

-- Insertar Recursos Multimedia (tipo válido, url empieza con http)
INSERT INTO RECURSO_MULTIMEDIA (id_recurso, id_videojuego, titulo, tipo, autor_externo, plataforma_origen, fecha_publicacion, url_recurso) VALUES 
('REC_001', 'VJ_ZELDA_TOTK', 'Trailer Oficial', 'Trailer', 'Nintendo', 'YouTube', '2023-02-08', 'https://www.youtube.com/watch?v=d9rdl3fGfYQ'),
('REC_002', 'VJ_CYBERPUNK', 'Gameplay Oficial 48 min', 'Video', 'IGN', 'YouTube', '2018-08-27', 'https://www.youtube.com/watch?v=fpu1pfPRLCQ'),
('REC_003', 'VJ_RE2_REMAKE', 'Trailer de Lanzamiento', 'Trailer', 'PlayStation', 'YouTube', '2019-01-23', 'https://www.youtube.com/watch?v=u3wS-Q2KBpk');

-- Insertar Géneros (géneros válidos según el CHECK)
INSERT INTO GENERO (id_videojuego, genero) VALUES 
('VJ_ZELDA_TOTK', 'Aventura'),
('VJ_CYBERPUNK', 'RPG'),
('VJ_CYBERPUNK', 'Acción'),
('VJ_ELDENRING', 'RPG'),
('VJ_RE2_REMAKE', 'Terror');

-- Insertar Publicaciones (tipo válido, título >= 5 chars)
INSERT INTO PUBLICACION (id_publicacion, titulo, contenido, tipo, fecha_publicacion, id_usuario) VALUES 
('PUB_001', 'Análisis de Zelda TOTK', 'Este es un análisis detallado del juego...', 'Análisis', '2023-05-15', 'USR_002'),
('PUB_002', 'Guía para Cyberpunk', 'Cómo conseguir dinero rápido en Night City...', 'Guía', '2021-01-10', 'USR_002');

-- Insertar Comentarios (contenido >= 1 char)
INSERT INTO COMENTARIO (id_comentario, id_publicacion, id_usuario, contenido, fecha_publicacion) VALUES 
('COM_001', 'PUB_001', 'USR_003', 'Great review! I totally agree.', '2023-05-16'),
('COM_002', 'PUB_002', 'USR_001', '¡Muy útil la guía, gracias!', '2021-01-11');

-- Relacionar Videojuegos con Eventos
INSERT INTO INCLUYE (id_videojuego, id_evento) VALUES 
('VJ_ZELDA_TOTK', 'EV_GAMEA_25'),
('VJ_ELDENRING', 'EV_GAMEA_25');

-- Insertar Valoraciones de Usuarios a Videojuegos
INSERT INTO VALORA (id_videojuego, id_usuario, valoracion) VALUES 
('VJ_ZELDA_TOTK', 'USR_003', 95),
('VJ_CYBERPUNK', 'USR_001', 85),
('VJ_ELDENRING', 'USR_002', 98),
('VJ_RE2_REMAKE', 'USR_002', 90);


