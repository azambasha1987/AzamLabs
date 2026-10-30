#!/usr/bin/env bash
# ==============================================================================
# Azam Basha Enterprise High-Identity Multi-Theme Engine (7 Vibrant Palettes)
# 1. Obsidian Slate  (Modern Neutral Charcoal Dark)
# 2. Crisp Daylight  (High-Contrast Daylight Light)
# 3. Cyberpunk Neon  (Synthwave Violet, Hot Pink & Electric Cyan)
# 4. Nord Arctic     (Frosted Scandinavian Slate & Ice Blue)
# 5. Solarized NOC   (Deep Oceanic Teal & Warm Amber)
# 6. Dracula Gothic  (Dark Vampire Plum, Lavender & Pink)
# 7. Retro Terminal  (Matrix Pitch Black & Phosphor Green)
# ==============================================================================
set -e
set -u
set -o pipefail 2>/dev/null || true

if [ "$(id -u)" -ne 0 ]; then
    echo "[ERROR] This script must be run as root. Please run: sudo bash $0" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "/opt/unetlab/scripts")"
PARENT_DIR="$(cd "${SCRIPT_DIR}/.." 2>/dev/null && pwd || echo "/opt/azambasha")"

echo "============================================================"
echo "   Applying Azam Basha High-Identity Multi-Theme Engine"
echo "============================================================"

# Ensure Target CSS Directories exist
mkdir -p /opt/unetlab/html/themes/default/css          /opt/unetlab/html/main/css          /opt/unetlab/html/assets-common/css 2>/dev/null || true

DARK_CSS="/opt/unetlab/html/themes/default/css/azambasha-dark.css"

cat > "$DARK_CSS" << 'EOF'
/* ==========================================================================
   Azam Basha High-Identity Multi-Theme Design Tokens
   7 Truly Distinct Palettes with bold colors and unique visual signatures
   ========================================================================== */

/* --------------------------------------------------------------------------
   1. OBSIDIAN SLATE (Neutral Charcoal Dark)
   -------------------------------------------------------------------------- */
:root,
:root[data-theme="dark"],
html[data-theme="dark"],
body.pnq-dark {
  --pnq-primary:        #0f1117 !important;
  --pnq-primary-light:  #181b24 !important;
  --pnq-primary-hover:  #222634 !important;
  --pnq-on-primary:     #f8fafc !important;
  --pnq-on-primary-dim: #94a3b8 !important;

  --pnq-bg:             #0a0c10 !important;
  --pnq-surface:        #12151e !important;
  --pnq-surface-2:      #1a1e2b !important;
  --pnq-text:           #f8fafc !important;
  --pnq-text-muted:     #94a3b8 !important;

  --pnq-accent:         #3b82f6 !important;
  --pnq-accent-hover:   #2563eb !important;
  --pnq-accent-soft:    rgba(59, 130, 246, 0.15) !important;
  --pnq-on-accent:      #ffffff !important;

  --pnq-border:         rgba(255, 255, 255, 0.10) !important;
  --pnq-border-strong:  #3b82f6 !important;
  --pnq-dot-color:      #3b82f6 !important;
  --pnq-shadow:         0 4px 20px rgba(0, 0, 0, 0.60) !important;
  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   2. CRISP DAYLIGHT (High-Contrast Daylight White & Cobalt)
   -------------------------------------------------------------------------- */
:root[data-theme="light"],
html[data-theme="light"],
body.pnq-light,
html:not([data-theme="dark"]):not([data-theme="cyberpunk"]):not([data-theme="nord"]):not([data-theme="solarized"]):not([data-theme="dracula"]):not([data-theme="matrix"]) body:not(.pnq-dark) {
  --pnq-primary:        #ffffff !important;
  --pnq-primary-light:  #f8fafc !important;
  --pnq-primary-hover:  #e2e8f0 !important;
  --pnq-on-primary:     #0f172a !important;
  --pnq-on-primary-dim: #475569 !important;

  --pnq-bg:             #ffffff !important;
  --pnq-surface:        #f8fafc !important;
  --pnq-surface-2:      #f1f5f9 !important;
  --pnq-text:           #0f172a !important;
  --pnq-text-muted:     #64748b !important;

  --pnq-accent:         #2563eb !important;
  --pnq-accent-hover:   #1d4ed8 !important;
  --pnq-accent-soft:    rgba(37, 99, 235, 0.12) !important;
  --pnq-on-accent:      #ffffff !important;

  --pnq-border:         rgba(0, 0, 0, 0.12) !important;
  --pnq-border-strong:  #2563eb !important;
  --pnq-dot-color:      #94a3b8 !important;
  --pnq-shadow:         0 2px 12px rgba(0, 0, 0, 0.08) !important;
  color-scheme: light !important;
}

/* --------------------------------------------------------------------------
   3. CYBERPUNK NEON (Synthwave Violet, Hot Pink & Electric Cyan)
   -------------------------------------------------------------------------- */
:root[data-theme="cyberpunk"],
html[data-theme="cyberpunk"],
body.pnq-cyberpunk {
  --pnq-primary:        #180b33 !important;
  --pnq-primary-light:  #24104c !important;
  --pnq-primary-hover:  #32166a !important;
  --pnq-on-primary:     #00f2fe !important;
  --pnq-on-primary-dim: #f43f5e !important;

  --pnq-bg:             #120726 !important;
  --pnq-surface:        #1c0c3b !important;
  --pnq-surface-2:      #281254 !important;
  --pnq-text:           #f8fafc !important;
  --pnq-text-muted:     #00f2fe !important;

  --pnq-accent:         #ff007f !important;
  --pnq-accent-hover:   #00f2fe !important;
  --pnq-accent-soft:    rgba(255, 0, 127, 0.22) !important;
  --pnq-on-accent:      #ffffff !important;

  --pnq-border:         rgba(0, 242, 254, 0.35) !important;
  --pnq-border-strong:  #00f2fe !important;
  --pnq-dot-color:      #00f2fe !important;
  --pnq-shadow:         0 0 25px rgba(0, 242, 254, 0.25), 0 0 10px rgba(255, 0, 127, 0.3) !important;
  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   4. NORD ARCTIC (Frosted Scandinavian Polar Slate & Ice Blue)
   -------------------------------------------------------------------------- */
:root[data-theme="nord"],
html[data-theme="nord"],
body.pnq-nord {
  --pnq-primary:        #2e3440 !important;
  --pnq-primary-light:  #3b4252 !important;
  --pnq-primary-hover:  #434c5e !important;
  --pnq-on-primary:     #eceff4 !important;
  --pnq-on-primary-dim: #88c0d0 !important;

  --pnq-bg:             #242933 !important;
  --pnq-surface:        #2e3440 !important;
  --pnq-surface-2:      #3b4252 !important;
  --pnq-text:           #eceff4 !important;
  --pnq-text-muted:     #88c0d0 !important;

  --pnq-accent:         #88c0d0 !important;
  --pnq-accent-hover:   #81a1c1 !important;
  --pnq-accent-soft:    rgba(136, 192, 208, 0.20) !important;
  --pnq-on-accent:      #242933 !important;

  --pnq-border:         rgba(136, 192, 208, 0.25) !important;
  --pnq-border-strong:  #88c0d0 !important;
  --pnq-dot-color:      #88c0d0 !important;
  --pnq-shadow:         0 4px 20px rgba(0, 0, 0, 0.40) !important;
  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   5. SOLARIZED NOC (Deep Oceanic Teal & Warm Amber)
   -------------------------------------------------------------------------- */
:root[data-theme="solarized"],
html[data-theme="solarized"],
body.pnq-solarized {
  --pnq-primary:        #002b36 !important;
  --pnq-primary-light:  #073642 !important;
  --pnq-primary-hover:  #0b4959 !important;
  --pnq-on-primary:     #93a1a1 !important;
  --pnq-on-primary-dim: #2aa198 !important;

  --pnq-bg:             #00212b !important;
  --pnq-surface:        #002b36 !important;
  --pnq-surface-2:      #073642 !important;
  --pnq-text:           #fdf6e3 !important;
  --pnq-text-muted:     #2aa198 !important;

  --pnq-accent:         #2aa198 !important;
  --pnq-accent-hover:   #b58900 !important;
  --pnq-accent-soft:    rgba(42, 161, 152, 0.20) !important;
  --pnq-on-accent:      #002b36 !important;

  --pnq-border:         rgba(42, 161, 152, 0.30) !important;
  --pnq-border-strong:  #2aa198 !important;
  --pnq-dot-color:      #2aa198 !important;
  --pnq-shadow:         0 4px 20px rgba(0, 33, 43, 0.70) !important;
  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   6. DRACULA GOTHIC (Dark Vampire Plum, Lavender & Pink)
   -------------------------------------------------------------------------- */
:root[data-theme="dracula"],
html[data-theme="dracula"],
body.pnq-dracula {
  --pnq-primary:        #282a36 !important;
  --pnq-primary-light:  #343746 !important;
  --pnq-primary-hover:  #44475a !important;
  --pnq-on-primary:     #f8f8f2 !important;
  --pnq-on-primary-dim: #bd93f9 !important;

  --pnq-bg:             #1e1f29 !important;
  --pnq-surface:        #282a36 !important;
  --pnq-surface-2:      #343746 !important;
  --pnq-text:           #f8f8f2 !important;
  --pnq-text-muted:     #bd93f9 !important;

  --pnq-accent:         #ff79c6 !important;
  --pnq-accent-hover:   #bd93f9 !important;
  --pnq-accent-soft:    rgba(255, 121, 198, 0.22) !important;
  --pnq-on-accent:      #1e1f29 !important;

  --pnq-border:         rgba(189, 147, 249, 0.30) !important;
  --pnq-border-strong:  #ff79c6 !important;
  --pnq-dot-color:      #ff79c6 !important;
  --pnq-shadow:         0 4px 22px rgba(30, 31, 41, 0.75) !important;
  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   7. RETRO TERMINAL (Matrix Pitch Black & Phosphor Green)
   -------------------------------------------------------------------------- */
:root[data-theme="matrix"],
html[data-theme="matrix"],
body.pnq-matrix {
  --pnq-primary:        #000a02 !important;
  --pnq-primary-light:  #001805 !important;
  --pnq-primary-hover:  #002808 !important;
  --pnq-on-primary:     #00ff66 !important;
  --pnq-on-primary-dim: #00cc52 !important;

  --pnq-bg:             #000500 !important;
  --pnq-surface:        #001003 !important;
  --pnq-surface-2:      #001805 !important;
  --pnq-text:           #00ff66 !important;
  --pnq-text-muted:     #00cc52 !important;

  --pnq-accent:         #00ff66 !important;
  --pnq-accent-hover:   #33ff85 !important;
  --pnq-accent-soft:    rgba(0, 255, 102, 0.18) !important;
  --pnq-on-accent:      #000000 !important;

  --pnq-border:         rgba(0, 255, 102, 0.35) !important;
  --pnq-border-strong:  #00ff66 !important;
  --pnq-dot-color:      #00ff66 !important;
  --pnq-shadow:         0 0 20px rgba(0, 255, 102, 0.25) !important;
  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   8. UNIVERSAL UI ELEMENT & TOOLBAR STYLING
   -------------------------------------------------------------------------- */
body {
  background-color: var(--pnq-bg) !important;
  color: var(--pnq-text) !important;
}

/* Canvas Toolbar (Quickbar) */
div[id$="-quickbar"], .canvas-quickbar, #pnq-buttons {
  background-color: var(--pnq-surface) !important;
  border-bottom: 2px solid var(--pnq-border-strong) !important;
  box-shadow: var(--pnq-shadow) !important;
  backdrop-filter: blur(12px) !important;
  transition: all 0.25s ease !important;
}

.topbar, header.topbar, .navbar {
  background-color: var(--pnq-primary) !important;
  border-bottom: 2px solid var(--pnq-border-strong) !important;
  box-shadow: var(--pnq-shadow) !important;
  transition: all 0.25s ease !important;
}

.topbar-brand-text, .navbar-brand {
  color: var(--pnq-on-primary) !important;
  font-weight: 600 !important;
}

.sidebar, nav.sidebar, .main-sidebar {
  background-color: var(--pnq-primary) !important;
  border-right: 1px solid var(--pnq-border) !important;
  transition: all 0.25s ease !important;
}

.content, main.content, #view {
  background-color: var(--pnq-bg) !important;
  color: var(--pnq-text) !important;
}

.card, .panel, .panel-default, .box,
.content-wrapper, .dropdown-menu {
  background-color: var(--pnq-surface) !important;
  border: 1px solid var(--pnq-border) !important;
  box-shadow: var(--pnq-shadow) !important;
  color: var(--pnq-text) !important;
}

.btn, .pnq-btn {
  background-color: var(--pnq-surface-2) !important;
  border: 1px solid var(--pnq-border) !important;
  color: var(--pnq-text) !important;
  transition: all 0.15s ease !important;
}
.btn:hover, .pnq-btn:hover {
  background-color: var(--pnq-surface) !important;
  border-color: var(--pnq-accent) !important;
  color: var(--pnq-accent) !important;
}

/* --------------------------------------------------------------------------
   9. CANVAS VIEWPORT & SVELTEFLOW TRANSPARENCY FIX
   -------------------------------------------------------------------------- */
/* Unsmother the grid: All inner containers must be transparent */
.svelte-flow__container,
.svelte-flow__pane,
.svelte-flow__zoom,
.svelte-flow__viewport,
.svelte-flow__edge-labels,
.svelte-flow__edges,
.svelte-flow__nodes {
  background: transparent !important;
  background-color: transparent !important;
}

/* Root Canvas Background */
.pnq-canvas-flow,
#pnq-island-canvas-flow,
#lab-viewport,
#viewport,
.canvas,
#topology-body {
  background-color: var(--pnq-bg) !important;
  color: var(--pnq-text) !important;
  transition: background-color 0.25s ease, color 0.25s ease;
}

/* SVG background layer */
svg.svelte-flow__background {
  background: transparent !important;
  background-color: transparent !important;
}

/* Vibrant, bold 1.6px theme grid dots */
svg.svelte-flow__background circle.svelte-flow__background-pattern {
  fill: var(--pnq-dot-color) !important;
  r: 1.6 !important;
  transition: fill 0.25s ease;
}

.svelte-flow__panel,
.svelte-flow__controls {
  background-color: var(--pnq-surface) !important;
  border: 1px solid var(--pnq-border-strong) !important;
  box-shadow: var(--pnq-shadow) !important;
}

.svelte-flow__controls button {
  background-color: var(--pnq-surface-2) !important;
  color: var(--pnq-text) !important;
  border-bottom: 1px solid var(--pnq-border) !important;
}
EOF

# Copy stylesheet to all html directories
cp -f "$DARK_CSS" /opt/unetlab/html/main/css/azambasha-dark.css 2>/dev/null || true
cp -f "$DARK_CSS" /opt/unetlab/html/assets-common/css/azambasha-dark.css 2>/dev/null || true
rm -f /opt/unetlab/html/login/azambasha-dark.css 2>/dev/null || true
chmod 0644 /opt/unetlab/html/themes/default/css/azambasha-dark.css            /opt/unetlab/html/main/css/azambasha-dark.css            /opt/unetlab/html/assets-common/css/azambasha-dark.css 2>/dev/null || true

# 2. Inject stylesheet link into UI HTML templates (excluding login which has its own cyber-glass theme)
INJECT_TAG='<link rel="stylesheet" id="azambasha-dark-theme" href="/themes/default/css/azambasha-dark.css">'

# Ensure login page uses its dedicated futuristic cyber-glass design system
sed -i '/id="azambasha-dark-theme"/d' /opt/unetlab/html/login/index.html 2>/dev/null || true

for html_file in     "/opt/unetlab/html/themes/default/index.html"     "/opt/unetlab/html/main/index.html"     "/opt/unetlab/html/index.html"; do
    if [ -f "$html_file" ]; then
        sed -i '/id="azambasha-dark-theme"/d' "$html_file" 2>/dev/null || true
        if grep -q "</head>" "$html_file"; then
            sed -i "s|</head>|  ${INJECT_TAG}\n</head>|I" "$html_file"
        else
            echo "$INJECT_TAG" >> "$html_file"
        fi
        echo "  [✔] Unified multi-theme injected into $html_file"
    fi
done

# 3. Deploy Logo & UI Branding Assets
if [ -f "${SCRIPT_DIR}/azambasha-apply-branding.sh" ]; then
    bash "${SCRIPT_DIR}/azambasha-apply-branding.sh" || true
elif [ -d "${PARENT_DIR}/assets" ]; then
    cp -f "${PARENT_DIR}/assets/logo.png" "/opt/unetlab/html/themes/default/images/logo.png" 2>/dev/null || true
    cp -f "${PARENT_DIR}/assets/logo.png" "/opt/unetlab/html/images/logo.png" 2>/dev/null || true
    cp -f "${PARENT_DIR}/assets/favicon.png" "/opt/unetlab/html/themes/default/images/favicon.ico" 2>/dev/null || true
    echo "  [✔] Azam Basha logo and favicon deployed"
fi

# 4. Refresh Web Server & Cache
if command -v systemctl >/dev/null 2>&1; then
    systemctl reload apache2 2>/dev/null || true
fi

echo "============================================================"
echo "  [SUCCESS] Azam Basha High-Identity Multi-Theme Applied!"
echo "============================================================"
