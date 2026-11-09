<#
  Instala el hook pre-commit que actualiza las versiones ?v= de index.html.

  Ejecutar una vez por cada clon del repositorio:
    powershell -ExecutionPolicy Bypass -File scripts/instalar-hooks.ps1
#>

$ErrorActionPreference = 'Stop'

# Carpeta raíz del repositorio (la carpeta padre de scripts/)
$raiz = Split-Path -Parent $PSScriptRoot
Set-Location $raiz

$hook = Join-Path $raiz 'scripts\hooks\pre-commit'
if (-not (Test-Path -LiteralPath $hook)) {
  throw "No se encuentra el hook: $hook"
}

git config core.hooksPath scripts/hooks

Write-Host "Hook instalado: git config core.hooksPath scripts/hooks"
Write-Host "A partir de ahora, cada 'git commit' actualizara los ?v= de index.html."
