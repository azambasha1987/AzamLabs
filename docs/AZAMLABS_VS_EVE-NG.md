# AzamLabs vs EVE-NG Pro v7.4: Architectural Analysis & "Match & Exceed" Implementation Plan

*Authoritative Engineering Reference & Blueprint* | *Date: October 2026* | *Platform: Ubuntu 26.04 Resolute LTS (AzamLabs v6.8.92)*

---

## 1. Executive Summary & Competitive Context

In late October 2026, EVE-NG announced **EVE-NG Professional v7.4**, skipping incremental point versions to introduce a major UI/UX overhaul. Rather than upgrading the underlying hypervisor engine, v7.4 focused almost entirely on the **operator console experience and workspace ergonomics**:
1. **Integrated Docked Consoles**: Moving away from annoying browser pop-up windows by docking terminals directly into the lab canvas with split-screen and draggable tabs.
2. **Terminal Syntax Highlighting**: Applying real-time color formatting to CLI output (IPs, interfaces, routing states).
3. **Decoupled Architecture**: Eliminating Apache Tomcat, the Guacamole MySQL database, and the resource-heavy Netdata daemon.
4. **Per-Node/Link Telemetry**: Native 1-second sampling and 1-hour throughput history.

### Strategic Assessment: Where Does AzamLabs Stand?
- **The Core Hypervisor Engine**: **AzamLabs dominates EVE-NG Pro.** AzamLabs delivers **Ultra-KSM 4KB RAM deduplication (65% to 80%+ memory savings)**, the **dynamic Cisco IOL C-shim (<64MB RAM/router)**, the **3-tier Anti-Bootstorm Staggering Engine**, the **AI Lab Architect Copilot**, the **Silicon Dataplane (MTU 9000 RoCEv2 RXE)**, and **100% Free, Unlimited Node Scaling with Zero Cloud Licensing Locks**.
- **The Modern UI/UX Gap**: EVE-NG v7.4 correctly identified that network engineers hate juggling 20 pop-up browser tabs. AzamLabs currently opens HTML5 sessions in new browser tabs via `window.open()`.
- **The Goal of this Implementation Plan**: Adopt all 3 marquee usability pillars from EVE-NG v7.4, integrate them cleanly with our existing high-density backend, and **exceed** EVE-NG by offering a superior, ultra-low-latency, pure-dark IDE workspace.

---

## 2. Competitive Scorecard: AzamLabs vs. EVE-NG Pro v7.4

```mermaid
quadrantChart
    title Platform Capability Matrix
    x-axis "Basic Web UI" --> "Integrated IDE Workspace"
    y-axis "Standard Hypervisor" --> "Hyper-Tuned Ultra-Density Engine"
    quadrant-1 "AzamLabs Goal (Match & Exceed)"
    quadrant-2 "AzamLabs Today (Unmatched Engine)"
    quadrant-3 "Legacy Emulators (GNS3 / PNET Community)"
    quadrant-4 "EVE-NG Pro v7.4 (Good UI, Weak Engine)"
    "EVE-NG Pro v7.4": [0.78, 0.45]
    "AzamLabs Today": [0.35, 0.95]
    "AzamLabs Post-Plan": [0.92, 0.98]
```

| Subsystem / Capability | EVE-NG Pro v7.4 | AzamLabs v6.8.92 (Current) | AzamLabs Post-Implementation (Exceeding EVE-NG) |
| :--- | :---: | :---: | :---: |
| **Console Windowing** | Docked, floating, split views | Sequenced Staggered Pop-ups | **Quantum In-Canvas Docked Console (1, 2, 4-way split, floating tabs)** |
| **CLI Formatting** | Regex syntax highlighting | Standard monochrome terminal | **Network-Aware Syntax Engine (IPs, Interfaces, States, Protocols)** |
| **Link & Node Telemetry** | 1s polling, 1h history | CLI/REST telemetry exporter | **Hover/Inspect SVG Micro-Sparklines (Rx/Tx, PPS, Drops, Latency)** |
| **RAM Optimization** | Standard Linux KSM (15–25%) | **Ultra-KSM (65–80% savings)** | **Ultra-KSM + C-Shim (<64MB IOL)** |
| **Bootstorm Protection** | None (CPU/IO lockups) | **3-Tier Dynamic Staggering** | **3-Tier Dynamic Staggering + Console Prompt Probing** |
| **AI Lab Builder** | None | **AI Copilot (Ollama / Cloud LLM)** | **AI Copilot + In-Canvas Voice/Chat Assist** |
| **Dataplane Networking** | Standard Linux Bridges | **Silicon Dataplane (RoCEv2 RXE)** | **MTU 9000 Zero-Fragmentation Cluster Mesh** |
| **Licensing & Cost** | Paid subscription ($$$); 7-node cap | **100% Free; Unlimited Nodes** | **100% Free; Unlimited Nodes; 100% Air-Gapped** |

---

## 3. The "Match & Exceed" Technical Architecture

```mermaid
flowchart TD
    subgraph Browser Canvas Layer
        Canvas["Active Lab Canvas (#main-canvas)"]
        LinkNode["Link Hover / Selection"]
        LinkNode --> Sparkline["Micro-Sparkline HUD Card<br/>(Live 60s SVG Throughput & Drops)"]
        
        Canvas --> Dock["Quantum Docked Console Drawer (#az-docked-console)"]
        Dock --> Controls["Dock Bar: Layout Switcher (1x, 2x, 4x) | Tabs | Height Drag | Detach"]
        Controls --> Grid["Multi-Pane Container"]
        Grid --> Pane1["Pane 1: R1 (xterm.js / Guac WebSocket)"]
        Grid --> Pane2["Pane 2: R2 (xterm.js / Guac WebSocket)"]
        Pane1 --> Syntax["Real-Time Network CLI Syntax Parser (ANSI / Regex)"]
        Pane2 --> Syntax
    end

    subgraph Host Engine Layer
        Syntax --> Guacd["azamlabs-guacd (Port 4822)"]
        Sparkline --> OpsAPI["azambasha-ops-api.py (Port 8889)"]
        OpsAPI --> Dataplane["azambasha-dataplane-stats.py (Ring Buffer)"]
        Dataplane --> ProcNet["Linux Kernel /proc/net/dev"]
    end
```

---

## 4. Detailed Step-by-Step Implementation Plan

### 📋 Phase 1: High-Speed Dataplane Telemetry & Sparkline API
**Objective**: Build a zero-disk-write in-memory sliding window ring buffer in Python to stream real-time Rx/Tx throughput and drop metrics per link to the frontend.

- [ ] **1.1 Extend [`scripts/azambasha-dataplane-stats.py`](file:///e:/AzamLabs/scripts/azambasha-dataplane-stats.py)**:
  - Implement a `TelemetryRingBuffer` class holding a 60-entry circular queue (1-second intervals) for every active interface (`vnet*`, `vunl*`, `pnet*`).
  - Calculate `delta_rx_bps`, `delta_tx_bps`, `delta_rx_pps`, `delta_tx_pps`, and error/drop deltas.
  - Expose thread-safe snapshot method `get_sparkline(iface_name)`.
- [ ] **1.2 Register REST API in [`scripts/azambasha-ops-api.py`](file:///e:/AzamLabs/scripts/azambasha-ops-api.py)**:
  - Add endpoint `/azam-ops/api/dataplane-sparkline?iface=<name>&seconds=60`.
  - Return compact JSON:
    ```json
    {
      "status": "success",
      "iface": "vunl0_1_1",
      "rx_bps_history": [12000, 14500, ...],
      "tx_bps_history": [45000, 48000, ...],
      "current_rx_kbps": 14.5,
      "current_tx_kbps": 48.0,
      "drops": 0,
      "errors": 0
    }
    ```
- [ ] **1.3 Test Performance**: Assert API latency < 5ms and CPU overhead < 0.2%.

---

### 📋 Phase 2: In-Canvas Docked Terminal Console Drawer
**Objective**: Replace separate browser pop-ups with an integrated, resizable multi-pane terminal dock inside the lab canvas.

- [ ] **2.1 Build In-Canvas Dock Container** (`html/themes/default/js/azamlabs-docked-console.js`):
  - Inject `#az-docked-console` at the bottom of the canvas.
  - Implement vertical drag-to-resize handle (minimum 180px, maximum 85vh).
  - Implement header controls:
    - **Tab Bar**: Draggable, closeable tabs with device icons and status pips.
    - **Layout Toggles**: `[ 1x Single ]`, `[ 2x Dual Split 50/50 ]`, `[ 4x Quad Grid 2x2 ]`.
    - **Window Actions**: Minimize (collapse to 36px bottom bar), Maximize (fill canvas), Detach (pop-out).
- [ ] **2.2 Hook [`html/azam-ops/azamlabs-sequenced-console.js`](file:///e:/AzamLabs/html/azam-ops/azamlabs-sequenced-console.js)**:
  - Add user preference check: `localStorage.getItem('az_console_mode') || 'docked'` (options: `docked`, `tabs`, `native`).
  - When in `docked` mode, divert `openSingleConsole(node)` to create/focus a tab inside `#az-docked-console` instead of calling `window.open(url, '_blank')`.
  - Support drag-and-drop between panes (drag tab from Left Pane to Right Pane in split mode).

---

### 📋 Phase 3: Real-Time Network CLI Syntax Parser
**Objective**: Apply color formatting to IP addresses, interfaces, and operational states directly inside web consoles.

- [ ] **3.1 Create Syntax Tokenizer Engine** (`html/themes/default/js/azam-cli-syntax.js`):
  - Pre-compile regex token rules:
    - **IPv4**: `\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(?:\/(?:3[0-2]|[12]?[0-9]))?\b` $\rightarrow$ Electric Cyan (`#38bdf8`)
    - **IPv6**: `\b([0-9a-fA-F]{1,4}:){1,7}:?([0-9a-fA-F]{1,4})?\b` $\rightarrow$ Sky Blue (`#60a5fa`)
    - **Interfaces**: `\b(Gi|Fa|Te|Eth|GigabitEthernet|FastEthernet|TenGigE|xe-|ge-|Ethernet|lo|vlan)\d+[\d/.]*\b` $\rightarrow$ Neon Violet (`#c084fc`)
    - **Up/Healthy States**: `\b(up|UP|Established|FULL|Active|Connected|Success|200 OK|OK)\b` $\rightarrow$ Emerald Green (`#22c55e`)
    - **Down/Error States**: `\b(down|DOWN|administratively down|Admin Down|Failed|Error|Drop|Reset|Idle|Active)\b` $\rightarrow$ Crimson Red (`#ef4444`)
    - **Protocols/ASNs**: `\b(OSPF|BGP|EIGRP|IS-IS|MPLS|LDP|VXLAN|EVPN|AS \d+)\b` $\rightarrow$ Amber (`#f59e0b`)
- [ ] **3.2 Integrate with Terminal Stream**:
  - Hook terminal output before rendering.
  - Transform matching tokens into ANSI escape codes (`\x1b[38;2;R;G;Bm`).
  - Add user toggle button in console header: `[ 🎨 Syntax: ON/OFF ]` and font-size controls (`12px`, `14px`, `16px`).

---

### 📋 Phase 4: Canvas Hover Sparkline & HUD Integration
**Objective**: Display interactive micro-graphs on link hover or node inspection.

- [ ] **4.1 Canvas Link & Node Hover Listeners** ([`html/azam-ops/azamlabs-features.js`](file:///e:/AzamLabs/html/azam-ops/azamlabs-features.js)):
  - Attach `mouseenter` / `mouseleave` debounced listeners to canvas SVG link paths and node icons.
  - Dynamically construct floating HUD element `#az-link-hud`.
- [ ] **4.2 Lightweight SVG Bezier Curve Generator**:
  - Convert 60-second throughput array into smooth SVG path coordinates:
    $$\text{path} = \text{M } x_0,y_0 \text{ C } x_{c1},y_{c1} \dots$$
  - Fill with glowing gradient (Green for Tx, Cyan for Rx).
  - Display current metrics: `Tx: 48.0 Kbps | Rx: 14.5 Kbps | Drops: 0`.
- [ ] **4.3 Pin-to-Canvas Functionality**:
  - Right-click link $\rightarrow$ "Pin Sparkline" keeps the mini-graph pinned permanently to the link on the canvas during lab runs.

---

### 📋 Phase 5: Cluster Deployment, Testing & Verification
**Objective**: Validate functionality across test VMs and ensure 100% future-install immunity.

- [ ] **5.1 Automated Syntax & Non-Regression Suite**:
  - Run [`tests/test_javascript_syntax.py`](file:///e:/AzamLabs/tests/test_javascript_syntax.py) to assert 0 bracket mismatches and 0 unclosed IIFEs.
  - Run full `pytest tests/` (36 tests) and [`scripts/azambasha-dry-test.py`](file:///e:/AzamLabs/scripts/azambasha-dry-test.py) (10/10 probes).
- [ ] **5.2 Test VM Fleet Deployment**:
  - Deploy to `R9-Master` (`192.168.1.23`) with `--install-features --force`.
  - Deploy to `R9-SAT` (`192.168.1.18`).
  - Verify live V8 syntax check via remote SSH: `node -c`.
- [ ] **5.3 Installer Pipeline Audit**:
  - Verify [`install.sh`](file:///e:/AzamLabs/install.sh) and [`scripts/azambasha-install-azam-features.sh`](file:///e:/AzamLabs/scripts/azambasha-install-azam-features.sh) deploy all new scripts with cache-busting timestamps.

---

## 5. Non-Regression Safeguards & Future-Install Immunity

To guarantee that new VM installations from scratch deploy without syntax errors or broken dependencies:
1. **Additive Hook Architecture**: All enhancements are isolated into modular JavaScript files (`azamlabs-docked-console.js`, `azam-cli-syntax.js`) without overwriting core upstream legacy code.
2. **Toggleable Fallback**: Users retain a 1-click toggle in the header to switch between `Docked Console` and traditional `Pop-up Windows` / `SecureCRT Native`.
3. **Zero External Dependencies**: All SVG sparklines and syntax parsing use vanilla JavaScript and native browser APIs—zero bulky Node/NPM dependencies.
4. **Authoritative Master-Satellite Parity**: Symlinked through `/opt/unetlab/` and versioned in Git.
