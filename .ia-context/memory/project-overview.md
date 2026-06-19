# Memoria — Visión General del Proyecto

## Identidad del sistema
- **Nombre interno**: Facturacion
- **Empresa**: PFP
- **Versión original**: 1.0.0
- **Dominio**: Gestión de taller automotriz (mantenimiento de vehículos)
- **Estado**: En producción / funcionando

## Stack original
| Capa | Tecnología |
|------|-----------|
| Lenguaje | Visual FoxPro (VFP) |
| Framework UI | CodeMine (librería `common50/codemine`) |
| Base de datos principal | SQL Server |
| BD auxiliar | Tablas DBF locales |
| Reportes | Crystal Reports v9 |
| Comunicación VFP→SQL | `SQLEXEC()` con SQL inline y `exec sp_nombre` |

## Estructura de carpetas original
```
ControlVehiculosIA-main/
├── Source/         Formularios (.scx/.sct), menús (.mnx), clases (.vcx), main (.prg)
├── Data/           Tablas DBF locales + bitmaps de temas + clases de botones (.vcx)
├── DATABASE/       Backup SQL Server (db_Control_AutomotrizIA, 6.2 MB)
├── Graphics/       Iconos (.ico)
├── CLAUDE.md       Documentación para Claude Code
└── .ia-context/    Este directorio de contexto IA
```

## Punto de entrada
- `Source/appmain.prg` — programa principal
- `Source/config.fpw` — configuración VFP (`TITLE=Facturacion`, `SCREEN=OFF`)
- `Source/appdefs.h` — constantes (`COMPANYNAME_LOC`, `APPNAME_LOC`, `VERSION_LOC`)
- `Source/APPMENU.MPR` — definición del menú principal

## Flujo de inicio de la aplicación
```
appmain.prg
  → SET CLASSLIB TO AppMain, AppForms
  → CreateGlobalObject('appApplication')
  → goApp.Start()
  → frm_selecciona_empresas  (login + selección empresa)
  → define nEmpresa, cPeriodo globales
  → frm_menu_principal       (menú gráfico)
```

## Números del sistema
- 40 formularios (.scx)
- 17 tablas en SQL Server
- 30+ stored procedures
- 9 reportes Crystal Reports
- 3 variables globales de sesión
- 8 formularios con conexiones SQL Server hardcodeadas
