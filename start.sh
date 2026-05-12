#!/bin/bash
echo "✅ Writing openclaw.json to /tmp..."

# Use /tmp to avoid Railway volume override
export HOME=/tmp
mkdir -p /tmp/.openclaw

cat > /tmp/.openclaw/openclaw.json << ENDOFCONFIG
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

echo "✅ Config written to /tmp/.openclaw/openclaw.json"
cat /tmp/.openclaw/openclaw.json

node openclaw.mjs gateway --allow-unconfigured
