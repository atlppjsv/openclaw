#!/bin/bash
echo "=== OpenClaw Gateway Help ==="
node openclaw.mjs gateway --help 2>&1

echo "=== Writing config ==="
node -e "
const fs = require('fs');
const config = {
  agents: { defaults: { model: { primary: 'deepseek/deepseek-chat' } } },
  gateway: {
    auth: { mode: 'token', token: 'openclaw-railway-2026' },
    bind: 'lan', mode: 'local', port: 18789
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
  plugins: { entries: { discord: { enabled: true }, deepseek: { enabled: true } } },
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
fs.mkdirSync('/home/node/.openclaw', { recursive: true });
fs.writeFileSync('/home/node/.openclaw/openclaw.json', JSON.stringify(config, null, 2));
console.log('✅ Done');
"

echo "=== Starting OpenClaw ==="
node openclaw.mjs gateway --allow-unconfigured --bind lan
