#!/bin/bash
echo "✅ Writing correct openclaw.json config..."

mkdir -p /home/node/.openclaw

cat > /home/node/.openclaw/openclaw.json << ENDOFCONFIG
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "deepseek/deepseek-chat"
      }
    }
  },
  "gateway": {
    "auth": {
      "mode": "token",
      "token": "railway-openclaw-token-2026"
    },
    "bind": "lan",
    "mode": "local",
    "port": 18789
  },
  "models": {
    "providers": {
      "deepseek": {
        "baseUrl": "https://api.deepseek.com",
        "api": "openai-completions",
        "apiKey": "${DEEPSEEK_API_KEY}"
      }
    }
  },
  "plugins": {
    "entries": {
      "discord": { "enabled": true },
      "deepseek": { "enabled": true }
    }
  },
  "channels": {
    "discord": {
      "enabled": true,
      "token": "${DISCORD_TOKEN}",
      "dmPolicy": "open",
      "groupPolicy": "open",
      "allowFrom": ["*"],
      "dm": { "enabled": true }
    }
  }
}
ENDOFCONFIG

echo "✅ Config written!"
node openclaw.mjs gateway --allow-unconfigured
