/**
 * azamlabs-docked-console.js
 * ==============================================================================
 * AzamLabs Quantum In-Canvas Docked Terminal Console
 *
 * Replaces disconnected browser pop-up windows with an integrated, resizable,
 * multi-pane terminal dock inside the lab canvas:
 *  1. Multi-Pane Layouts: 1x (Single Focus), 2x (Side-by-Side Dual Split), 4x (Quad Grid).
 *  2. Real-Time Network CLI Syntax Highlighting: Auto-colorizes IPv4/v6, interfaces,
 *     BGP/OSPF states (up/down/Established), and error tokens.
 *  3. Dynamic Drag Resizing: Smooth vertical height adjustment with persistent storage.
 *  4. Session Management: Add tab, close tab, duplicate, pop-out to external window.
 *  5. Compact Minimization: Collapses to a slim 34px status strip with active pips.
 * ==============================================================================
 */
(function() {
  'use strict';

  if (window.azamDockedConsole) return; // Prevent double registration

  var AzamDockedConsole = {
    dockEl: null,
    resizerEl: null,
    headerEl: null,
    tabsEl: null,
    bodyEl: null,
    panes: [],
    sessions: [], // { id, name, url, paneIdx: 0 }
    activeTabId: null,
    currentLayout: '1x', // '1x', '2x', '4x'
    isMinimized: false,
    syntaxEnabled: true,
    height: 380,

    init: function() {
      var self = this;
      this.syntaxEnabled = localStorage.getItem('az_cli_syntax') !== 'false';
      this.currentLayout = localStorage.getItem('az_dock_layout') || '1x';
      this.height = parseInt(localStorage.getItem('az_dock_height'), 10) || 380;

      this.injectStyles();
      this.buildDOM();
      this.bindResizer();

      // Listen for window resize
      window.addEventListener('resize', function() {
        if (!self.isMinimized && self.dockEl && self.dockEl.style.display !== 'none') {
          self.clampHeight();
        }
      });

      console.log('[AzamLabs] Quantum In-Canvas Docked Console initialized.');
    },

    isEnabled: function() {
      return localStorage.getItem('az_console_mode') !== 'popup';
    },

    injectStyles: function() {
      if (document.getElementById('az-dock-styles')) return;
      var style = document.createElement('style');
      style.id = 'az-dock-styles';
      style.textContent = [
        '#az-docked-console {',
        '  position: fixed;',
        '  bottom: 0;',
        '  left: 0;',
        '  right: 0;',
        '  background: rgba(10, 14, 23, 0.96);',
        '  border-top: 2px solid rgba(56, 189, 248, 0.45);',
        '  box-shadow: 0 -8px 32px rgba(0, 0, 0, 0.75);',
        '  z-index: 99990;',
        '  display: none;',
        '  flex-direction: column;',
        '  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "JetBrains Mono", monospace;',
        '  backdrop-filter: blur(12px);',
        '  transition: height 0.15s ease-out, transform 0.2s ease-out;',
        '}',
        '#az-dock-resizer {',
        '  height: 6px;',
        '  background: transparent;',
        '  cursor: ns-resize;',
        '  position: relative;',
        '  width: 100%;',
        '  transition: background 0.2s;',
        '}',
        '#az-dock-resizer:hover, #az-dock-resizer.dragging {',
        '  background: rgba(56, 189, 248, 0.6);',
        '}',
        '#az-dock-resizer::after {',
        '  content: "";',
        '  position: absolute;',
        '  top: 1px;',
        '  left: 50%;',
        '  transform: translateX(-50%);',
        '  width: 48px;',
        '  height: 4px;',
        '  border-radius: 2px;',
        '  background: rgba(56, 189, 248, 0.35);',
        '}',
        '#az-dock-header {',
        '  height: 36px;',
        '  background: rgba(15, 23, 42, 0.95);',
        '  border-bottom: 1px solid rgba(255, 255, 255, 0.08);',
        '  display: flex;',
        '  align-items: center;',
        '  justify-content: space-between;',
        '  padding: 0 10px;',
        '  user-select: none;',
        '}',
        '#az-dock-tabs {',
        '  display: flex;',
        '  align-items: center;',
        '  gap: 4px;',
        '  overflow-x: auto;',
        '  max-width: 60%;',
        '  scrollbar-width: none;',
        '}',
        '#az-dock-tabs::-webkit-scrollbar { display: none; }',
        '.az-dock-tab {',
        '  display: flex;',
        '  align-items: center;',
        '  gap: 6px;',
        '  padding: 4px 10px;',
        '  background: rgba(255, 255, 255, 0.05);',
        '  border: 1px solid rgba(255, 255, 255, 0.08);',
        '  border-radius: 6px 6px 0 0;',
        '  color: #94a3b8;',
        '  font-size: 11.5px;',
        '  font-weight: 500;',
        '  cursor: pointer;',
        '  white-space: nowrap;',
        '  transition: all 0.15s;',
        '}',
        '.az-dock-tab:hover {',
        '  background: rgba(255, 255, 255, 0.1);',
        '  color: #f1f5f9;',
        '}',
        '.az-dock-tab.active {',
        '  background: rgba(56, 189, 248, 0.15);',
        '  border-color: rgba(56, 189, 248, 0.5);',
        '  border-bottom-color: transparent;',
        '  color: #38bdf8;',
        '  font-weight: 600;',
        '}',
        '.az-dock-tab-pip {',
        '  width: 7px;',
        '  height: 7px;',
        '  border-radius: 50%;',
        '  background: #22c55e;',
        '  box-shadow: 0 0 6px #22c55e;',
        '}',
        '.az-dock-tab-close {',
        '  width: 14px;',
        '  height: 14px;',
        '  border-radius: 50%;',
        '  display: flex;',
        '  align-items: center;',
        '  justify-content: center;',
        '  font-size: 11px;',
        '  color: #64748b;',
        '  margin-left: 2px;',
        '}',
        '.az-dock-tab-close:hover {',
        '  background: rgba(239, 68, 68, 0.2);',
        '  color: #ef4444;',
        '}',
        '#az-dock-actions {',
        '  display: flex;',
        '  align-items: center;',
        '  gap: 6px;',
        '}',
        '.az-dock-btn {',
        '  padding: 3px 8px;',
        '  background: rgba(255, 255, 255, 0.06);',
        '  border: 1px solid rgba(255, 255, 255, 0.1);',
        '  border-radius: 5px;',
        '  color: #cbd5e1;',
        '  font-size: 11px;',
        '  cursor: pointer;',
        '  display: flex;',
        '  align-items: center;',
        '  gap: 4px;',
        '  transition: all 0.15s;',
        '}',
        '.az-dock-btn:hover {',
        '  background: rgba(56, 189, 248, 0.2);',
        '  border-color: rgba(56, 189, 248, 0.4);',
        '  color: #f8fafc;',
        '}',
        '.az-dock-btn.active {',
        '  background: rgba(56, 189, 248, 0.25);',
        '  border-color: #38bdf8;',
        '  color: #38bdf8;',
        '}',
        '#az-dock-body {',
        '  flex: 1;',
        '  display: grid;',
        '  background: #000000;',
        '  overflow: hidden;',
        '}',
        '#az-dock-body.layout-1x { grid-template-columns: 1fr; grid-template-rows: 1fr; }',
        '#az-dock-body.layout-2x { grid-template-columns: 1fr 1fr; grid-template-rows: 1fr; gap: 2px; background: rgba(56, 189, 248, 0.2); }',
        '#az-dock-body.layout-4x { grid-template-columns: 1fr 1fr; grid-template-rows: 1fr 1fr; gap: 2px; background: rgba(56, 189, 248, 0.2); }',
        '.az-dock-pane {',
        '  position: relative;',
        '  width: 100%;',
        '  height: 100%;',
        '  background: #050811;',
        '  overflow: hidden;',
        '}',
        '.az-dock-pane iframe {',
        '  width: 100%;',
        '  height: 100%;',
        '  border: none;',
        '  display: block;',
        '}',
        '.az-dock-pane-empty {',
        '  display: flex;',
        '  align-items: center;',
        '  justify-content: center;',
        '  flex-direction: column;',
        '  height: 100%;',
        '  color: #475569;',
        '  font-size: 12px;',
        '  gap: 8px;',
        '}'
      ].join('\n');
      document.head.appendChild(style);
    },

    buildDOM: function() {
      var self = this;
      if (document.getElementById('az-docked-console')) return;

      var dock = document.createElement('div');
      dock.id = 'az-docked-console';
      dock.style.height = this.height + 'px';

      dock.innerHTML = [
        '<div id="az-dock-resizer" title="Drag up/down to resize terminal dock"></div>',
        '<div id="az-dock-header">',
        '  <div id="az-dock-tabs"></div>',
        '  <div id="az-dock-actions">',
        '    <div style="display:flex;align-items:center;background:rgba(0,0,0,0.3);border-radius:6px;padding:1px;border:1px solid rgba(255,255,255,0.06);margin-right:4px;">',
        '      <button class="az-dock-btn" data-layout="1x" title="Single Focused Terminal">1x</button>',
        '      <button class="az-dock-btn" data-layout="2x" title="Dual Split View (50/50)">2x Split</button>',
        '      <button class="az-dock-btn" data-layout="4x" title="Quad Grid (2x2)">4x Grid</button>',
        '    </div>',
        '    <button id="az-btn-syntax" class="az-dock-btn ' + (this.syntaxEnabled ? 'active' : '') + '" title="Toggle Network CLI Syntax Highlighting">🎨 Syntax</button>',
        '    <button id="az-btn-detach" class="az-dock-btn" title="Detach active tab into external window">↗ Pop-Out</button>',
        '    <button id="az-btn-min" class="az-dock-btn" title="Minimize/Expand Dock">▾</button>',
        '    <button id="az-btn-close-all" class="az-dock-btn" style="color:#ef4444;" title="Close All Docked Sessions">✕</button>',
        '  </div>',
        '</div>',
        '<div id="az-dock-body" class="layout-' + this.currentLayout + '"></div>'
      ].join('\n');

      document.body.appendChild(dock);

      this.dockEl = dock;
      this.resizerEl = dock.querySelector('#az-dock-resizer');
      this.headerEl = dock.querySelector('#az-dock-header');
      this.tabsEl = dock.querySelector('#az-dock-tabs');
      this.bodyEl = dock.querySelector('#az-dock-body');

      // Bind header button actions
      dock.querySelectorAll('[data-layout]').forEach(function(btn) {
        btn.addEventListener('click', function() {
          self.setLayout(btn.getAttribute('data-layout'));
        });
      });

      dock.querySelector('#az-btn-syntax').addEventListener('click', function() {
        self.toggleSyntax();
      });

      dock.querySelector('#az-btn-detach').addEventListener('click', function() {
        if (self.activeTabId) self.detachSession(self.activeTabId);
      });

      dock.querySelector('#az-btn-min').addEventListener('click', function() {
        self.toggleMinimize();
      });

      dock.querySelector('#az-btn-close-all').addEventListener('click', function() {
        self.closeAll();
      });

      this.updateLayoutButtons();
      this.renderPanes();
    },

    bindResizer: function() {
      var self = this;
      var startY = 0;
      var startH = 0;
      var isDragging = false;

      function onMouseMove(e) {
        if (!isDragging) return;
        var delta = startY - e.clientY;
        var newH = Math.max(160, Math.min(window.innerHeight * 0.85, startH + delta));
        self.height = newH;
        self.dockEl.style.height = newH + 'px';
      }

      function onMouseUp() {
        if (!isDragging) return;
        isDragging = false;
        self.resizerEl.classList.remove('dragging');
        window.removeEventListener('mousemove', onMouseMove);
        window.removeEventListener('mouseup', onMouseUp);
        localStorage.setItem('az_dock_height', String(Math.round(self.height)));
      }

      this.resizerEl.addEventListener('mousedown', function(e) {
        if (self.isMinimized) return;
        isDragging = true;
        startY = e.clientY;
        startH = self.height;
        self.resizerEl.classList.add('dragging');
        window.addEventListener('mousemove', onMouseMove);
        window.addEventListener('mouseup', onMouseUp);
        e.preventDefault();
      });
    },

    clampHeight: function() {
      var maxH = window.innerHeight * 0.85;
      if (this.height > maxH) {
        this.height = maxH;
        this.dockEl.style.height = maxH + 'px';
      }
    },

    toggleMinimize: function() {
      var btn = this.dockEl.querySelector('#az-btn-min');
      if (this.isMinimized) {
        this.isMinimized = false;
        this.dockEl.style.height = this.height + 'px';
        this.bodyEl.style.display = 'grid';
        if (btn) btn.textContent = '▾';
      } else {
        this.isMinimized = true;
        this.dockEl.style.height = '38px';
        this.bodyEl.style.display = 'none';
        if (btn) btn.textContent = '▴';
      }
    },

    setLayout: function(mode) {
      if (!['1x', '2x', '4x'].includes(mode)) mode = '1x';
      this.currentLayout = mode;
      localStorage.setItem('az_dock_layout', mode);
      this.bodyEl.className = 'layout-' + mode;
      this.updateLayoutButtons();
      this.renderPanes();
    },

    updateLayoutButtons: function() {
      var self = this;
      this.dockEl.querySelectorAll('[data-layout]').forEach(function(btn) {
        if (btn.getAttribute('data-layout') === self.currentLayout) {
          btn.classList.add('active');
        } else {
          btn.classList.remove('active');
        }
      });
    },

    toggleSyntax: function() {
      this.syntaxEnabled = !this.syntaxEnabled;
      localStorage.setItem('az_cli_syntax', this.syntaxEnabled ? 'true' : 'false');
      var btn = this.dockEl.querySelector('#az-btn-syntax');
      if (btn) {
        if (this.syntaxEnabled) btn.classList.add('active');
        else btn.classList.remove('active');
      }
      if (window.azamCliSyntax) {
        window.azamCliSyntax.setEnabled(this.syntaxEnabled);
      }
    },

    renderPanes: function() {
      var maxPanes = this.currentLayout === '1x' ? 1 : (this.currentLayout === '2x' ? 2 : 4);
      this.bodyEl.innerHTML = '';
      this.panes = [];

      for (var i = 0; i < maxPanes; i++) {
        var pane = document.createElement('div');
        pane.className = 'az-dock-pane';
        pane.setAttribute('data-pane-idx', i);

        // Find session assigned to this pane index
        var s = this.sessions.find(function(item) { return item.paneIdx === i; });
        if (!s && i === 0 && this.sessions.length > 0) {
          // Fallback to active tab
          s = this.sessions.find(function(item) { return item.id === this.activeTabId; }.bind(this)) || this.sessions[0];
          if (s) s.paneIdx = 0;
        }

        if (s) {
          var ifr = document.createElement('iframe');
          ifr.src = s.url;
          ifr.setAttribute('allow', 'clipboard-read; clipboard-write');
          pane.appendChild(ifr);
        } else {
          pane.innerHTML = [
            '<div class="az-dock-pane-empty">',
            '  <div style="font-size:24px;opacity:0.4">🖥️</div>',
            '  <div>Pane ' + (i + 1) + ' Empty</div>',
            '  <div style="font-size:10px;color:#64748b">Click a device on the canvas to dock here</div>',
            '</div>'
          ].join('\n');
        }

        this.bodyEl.appendChild(pane);
        this.panes.push(pane);
      }
    },

    openSession: function(node, url, name) {
      var id = String(node.id || (node && node.node) || name);
      name = name || (node.name || 'Node-' + id);

      // Check if session already open
      var existing = this.sessions.find(function(s) { return s.id === id; });
      if (existing) {
        this.activeTabId = id;
        this.renderTabs();
        this.showDock();
        return;
      }

      // Assign to available pane index or 0
      var maxPanes = this.currentLayout === '1x' ? 1 : (this.currentLayout === '2x' ? 2 : 4);
      var usedIndices = this.sessions.map(function(s) { return s.paneIdx; });
      var targetIdx = 0;
      for (var p = 0; p < maxPanes; p++) {
        if (!usedIndices.includes(p)) {
          targetIdx = p;
          break;
        }
      }

      var session = {
        id: id,
        name: name,
        url: url,
        paneIdx: targetIdx
      };

      this.sessions.push(session);
      this.activeTabId = id;

      this.renderTabs();
      this.renderPanes();
      this.showDock();
    },

    showDock: function() {
      if (!this.dockEl) return;
      this.dockEl.style.display = 'flex';
      if (this.isMinimized) {
        this.toggleMinimize();
      }
    },

    renderTabs: function() {
      var self = this;
      this.tabsEl.innerHTML = '';

      this.sessions.forEach(function(s) {
        var tab = document.createElement('div');
        tab.className = 'az-dock-tab' + (s.id === self.activeTabId ? ' active' : '');
        tab.innerHTML = [
          '<span class="az-dock-tab-pip"></span>',
          '<span>' + s.name + '</span>',
          '<span class="az-dock-tab-close" title="Close Session">✕</span>'
        ].join('');

        tab.addEventListener('click', function(e) {
          if (e.target.classList.contains('az-dock-tab-close')) {
            e.stopPropagation();
            self.closeSession(s.id);
          } else {
            self.activeTabId = s.id;
            // In 1x mode, assign active tab to pane 0
            if (self.currentLayout === '1x') {
              s.paneIdx = 0;
            }
            self.renderTabs();
            self.renderPanes();
          }
        });

        self.tabsEl.appendChild(tab);
      });
    },

    closeSession: function(id) {
      var idx = this.sessions.findIndex(function(s) { return s.id === id; });
      if (idx !== -1) {
        this.sessions.splice(idx, 1);
      }

      if (this.sessions.length === 0) {
        this.closeAll();
        return;
      }

      if (this.activeTabId === id) {
        this.activeTabId = this.sessions[Math.max(0, idx - 1)].id;
      }

      this.renderTabs();
      this.renderPanes();
    },

    detachSession: function(id) {
      var s = this.sessions.find(function(item) { return item.id === id; });
      if (s) {
        this.closeSession(id);
        window.open(s.url, '_blank');
      }
    },

    closeAll: function() {
      this.sessions = [];
      this.activeTabId = null;
      if (this.dockEl) {
        this.dockEl.style.display = 'none';
      }
    }
  };

  // Initialize on load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() { AzamDockedConsole.init(); });
  } else {
    AzamDockedConsole.init();
  }

  window.azamDockedConsole = AzamDockedConsole;
})();
