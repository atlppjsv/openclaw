#!/bin/bash
echo "=== Setting up OpenClaw ==="
rm -f /home/node/.openclaw/openclaw.json.bak*
rm -f /home/node/.openclaw/openclaw.json.last-good

node -e "
const fs = require('fs');
const config = {
  agents: { defaults: { model: { primary: 'deepseek/deepseek-chat' }, workspace: '/home/node/.openclaw/workspace' } },
  gateway: { auth: { mode: 'token', token: 'openclaw-railway-2026' }, bind: 'lan', mode: 'local', port: 18789 },
  meta: { lastTouchedAt: new Date().toISOString(), lastTouchedVersion: '2026.5.6' },
  models: { providers: { deepseek: { baseUrl: 'https://api.deepseek.com', api: 'openai-completions', apiKey: process.env.DEEPSEEK_API_KEY } } },
  plugins: { entries: { discord: { enabled: true }, deepseek: { enabled: true } } },
  session: { dmScope: 'per-channel-peer' },
  channels: { discord: { enabled: true, token: process.env.DISCORD_TOKEN, dmPolicy: 'open', groupPolicy: 'open', allowFrom: ['*'], dm: { enabled: true } } }
};
fs.mkdirSync('/home/node/.openclaw', { recursive: true });
fs.writeFileSync('/home/node/.openclaw/openclaw.json', JSON.stringify(config, null, 2));
console.log('✅ Config written! Discord:', !!process.env.DISCORD_TOKEN);
"

node openclaw.mjs gateway --allow-unconfigured --bind lan
