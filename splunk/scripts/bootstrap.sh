echo "Get .env vars"
set -a
source /home/vagrant/.env
set +a

echo "Update system"
sudo apt update && sudo apt upgrade -y

echo "Installing wget"
sudo apt install -y wget

echo "Downloading Splunk"
wget -O $DEB_FILE "$SPLUNK_DEB_URL"

echo "Installing Splunk"
dpkg -i $DEB_FILE

echo "Accepting license and starting Splunk"
/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt \
  --seed-passwd "$SPLUNK_PASS"

echo "Enabling Splunk on boot..."
/opt/splunk/bin/splunk enable boot-start