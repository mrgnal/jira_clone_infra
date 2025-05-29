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