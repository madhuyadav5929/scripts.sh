#!/bin/bash

# Create Node Exporter system user
sudo useradd \
    --system \
    --no-create-home \
    --shell /bin/false \
    node_exporter

# Download and install Node Exporter
NE_VERSION="1.6.1"
wget https://github.com/prometheus/node_exporter/releases/download/v${NE_VERSION}/node_exporter-${NE_VERSION}.linux-amd64.tar.gz
tar -xvf node_exporter-${NE_VERSION}.linux-amd64.tar.gz
sudo mv node_exporter-${NE_VERSION}.linux-amd64/node_exporter /usr/local/bin/

# Create systemd service file for Node Exporter
cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter \
    --collector.logind

[Install]
WantedBy=multi-user.target
EOF

# Enable and start Node Exporter service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter
