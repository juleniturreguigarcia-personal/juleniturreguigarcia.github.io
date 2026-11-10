# Julen Iturregui García

Web personal de **Julen Iturregui García**, monitor de ocio y tiempo libre y Técnico Superior en Desarrollo de Aplicaciones Web. Una página de presentación, hecha con HTML y CSS sin dependencias, que reúne en un solo lugar los enlaces de contacto, LinkedIn, el currículum en español e inglés y sus redes.

**Dominio:** <https://juleniturreguigarcia.dpdns.org>

## Publicación

La web se publica desde la rama `main` con GitHub Pages ("Deploy from a branch").

## Versiones de caché (`?v=`)

El hook `pre-commit` ejecuta `scripts/versionar-assets.ps1` y actualiza los `?v=<hash>` de `index.html` antes de cada commit. Así, cuando cambia el CSS, un PDF o una imagen, el navegador descarga la versión nueva en vez de usar la copia antigua.

Si clonas el repositorio en otro equipo, instala el hook una vez:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/instalar-hooks.ps1
```

> Nota: si editas archivos directamente desde la web de GitHub, el hook no se ejecuta y los `?v=` no se actualizan.