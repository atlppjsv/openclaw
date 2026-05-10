#!/bin/bash

# Create OpenClaw config directory
mkdir -p /root/.openclaw

# Write config file using Railway environment variables
cat > /root/.openclaw/config.json << EOF
{
  "channels": {
    "discord": {
      "token": "$DISCORD_TOKEN",
      "dmPolicy": "open"
    }
  },
  "models": {
    "default": "deepseek/deepseek-chat"
  },
  "keys": {
    "deepseek": "$DEEPSEEK_API_KEY"
  }
}
EOF

echo "✅ Config created successfully"

# Start OpenClaw
openclaw gateway start --port 8080
