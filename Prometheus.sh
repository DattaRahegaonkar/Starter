
#!/bin/bash

sudo apt update


sudo useradd --system --no-create-home --shell /bin/false prometheus  # Create a Prometheus user without a home directory and with no login shell
sudo mkdir /etc/prometheus                                   # Create a directory for Prometheus configuration files
sudo mkdir /var/lib/prometheus                               # Create a directory for Prometheus data storage
sudo chown prometheus:prometheus /var/lib/prometheus         # Change ownership of the data directory to the Prometheus user


cd /tmp                                                      # Change to the /tmp directory to download Prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-amd64.tar.gz  # Download the Prometheus tarball from the official GitHub releases page

tar vxf prometheus*.tar.gz                                  # Extract the downloaded Prometheus tarball
cd prometheus*                                              # Change to the extracted Prometheus directory


sudo mv prometheus /usr/local/bin/                          # Move the Prometheus binary to /usr/local/bin for system-wide access
sudo mv promtool /usr/local/bin/                            # Move the promtool binary to /usr/local/bin for system-wide access
sudo mv consoles /etc/prometheus                            # Move the consoles directory to /etc/prometheus for Prometheus web interface
sudo mv console_libraries /etc/prometheus                   # Move the console_libraries directory to /etc/prometheus for Prometheus web interface

sudo mv prometheus.yml /etc/prometheus                      # Move the Prometheus configuration file to /etc/prometheus


sudo chown -R prometheus:prometheus /etc/prometheus        # Change ownership of the Prometheus configuration directory to the Prometheus user
sudo chown prometheus:prometheus /usr/local/bin/prometheus # Change ownership of the Prometheus binary to the Prometheus user


sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF

[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
 --config.file=/etc/prometheus/prometheus.yml \
 --storage.tsdb.path=/var/lib/prometheus \
 --web.console.templates=/etc/prometheus/consoles \
 --web.console.libraries=/etc/prometheus/console_libraries

Restart=always

[Install]
WantedBy=multi-user.target

EOF


sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus

