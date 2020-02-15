# This Script is for installing node exporter on a machine.

# Check for if it is run as root or sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
# Install and Extract Binary From Github
# Change WGET if new version released.
echo "Getting Binaries from Git"
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar xvzf node_exporter-0.18.1.linux-amd64.tar.gz

# Adding user node_exporter and setting Permission for running.
echo "Adding Users and Permissions"
useradd -rs /bin/false node_exporter
cp node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin 
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Creating it as a service so it can be run on Startup
echo "Setting up as Service"
cd /etc/systemd/system

echo "Adding Repo to Trusted repo."
cat << 'EOT' > node_exporter.service
[Unit]
Description=Node Exporter
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOT

echo "Starting Service"
systemctl daemon-reload
systemctl start node_exporter
# Enable to run on Boot
systemctl enable node_exporter

# Testing
curl http://localhost:9100/metrics