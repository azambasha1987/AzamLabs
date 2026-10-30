#!/usr/bin/env bash
# ==============================================================================
# Azam Basha Enterprise Multi-Theme Design System (7 Distinct Palettes)
# 1. Obsidian Slate (Default Dark)
# 2. Crisp Daylight (Default Light)
# 3. Cyber Matrix   (Cyberpunk Neon Synthwave)
# 4. Nord Arctic    (Scandinavian Frost)
# 5. Midnight Navy  (Enterprise NOC Operations)
# 6. Tokyo Night    (Developer Twilight)
# 7. Pure OLED      (100% True Black)
# Full runtime synchronization across Dashboard, Lab Canvas, & Overlays.
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
echo "    Applying Azam Basha Multi-Theme Design System (7 Themes)"
echo "============================================================"

# Ensure Target CSS Directories exist
mkdir -p /opt/unetlab/html/themes/default/css          /opt/unetlab/html/main/css          /opt/unetlab/html/assets-common/css 2>/dev/null || true

DARK_CSS="/opt/unetlab/html/themes/default/css/azambasha-dark.css"

cat > "$DARK_CSS" << 'EOF'
/* ==========================================================================
   Azam Basha Enterprise Multi-Theme Palette Engine
   7 Production Palettes: Obsidian, Light, Cyberpunk, Nord, Midnight, Tokyo, OLED
   ========================================================================== */

/* --------------------------------------------------------------------------
   1. OBSIDIAN SLATE (Default Dark) — Active when theme is dark or unspecified
   -------------------------------------------------------------------------- */
:root,
:root[data-theme="dark"],
html[data-theme="dark"],
body.pnq-dark {
  --pnq-primary:        #0a0c10 !important;
  --pnq-primary-light:  #181c28 !important;
  --pnq-primary-hover:  #131620 !important;
  --pnq-on-primary:     #f8fafc !important;
  --pnq-on-primary-dim: #94a3b8 !important;

  --pnq-bg:             #07080c !important;
  --pnq-surface:        #0f1117 !important;
  --pnq-surface-2:      #151822 !important;
  --pnq-text:           #f8fafc !important;
  --pnq-text-muted:     #94a3b8 !important;

  --pnq-accent:         #3b82f6 !important;
  --pnq-accent-hover:   #2563eb !important;
  --pnq-accent-soft:    rgba(59, 130, 246, 0.15) !important;
  --pnq-on-accent:      #ffffff !important;

  --pnq-danger:         #ef4444 !important;
  --pnq-danger-soft:    rgba(239, 68, 68, 0.14) !important;
  --pnq-ok:             #10b981 !important;
  --pnq-warn:           #f59e0b !important;

  --pnq-border:         rgba(255, 255, 255, 0.08) !important;
  --pnq-border-strong:  rgba(255, 255, 255, 0.16) !important;
  --pnq-shadow:         0 4px 20px rgba(0, 0, 0, 0.55) !important;

  --pnq-folder:         #fbbf24 !important;
  --pnq-preview-from:   #0d0f16 !important;
  --pnq-preview-to:     #07080c !important;
  --pnq-preview-live-from: #0c1420 !important;
  --pnq-preview-live-to:   #07080c !important;
  --pnq-overlay-chip:   rgba(21, 24, 34, 0.92) !important;
  --pnq-card-btn:       rgba(21, 24, 34, 0.95) !important;
  --pnq-card-btn-hover: #222636 !important;
  --pnq-perm-hover:     #1a1d28 !important;
  --pnq-hover-veil:     rgba(255, 255, 255, 0.04) !important;
  --pnq-overlay-veil:   rgba(7, 8, 12, 0.75) !important;

  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   2. CRISP DAYLIGHT (Modern High-Contrast Light)
   -------------------------------------------------------------------------- */
:root[data-theme="light"],
html[data-theme="light"],
body.pnq-light,
html:not([data-theme="dark"]):not([data-theme="cyberpunk"]):not([data-theme="nord"]):not([data-theme="midnight"]):not([data-theme="tokyo-night"]):not([data-theme="oled"]) body:not(.pnq-dark) {
  --pnq-primary:        #ffffff !important;
  --pnq-primary-light:  #f1f5f9 !important;
  --pnq-primary-hover:  #e2e8f0 !important;
  --pnq-on-primary:     #0f172a !important;
  --pnq-on-primary-dim: #64748b !important;

  --pnq-bg:             #f8fafc !important;
  --pnq-surface:        #ffffff !important;
  --pnq-surface-2:      #f1f5f9 !important;
  --pnq-text:           #0f172a !important;
  --pnq-text-muted:     #64748b !important;

  --pnq-accent:         #2563eb !important;
  --pnq-accent-hover:   #1d4ed8 !important;
  --pnq-accent-soft:    rgba(37, 99, 235, 0.10) !important;
  --pnq-on-accent:      #ffffff !important;

  --pnq-danger:         #dc2626 !important;
  --pnq-danger-soft:    rgba(220, 38, 38, 0.10) !important;
  --pnq-ok:             #16a34a !important;
  --pnq-warn:           #d97706 !important;

  --pnq-border:         rgba(0, 0, 0, 0.10) !important;
  --pnq-border-strong:  rgba(0, 0, 0, 0.18) !important;
  --pnq-shadow:         0 1px 3px rgba(0, 0, 0, 0.08), 0 4px 12px rgba(0, 0, 0, 0.05) !important;

  --pnq-folder:         #d97706 !important;
  --pnq-preview-from:   #f8fafc !important;
  --pnq-preview-to:     #f1f5f9 !important;
  --pnq-preview-live-from: #f0fdf4 !important;
  --pnq-preview-live-to:   #dcfce7 !important;
  --pnq-overlay-chip:   rgba(255, 255, 255, 0.90) !important;
  --pnq-card-btn:       rgba(255, 255, 255, 0.92) !important;
  --pnq-card-btn-hover: #ffffff !important;
  --pnq-perm-hover:     #f1f5f9 !important;
  --pnq-hover-veil:     rgba(0, 0, 0, 0.04) !important;
  --pnq-overlay-veil:   rgba(248, 250, 252, 0.65) !important;

  color-scheme: light !important;
}

/* --------------------------------------------------------------------------
   3. CYBER MATRIX (Cyberpunk Neon Synthwave — matches homescreen)
   -------------------------------------------------------------------------- */
:root[data-theme="cyberpunk"],
html[data-theme="cyberpunk"],
body.pnq-cyberpunk {
  --pnq-primary:        #060b17 !important;
  --pnq-primary-light:  #0d162d !important;
  --pnq-primary-hover:  #111c38 !important;
  --pnq-on-primary:     #00f2fe !important;
  --pnq-on-primary-dim: #94a3b8 !important;

  --pnq-bg:             #040711 !important;
  --pnq-surface:        #0a0f1d !important;
  --pnq-surface-2:      #0f172a !important;
  --pnq-text:           #f8fafc !important;
  --pnq-text-muted:     #00f2fe !important;

  --pnq-accent:         #00f2fe !important;
  --pnq-accent-hover:   #38bdf8 !important;
  --pnq-accent-soft:    rgba(0, 242, 254, 0.18) !important;
  --pnq-on-accent:      #040711 !important;

  --pnq-danger:         #ec4899 !important;
  --pnq-danger-soft:    rgba(236, 72, 153, 0.18) !important;
  --pnq-ok:             #10b981 !important;
  --pnq-warn:           #fbbf24 !important;

  --pnq-border:         rgba(0, 242, 254, 0.22) !important;
  --pnq-border-strong:  rgba(0, 242, 254, 0.45) !important;
  --pnq-shadow:         0 4px 25px rgba(0, 242, 254, 0.22) !important;

  --pnq-folder:         #00f2fe !important;
  --pnq-preview-from:   #060b17 !important;
  --pnq-preview-to:     #040711 !important;
  --pnq-preview-live-from: #091a2f !important;
  --pnq-preview-live-to:   #040711 !important;
  --pnq-overlay-chip:   rgba(10, 15, 29, 0.94) !important;
  --pnq-card-btn:       rgba(10, 15, 29, 0.95) !important;
  --pnq-card-btn-hover: #16223b !important;
  --pnq-perm-hover:     #131c33 !important;
  --pnq-hover-veil:     rgba(0, 242, 254, 0.05) !important;
  --pnq-overlay-veil:   rgba(4, 7, 17, 0.8) !important;

  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   4. NORD ARCTIC (Scandinavian Minimal Slate & Frost)
   -------------------------------------------------------------------------- */
:root[data-theme="nord"],
html[data-theme="nord"],
body.pnq-nord {
  --pnq-primary:        #242933 !important;
  --pnq-primary-light:  #2e3440 !important;
  --pnq-primary-hover:  #3b4252 !important;
  --pnq-on-primary:     #eceff4 !important;
  --pnq-on-primary-dim: #d8dee9 !important;

  --pnq-bg:             #1e222a !important;
  --pnq-surface:        #2e3440 !important;
  --pnq-surface-2:      #3b4252 !important;
  --pnq-text:           #eceff4 !important;
  --pnq-text-muted:     #88c0d0 !important;

  --pnq-accent:         #88c0d0 !important;
  --pnq-accent-hover:   #81a1c1 !important;
  --pnq-accent-soft:    rgba(136, 192, 208, 0.18) !important;
  --pnq-on-accent:      #2e3440 !important;

  --pnq-danger:         #bf616a !important;
  --pnq-danger-soft:    rgba(191, 97, 106, 0.16) !important;
  --pnq-ok:             #a3be8c !important;
  --pnq-warn:           #ebcb8b !important;

  --pnq-border:         rgba(216, 222, 233, 0.14) !important;
  --pnq-border-strong:  rgba(136, 192, 208, 0.35) !important;
  --pnq-shadow:         0 4px 20px rgba(0, 0, 0, 0.45) !important;

  --pnq-folder:         #ebcb8b !important;
  --pnq-preview-from:   #242933 !important;
  --pnq-preview-to:     #1e222a !important;
  --pnq-preview-live-from: #25333d !important;
  --pnq-preview-live-to:   #1e222a !important;
  --pnq-overlay-chip:   rgba(46, 52, 64, 0.94) !important;
  --pnq-card-btn:       rgba(46, 52, 64, 0.95) !important;
  --pnq-card-btn-hover: #3b4252 !important;
  --pnq-perm-hover:     #383f4f !important;
  --pnq-hover-veil:     rgba(136, 192, 208, 0.05) !important;
  --pnq-overlay-veil:   rgba(30, 34, 42, 0.78) !important;

  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   5. MIDNIGHT NAVY (Enterprise NOC Operations & Deep Blue)
   -------------------------------------------------------------------------- */
:root[data-theme="midnight"],
html[data-theme="midnight"],
body.pnq-midnight {
  --pnq-primary:        #060d1f !important;
  --pnq-primary-light:  #0a1530 !important;
  --pnq-primary-hover:  #0f1f45 !important;
  --pnq-on-primary:     #f1f5f9 !important;
  --pnq-on-primary-dim: #93c5fd !important;

  --pnq-bg:             #040915 !important;
  --pnq-surface:        #0a1530 !important;
  --pnq-surface-2:      #0f1f45 !important;
  --pnq-text:           #f1f5f9 !important;
  --pnq-text-muted:     #93c5fd !important;

  --pnq-accent:         #38bdf8 !important;
  --pnq-accent-hover:   #0284c7 !important;
  --pnq-accent-soft:    rgba(56, 189, 248, 0.18) !important;
  --pnq-on-accent:      #ffffff !important;

  --pnq-danger:         #f43f5e !important;
  --pnq-danger-soft:    rgba(244, 63, 94, 0.16) !important;
  --pnq-ok:             #10b981 !important;
  --pnq-warn:           #fbbf24 !important;

  --pnq-border:         rgba(56, 189, 248, 0.16) !important;
  --pnq-border-strong:  rgba(56, 189, 248, 0.35) !important;
  --pnq-shadow:         0 4px 22px rgba(6, 13, 31, 0.65) !important;

  --pnq-folder:         #fbbf24 !important;
  --pnq-preview-from:   #060d1f !important;
  --pnq-preview-to:     #040915 !important;
  --pnq-preview-live-from: #081736 !important;
  --pnq-preview-live-to:   #040915 !important;
  --pnq-overlay-chip:   rgba(10, 21, 48, 0.94) !important;
  --pnq-card-btn:       rgba(10, 21, 48, 0.95) !important;
  --pnq-card-btn-hover: #142858 !important;
  --pnq-perm-hover:     #12234e !important;
  --pnq-hover-veil:     rgba(56, 189, 248, 0.05) !important;
  --pnq-overlay-veil:   rgba(4, 9, 21, 0.8) !important;

  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   6. TOKYO NIGHT (Developer Twilight & Soft Lavender)
   -------------------------------------------------------------------------- */
:root[data-theme="tokyo-night"],
html[data-theme="tokyo-night"],
body.pnq-tokyo-night {
  --pnq-primary:        #16161e !important;
  --pnq-primary-light:  #1a1b26 !important;
  --pnq-primary-hover:  #24283b !important;
  --pnq-on-primary:     #c0caf5 !important;
  --pnq-on-primary-dim: #9aa5ce !important;

  --pnq-bg:             #13131a !important;
  --pnq-surface:        #1a1b26 !important;
  --pnq-surface-2:      #24283b !important;
  --pnq-text:           #c0caf5 !important;
  --pnq-text-muted:     #7aa2f7 !important;

  --pnq-accent:         #7aa2f7 !important;
  --pnq-accent-hover:   #bb9af7 !important;
  --pnq-accent-soft:    rgba(122, 162, 247, 0.18) !important;
  --pnq-on-accent:      #1a1b26 !important;

  --pnq-danger:         #f7768e !important;
  --pnq-danger-soft:    rgba(247, 118, 142, 0.16) !important;
  --pnq-ok:             #9ece6a !important;
  --pnq-warn:           #e0af68 !important;

  --pnq-border:         rgba(122, 162, 247, 0.15) !important;
  --pnq-border-strong:  rgba(187, 154, 247, 0.35) !important;
  --pnq-shadow:         0 4px 20px rgba(0, 0, 0, 0.5) !important;

  --pnq-folder:         #e0af68 !important;
  --pnq-preview-from:   #16161e !important;
  --pnq-preview-to:     #13131a !important;
  --pnq-preview-live-from: #192036 !important;
  --pnq-preview-live-to:   #13131a !important;
  --pnq-overlay-chip:   rgba(26, 27, 38, 0.94) !important;
  --pnq-card-btn:       rgba(26, 27, 38, 0.95) !important;
  --pnq-card-btn-hover: #292e42 !important;
  --pnq-perm-hover:     #222638 !important;
  --pnq-hover-veil:     rgba(122, 162, 247, 0.05) !important;
  --pnq-overlay-veil:   rgba(19, 19, 26, 0.8) !important;

  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   7. PURE OLED (Absolute Pitch Black #000000)
   -------------------------------------------------------------------------- */
:root[data-theme="oled"],
html[data-theme="oled"],
body.pnq-oled {
  --pnq-primary:        #000000 !important;
  --pnq-primary-light:  #0a0a0a !important;
  --pnq-primary-hover:  #121212 !important;
  --pnq-on-primary:     #ffffff !important;
  --pnq-on-primary-dim: #a3a3a3 !important;

  --pnq-bg:             #000000 !important;
  --pnq-surface:        #080808 !important;
  --pnq-surface-2:      #121212 !important;
  --pnq-text:           #ffffff !important;
  --pnq-text-muted:     #00f0ff !important;

  --pnq-accent:         #00f0ff !important;
  --pnq-accent-hover:   #00c8d6 !important;
  --pnq-accent-soft:    rgba(0, 240, 255, 0.15) !important;
  --pnq-on-accent:      #000000 !important;

  --pnq-danger:         #ff3344 !important;
  --pnq-danger-soft:    rgba(255, 51, 68, 0.16) !important;
  --pnq-ok:             #00ff88 !important;
  --pnq-warn:           #ffbb00 !important;

  --pnq-border:         rgba(255, 255, 255, 0.14) !important;
  --pnq-border-strong:  rgba(255, 255, 255, 0.28) !important;
  --pnq-shadow:         none !important;

  --pnq-folder:         #ffbb00 !important;
  --pnq-preview-from:   #000000 !important;
  --pnq-preview-to:     #000000 !important;
  --pnq-preview-live-from: #051417 !important;
  --pnq-preview-live-to:   #000000 !important;
  --pnq-overlay-chip:   rgba(10, 10, 10, 0.95) !important;
  --pnq-card-btn:       rgba(10, 10, 10, 0.96) !important;
  --pnq-card-btn-hover: #1a1a1a !important;
  --pnq-perm-hover:     #141414 !important;
  --pnq-hover-veil:     rgba(255, 255, 255, 0.04) !important;
  --pnq-overlay-veil:   rgba(0, 0, 0, 0.85) !important;

  color-scheme: dark !important;
}

/* --------------------------------------------------------------------------
   8. UNIVERSAL UI ELEMENT STYLING (DRIVEN BY TOKENS)
   -------------------------------------------------------------------------- */
body {
  background-color: var(--pnq-bg) !important;
  color: var(--pnq-text) !important;
}

.topbar, header.topbar, .navbar {
  background-color: var(--pnq-primary) !important;
  border-bottom: 1px solid var(--pnq-border) !important;
  box-shadow: var(--pnq-shadow) !important;
}

.topbar-brand-text, .navbar-brand {
  color: var(--pnq-on-primary) !important;
  font-weight: 600 !important;
}

.topbar-user {
  color: var(--pnq-on-primary-dim) !important;
}
.topbar-user span {
  color: var(--pnq-on-primary) !important;
}

.topbar-logout {
  color: var(--pnq-on-primary-dim) !important;
  border: 1px solid transparent !important;
}
.topbar-logout:hover {
  background-color: var(--pnq-primary-hover) !important;
  color: var(--pnq-on-primary) !important;
  border-color: var(--pnq-border) !important;
}

.sidebar, nav.sidebar, .main-sidebar {
  background-color: var(--pnq-primary) !important;
  border-right: 1px solid var(--pnq-border) !important;
}

.nav-item {
  color: var(--pnq-on-primary-dim) !important;
  background-color: transparent !important;
}
.nav-item:hover {
  background-color: var(--pnq-primary-hover) !important;
  color: var(--pnq-on-primary) !important;
}
.nav-item.active, .nav-item.is-active {
  background-color: var(--pnq-accent-soft) !important;
  color: var(--pnq-accent) !important;
  box-shadow: inset 3px 0 0 var(--pnq-accent) !important;
}

.sidebar-version {
  background-color: var(--pnq-surface-2) !important;
  border: 1px solid var(--pnq-border) !important;
  color: var(--pnq-on-primary-dim) !important;
}

.content, main.content, #view {
  background-color: var(--pnq-bg) !important;
  color: var(--pnq-text) !important;
}

.view-title {
  color: var(--pnq-text) !important;
}

.fm-split__list, .fm-split__preview,
.card, .panel, .panel-default, .box,
.content-wrapper, .dropdown-menu {
  background-color: var(--pnq-surface) !important;
  border: 1px solid var(--pnq-border) !important;
  box-shadow: var(--pnq-shadow) !important;
  color: var(--pnq-text) !important;
}

.lab-preview__stage {
  background: var(--pnq-bg) !important;
  border: 1px solid var(--pnq-border) !important;
}
.lab-preview__info {
  background-color: var(--pnq-surface-2) !important;
  border: 1px solid var(--pnq-border) !important;
}

.btn {
  background-color: var(--pnq-surface-2) !important;
  border: 1px solid var(--pnq-border) !important;
  color: var(--pnq-text) !important;
}
.btn:hover {
  background-color: var(--pnq-surface) !important;
  border-color: var(--pnq-accent) !important;
}

input, select, textarea, .form-control {
  background-color: var(--pnq-surface-2) !important;
  color: var(--pnq-text) !important;
  border: 1px solid var(--pnq-border) !important;
}

.table, .fm-table, table {
  background-color: var(--pnq-surface) !important;
  color: var(--pnq-text) !important;
}
.table th {
  background-color: var(--pnq-surface-2) !important;
  color: var(--pnq-text-muted) !important;
  border-bottom: 1px solid var(--pnq-border) !important;
}
.table td {
  border-bottom: 1px solid var(--pnq-border) !important;
  color: var(--pnq-text) !important;
}
.table tbody tr:hover {
  background-color: var(--pnq-surface-2) !important;
}

.modal, .modal-content {
  background-color: var(--pnq-surface) !important;
  border: 1px solid var(--pnq-border-strong) !important;
  color: var(--pnq-text) !important;
}
.modal-head, .modal-header {
  background-color: var(--pnq-surface-2) !important;
  border-bottom: 1px solid var(--pnq-border) !important;
  color: var(--pnq-text) !important;
}
.modal-foot, .modal-footer {
  background-color: var(--pnq-surface-2) !important;
  border-top: 1px solid var(--pnq-border) !important;
}

/* --------------------------------------------------------------------------
   9. PER-THEME CANVAS VIEWPORT BACKGROUNDS & GRIDS (SvelteFlow & Legacy)
   -------------------------------------------------------------------------- */
.pnq-canvas-flow,
.svelte-flow,
.svelte-flow__container,
svg.svelte-flow__background,
#pnq-island-canvas-flow,
#lab-viewport,
#viewport,
.canvas,
#topology-body {
  background-color: var(--pnq-bg) !important;
  color: var(--pnq-text) !important;
  transition: background-color 0.25s ease, color 0.25s ease;
}

.svelte-flow__background-pattern {
  fill: var(--pnq-border-strong) !important;
  transition: fill 0.25s ease;
}

.svelte-flow__panel,
.svelte-flow__controls {
  background-color: var(--pnq-surface) !important;
  border: 1px solid var(--pnq-border) !important;
  box-shadow: var(--pnq-shadow) !important;
}

.svelte-flow__controls button {
  background-color: var(--pnq-surface-2) !important;
  color: var(--pnq-text) !important;
  border-bottom: 1px solid var(--pnq-border) !important;
}

.svelte-flow__controls button:hover {
  background-color: var(--pnq-surface) !important;
  color: var(--pnq-accent) !important;
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
        # Remove any duplicate link tags first
        sed -i '/id="azambasha-dark-theme"/d' "$html_file" 2>/dev/null || true
        # Append before </head>
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
echo "  [SUCCESS] Azam Basha Multi-Theme Engine (7 Themes) Applied!"
echo "============================================================"
