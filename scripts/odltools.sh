mkdir odltools
sudo yum install wget -y
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install epel-release-latest-7.noarch.rpm -y
sudo yum install python-pip -y
sudo pip install odltools

odl_ip=$(sudo hiera -c /etc/puppet/hiera.yaml opendaylight::odl_bind_ip)
port=$(sudo hiera -c /etc/puppet/hiera.yaml opendaylight::odl_rest_port)
username=$(sudo hiera -c /etc/puppet/hiera.yaml opendaylight::username)
password=$(sudo hiera -c /etc/puppet/hiera.yaml opendaylight::password)

if [[ $odl_ip =~ .*:.* ]]; then
  odl_ip="[${odl_ip}]"
fi

##TODO: Get port, username, password from the node
python -m odltools model get --ip $odl_ip --port $port --user $username --pw $password -p ~/odltools/odl_dumps
python -m odltools netvirt show cluster-info --ip $odl_ip --port $port --user $username --pw $password >> ~/odltools/cluster.info
python -m odltools netvirt analyze tunnels --ip $odl_ip --port $port --user $username --pw $password --path ~/odltools/tunnels >> ~/odltools/tunnels_info.log
python -m odltools netvirt show eos --ip $odl_ip --port $port --user $username --pw $password --path ~/odltools/eos 
