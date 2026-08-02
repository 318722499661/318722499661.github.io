#!/bin/bash

ip link set wlan0 up

cat > /etc/wpa_supplicant/wpa_supplicant-wlan0.conf <<'EOF'
ctrl_interface=DIR=/run/wpa_supplicant GROUP=wheel
update_config=1
country=US

network={
    ssid="Zen"
    psk="Poopscoop2!"
    key_mgmt=WPA-PSK
}
EOF

systemctl enable --now wpa_supplicant@wlan0

dhcpcd wlan0
