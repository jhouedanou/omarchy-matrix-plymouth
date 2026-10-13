#!/usr/bin/env bash
# Génère les images du thème Plymouth omarchy-matrix avec ImageMagick.
# Couleurs : thème Omarchy actif (colors.toml), sinon vert Matrix.
# Usage : ./build.sh   (sans sudo ; écrit les PNG à côté de ce script)
set -euo pipefail
cd "$(dirname "$0")"

command -v magick >/dev/null || { echo "ImageMagick (magick) est requis." >&2; exit 1; }

COLORS=${COLORS:-$HOME/.local/state/omarchy/current/theme/colors.toml}
LOGO_TXT=${LOGO_TXT:-$HOME/.config/omarchy/branding/screensaver.txt}
GLYPH_FONT=${GLYPH_FONT:-/usr/share/fonts/noto-cjk/NotoSansCJK-Medium.ttc}
LOGO_FONT=${LOGO_FONT:-/usr/share/fonts/noto/NotoSansMono-Regular.ttf}
[[ -f $LOGO_FONT ]] || LOGO_FONT=/usr/share/fonts/Adwaita/AdwaitaMono-Regular.ttf

# Lit une couleur "#RRGGBB" dans colors.toml, avec valeur par défaut
color() {
  local v=""
  [[ -f $COLORS ]] && v=$(sed -nE "s/^$1[[:space:]]*=[[:space:]]*\"(#[0-9A-Fa-f]{6})\".*/\1/p" "$COLORS" | head -1)
  echo "${v:-$2}"
}
BG=$(color background "#000000")
ACCENT=$(color accent "#00FF41")
HEAD=$(color bright_foreground "#D8FFD8")
BODY=$(color green "#00B32C")
TRAIL=$(color selection "#003B00")
TEXT=$(color foreground "#8BC98C")
echo "fond=$BG accent=$ACCENT tête=$HEAD corps=$BODY traîne=$TRAIL"

# Mélange deux couleurs hex : mix C1 C2 t(0..100)
mix() {
  local a=${1#\#} b=${2#\#} t=$3 out="#" i
  for i in 0 2 4; do
    printf -v out '%s%02X' "$out" $(( (16#${a:i:2} * (100 - t) + 16#${b:i:2} * t) / 100 ))
  done
  echo "$out"
}

# --- Bandes de pluie : une colonne de glyphes, traîne en haut, tête claire en bas
GLYPHS=(2 5 9 8 Z '*' ')' ':' . '"' = + - '¦' '|' ｦ ｱ ｳ ｴ ｵ ｶ ｷ ｹ ｺ ｻ ｼ ｽ ｾ ｿ ﾀ ﾂ ﾃ ﾅ ﾆ ﾇ ﾈ ﾊ ﾋ ﾎ ﾏ ﾐ ﾑ ﾒ ﾓ ﾔ ﾕ ﾗ ﾘ ﾜ)
CELL_W=24 CELL_H=26 PT=20
STRIPS=6
for s in $(seq 0 $((STRIPS - 1))); do
  n=$((22 + RANDOM % 10))          # longueur variable selon la bande
  args=()
  for i in $(seq 0 $((n - 1))); do
    g=${GLYPHS[RANDOM % ${#GLYPHS[@]}]}
    if (( i == n - 1 )); then c=$HEAD
    elif (( i >= n - 3 )); then c=$(mix "$ACCENT" "$HEAD" 40)
    else c=$(mix "$TRAIL" "$ACCENT" $(( i * 100 / n )))
    fi
    # Glyphes en miroir, comme dans le film
    args+=( \( -background none -fill "$c" -font "$GLYPH_FONT" -pointsize $PT
              -size ${CELL_W}x${CELL_H} -gravity center "label:$g" -flop \) )
  done
  h=$((n * CELL_H))
  magick "${args[@]}" -append \
    \( -size ${CELL_W}x${h} gradient:black-white -evaluate pow 0.6 \) \
    -compose multiply -channel A -composite +channel \
    -define png:color-type=6 "strip-$s.png"
done

# --- Logo : screensaver.txt rendu en PNG, halo accent
if [[ -f $LOGO_TXT ]]; then
  magick -background none -fill "$HEAD" -font "$LOGO_FONT" -pointsize 16 +antialias \
    -interline-spacing -3 "label:@$LOGO_TXT" -trim +repage -morphology Close Square:1 \
    \( +clone -fill "$ACCENT" -colorize 100 -blur 0x6 \) +swap \
    -background none -compose over -layers merge -bordercolor none -border 12 \
    -define png:color-type=6 logo.png
else
  cp /usr/share/plymouth/themes/omarchy/logo.png logo.png
fi

# --- Champ, cadenas, puces, barre de progression (dimensions d'origine)
magick -size 286x48 xc:none -fill "$(mix "$BG" "$TRAIL" 50)" -stroke "$ACCENT" -strokewidth 2 \
  -draw "roundrectangle 1,1 284,46 6,6" -define png:color-type=6 entry.png
magick /usr/share/plymouth/themes/omarchy/lock.png -fill "$ACCENT" -colorize 100 -define png:color-type=6 lock.png
magick -size 14x14 xc:none -fill "$HEAD" -draw "circle 7,7 7,1" -define png:color-type=6 bullet.png
magick -size 300x10 xc:none -fill none -stroke "$TRAIL" -strokewidth 2 -draw "rectangle 1,1 298,8" \
  -define png:color-type=6 progress_box.png
magick -size 300x10 xc:"$ACCENT" -define png:color-type=6 progress_bar.png
# Voile derrière logo + champ (mis à l'échelle par le script)
magick -size 4x4 xc:"$BG" -define png:color-type=6 veil.png

# Couleurs injectées dans le script (fond, texte, erreur)
rgb() { local h=${1#\#}; awk -v r=$((16#${h:0:2})) -v g=$((16#${h:2:2})) -v b=$((16#${h:4:2})) \
  'BEGIN { printf "%.3f, %.3f, %.3f", r/255, g/255, b/255 }'; }
sed -e "s/@BG_RGB@/$(rgb "$BG")/g" -e "s/@TEXT_RGB@/$(rgb "$TEXT")/g" \
    -e "s/@ERROR_RGB@/$(rgb "$(color red "#FF5555")")/g" -e "s/@STRIPS@/$STRIPS/g" \
    omarchy-matrix.script.in > omarchy-matrix.script
sed -e "s/@BG_HEX@/0x${BG#\#}/" omarchy-matrix.plymouth.in > omarchy-matrix.plymouth
echo "Images générées dans $PWD"
