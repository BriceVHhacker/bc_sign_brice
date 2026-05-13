#!/bin/bash
# m1.sh — Suppression de fichiers par extension (version optimisée)
# Usage: ./m1.sh <répertoire> <extension> [--dry-run]
# Dépôt: bc_sign_votreprenom
 
set -euo pipefail
 
# ── Constantes ────────────────────────────────────────────────────────────────
readonly SCRIPT_NAME="${0##*/}"
 
# ── Aide ──────────────────────────────────────────────────────────────────────
usage() {
    cat >&2 <<EOF
Usage: $SCRIPT_NAME <répertoire> <extension> [--dry-run]
 
  répertoire   Dossier racine à parcourir (récursif)
  extension    Extension sans point  (ex: txt, log, tmp)
  --dry-run    Simule la suppression sans rien effacer
 
Exemples:
  $SCRIPT_NAME /tmp/logs log
  $SCRIPT_NAME /var/www html --dry-run
EOF
    exit 1
}
 
# ── Validation des arguments ──────────────────────────────────────────────────
[[ $# -lt 2 ]] && usage
 
target="$1"
extension="$2"
dry_run=0
shift 2
 
for arg in "$@"; do
    [[ "$arg" == "--dry-run" ]] && dry_run=1
done
 
[[ -d "$target" ]]      || { echo "erreur: '$target' n'est pas un répertoire" >&2; exit 1; }
[[ -n "$extension" ]]   || { echo "erreur: extension vide"                    >&2; exit 1; }
 
# ── Compteurs ─────────────────────────────────────────────────────────────────
count=0
errors=0
 
# ── Traitement avec find (pas de récursion manuelle) ─────────────────────────
# -L  : suit les liens symboliques (robustesse)
# find remplace la boucle shell récursive et gère les noms avec espaces nativement
while IFS= read -r -d '' file; do
    if (( dry_run )); then
        echo "[dry-run] $file"
    else
        if rm -- "$file" 2>/dev/null; then
            echo "supprimé : $file"
            (( count++ ))
        else
            echo "erreur   : impossible de supprimer '$file'" >&2
            (( errors++ ))
        fi
    fi
done < <(find -L "$target" -type f -name "*.$extension" -print0 | sort -z)
 
# ── Rapport final ─────────────────────────────────────────────────────────────
echo "────────────────────────────────────"
if (( dry_run )); then
    echo "Mode dry-run — aucun fichier supprimé."
else
    echo "Fichiers supprimés : $count"
    (( errors > 0 )) && echo "Erreurs            : $errors"
fi