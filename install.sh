#!/usr/bin/env bash
# Installe le thème Plymouth omarchy-matrix et le définit par défaut (demande sudo).
# Pour régénérer les images avec les couleurs du thème Omarchy actif : ./build.sh d'abord.
# Retour au thème d'origine : omarchy-refresh-plymouth
set -euo pipefail
cd "$(dirname "$0")"

DEST=/usr/share/plymouth/themes/omarchy-matrix
for f in omarchy-matrix.plymouth omarchy-matrix.script logo.png; do
  [[ -f $f ]] || { echo "$f manquant : lance ./build.sh" >&2; exit 1; }
done

sudo install -d -m 755 "$DEST"
sudo install -m 644 omarchy-matrix.plymouth omarchy-matrix.script ./*.png "$DEST/"
# Omarchy démarre via Limine : -R (mkinitcpio -P) n'a pas de preset, on reconstruit l'UKI avec limine-mkinitcpio
if command -v limine-mkinitcpio >/dev/null; then
  sudo plymouth-set-default-theme omarchy-matrix
  sudo limine-mkinitcpio
else
  sudo plymouth-set-default-theme -R omarchy-matrix
fi
echo "Thème omarchy-matrix installé."
