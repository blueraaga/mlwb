########################################################################
# Complementary shell script to provide advanced features in the box
########################################################################

echo -e "${YELLOW}------ Initiating Booster Script ------${NC}"

# Install charting libraries
pip install seaborn altair
# Install Flask: Barebones for serving model
# - Example code to be done
pip install Flask
# Install Spark support with Apache Beam
pip install pyspark apache-beam
# Install OpenCV for image processing (preceeded by dependencies)
# https://stackoverflow.com/questions/47113029/importerror-libsm-so-6-cannot-open-shared-object-file-no-such-file-or-directo
sudo apt-get -y install libsm6
pip install opencv-python
# Install Python ML Frameworks: MXNet
pip install mxnet

# Install Java
echo -e "${YELLOW}------ Install Java ------${NC}"
sudo apt-get --yes install openjdk-8-jre-headless

# Install Scala
echo -e "${YELLOW}------ Install Scala ------${NC}"
sudo apt-get -y install scala

# Install Spark
echo -e "${YELLOW}------ Install Spark ------${NC}"
# Installed with hadoop
# More info here: https://stackoverflow.com/questions/32022334/can-apache-spark-run-without-hadoop
# To speed up operations, Spark can be downloaded upfront to the
# host OS folder which is mapped to the shared folder
# /vagrant/resources/apps
cd /vagrant/resources/apps
sudo wget --no-verbose --timestamping https://archive.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz
# Always download the checksum, overwriting any previously downloaded file
sudo wget --no-verbose --output-document=spark-2.3.1-bin-hadoop2.7.tgz.sha512 https://archive.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz.sha512
# Compare checksum
# - Use another utility that matches the format
sudo python3 /vagrant/resources/utils/spark_sha512_gen.py
sudo  --user=ubuntu sha512sum  -c local-spark-hash.sha512

cd /home/ubuntu
sudo --user=ubuntu tar --extract --skip-old-files --file /vagrant/resources/apps/spark-2.3.1-bin-hadoop2.7.tgz
sudo --user=ubuntu ln --symbolic --force /home/ubuntu/spark-2.3.1-bin-hadoop2.7 /home/ubuntu/spark

sed -e 's|/home/ubuntu/spark/bin:||g' -e 's|PATH="\(.*\)"|PATH="/home/ubuntu/spark/bin:\1"|g' -i /etc/environment
# https://medium.com/@GalarnykMichael/install-spark-on-ubuntu-pyspark-231c45677de0
sed -e 's|SPARK_PATH=/home/ubuntu/spark||g' -i /etc/environment
sudo echo SPARK_PATH=/home/ubuntu/spark >> /etc/environment
sed -e 's|PYSPARK_DRIVER_PYTHON="jupyter"||g' -i /etc/environment
sudo echo PYSPARK_DRIVER_PYTHON="jupyter" >> /etc/environment
sed -e 's|PYSPARK_DRIVER_PYTHON_OPTS="notebook"||g' -i /etc/environment
sudo echo PYSPARK_DRIVER_PYTHON_OPTS="notebook" >> /etc/environment
sed -e 's|PYSPARK_PYTHON=python3||g' -i /etc/environment
sudo echo PYSPARK_PYTHON=python3 >> /etc/environment


# Install Zeppelin
echo -e "${YELLOW}------ Install Zeppelin ------${NC}"
# To speed up operations, Zeppelin can be downloaded upfront to the
# host OS folder which is mapped to the shared folder
# /vagrant/resources/apps
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

# Spark-YARN: https://www.linode.com/docs/databases/hadoop/install-configure-run-spark-on-top-of-hadoop-yarn-cluster/
# Setup hadoop: https://www.linode.com/docs/databases/hadoop/how-to-install-and-set-up-hadoop-cluster/

echo -e "${YELLOW}------ Install Hadoop ------${NC}"
echo "Nothing done currently"
# Download hadoop from http://www-eu.apache.org/dist/hadoop/common/
# sed -e 's|HADOOP_HOME=~/hadoop-2.8.0||g' -i /etc/environment
# sudo echo HADOOP_HOME=~/hadoop-2.8.0 >> /etc/environment

echo -e "${YELLOW}------ Completed Booster Script ------${NC}"