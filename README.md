# omarchy-matrix Plymouth theme

**English** · [Français](README.fr.md) · [Español](README.es.md)

Boot and LUKS decryption screen for [Omarchy](https://omarchy.org): the Matrix rain
from the Omarchy screensaver, with the OMARCHY logo and the password prompt from the original
`omarchy` theme (padlock, field, dots, error messages).

The rain uses 6 pre-rendered glyph strips (48 sprites at most), which keeps it smooth
even during boot.

## Requirements

- Omarchy (Arch Linux + Hyprland) with Plymouth enabled. This is the default, especially with an encrypted disk.
- `sudo`.
- To **regenerate** the images (optional): ImageMagick (`magick`) and the Noto CJK fonts.
  The PNGs are already in the repo, so you don't need them to install.

      omarchy pkg add imagemagick noto-fonts-cjk

## Installation

1. Clone the repo:

       git clone https://github.com/jhouedanou/omarchy-matrix-plymouth.git
       cd omarchy-matrix-plymouth

2. *(Optional)* Use the colors of the active Omarchy theme:

       ./build.sh

3. Install and set as the default theme (asks for your sudo password):

       ./install.sh

   The script copies the theme to `/usr/share/plymouth/themes/omarchy-matrix/`, sets it
   as the default and rebuilds the boot image: `limine-mkinitcpio` on Omarchy (Limine boot),
   otherwise `plymouth-set-default-theme -R`.

4. Reboot. The new theme shows up at the LUKS password prompt.

## Test without rebooting

Hyprland holds the screen, so you need to switch to a real TTY (**Ctrl+Alt+F3**), log in, then:

    sudo plymouthd
    sudo plymouth --show-splash
    sudo plymouth ask-for-password --prompt="Test"     # type a password, then Enter
    sudo plymouth display-message --text="Wrong password"
    sudo plymouth --quit

Back to the graphical session: **Ctrl+Alt+F1** (or F2, depending on the machine).

## Configuration

### Colors and logo

`build.sh` reads:

| Element | Default source | Variable to change it |
|---|---|---|
| Colors | `~/.local/state/omarchy/current/theme/colors.toml` (active theme) | `COLORS=` |
| Logo | `~/.config/omarchy/branding/screensaver.txt` | `LOGO_TXT=` |
| Glyph font | Noto Sans CJK | `GLYPH_FONT=` |
| Logo font | Noto Sans Mono (otherwise Adwaita Mono) | `LOGO_FONT=` |

Without `colors.toml`, it falls back to Matrix green. Bundled themes are in `/usr/share/omarchy/themes/`,
manually installed ones in `~/.config/omarchy/themes/`. Example:

    COLORS=/usr/share/omarchy/themes/tokyo-night/colors.toml ./build.sh && ./install.sh

After changing the Omarchy theme, run `./build.sh && ./install.sh` again so the boot screen
follows. Glyphs are picked at random on each build.

### Rain

In `omarchy-matrix.script.in` (then `./build.sh && ./install.sh`):

- `rain_max_drops` (48): maximum number of columns. Lower it if the animation stutters.
- `rain_step` (2): the rain moves every other frame. `1` is smoother but heavier.

Only edit the `.in` files: `build.sh` rewrites `omarchy-matrix.script` and `.plymouth` from them.

## Uninstall / restore the original theme

    omarchy-refresh-plymouth
    sudo rm -rf /usr/share/plymouth/themes/omarchy-matrix

## Files

- `build.sh`: generates the PNGs, `omarchy-matrix.script` and `omarchy-matrix.plymouth` from the `.in` files.
- `install.sh`: installs the theme and rebuilds the boot image.
- `omarchy-matrix.script.in` / `.plymouth.in`: templates (colors filled in by `build.sh`).
- `*.png`: generated images (rain strips, logo, padlock, field, dots, progress bar, overlay).

## Troubleshooting

- **`mkinitcpio: No presets found`**: normal on Omarchy, which boots through Limine. `install.sh`
  uses `limine-mkinitcpio` instead.
- **Nothing shows up during the test**: run the test from a TTY, not from a Hyprland terminal.
- **Still the old theme at boot**: check `plymouth-set-default-theme` (it should print
  `omarchy-matrix`), then run `sudo limine-mkinitcpio` again.

## My Omarchy setup

The theme runs on [Omarchy](https://github.com/basecamp/omarchy) 4.0.4 (Quattro), with the following.

### Themes

| Theme | Link |
|---|---|
| **Matrix** (active): the 1999 film, the base for this Plymouth theme's colors | [BVisagie/omarchy-matrix-theme](https://github.com/BVisagie/omarchy-matrix-theme) |
| Monokai: high-contrast Monokai Pro | [bjarneo/omarchy-monokai-theme](https://github.com/bjarneo/omarchy-monokai-theme) |

### Omarchy plugins

| Plugin | What it does | Link |
|---|---|---|
| Plugin Manager | Manage plugins: enable, update, install from git, remove | [fross100/omaplug](https://github.com/fross100/omaplug) |
| OmaStats | System monitor in the bar (CPU, GPU, memory, disk, network, temperatures, battery) | [crmne/omastats](https://github.com/crmne/omastats) |
| Fan Monitor | Fan speeds and temperatures in the bar | [elynch303/fan-monitor](https://github.com/elynch303/fan-monitor) |
| Dev Stats | GitHub / GitLab / Forgejo contribution grid in the bar | [qempexe/omarchy-dev-stats](https://github.com/qempexe/omarchy-dev-stats) |
| lerd Glance | [lerd](https://github.com/lerd-env) sites, services and workers in the bar | [lerd-env/lerd-omarchy-glance](https://github.com/lerd-env/lerd-omarchy-glance) |
| Power Menu | Power button: lock, log out, suspend, hibernate, reboot, shut down | [alshareedah22/omarchy-power-menu](https://github.com/alshareedah22/omarchy-power-menu) |
| omac | Mac-style navigation: ⌘ shortcuts, cursor movement, ⌘W, gestures | [nchudleigh/omac](https://github.com/nchudleigh/omac) |
| Switch Magic | Visual workspace and window switcher, with previews | [renanmt/switch-magic](https://github.com/renanmt/switch-magic) |
| Keyboard Layout Switcher | Keyboard layout switching and keyboard viewer | [jesusarchive/omarchy-keyboard-layout-switcher](https://github.com/jesusarchive/omarchy-keyboard-layout-switcher) |
| Mouse | Mouse speed, acceleration and natural scrolling | [wouldja/omarchy-mouse](https://github.com/wouldja/omarchy-mouse) |
| Cursor Accent | Cursor in the active theme's accent colors | [SmoothPixels/cursor-accent](https://github.com/SmoothPixels/cursor-accent) |
| Claude Strip | Banner at the top of terminals running Claude Code | [TaylorBurke/claude-strip](https://github.com/TaylorBurke/claude-strip) |

### Tools

| Tool | What it does | Link |
|---|---|---|
| Aether | Theme creation from the wallpaper | [omacom/aether](https://github.com/omacom/aether) |
| omafiles | Keyboard-driven file explorer for Omarchy | [aloisdeniel/omafiles](https://github.com/aloisdeniel/omafiles) |
| nwg-dock-hyprland | Dock, recolored on every theme change | [nwg-piotr/nwg-dock-hyprland](https://github.com/nwg-piotr/nwg-dock-hyprland) |
| omazed | Zed theme synced with Omarchy | [aps6/omazed](https://github.com/aps6/omazed) |
| Voxtype | Voice dictation (push to talk) | [voxtype.io](https://voxtype.io) |
| tmux-resurrect + tmux-continuum | Automatic save and restore of tmux sessions | [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect), [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) |

Terminals: foot, Ghostty, Kitty, Alacritty. Shell: fish + [Starship](https://starship.rs). Editors: Neovim ([LazyVim](https://www.lazyvim.org)), [Zed](https://zed.dev), VS Code.

<details>
<summary>VS Code extensions (162)</summary>

- [`aaaaronzhou.vscode-auto-light-dark-theme`](https://marketplace.visualstudio.com/items?itemName=aaaaronzhou.vscode-auto-light-dark-theme)
- [`adrianwilczynski.terminal-commands`](https://marketplace.visualstudio.com/items?itemName=adrianwilczynski.terminal-commands)
- [`ahmadalli.vscode-nginx-conf`](https://marketplace.visualstudio.com/items?itemName=ahmadalli.vscode-nginx-conf)
- [`alefragnani.project-manager`](https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager)
- [`alturos.vscjsontableeditor`](https://marketplace.visualstudio.com/items?itemName=alturos.vscjsontableeditor)
- [`anseki.vscode-color`](https://marketplace.visualstudio.com/items?itemName=anseki.vscode-color)
- [`antfu.goto-alias`](https://marketplace.visualstudio.com/items?itemName=antfu.goto-alias)
- [`anthropic.claude-code`](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code)
- [`asapmatin.div-color-highlighter`](https://marketplace.visualstudio.com/items?itemName=asapmatin.div-color-highlighter)
- [`aykutsarac.jsoncrack-vscode`](https://marketplace.visualstudio.com/items?itemName=aykutsarac.jsoncrack-vscode)
- [`benjaminzekavica.wordpress-gutenberg-snippets`](https://marketplace.visualstudio.com/items?itemName=benjaminzekavica.wordpress-gutenberg-snippets)
- [`bierner.lit-html`](https://marketplace.visualstudio.com/items?itemName=bierner.lit-html)
- [`bierner.markdown-preview-github-styles`](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-preview-github-styles)
- [`bradgashler.htmltagwrap`](https://marketplace.visualstudio.com/items?itemName=bradgashler.htmltagwrap)
- [`bradlc.vscode-tailwindcss`](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss)
- [`chouzz.vscode-better-align`](https://marketplace.visualstudio.com/items?itemName=chouzz.vscode-better-align)
- [`christian-kohler.npm-intellisense`](https://marketplace.visualstudio.com/items?itemName=christian-kohler.npm-intellisense)
- [`cloudflare.cloudflare-workers-bindings-extension`](https://marketplace.visualstudio.com/items?itemName=cloudflare.cloudflare-workers-bindings-extension)
- [`codeandstuff.package-json-upgrade`](https://marketplace.visualstudio.com/items?itemName=codeandstuff.package-json-upgrade)
- [`coder911th.vuetify-camelcase-snippets`](https://marketplace.visualstudio.com/items?itemName=coder911th.vuetify-camelcase-snippets)
- [`codezombiech.gitignore`](https://marketplace.visualstudio.com/items?itemName=codezombiech.gitignore)
- [`continue.continue`](https://marketplace.visualstudio.com/items?itemName=continue.continue)
- [`cweijan.vscode-mysql-client2`](https://marketplace.visualstudio.com/items?itemName=cweijan.vscode-mysql-client2)
- [`dart-code.dart-code`](https://marketplace.visualstudio.com/items?itemName=dart-code.dart-code)
- [`dart-code.flutter`](https://marketplace.visualstudio.com/items?itemName=dart-code.flutter)
- [`davidanson.vscode-markdownlint`](https://marketplace.visualstudio.com/items?itemName=davidanson.vscode-markdownlint)
- [`dbaeumer.vscode-eslint`](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
- [`develostudios.atgout`](https://marketplace.visualstudio.com/items?itemName=develostudios.atgout)
- [`dk189.vscode-files-explorer`](https://marketplace.visualstudio.com/items?itemName=dk189.vscode-files-explorer)
- [`donjayamanne.git-extension-pack`](https://marketplace.visualstudio.com/items?itemName=donjayamanne.git-extension-pack)
- [`donjayamanne.githistory`](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory)
- [`donjayamanne.jquerysnippets`](https://marketplace.visualstudio.com/items?itemName=donjayamanne.jquerysnippets)
- [`eamodio.gitlens`](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- [`editorconfig.editorconfig`](https://marketplace.visualstudio.com/items?itemName=editorconfig.editorconfig)
- [`eiminsasete.apacheconf-snippets`](https://marketplace.visualstudio.com/items?itemName=eiminsasete.apacheconf-snippets)
- [`enhancedjs.html-in-template-string`](https://marketplace.visualstudio.com/items?itemName=enhancedjs.html-in-template-string)
- [`eriklynd.json-tools`](https://marketplace.visualstudio.com/items?itemName=eriklynd.json-tools)
- [`esbenp.prettier-vscode`](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [`faxes.easycollapse`](https://marketplace.visualstudio.com/items?itemName=faxes.easycollapse)
- [`feziro.image-to-base64`](https://marketplace.visualstudio.com/items?itemName=feziro.image-to-base64)
- [`file-icons.file-icons`](https://marketplace.visualstudio.com/items?itemName=file-icons.file-icons)
- [`floone.varnish-vcl`](https://marketplace.visualstudio.com/items?itemName=floone.varnish-vcl)
- [`formulahendry.auto-close-tag`](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-close-tag)
- [`formulahendry.auto-complete-tag`](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-complete-tag)
- [`formulahendry.auto-rename-tag`](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag)
- [`george-alisson.html-preview-vscode`](https://marketplace.visualstudio.com/items?itemName=george-alisson.html-preview-vscode)
- [`github.vscode-github-actions`](https://marketplace.visualstudio.com/items?itemName=github.vscode-github-actions)
- [`github.vscode-pull-request-github`](https://marketplace.visualstudio.com/items?itemName=github.vscode-pull-request-github)
- [`glenn2223.live-sass`](https://marketplace.visualstudio.com/items?itemName=glenn2223.live-sass)
- [`google.gemini-cli-vscode-ide-companion`](https://marketplace.visualstudio.com/items?itemName=google.gemini-cli-vscode-ide-companion)
- [`grapecity.gc-excelviewer`](https://marketplace.visualstudio.com/items?itemName=grapecity.gc-excelviewer)
- [`gydunhn.html-essentials`](https://marketplace.visualstudio.com/items?itemName=gydunhn.html-essentials)
- [`hollowtree.vue-pack`](https://marketplace.visualstudio.com/items?itemName=hollowtree.vue-pack)
- [`hollowtree.vue-snippets`](https://marketplace.visualstudio.com/items?itemName=hollowtree.vue-snippets)
- [`hookyqr.minify`](https://marketplace.visualstudio.com/items?itemName=hookyqr.minify)
- [`howardzuo.vscode-npm-dependency`](https://marketplace.visualstudio.com/items?itemName=howardzuo.vscode-npm-dependency)
- [`html-validate.vscode-html-validate`](https://marketplace.visualstudio.com/items?itemName=html-validate.vscode-html-validate)
- [`humy2833.ftp-simple`](https://marketplace.visualstudio.com/items?itemName=humy2833.ftp-simple)
- [`idered.npm`](https://marketplace.visualstudio.com/items?itemName=idered.npm)
- [`includable.file-duplicate`](https://marketplace.visualstudio.com/items?itemName=includable.file-duplicate)
- [`janisdd.vscode-edit-csv`](https://marketplace.visualstudio.com/items?itemName=janisdd.vscode-edit-csv)
- [`jasonnutter.search-node-modules`](https://marketplace.visualstudio.com/items?itemName=jasonnutter.search-node-modules)
- [`jeroen-meijer.pubspec-assist`](https://marketplace.visualstudio.com/items?itemName=jeroen-meijer.pubspec-assist)
- [`jithurjacob.nbpreviewer`](https://marketplace.visualstudio.com/items?itemName=jithurjacob.nbpreviewer)
- [`jota0222.multi-formatter`](https://marketplace.visualstudio.com/items?itemName=jota0222.multi-formatter)
- [`kelset.rn-full-pack`](https://marketplace.visualstudio.com/items?itemName=kelset.rn-full-pack)
- [`khaeransori.json2csv`](https://marketplace.visualstudio.com/items?itemName=khaeransori.json2csv)
- [`ldd-vs-code.better-package-json`](https://marketplace.visualstudio.com/items?itemName=ldd-vs-code.better-package-json)
- [`local.omarchy-theme`](https://marketplace.visualstudio.com/items?itemName=local.omarchy-theme)
- [`lokalise.i18n-ally`](https://marketplace.visualstudio.com/items?itemName=lokalise.i18n-ally)
- [`maciejdems.add-to-gitignore`](https://marketplace.visualstudio.com/items?itemName=maciejdems.add-to-gitignore)
- [`man-vu.claude-code-usage-dashboard`](https://marketplace.visualstudio.com/items?itemName=man-vu.claude-code-usage-dashboard)
- [`mariorodeghiero.vue-theme`](https://marketplace.visualstudio.com/items?itemName=mariorodeghiero.vue-theme)
- [`marp-team.marp-vscode`](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode)
- [`mathiasfrohlich.kotlin`](https://marketplace.visualstudio.com/items?itemName=mathiasfrohlich.kotlin)
- [`mdickin.markdown-shortcuts`](https://marketplace.visualstudio.com/items?itemName=mdickin.markdown-shortcuts)
- [`mechatroner.rainbow-csv`](https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv)
- [`mgmcdermott.vscode-language-babel`](https://marketplace.visualstudio.com/items?itemName=mgmcdermott.vscode-language-babel)
- [`mhutchie.git-graph`](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph)
- [`michaelcurrin.auto-commit-msg`](https://marketplace.visualstudio.com/items?itemName=michaelcurrin.auto-commit-msg)
- [`michelemelluso.code-beautifier`](https://marketplace.visualstudio.com/items?itemName=michelemelluso.code-beautifier)
- [`monokai.theme-monokai-pro-vscode`](https://marketplace.visualstudio.com/items?itemName=monokai.theme-monokai-pro-vscode)
- [`moondevaa.moon-violet-dark-plus`](https://marketplace.visualstudio.com/items?itemName=moondevaa.moon-violet-dark-plus)
- [`mrmlnc.vscode-apache`](https://marketplace.visualstudio.com/items?itemName=mrmlnc.vscode-apache)
- [`ms-azuretools.vscode-containers`](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers)
- [`ms-azuretools.vscode-docker`](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [`ms-ceintl.vscode-language-pack-fr`](https://marketplace.visualstudio.com/items?itemName=ms-ceintl.vscode-language-pack-fr)
- [`ms-dotnettools.vscode-dotnet-runtime`](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.vscode-dotnet-runtime)
- [`ms-edgedevtools.vscode-edge-devtools`](https://marketplace.visualstudio.com/items?itemName=ms-edgedevtools.vscode-edge-devtools)
- [`ms-python.debugpy`](https://marketplace.visualstudio.com/items?itemName=ms-python.debugpy)
- [`ms-python.python`](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
- [`ms-python.vscode-pylance`](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)
- [`ms-python.vscode-python-envs`](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-python-envs)
- [`ms-vscode-remote.remote-containers`](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [`ms-vscode.live-server`](https://marketplace.visualstudio.com/items?itemName=ms-vscode.live-server)
- [`ms-vscode.powershell`](https://marketplace.visualstudio.com/items?itemName=ms-vscode.powershell)
- [`ms-vscode.sublime-keybindings`](https://marketplace.visualstudio.com/items?itemName=ms-vscode.sublime-keybindings)
- [`ms-vscode.vscode-chat-customizations-evaluations`](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-chat-customizations-evaluations)
- [`msjsdiag.vscode-react-native`](https://marketplace.visualstudio.com/items?itemName=msjsdiag.vscode-react-native)
- [`mushan.vscode-paste-image`](https://marketplace.visualstudio.com/items?itemName=mushan.vscode-paste-image)
- [`naumovs.color-highlight`](https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight)
- [`nemesv.copy-file-name`](https://marketplace.visualstudio.com/items?itemName=nemesv.copy-file-name)
- [`nikolaosgeorgiou.html-fmt-vscode`](https://marketplace.visualstudio.com/items?itemName=nikolaosgeorgiou.html-fmt-vscode)
- [`nucllear.vscode-extension-auto-import`](https://marketplace.visualstudio.com/items?itemName=nucllear.vscode-extension-auto-import)
- [`nurbek0298.vue-css-modules`](https://marketplace.visualstudio.com/items?itemName=nurbek0298.vue-css-modules)
- [`nuxt.mdc`](https://marketplace.visualstudio.com/items?itemName=nuxt.mdc)
- [`nuxtr.nuxt-vscode-extentions`](https://marketplace.visualstudio.com/items?itemName=nuxtr.nuxt-vscode-extentions)
- [`nuxtr.nuxtr-vscode`](https://marketplace.visualstudio.com/items?itemName=nuxtr.nuxtr-vscode)
- [`openai.chatgpt`](https://marketplace.visualstudio.com/items?itemName=openai.chatgpt)
- [`openai.codex-audio`](https://marketplace.visualstudio.com/items?itemName=openai.codex-audio)
- [`oscarcs.dart-syntax-highlighting-only`](https://marketplace.visualstudio.com/items?itemName=oscarcs.dart-syntax-highlighting-only)
- [`pabloandroetto.a-matrix-theme`](https://marketplace.visualstudio.com/items?itemName=pabloandroetto.a-matrix-theme)
- [`panu00x.json2tablehtml`](https://marketplace.visualstudio.com/items?itemName=panu00x.json2tablehtml)
- [`pengbouestc.vscode-gutter-preview-plus`](https://marketplace.visualstudio.com/items?itemName=pengbouestc.vscode-gutter-preview-plus)
- [`phplasma.csv-to-table`](https://marketplace.visualstudio.com/items?itemName=phplasma.csv-to-table)
- [`prabinpebam.vscode-focus-mode`](https://marketplace.visualstudio.com/items?itemName=prabinpebam.vscode-focus-mode)
- [`pranaygp.vscode-css-peek`](https://marketplace.visualstudio.com/items?itemName=pranaygp.vscode-css-peek)
- [`qinjia.md2pdf`](https://marketplace.visualstudio.com/items?itemName=qinjia.md2pdf)
- [`qiqigou.tpl-lang`](https://marketplace.visualstudio.com/items?itemName=qiqigou.tpl-lang)
- [`quanli.focus`](https://marketplace.visualstudio.com/items?itemName=quanli.focus)
- [`qufiwefefwoyn.kanagawa`](https://marketplace.visualstudio.com/items?itemName=qufiwefefwoyn.kanagawa)
- [`quicktype.quicktype`](https://marketplace.visualstudio.com/items?itemName=quicktype.quicktype)
- [`randomfractalsinc.vscode-data-preview`](https://marketplace.visualstudio.com/items?itemName=randomfractalsinc.vscode-data-preview)
- [`raynigon.nginx-formatter`](https://marketplace.visualstudio.com/items?itemName=raynigon.nginx-formatter)
- [`redis.redis-for-vscode`](https://marketplace.visualstudio.com/items?itemName=redis.redis-for-vscode)
- [`rifi2k.format-html-in-php`](https://marketplace.visualstudio.com/items?itemName=rifi2k.format-html-in-php)
- [`rimuruchan.vscode-fix-checksums-next`](https://marketplace.visualstudio.com/items?itemName=rimuruchan.vscode-fix-checksums-next)
- [`s2junn.image-essentials`](https://marketplace.visualstudio.com/items?itemName=s2junn.image-essentials)
- [`sdras.vue-vscode-snippets`](https://marketplace.visualstudio.com/items?itemName=sdras.vue-vscode-snippets)
- [`searking.preview-vscode`](https://marketplace.visualstudio.com/items?itemName=searking.preview-vscode)
- [`seemasoft.minify-html-in-php`](https://marketplace.visualstudio.com/items?itemName=seemasoft.minify-html-in-php)
- [`shd101wyy.markdown-preview-enhanced`](https://marketplace.visualstudio.com/items?itemName=shd101wyy.markdown-preview-enhanced)
- [`sibiraj-s.vscode-scss-formatter`](https://marketplace.visualstudio.com/items?itemName=sibiraj-s.vscode-scss-formatter)
- [`silverfletcherr.vuetify-gotodocs`](https://marketplace.visualstudio.com/items?itemName=silverfletcherr.vuetify-gotodocs)
- [`simonsiefke.svg-preview`](https://marketplace.visualstudio.com/items?itemName=simonsiefke.svg-preview)
- [`streetsidesoftware.code-spell-checker`](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
- [`studiocenturio.classify-ts-import`](https://marketplace.visualstudio.com/items?itemName=studiocenturio.classify-ts-import)
- [`stylelint.vscode-stylelint`](https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint)
- [`sunzehui.krpano-lang`](https://marketplace.visualstudio.com/items?itemName=sunzehui.krpano-lang)
- [`supabase.vscode-supabase-extension`](https://marketplace.visualstudio.com/items?itemName=supabase.vscode-supabase-extension)
- [`tanishranjan.the-professionals-language`](https://marketplace.visualstudio.com/items?itemName=tanishranjan.the-professionals-language)
- [`teclado.vscode-nginx-format`](https://marketplace.visualstudio.com/items?itemName=teclado.vscode-nginx-format)
- [`tobermory.es6-string-html`](https://marketplace.visualstudio.com/items?itemName=tobermory.es6-string-html)
- [`tobysmith568.run-in-powershell`](https://marketplace.visualstudio.com/items?itemName=tobysmith568.run-in-powershell)
- [`tomasr8.close-all-but-this`](https://marketplace.visualstudio.com/items?itemName=tomasr8.close-all-but-this)
- [`tomblind.scm-buttons-vscode`](https://marketplace.visualstudio.com/items?itemName=tomblind.scm-buttons-vscode)
- [`tomoki1207.pdf`](https://marketplace.visualstudio.com/items?itemName=tomoki1207.pdf)
- [`usernamehw.remove-empty-lines`](https://marketplace.visualstudio.com/items?itemName=usernamehw.remove-empty-lines)
- [`vaniship.vue-ls-snippets`](https://marketplace.visualstudio.com/items?itemName=vaniship.vue-ls-snippets)
- [`vincaslt.highlight-matching-tag`](https://marketplace.visualstudio.com/items?itemName=vincaslt.highlight-matching-tag)
- [`vue.volar`](https://marketplace.visualstudio.com/items?itemName=vue.volar)
- [`waderyan.gitblame`](https://marketplace.visualstudio.com/items?itemName=waderyan.gitblame)
- [`walkme.markdown-extension-pack`](https://marketplace.visualstudio.com/items?itemName=walkme.markdown-extension-pack)
- [`william-voyek.vscode-nginx`](https://marketplace.visualstudio.com/items?itemName=william-voyek.vscode-nginx)
- [`wmaurer.change-case`](https://marketplace.visualstudio.com/items?itemName=wmaurer.change-case)
- [`yandeu.five-server`](https://marketplace.visualstudio.com/items?itemName=yandeu.five-server)
- [`yoshinorin.current-file-path`](https://marketplace.visualstudio.com/items?itemName=yoshinorin.current-file-path)
- [`yzane.markdown-pdf`](https://marketplace.visualstudio.com/items?itemName=yzane.markdown-pdf)
- [`yzhang.markdown-all-in-one`](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
- [`zainchen.json`](https://marketplace.visualstudio.com/items?itemName=zainchen.json)
- [`ziyasal.vscode-open-in-github`](https://marketplace.visualstudio.com/items?itemName=ziyasal.vscode-open-in-github)
- [`zjcompt.es6-string-javascript`](https://marketplace.visualstudio.com/items?itemName=zjcompt.es6-string-javascript)

</details>

## License

MIT, see [LICENSE](LICENSE). The password prompt and the progress bar come from
[Omarchy](https://github.com/basecamp/omarchy)'s Plymouth theme (MIT).
