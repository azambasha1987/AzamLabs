#!/usr/bin/env bash
# ==============================================================================
# AzamLabs Safe APT Guard & Command Interceptor Utility
# Ubuntu 24.04 / 26.04+ Native Architecture
#
# Prevents accidental destruction of AzamLabs virtualization environment:
# 1. Intercepts 'apt upgrade', 'dist-upgrade', and 'full-upgrade' (prevents kernel/PHP break).
# 2. Intercepts 'apt autoremove' (prevents purging 32-bit IOL libraries & DKMS headers).
# 3. Permits all safe operations: 'apt update', 'apt install', 'apt search', 'apt show'.
# 4. Supports emergency override: --force-azam-override
#
# Usage:
#   sudo bash scripts/azambasha-apt-guard.sh --enable   # Install & engage guard (default)
#   sudo bash scripts/azambasha-apt-guard.sh --check    # Check guard status
#   sudo bash scripts/azambasha-apt-guard.sh --disable  # Remove guard & restore native APT
# ==============================================================================
set -euo pipefail

APT_WRAPPER="/usr/local/bin/apt"
APT_GET_WRAPPER="/usr/local/bin/apt-get"
APT_CONF_HOOK="/etc/apt/apt.conf.d/99azamlabs-apt-guard"

# Color tokens
BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
RED="\033[31m"
RESET="\033[0m"

log_info() { echo -e "${CYAN}[*]${RESET} $*"; }
log_ok()   { echo -e "${GREEN}[✔]${RESET} $*"; }
log_warn() { echo -e "${YELLOW}[⚠]${RESET} $*"; }
log_err()  { echo -e "${RED}[✘]${RESET} $*"; }

# --- Check Mode ---
if [[ "${1:-}" =~ ^(--check|--status|-c)$ ]]; then
    echo "============================================================"
    echo "         AzamLabs APT Guard Status Diagnostic Probe         "
    echo "============================================================"
    
    echo -n "[*] /usr/local/bin/apt wrapper       : "
    if [ -f "$APT_WRAPPER" ] && grep -q "BREAK AzamLabs" "$APT_WRAPPER" 2>/dev/null; then
        echo -e "${GREEN}ACTIVE (Intercepting upgrade & autoremove)${RESET}"
    elif [ -f "$APT_WRAPPER" ]; then
        echo -e "${YELLOW}CUSTOM / UNRECOGNIZED WRAPPER${RESET}"
    else
        echo -e "${RED}DISABLED (Native APT active)${RESET}"
    fi

    echo -n "[*] /usr/local/bin/apt-get wrapper   : "
    if [ -L "$APT_GET_WRAPPER" ] || [ -f "$APT_GET_WRAPPER" ]; then
        echo -e "${GREEN}ACTIVE${RESET}"
    else
        echo -e "${RED}DISABLED${RESET}"
    fi

    echo -n "[*] APT Configuration Hook           : "
    if [ -f "$APT_CONF_HOOK" ]; then
        echo -e "${GREEN}ENGAGED ($APT_CONF_HOOK)${RESET}"
    else
        echo -e "${RED}DISABLED${RESET}"
    fi

    echo -n "[*] Active Default 'apt' in PATH     : "
    ACTIVE_APT="$(which apt 2>/dev/null || echo "not found")"
    if [ "$ACTIVE_APT" = "$APT_WRAPPER" ]; then
        echo -e "${GREEN}${ACTIVE_APT} (Protected)${RESET}"
    else
        echo -e "${YELLOW}${ACTIVE_APT} (Direct)${RESET}"
    fi
    echo "============================================================"
    exit 0
fi

# Require root for mutations
if [ "$(id -u)" -ne 0 ]; then
    log_err "Please run this script as root (sudo bash $0)"
    exit 1
fi

# --- Disable / Unblock Mode ---
if [[ "${1:-}" =~ ^(--disable|--unblock|--restore|-d)$ ]]; then
    echo "============================================================"
    echo "           Disabling AzamLabs APT Guard Subsystem           "
    echo "============================================================"
    
    log_info "Removing CLI wrappers..."
    rm -f "$APT_WRAPPER" "$APT_GET_WRAPPER"
    
    log_info "Removing APT configuration hooks..."
    rm -f "$APT_CONF_HOOK"
    
    log_ok "AzamLabs APT Guard has been disabled. Native APT restored."
    exit 0
fi

# --- Enable / Engage Mode (Default) ---
echo "============================================================"
echo "          Engaging AzamLabs Safe APT Guard Subsystem         "
echo "============================================================"

mkdir -p /usr/local/bin /etc/apt/apt.conf.d

log_info "Generating high-priority CLI wrapper: ${APT_WRAPPER}..."
cat > "$APT_WRAPPER" << 'WRAPPER_EOF'
#!/usr/bin/env bash
# ==============================================================================
# AzamLabs Protective APT Interceptor Wrapper
# Protects system from destructive upgrades and autoremove operations
# ==============================================================================
REAL_BIN="/usr/bin/apt"
FORCE_OVERRIDE=0

# Parse arguments to detect emergency override flag
ARGS=()
for arg in "$@"; do
    if [ "$arg" = "--force-azam-override" ]; then
        FORCE_OVERRIDE=1
    else
        ARGS+=("$arg")
    fi
done

# First positional verb
CMD="${ARGS[0]:-}"

if [ "$FORCE_OVERRIDE" -eq 0 ]; then
    case "$CMD" in
        upgrade|dist-upgrade|full-upgrade)
            echo -e "\033[1;31m====================================================================\033[0m"
            echo -e "\033[1;31m [BLOCKED] Do Not Try to UPGRADE, this will BREAK AzamLabs.\033[0m"
            echo -e "\033[1;31m====================================================================\033[0m"
            echo -e " Running direct system upgrades overwrites custom PHP 8.5 tuning,"
            echo -e " breaks Cisco L2 DKMS bridge modules, and causes QEMU node failures."
            echo -e ""
            echo -e " \033[1;32mCanonical Update Procedure:\033[0m"
            echo -e "   Please use the hardened AzamLabs one-step update command:"
            echo -e "       \033[1;33msudo azam-update\033[0m"
            echo -e ""
            echo -e " \033[1;30m(Emergency override: add --force-azam-override to force execution)\033[0m"
            echo -e "\033[1;31m====================================================================\033[0m"
            exit 1
            ;;
        autoremove)
            echo -e "\033[1;31m====================================================================\033[0m"
            echo -e "\033[1;31m [BLOCKED] Do Not Try to AUTOREMOVE, this will BREAK AzamLabs.\033[0m"
            echo -e "\033[1;31m====================================================================\033[0m"
            echo -e " This command will purge 32-bit libraries (libc6-i386) and kernel"
            echo -e " headers essential for Cisco IOL/IOU emulation and DKMS drivers."
            echo -e ""
            echo -e " \033[1;30m(Emergency override: add --force-azam-override to force execution)\033[0m"
            echo -e "\033[1;31m====================================================================\033[0m"
            exit 1
            ;;
    esac
fi

# Pass through all safe commands (update, install, search, show, etc.)
exec "$REAL_BIN" "${ARGS[@]}"
WRAPPER_EOF

chmod 0755 "$APT_WRAPPER"
ln -sf "$APT_WRAPPER" "$APT_GET_WRAPPER"
log_ok "CLI wrappers deployed in /usr/local/bin (apt, apt-get)."

log_info "Configuring Tier 2 APT Configuration Hook: ${APT_CONF_HOOK}..."
cat > "$APT_CONF_HOOK" << 'CONF_EOF'
// AzamLabs Protective Configuration Hook
// Prevents non-interactive direct invocation of upgrade/autoremove
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
CONF_EOF

chmod 0644 "$APT_CONF_HOOK"
log_ok "APT configuration hooks and periodic upgrade suppressions applied."

# Mask unattended background timer services
for u in apt-daily.timer apt-daily-upgrade.timer unattended-upgrades.service; do
    systemctl stop "$u" 2>/dev/null || true
    systemctl mask "$u" 2>/dev/null || true
done
log_ok "Background systemd update timers permanently masked."

echo ""
echo "============================================================"
echo "    [SUCCESS] AzamLabs Safe APT Guard Successfully Active   "
echo "============================================================"
echo "  - 'apt upgrade'    : BLOCKED (Educational barrier active)"
echo "  - 'apt autoremove' : BLOCKED (32-bit IOL libraries protected)"
echo "  - 'apt update'     : ALLOWED (Safe index queries permitted)"
echo "  - 'apt install'    : ALLOWED (Benign package installations permitted)"
echo "  - Override Switch  : --force-azam-override"
echo "============================================================"
exit 0

