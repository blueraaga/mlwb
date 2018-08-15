########################################################################
# Shell script to set up the box
# Composed by blueraaga@gmail.com
########################################################################

# Colors to use
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NC="\033[0m"

echo -e "${GREEN}------------------------${NC}"
echo -e "${GREEN}Start Shell Script${NC}"
echo -e "${GREEN}------------------------${NC}"

echo -e "${YELLOW}------ Export language related env. vaiables ------${NC}"
# Take care of language related notification on ssh login in
# Ubuntu 16.04
sudo echo LC_ALL=C.UTF-8 >> /etc/environment
sudo echo LANG=C.UTF-8 >> /etc/environment

echo -e "${YELLOW}------ Update and upgrade package list ------${NC}"
# Update and upgrade all packages
sudo apt-get update
sudo apt-get -y upgrade

# - Setup

# Install pip, uprade it (leading to 2 pips - system and python) and
# then remove system pip. Final version is pip 10
echo -e "${YELLOW}------ Install Python pip ------${NC}"
sudo apt-get install -y python3-pip

echo -e "${YELLOW}------ Upgrade Python pip ------${NC}"
pip3 install --upgrade pip

echo -e "${RED}------ Remove pip system package ------${NC}"
sudo apt-get -y remove python3-pip

# Install Python packages
echo -e "${YELLOW}------ Install Python packages ------${NC}"
# - Explore possibility for requirements.txt
# Install math processing stuffs
pip install numpy scipy scikit-learn pandas matplotlib
pip install jupyter seaborn
# Install OpenCV for image processing (preceeded by dependencies)
# https://stackoverflow.com/questions/47113029/importerror-libsm-so-6-cannot-open-shared-object-file-no-such-file-or-directo
sudo apt-get -y install libsm6
pip install opencv-python
# Install Python ML Frameworks: TensorFlow and MXNet
pip install tensorflow keras
pip install mxnet
# Install Flask: Barebones for serving model
# - Example code to be done
pip install Flask
# Install VirtualEnv
pip install virtualenv

# Install Java
echo -e "${YELLOW}------ Install Java ------${NC}"
sudo apt-get --yes install openjdk-8-jre-headless

# Install Scala
echo -e "${YELLOW}------ Install Scala ------${NC}"
sudo apt-get -y install scala

# Start Jupyter notebook
echo -e "${YELLOW}------ Start Jupyter notebook ------${NC}"
# - Explore running Jupyter as a service
echo y | jupyter notebook --generate-config
echo -e 'mlwb\nmlwb' | jupyter notebook password
sudo jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --notebook-dir='/vagrant/jnotes' &

# Install Zeppelin
echo -e "${YELLOW}------ Install Zeppelin ------${NC}"
# To speed up operations, zeppelin can be downloaded upfront to the
# host OS folder which is mapped to the shared folder /vagrant
cd /vagrant/resources/apps
sudo wget --no-verbose --timestamping http://www-eu.apache.org/dist/zeppelin/zeppelin-0.8.0/zeppelin-0.8.0-bin-all.tgz
# Always download the checksum, overwriting any previously downloaded file
sudo wget --no-verbose --output-document=zeppelin-0.8.0-bin-all.tgz.sha512 https://www.apache.org/dist/zeppelin/zeppelin-0.8.0/zeppelin-0.8.0-bin-all.tgz.sha512
# Compare checksum
sudo --user=ubuntu sha512sum -c zeppelin-0.8.0-bin-all.tgz.sha512
cd /home/ubuntu
sudo --user=ubuntu tar --extract --skip-old-files --file /vagrant/resources/apps/zeppelin-0.8.0-bin-all.tgz
sudo --user=ubuntu ln --symbolic --force /home/ubuntu/zeppelin-0.8.0-bin-all /home/ubuntu/zeppelin
/home/ubuntu/zeppelin/bin/zeppelin-daemon.sh start




echo -e "${GREEN}------------------------${NC}"
echo -e "${GREEN}End Shell Script${NC}"
echo -e "${GREEN}------------------------${NC}"
