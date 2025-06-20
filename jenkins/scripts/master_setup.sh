echo "Get .env vars"
set -a
source /home/vagrant/.env
set +a

echo "Update system"
# sudo apt update && sudo apt upgrade -y

echo "Install jdk"
sudo sudo apt install -y default-jdk

echo "Add jenkins repo"
wget -q -O - $JENKINS_KEY | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] $JENKINS_REPO binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list


echo "Install jenkins"
sudo apt install -y jenkins

echo "Install git"
sudo apt install -y git

echo "Start jenkins"
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "Set up ngrok"
snap install ngrok

echo "Set ngrok auth token"
sudo ngrok config add-authtoken $NGROK_TOKEN
