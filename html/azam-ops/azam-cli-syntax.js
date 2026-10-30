/**
 * azam-cli-syntax.js
 * ==============================================================================
 * AzamLabs Real-Time Network CLI Syntax Highlighting Engine
 *
 * Real-time parser for network terminal streams (Cisco, Juniper, Arista, Linux):
 *  - IPv4 & Subnet Masks (Cyan #38bdf8)
 *  - IPv6 Addresses (Sky Blue #60a5fa)
 *  - Interfaces (Gi0/0, Eth1/1, ge-0/0/0, lo0) (Neon Violet #c084fc)
 *  - Up / Positive Operational States (Emerald Green #22c55e)
 *  - Down / Error Operational States (Crimson Red #ef4444)
 *  - Routing Protocols & ASNs (Amber #f59e0b)
 * ==============================================================================
 */
(function() {
  'use strict';

  if (window.azamCliSyntax) return; // Prevent double registration

  var AzamCliSyntax = {
    enabled: localStorage.getItem('az_cli_syntax') !== 'false',

    rules: [
      // 1. Up / Positive Operational States (Green)
      {
        name: 'state_up',
        regex: /\b(up|UP|Established|FULL|Active|Connected|Forwarding|Success|200 OK|OK)\b/g,
        color: '#22c55e',
        weight: 'bold'
      },
      // 2. Down / Negative Operational States (Red)
      {
        name: 'state_down',
        regex: /\b(down|DOWN|administratively down|Admin Down|Failed|Error|Drop|Reset|Idle|Active(?=\s*in\s*BGP)|Discard|Timeout)\b/g,
        color: '#ef4444',
        weight: 'bold'
      },
      // 3. IPv4 Addresses & Subnet Masks (Cyan)
      {
        name: 'ipv4',
        regex: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(?:\/(?:3[0-2]|[12]?[0-9]))?\b/g,
        color: '#38bdf8',
        weight: '600'
      },
      // 4. IPv6 Addresses (Sky Blue)
      {
        name: 'ipv6',
        regex: /\b([0-9a-fA-F]{1,4}:){1,7}:?([0-9a-fA-F]{1,4})?(?:\/\d{1,3})?\b/g,
        color: '#60a5fa',
        weight: '600'
      },
      // 5. Interface Names (Violet)
      {
        name: 'interfaces',
        regex: /\b(Gi|Fa|Te|Eth|GigabitEthernet|FastEthernet|TenGigE|TwentyFiveGigE|HundredGigE|xe-|ge-|et-|Ethernet|lo|vlan|mgmt|Loopback|Port-channel|Bundle-Ether)\d+[\d\/\.]*\b/g,
        color: '#c084fc',
        weight: '600'
      },
      // 6. Routing Protocols & AS Numbers (Amber)
      {
        name: 'protocols',
        regex: /\b(OSPF|BGP|EIGRP|IS-IS|MPLS|LDP|VXLAN|EVPN|BGP4|RIP|VRF|AS\s*\d+)\b/g,
        color: '#f59e0b',
        weight: '600'
      }
    ],

    setEnabled: function(val) {
      this.enabled = !!val;
      localStorage.setItem('az_cli_syntax', this.enabled ? 'true' : 'false');
    },

    // Colorize plain text to HTML spans
    colorizeHtml: function(text) {
      if (!this.enabled || !text) return text;

      // Escape HTML entities first
      var safe = String(text)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');

      this.rules.forEach(function(rule) {
        safe = safe.replace(rule.regex, function(match) {
          return '<span style="color:' + rule.color + ';font-weight:' + rule.weight + ';">' + match + '</span>';
        });
      });

      return safe;
    },

    // Convert text tokens to ANSI escape sequences for terminal streams
    colorizeAnsi: function(text) {
      if (!this.enabled || !text) return text;
      var str = String(text);

      var ansiMap = {
        state_up:   '\x1b[1;32m', // Bold Green
        state_down: '\x1b[1;31m', // Bold Red
        ipv4:       '\x1b[1;36m', // Bold Cyan
        ipv6:       '\x1b[34m',   // Blue
        interfaces: '\x1b[1;35m', // Bold Magenta
        protocols:  '\x1b[1;33m'  // Bold Yellow
      };
      var reset = '\x1b[0m';

      this.rules.forEach(function(rule) {
        var code = ansiMap[rule.name];
        if (code) {
          str = str.replace(rule.regex, function(match) {
            return code + match + reset;
          });
        }
      });

      return str;
    }
  };

  window.azamCliSyntax = AzamCliSyntax;
})();
