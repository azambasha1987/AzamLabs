#!/usr/bin/env bash
# ==============================================================================
# Azam Basha Enterprise Dual Theme System (Pure Dark & Crisp Modern Light)
# Provides a 100% unified, seamless, modern design system across all pages:
# Dashboard (/main/), Lab Canvas (/themes/default/), Login (/login/), & Overlays.
# Supports full runtime toggling between Dark Mode and Light Mode.
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
echo "   Applying Azam Basha Unified Dual Theme (Dark & Light)    "
echo "============================================================"

# Ensure Target CSS Directories exist
mkdir -p /opt/unetlab/html/themes/default/css \
         /opt/unetlab/html/main/css \
         /opt/unetlab/html/assets-common/css 2>/dev/null || true

DARK_CSS="/opt/unetlab/html/themes/default/css/azambasha-dark.css"

cat > "$DARK_CSS" << 'EOF'
/* ==========================================================================
   Azam Basha Enterprise Dual Theme System (Pure Dark & Modern Crisp Light)
   ========================================================================== */

/* --------------------------------------------------------------------------
   1. DARK THEME TOKENS (Active when data-theme="dark" OR body has .pnq-dark)
   -------------------------------------------------------------------------- */
:root,
:root[data-theme="dark"],
html[data-theme="dark"],
body.pnq-dark {
  /* Topbar & Sidebar Chrome */
  --pnq-primary:        #0a0c10 !important;
  --pnq-primary-light:  #181c28 !important;
  --pnq-primary-hover:  #131620 !important;
  --pnq-on-primary:     #f8fafc !important;
  --pnq-on-primary-dim: #94a3b8 !important;

  /* App Surfaces & Backgrounds */
  --pnq-bg:             #07080c !important;
  --pnq-surface:        #0f1117 !important;
  --pnq-surface-2:      #151822 !important;
  --pnq-text:           #f8fafc !important;
  --pnq-text-muted:     #94a3b8 !important;

  /* Brand Accents */
  --pnq-accent:         #3b82f6 !important;
  --pnq-accent-hover:   #2563eb !important;
  --pnq-accent-soft:    rgba(59, 130, 246, 0.15) !important;
  --pnq-on-accent:      #ffffff !important;

  /* Status Colors */
  --pnq-danger:         #ef4444 !important;
  --pnq-danger-soft:    rgba(239, 68, 68, 0.14) !important;
  --pnq-ok:             #10b981 !important;
  --pnq-warn:           #f59e0b !important;

  /* Sleek Minimal Borders & Elevation */
  --pnq-border:         rgba(255, 255, 255, 0.08) !important;
  --pnq-border-strong:  rgba(255, 255, 255, 0.16) !important;
  --pnq-shadow:         0 4px 20px rgba(0, 0, 0, 0.55) !important;

  /* Media & Canvas Previews */
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
   2. LIGHT THEME TOKENS (Active when data-theme="light" OR body does NOT have .pnq-dark)
   -------------------------------------------------------------------------- */
:root[data-theme="light"],
html[data-theme="light"],
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) {
  /* Topbar & Sidebar Chrome */
  --pnq-primary:        #ffffff !important;
  --pnq-primary-light:  #f1f5f9 !important;
  --pnq-primary-hover:  #e2e8f0 !important;
  --pnq-on-primary:     #0f172a !important;
  --pnq-on-primary-dim: #64748b !important;

  /* App Surfaces & Backgrounds */
  --pnq-bg:             #f8fafc !important;
  --pnq-surface:        #ffffff !important;
  --pnq-surface-2:      #f1f5f9 !important;
  --pnq-text:           #0f172a !important;
  --pnq-text-muted:     #64748b !important;

  /* Brand Accents */
  --pnq-accent:         #2563eb !important;
  --pnq-accent-hover:   #1d4ed8 !important;
  --pnq-accent-soft:    rgba(37, 99, 235, 0.10) !important;
  --pnq-on-accent:      #ffffff !important;

  /* Status Colors */
  --pnq-danger:         #dc2626 !important;
  --pnq-danger-soft:    rgba(220, 38, 38, 0.10) !important;
  --pnq-ok:             #16a34a !important;
  --pnq-warn:           #d97706 !important;

  /* Crisp Borders & Elevation */
  --pnq-border:         rgba(0, 0, 0, 0.10) !important;
  --pnq-border-strong:  rgba(0, 0, 0, 0.18) !important;
  --pnq-shadow:         0 1px 3px rgba(0, 0, 0, 0.08), 0 4px 12px rgba(0, 0, 0, 0.05) !important;

  /* Media & Canvas Previews */
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
   3. SCOPED DARK MODE UI ELEMENTS
   -------------------------------------------------------------------------- */
:root[data-theme="dark"] body,
body.pnq-dark {
  background-color: #07080c !important;
  color: #f8fafc !important;
}

:root[data-theme="dark"] .topbar,
:root[data-theme="dark"] header.topbar,
:root[data-theme="dark"] .navbar,
body.pnq-dark .topbar,
body.pnq-dark header.topbar {
  background-color: #0a0c10 !important;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.6) !important;
}

:root[data-theme="dark"] .topbar-brand-text,
:root[data-theme="dark"] .navbar-brand,
body.pnq-dark .topbar-brand-text {
  color: #ffffff !important;
  font-weight: 600 !important;
}

:root[data-theme="dark"] .topbar-user,
body.pnq-dark .topbar-user {
  color: #94a3b8 !important;
}
:root[data-theme="dark"] .topbar-user span,
body.pnq-dark .topbar-user span {
  color: #f1f5f9 !important;
}

:root[data-theme="dark"] .topbar-logout,
body.pnq-dark .topbar-logout {
  color: #94a3b8 !important;
  border: 1px solid transparent !important;
}
:root[data-theme="dark"] .topbar-logout:hover,
body.pnq-dark .topbar-logout:hover {
  background-color: #151822 !important;
  color: #ffffff !important;
  border-color: rgba(255, 255, 255, 0.1) !important;
}

:root[data-theme="dark"] .sidebar,
:root[data-theme="dark"] nav.sidebar,
:root[data-theme="dark"] .main-sidebar,
body.pnq-dark .sidebar {
  background-color: #0a0c10 !important;
  border-right: 1px solid rgba(255, 255, 255, 0.08) !important;
}

:root[data-theme="dark"] .nav-item,
body.pnq-dark .nav-item {
  color: #94a3b8 !important;
  background-color: transparent !important;
}
:root[data-theme="dark"] .nav-item:hover,
body.pnq-dark .nav-item:hover {
  background-color: #151822 !important;
  color: #ffffff !important;
}
:root[data-theme="dark"] .nav-item.active,
:root[data-theme="dark"] .nav-item.is-active,
body.pnq-dark .nav-item.active {
  background-color: #181c28 !important;
  color: #ffffff !important;
  box-shadow: inset 3px 0 0 #3b82f6 !important;
}

:root[data-theme="dark"] .sidebar-version,
body.pnq-dark .sidebar-version {
  background-color: #10121a !important;
  border: 1px solid rgba(255, 255, 255, 0.08) !important;
  color: #94a3b8 !important;
}

:root[data-theme="dark"] .content,
:root[data-theme="dark"] main.content,
:root[data-theme="dark"] #view,
body.pnq-dark #view {
  background-color: #07080c !important;
  color: #f8fafc !important;
}

:root[data-theme="dark"] .view-title,
body.pnq-dark .view-title {
  color: #ffffff !important;
}

:root[data-theme="dark"] .fm-split__list,
:root[data-theme="dark"] .fm-split__preview,
:root[data-theme="dark"] .card,
:root[data-theme="dark"] .panel,
:root[data-theme="dark"] .panel-default,
:root[data-theme="dark"] .box,
:root[data-theme="dark"] .content-wrapper,
:root[data-theme="dark"] .dropdown-menu,
body.pnq-dark .card,
body.pnq-dark .panel,
body.pnq-dark .panel-default,
body.pnq-dark .dropdown-menu {
  background-color: #0f1117 !important;
  border: 1px solid rgba(255, 255, 255, 0.08) !important;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.4) !important;
  color: #f8fafc !important;
}

:root[data-theme="dark"] .lab-preview__stage,
body.pnq-dark .lab-preview__stage {
  background: #0a0c12 !important;
  border: 1px solid rgba(255, 255, 255, 0.08) !important;
  background-image: radial-gradient(circle, #181c28 1px, transparent 1px) !important;
  background-size: 20px 20px !important;
}
:root[data-theme="dark"] .lab-preview__info,
body.pnq-dark .lab-preview__info {
  background-color: #131620 !important;
  border: 1px solid rgba(255, 255, 255, 0.08) !important;
}

:root[data-theme="dark"] .btn,
body.pnq-dark .btn {
  background-color: #151822 !important;
  border: 1px solid rgba(255, 255, 255, 0.12) !important;
  color: #e2e8f0 !important;
}
:root[data-theme="dark"] .btn:hover,
body.pnq-dark .btn:hover {
  background-color: #202434 !important;
  color: #ffffff !important;
  border-color: rgba(255, 255, 255, 0.2) !important;
}

:root[data-theme="dark"] input,
:root[data-theme="dark"] select,
:root[data-theme="dark"] textarea,
:root[data-theme="dark"] .form-control,
body.pnq-dark input,
body.pnq-dark select,
body.pnq-dark textarea,
body.pnq-dark .form-control {
  background-color: #131620 !important;
  color: #f8fafc !important;
  border: 1px solid rgba(255, 255, 255, 0.12) !important;
}

:root[data-theme="dark"] .table,
:root[data-theme="dark"] .fm-table,
:root[data-theme="dark"] table,
body.pnq-dark .table,
body.pnq-dark table {
  background-color: #0f1117 !important;
  color: #f8fafc !important;
}
:root[data-theme="dark"] .table th,
body.pnq-dark .table th {
  background-color: #131620 !important;
  color: #94a3b8 !important;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important;
}
:root[data-theme="dark"] .table td,
body.pnq-dark .table td {
  border-bottom: 1px solid rgba(255, 255, 255, 0.06) !important;
  color: #e2e8f0 !important;
}
:root[data-theme="dark"] .table tbody tr:hover,
body.pnq-dark .table tbody tr:hover {
  background-color: #151822 !important;
}

body.pnq-dark #lab-viewport,
body.pnq-dark #viewport,
body.pnq-dark .canvas,
body.pnq-dark .topology-canvas,
body.pnq-dark #topology-body {
  background-color: #07080c !important;
  background-image: radial-gradient(circle, #1a1e2c 1px, transparent 1px) !important;
  background-size: 24px 24px !important;
}

:root[data-theme="dark"] .modal,
:root[data-theme="dark"] .modal-content,
body.pnq-dark .modal,
body.pnq-dark .modal-content {
  background-color: #0f1117 !important;
  border: 1px solid rgba(255, 255, 255, 0.12) !important;
  color: #f8fafc !important;
}
:root[data-theme="dark"] .modal-head,
:root[data-theme="dark"] .modal-header,
body.pnq-dark .modal-header {
  background-color: #131620 !important;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important;
  color: #ffffff !important;
}
:root[data-theme="dark"] .modal-foot,
:root[data-theme="dark"] .modal-footer,
body.pnq-dark .modal-footer {
  background-color: #131620 !important;
  border-top: 1px solid rgba(255, 255, 255, 0.08) !important;
}

/* --------------------------------------------------------------------------
   4. SCOPED LIGHT MODE UI ELEMENTS
   -------------------------------------------------------------------------- */
:root[data-theme="light"] body,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) {
  background-color: #f8fafc !important;
  color: #0f172a !important;
}

:root[data-theme="light"] .topbar,
:root[data-theme="light"] header.topbar,
:root[data-theme="light"] .navbar,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .topbar,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) header.topbar {
  background-color: #ffffff !important;
  border-bottom: 1px solid #e2e8f0 !important;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05) !important;
}

:root[data-theme="light"] .topbar-brand-text,
:root[data-theme="light"] .navbar-brand,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .topbar-brand-text {
  color: #0f172a !important;
  font-weight: 600 !important;
}

:root[data-theme="light"] .topbar-user,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .topbar-user {
  color: #64748b !important;
}
:root[data-theme="light"] .topbar-user span,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .topbar-user span {
  color: #0f172a !important;
}

:root[data-theme="light"] .topbar-logout,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .topbar-logout {
  color: #64748b !important;
  border: 1px solid transparent !important;
}
:root[data-theme="light"] .topbar-logout:hover,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .topbar-logout:hover {
  background-color: #f1f5f9 !important;
  color: #0f172a !important;
  border-color: #cbd5e1 !important;
}

:root[data-theme="light"] .sidebar,
:root[data-theme="light"] nav.sidebar,
:root[data-theme="light"] .main-sidebar,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .sidebar {
  background-color: #ffffff !important;
  border-right: 1px solid #e2e8f0 !important;
}

:root[data-theme="light"] .nav-item,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .nav-item {
  color: #64748b !important;
  background-color: transparent !important;
}
:root[data-theme="light"] .nav-item:hover,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .nav-item:hover {
  background-color: #f1f5f9 !important;
  color: #0f172a !important;
}
:root[data-theme="light"] .nav-item.active,
:root[data-theme="light"] .nav-item.is-active,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .nav-item.active {
  background-color: #eff6ff !important;
  color: #2563eb !important;
  box-shadow: inset 3px 0 0 #2563eb !important;
}

:root[data-theme="light"] .sidebar-version,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .sidebar-version {
  background-color: #f8fafc !important;
  border: 1px solid #e2e8f0 !important;
  color: #64748b !important;
}

:root[data-theme="light"] .content,
:root[data-theme="light"] main.content,
:root[data-theme="light"] #view,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) #view {
  background-color: #f8fafc !important;
  color: #0f172a !important;
}

:root[data-theme="light"] .view-title,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .view-title {
  color: #0f172a !important;
}

:root[data-theme="light"] .fm-split__list,
:root[data-theme="light"] .fm-split__preview,
:root[data-theme="light"] .card,
:root[data-theme="light"] .panel,
:root[data-theme="light"] .panel-default,
:root[data-theme="light"] .box,
:root[data-theme="light"] .content-wrapper,
:root[data-theme="light"] .dropdown-menu,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .card,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .panel,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .panel-default,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .dropdown-menu {
  background-color: #ffffff !important;
  border: 1px solid #e2e8f0 !important;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05) !important;
  color: #0f172a !important;
}

:root[data-theme="light"] .lab-preview__stage,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .lab-preview__stage {
  background: #f8fafc !important;
  border: 1px solid #e2e8f0 !important;
  background-image: radial-gradient(circle, #cbd5e1 1px, transparent 1px) !important;
  background-size: 20px 20px !important;
}
:root[data-theme="light"] .lab-preview__info,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .lab-preview__info {
  background-color: #f1f5f9 !important;
  border: 1px solid #e2e8f0 !important;
}

:root[data-theme="light"] .btn,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .btn {
  background-color: #ffffff !important;
  border: 1px solid #cbd5e1 !important;
  color: #1e293b !important;
}
:root[data-theme="light"] .btn:hover,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .btn:hover {
  background-color: #f1f5f9 !important;
  color: #0f172a !important;
  border-color: #94a3b8 !important;
}

:root[data-theme="light"] input,
:root[data-theme="light"] select,
:root[data-theme="light"] textarea,
:root[data-theme="light"] .form-control,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) input,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) select,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) textarea,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .form-control {
  background-color: #ffffff !important;
  color: #0f172a !important;
  border: 1px solid #cbd5e1 !important;
}

:root[data-theme="light"] .table,
:root[data-theme="light"] .fm-table,
:root[data-theme="light"] table,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .table,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) table {
  background-color: #ffffff !important;
  color: #0f172a !important;
}
:root[data-theme="light"] .table th,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .table th {
  background-color: #f8fafc !important;
  color: #475569 !important;
  border-bottom: 1px solid #e2e8f0 !important;
}
:root[data-theme="light"] .table td,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .table td {
  border-bottom: 1px solid #f1f5f9 !important;
  color: #1e293b !important;
}
:root[data-theme="light"] .table tbody tr:hover,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .table tbody tr:hover {
  background-color: #f8fafc !important;
}

body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) #lab-viewport,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) #viewport,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .canvas,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .topology-canvas,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) #topology-body {
  background-color: #ffffff !important;
  background-image: radial-gradient(circle, #cbd5e1 1px, transparent 1px) !important;
  background-size: 20px 20px !important;
}

:root[data-theme="light"] .modal,
:root[data-theme="light"] .modal-content,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .modal,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .modal-content {
  background-color: #ffffff !important;
  border: 1px solid #cbd5e1 !important;
  color: #0f172a !important;
}
:root[data-theme="light"] .modal-head,
:root[data-theme="light"] .modal-header,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .modal-header {
  background-color: #f8fafc !important;
  border-bottom: 1px solid #e2e8f0 !important;
  color: #0f172a !important;
}
:root[data-theme="light"] .modal-foot,
:root[data-theme="light"] .modal-footer,
body.pnq-light,
html:not([data-theme="dark"]) body:not(.pnq-dark) .modal-footer {
  background-color: #f8fafc !important;
  border-top: 1px solid #e2e8f0 !important;
}

EOF

# Copy stylesheet to all html directories
cp -f "$DARK_CSS" /opt/unetlab/html/main/css/azambasha-dark.css 2>/dev/null || true
cp -f "$DARK_CSS" /opt/unetlab/html/assets-common/css/azambasha-dark.css 2>/dev/null || true
rm -f /opt/unetlab/html/login/azambasha-dark.css 2>/dev/null || true
chmod 0644 /opt/unetlab/html/themes/default/css/azambasha-dark.css \
           /opt/unetlab/html/main/css/azambasha-dark.css \
           /opt/unetlab/html/assets-common/css/azambasha-dark.css 2>/dev/null || true

# 2. Inject stylesheet link into UI HTML templates (excluding login which has its own cyber-glass theme)
INJECT_TAG='<link rel="stylesheet" id="azambasha-dark-theme" href="/themes/default/css/azambasha-dark.css">'

# Ensure login page uses its dedicated futuristic cyber-glass design system
sed -i '/id="azambasha-dark-theme"/d' /opt/unetlab/html/login/index.html 2>/dev/null || true

for html_file in \
    "/opt/unetlab/html/themes/default/index.html" \
    "/opt/unetlab/html/main/index.html" \
    "/opt/unetlab/html/index.html"; do
    if [ -f "$html_file" ]; then
        # Remove any duplicate link tags first
        sed -i '/id="azambasha-dark-theme"/d' "$html_file" 2>/dev/null || true
        # Append before </head>
        if grep -q "</head>" "$html_file"; then
            sed -i -E "s|</head>|  ${INJECT_TAG}\n</head>|I" "$html_file"
        else
            echo "$INJECT_TAG" >> "$html_file"
        fi
        echo "  [✔] Unified dual theme injected into $html_file"
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
echo "  [SUCCESS] Azam Basha Dual Theme (Dark & Light) Applied!  "
echo "============================================================"
