#!/bin/bash

# Create config directory for node user
mkdir -p /home/node/.openclaw

# Write config file
cat > /home/node/.openclaw/config.json << EOF
{
  "channels": {
    "discord": {
      "token": "$MTUwMjYyNTcwNzI5NjI5MjkwNA.GV2Ny9.crSL6GK2Qse7bZSjykT07SdiFf8Q5eBP9d4bHY",
      "dmPolicy": "open"
    }
  },
  "models": {
    "default": "deepseek/deepseek-chat"
  },
  "keys": {
    "deepseek": "$sk-66bfb8d85ce44abc98f9aa12c069dd31"
  }
}
EOF

echo "✅ Config written to /home/node/.openclaw/config.json"

# Start OpenClaw
node openclaw.mjs gateway --allow-unconfigured
