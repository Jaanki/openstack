mkdir odltools
sudo yum install wget -y
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install epel-release-latest-7.noarch.rpm -y
sudo yum install python-pip -y
sudo pip install odltools

odl_ip=$(sudo hiera -c /etc/puppet/hiera.yaml opendaylight::odl_bind_ip)
##TODO: Get port, username, password from the node
python -m odltools model get --ip $odl_ip --port 8081 --user odladmin --pw redhat -p ~/odltools/odl_dumps
python -m odltools show cluster-info --ip $odl_ip --port 8081 --user odladmin --pw redhat
python -m odltools show eos -ip $odl_ip --port 8081 --user odladmin --pw redhat --path ~/odltools/eos
python -m odltools analyze tunnels -ip $odl_ip --port 8081 --user odladmin --pw redhat --path ~/odltools/tunnels
