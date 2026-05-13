#!/usr/bin/env bash
# =============================================================================
# commandes_sh.sh — Toutes les commandes shell présentes dans git_utils.sh
# =============================================================================

# -----------------------------------------------------------------------------
# 1. AFFICHAGE / ECHO
# -----------------------------------------------------------------------------
echo -e "${CYAN}[INFO]${NC}  message"          # Affiche un message coloré (info)
echo -e "${GREEN}[OK]${NC}    message"          # Affiche un message coloré (succès)
echo -e "${YELLOW}[WARN]${NC}  message"         # Affiche un message coloré (avertissement)
echo -e "${RED}[ERROR]${NC} message" >&2        # Affiche une erreur sur stderr
echo "texte simple"                             # Affiche du texte brut

# -----------------------------------------------------------------------------
# 2. LECTURE D'ENTRÉE UTILISATEUR
# -----------------------------------------------------------------------------
read -r -p "  Continuer ? [y/N] " answer        # Lit une réponse utilisateur
read -r -p "  Votre choix [1-4] : " choice      # Lit un choix numérique
read -r -p "  Nouveau message : " new_message   # Lit un texte libre

# -----------------------------------------------------------------------------
# 3. VARIABLES ET CONDITIONS
# -----------------------------------------------------------------------------
[[ -z "$variable" ]]                            # Vérifie si une variable est vide
[[ "$answer" =~ ^[Yy]$ ]]                       # Vérifie si la réponse est o/O ou y/Y
[[ "$full_hash" == "$head_hash" ]]              # Compare deux chaînes
[[ -z "$new_message" ]]                         # Vérifie si le message est vide
choice="${choice:-3}"                           # Valeur par défaut si variable vide

# -----------------------------------------------------------------------------
# 4. COMMANDES GIT
# -----------------------------------------------------------------------------
git rev-parse --is-inside-work-tree            # Vérifie qu'on est dans un dépôt Git
git cat-file -e "${hash}^{commit}"             # Vérifie qu'un hash de commit existe
git rev-parse --verify "${hash}"               # Résout un hash court en hash complet
git rev-parse HEAD                             # Récupère le hash du commit HEAD
git log --oneline -1 "$hash"                   # Affiche le commit en une ligne
git log --format='%s' -1 "$hash"               # Récupère le sujet du message de commit
git log --format='%B' -1 "$hash"               # Récupère le corps complet du message
git diff --quiet                               # Vérifie si le working tree est propre
git diff --cached --quiet                      # Vérifie si le staging est propre
git symbolic-ref --short HEAD                  # Récupère le nom de la branche courante
git update-ref "$backup_ref" HEAD              # Crée une référence de sauvegarde
git reset --soft HEAD~1                        # Annule le dernier commit (garde les fichiers en staging)
git reset --hard "$backup_ref"                 # Restaure l'état depuis une référence
git rebase --onto "${hash}~1" "${hash}" HEAD   # Rebase en excluant un commit précis
git rebase --abort                             # Annule un rebase en cours
git merge-base --is-ancestor "$h1" "$h2"       # Vérifie si h1 est un ancêtre de h2
git rebase -i "$rebase_base"                   # Lance un rebase interactif
git commit --amend -m "$message"               # Modifie le message du dernier commit
git push --force-with-lease                    # Pousse en forçant (plus sûr que --force)

# -----------------------------------------------------------------------------
# 5. VARIABLES D'ENVIRONNEMENT GIT
# -----------------------------------------------------------------------------
GIT_SEQUENCE_EDITOR="sed -i '...'" git rebase -i   # Remplace l'éditeur de la todo-list rebase
GIT_EDITOR="cat" git rebase -i                     # Désactive l'éditeur de message de commit

# -----------------------------------------------------------------------------
# 6. MANIPULATION DE CHAÎNES (BASH)
# -----------------------------------------------------------------------------
short_hash="${full_hash:0:7}"                  # Extrait les 7 premiers caractères (hash court)

# -----------------------------------------------------------------------------
# 7. FLUX ET REDIRECTIONS
# -----------------------------------------------------------------------------
command &>/dev/null                            # Redirige stdout et stderr vers /dev/null
command 2>/dev/null                            # Redirige uniquement stderr vers /dev/null
command 2>/dev/null || true                    # Ignore les erreurs d'une commande

# -----------------------------------------------------------------------------
# 8. SED (édition de flux)
# -----------------------------------------------------------------------------
sed -i 's/^pick abc1234/squash abc1234/'       # Remplace "pick" par "squash" dans un fichier
sed -i '/^pick abc1234/d'                      # Supprime une ligne contenant le hash ciblé

# -----------------------------------------------------------------------------
# 9. STRUCTURES DE CONTRÔLE
# -----------------------------------------------------------------------------
if [[ condition ]]; then ... fi                # Condition simple
if ! commande; then ... fi                     # Condition sur l'échec d'une commande
case "$variable" in ... esac                   # Sélection selon la valeur d'une variable
local tmp="$var1"; var1="$var2"; var2="$tmp"   # Échange de deux variables (swap)
shift || true                                  # Décale les arguments positionnels

# -----------------------------------------------------------------------------
# 10. FONCTIONS BASH
# -----------------------------------------------------------------------------
function_name() { ... }                        # Déclaration d'une fonction
local variable="valeur"                        # Variable locale à une fonction
return 0                                       # Retourne un code de succès
return 1                                       # Retourne un code d'erreur

# -----------------------------------------------------------------------------
# 11. POINT D'ENTRÉE (exécution directe du script)
# -----------------------------------------------------------------------------
[[ "${BASH_SOURCE[0]}" == "${0}" ]]            # Vérifie si le script est exécuté (pas sourcé)
exit 1                                         # Quitte le script avec un code d'erreur
