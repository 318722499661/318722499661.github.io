#!/bin/sh

pkill -STOP muxtask
/opt/muos/extra/muxlog &
sleep 1

TMP_FILE=/tmp/muxlog_global
rm -rf "$TMP_FILE"

# Check if Tailscale is running
if ps aux | grep -v grep | grep "tailscaled" >/dev/null; then
    echo "Stopping Tailscale..." >/tmp/muxlog_info
    /opt/muos/bin/tailscale down
    sleep 2  # Give tailscaled a moment to down
    pkill "tailscaled"
    echo "Tailscale stopped." >/tmp/muxlog_info
else
    echo "Starting Tailscale..." >/tmp/muxlog_info
    /opt/muos/bin/tailscaled &
    sleep 2  # Give tailscaled a moment to start

    /opt/muos/bin/tailscale up 2>/tmp/muxlog_info

    echo "Tailscale started." >/tmp/muxlog_info
fi

sleep 3

killall -q muxlog
rm -rf "$MUX_TEMP" /tmp/muxlog_*

pkill -CONT muxtask
killall -q "Toggle Tailscale.sh"
