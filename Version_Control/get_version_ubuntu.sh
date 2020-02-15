echo "OS Details"
echo " "
hostnamectl
echo " "

echo "---"
echo "Docker-Version"
echo " "
docker --version
docker-compose --version
echo " "

echo "---"
echo "Postgres and RabbitMQ Versions:"
echo " "
dpkg -l | grep 'postgresql\|rabbitmq'
echo " "

echo "---"
echo "Docker-Container Running"
echo " "
docker ps
echo " "

echo "---"
echo "Docker-Images"
echo " "
docker images
echo " "

echo "---"
echo "Services Running"
echo " "
service --status-all | grep '+'
echo " "


echo "---"
echo "List Of Users"
echo " "
cut -d: -f1 /etc/passwd
echo " "

echo "---"
echo "Pip Requriments"
echo " "
pip freeze
echo " "


