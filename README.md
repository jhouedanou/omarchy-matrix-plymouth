# Thème Plymouth omarchy-matrix

Écran de démarrage et de déchiffrement LUKS pour [Omarchy](https://omarchy.org) : la pluie Matrix
du screensaver Omarchy, avec le logo OMARCHY et la saisie du mot de passe du thème `omarchy`
d'origine (cadenas, champ, puces, messages d'erreur).

La pluie utilise 6 bandes de glyphes pré-rendues (48 sprites au plus), ce qui la garde fluide
même au démarrage.

## Prérequis

- Omarchy (Arch Linux + Hyprland), avec Plymouth actif. C'est le cas par défaut, surtout avec un disque chiffré.
- `sudo`.
- Pour **régénérer** les images (facultatif) : ImageMagick (`magick`) et les polices Noto CJK.
  Les PNG sont déjà fournis dans le dépôt, donc ce n'est pas nécessaire pour installer.

      omarchy pkg add imagemagick noto-fonts-cjk

## Installation

1. Récupérer le dépôt :

       git clone https://github.com/jhouedanou/omarchy-matrix-plymouth.git
       cd omarchy-matrix-plymouth

2. *(Facultatif)* Reprendre les couleurs du thème Omarchy actif :

       ./build.sh

3. Installer et définir le thème par défaut (demande le mot de passe sudo) :

       ./install.sh

   Le script copie le thème dans `/usr/share/plymouth/themes/omarchy-matrix/`, le définit
   par défaut et reconstruit l'image de boot : `limine-mkinitcpio` sur Omarchy (démarrage Limine),
   sinon `plymouth-set-default-theme -R`.

4. Redémarrer. Le nouveau thème s'affiche à la demande du mot de passe LUKS.

## Tester sans redémarrer

Hyprland occupe l'écran : il faut passer sur un vrai TTY (**Ctrl+Alt+F3**), se connecter, puis :

    sudo plymouthd
    sudo plymouth --show-splash
    sudo plymouth ask-for-password --prompt="Test"     # tape un mot de passe, puis Entrée
    sudo plymouth display-message --text="Mot de passe incorrect"
    sudo plymouth --quit

Retour à la session graphique : **Ctrl+Alt+F1** (ou F2, selon la machine).

## Configuration

### Couleurs et logo

`build.sh` lit :

| Élément | Source par défaut | Variable pour la changer |
|---|---|---|
| Couleurs | `~/.local/state/omarchy/current/theme/colors.toml` (thème actif) | `COLORS=` |
| Logo | `~/.config/omarchy/branding/screensaver.txt` | `LOGO_TXT=` |
| Police des glyphes | Noto Sans CJK | `GLYPH_FONT=` |
| Police du logo | Noto Sans Mono (sinon Adwaita Mono) | `LOGO_FONT=` |

Sans `colors.toml`, il prend un vert Matrix. Les thèmes fournis sont dans `/usr/share/omarchy/themes/`,
ceux installés à la main dans `~/.config/omarchy/themes/`. Exemple :

    COLORS=/usr/share/omarchy/themes/tokyo-night/colors.toml ./build.sh && ./install.sh

Après un changement de thème Omarchy, relancer `./build.sh && ./install.sh` pour que l'écran de
boot suive. Les glyphes sont tirés au hasard à chaque build.

### Pluie

Dans `omarchy-matrix.script.in` (puis `./build.sh && ./install.sh`) :

- `rain_max_drops` (48) : nombre maximal de colonnes. Baisser si l'animation saccade.
- `rain_step` (2) : la pluie avance une image sur deux. `1` est plus fluide mais plus coûteux.

Ne modifie que les fichiers `.in` : `build.sh` réécrit `omarchy-matrix.script` et `.plymouth` à partir d'eux.

## Désinstaller / revenir au thème d'origine

    omarchy-refresh-plymouth
    sudo rm -rf /usr/share/plymouth/themes/omarchy-matrix

## Fichiers

- `build.sh` : génère les PNG, `omarchy-matrix.script` et `omarchy-matrix.plymouth` depuis les `.in`.
- `install.sh` : installe le thème et reconstruit l'image de boot.
- `omarchy-matrix.script.in` / `.plymouth.in` : modèles (couleurs remplacées par `build.sh`).
- `*.png` : images générées (bandes de pluie, logo, cadenas, champ, puces, barre de progression, voile).

## Dépannage

- **`mkinitcpio: No presets found`** : normal sur Omarchy, qui démarre via Limine. `install.sh`
  utilise `limine-mkinitcpio` à la place.
- **Rien ne s'affiche au test** : le test doit se faire depuis un TTY, pas depuis un terminal Hyprland.
- **Toujours l'ancien thème au boot** : vérifier `plymouth-set-default-theme` (doit afficher
  `omarchy-matrix`), puis relancer `sudo limine-mkinitcpio`.

## Licence

MIT, voir [LICENSE](LICENSE). La saisie du mot de passe et la barre de progression viennent du
thème Plymouth d'[Omarchy](https://github.com/basecamp/omarchy) (MIT).
