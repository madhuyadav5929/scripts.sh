#!/bin/bash

# Create Prometheus system user
sudo useradd \
    --system \
    --no-create-home \
    --shell /bin/false \
    prometheus

# Download and install Prometheus
PROM_VERSION="2.47.1"
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
tar -xvf prometheus-${PROM_VERSION}.linux-amd64.tar.gz
sudo mv prometheus-${PROM_VERSION}.linux-amd64/{prometheus,promtool} /usr/local/bin/
sudo mv prometheus-${PROM_VERSION}.linux-amd64/consoles/ /etc/prometheus/
sudo mv prometheus-${PROM_VERSION}.linux-amd64/console_libraries/ /etc/prometheus/
sudo mv prometheus-${PROM_VERSION}.linux-amd64/prometheus.yml /etc/prometheus/

# Set permissions
sudo mkdir -p /data /etc/prometheus
sudo chown -R prometheus:prometheus /data /etc/prometheus

# Create systemd service file for Prometheus
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/data \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090 \
    --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOF

# Enable and start Prometheus service
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus
