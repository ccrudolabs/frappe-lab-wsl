# Frappe Lab WSL

Laboratorio profesional para preparar, ejecutar y documentar entornos Frappe/ERPNext sobre WSL, con foco en desarrollo local, contenedores, buenas practicas operativas y seguridad basica del entorno.

## Proposito

Este repositorio sirve como base de laboratorio para validar instalaciones, configuraciones y flujos de trabajo relacionados con Frappe, ERPNext, Python, Node.js, Docker y WSL. Esta pensado para aprendizaje, troubleshooting y armado de ambientes reproducibles.

## Stack y alcance

- Windows Subsystem for Linux (WSL).
- Frappe Framework / ERPNext.
- Python y Node.js.
- Docker y docker-compose cuando aplique.
- Gestion de backups, logs y archivos temporales fuera del control de versiones.

## Buenas practicas incluidas

- `.gitignore` preparado para excluir `.env`, backups, logs, assets generados y archivos temporales.
- Separacion entre laboratorio, configuracion local y datos sensibles.
- Repositorio orientado a reproducibilidad y documentacion tecnica.

## Recomendaciones de uso

1. No commitear archivos `.env`, backups, logs ni datos de sitios reales.
2. Documentar cada ajuste de infraestructura o dependencia.
3. Mantener scripts idempotentes cuando sea posible.
4. Usar ramas para pruebas de configuracion.
5. Registrar errores y soluciones en una seccion de troubleshooting.

## Estructura sugerida

```text
.
├── docs/                 # notas, arquitectura y troubleshooting
├── scripts/              # automatizaciones de setup o mantenimiento
├── compose/              # archivos Docker separados por escenario
├── examples/             # ejemplos sin secretos ni datos reales
└── README.md
```

## Seguridad

Este repositorio no debe contener datos reales de clientes, backups de sitios, claves, tokens, contrasenas ni archivos `.env`. Ver [SECURITY.md](SECURITY.md).

## Autor

Carlos Crudo  
Blog: https://carloscrudo.com/  
LinkedIn: https://www.linkedin.com/in/carloscrudo/
