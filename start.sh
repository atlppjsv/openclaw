#!/bin/bash
echo "=== Setting up OpenClaw ==="

# Create both config directories
mkdir -p /data/.openclaw
mkdir -p /home/node/.openclaw

# Clear old backup files that may override our config
rm -f /home/node/.openclaw/openclaw.json.bak*
rm -f /home/node/.openclaw/openclaw.json.last-good

# Write config using Node.js to BOTH locations
node -e "
const fs = require('fs');

const config = {
  agents: {
    defaults: {
      model: { primary: 'deepseek/deepseek-chat' },
      workspace: '/data/.openclaw/workspace'
    }
  },
  gateway: {
    auth: { mode: 'token', token: 'openclaw-railway-2026' },
    bind: 'lan',
    mode: 'local',
    port: 18789
  },
  meta: {
    lastTouchedAt: new Date().toISOString(),
    lastTouchedVersion: '2026.5.6'
  },
  models: {
    providers: {
      deepseek: {
        baseUrl: 'https://api.deepseek.com',
        api: 'openai-completions',
        apiKey: process.env.DEEPSEEK_API_KEY
      }
    }
  },
  plugins: {
    entries: {
      discord: { enabled: true },
      deepseek: { enabled: true }
    }
  },
  session: { dmScope: 'per-channel-peer' },
  auth: {
    profiles: {
      'deepseek:default': { provider: 'deepseek', mode: 'api_key' }
    }
  },
  channels: {
    discord: {
      enabled: true,
      token: process.env.DISCORD_TOKEN,
      dmPolicy: 'open',
      groupPolicy: 'open',
      allowFrom: ['*'],
      dm: { enabled: true }
    }
  }
};

const json = JSON.stringify(config, null, 2);
fs.writeFileSync('/data/.openclaw/openclaw.json', json);
fs.writeFileSync('/home/node/.openclaw/openclaw.json', json);
console.log('✅ Config written to both locations!');
console.log('Discord token:', !!process.env.DISCORD_TOKEN);
"

echo "=== Starting OpenClaw ==="
node openclaw.mjs gateway --allow-unconfigured --bind lan
