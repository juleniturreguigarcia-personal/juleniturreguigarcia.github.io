<#
  Añade (o actualiza) la versión ?v=<hash> a los archivos locales
  referenciados en index.html (css/, docs/ e images/).

  El hash se calcula a partir del CONTENIDO del archivo, así que la URL
  solo cambia cuando el archivo cambia. El workflow lo ejecuta al publicar.

  Uso local (solo muestra el resultado, no escribe):
    powershell -ExecutionPolicy Bypass -File scripts/versionar-assets.ps1 -DryRun
#>

param(
  [string]$HtmlPath = (Join-Path (Split-Path -Parent $PSScriptRoot) 'index.html'),
  [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

# Carpeta raíz del repositorio (la que contiene index.html, css/, docs/ e images/)
$raiz = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path -LiteralPath $HtmlPath)) {
  throw "No se encuentra el HTML: $HtmlPath"
}

$html = Get-Content -LiteralPath $HtmlPath -Raw -Encoding UTF8

# Coincide con href="..." y src="..." que apunten a css/, docs/ o images/,
# tenga o no ya un ?v=...
$patron = '(?<attr>href|src)="(?<ruta>(?:css|docs|images)/[^"?]+)(?:\?v=[^"]*)?"'

$htmlNuevo = [regex]::Replace($html, $patron, {
  param($m)

  $ruta = $m.Groups['ruta'].Value
  $archivo = Join-Path $raiz $ruta

  if (-not (Test-Path -LiteralPath $archivo)) {
    throw "index.html referencia un archivo que no existe: $ruta"
  }

  # Hash corto (8 caracteres) del contenido del archivo
  $hash = (Get-FileHash -LiteralPath $archivo -Algorithm SHA256).Hash.Substring(0, 8).ToLowerInvariant()

  '{0}="{1}?v={2}"' -f $m.Groups['attr'].Value, $ruta, $hash
})

$total = ([regex]::Matches($htmlNuevo, '\?v=[0-9a-f]{8}')).Count

if ($DryRun) {
  Write-Host "--- Resultado (no se ha escrito nada) ---"
  Write-Host $htmlNuevo
  Write-Host "------------------------------------------"
  Write-Host "Referencias versionadas: $total"
  return
}

# Guardar en UTF-8 sin BOM (igual que el archivo original)
$utf8SinBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($HtmlPath, $htmlNuevo, $utf8SinBom)

Write-Host "OK: $total referencias versionadas en $HtmlPath"
