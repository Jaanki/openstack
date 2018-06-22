source ~/stackrc

#!/bin/bash

openstack overcloud deploy \
--templates /usr/share/openstack-tripleo-heat-templates \
--stack overcloud \
--libvirt-type kvm \
--ntp-server clock.redhat.com \
-e /home/stack/virt/config_lvm.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
-e /home/stack/virt/network/network-environment.yaml \
-e /home/stack/virt/inject-trust-anchor.yaml \
-e /home/stack/virt/hostnames.yml \
-e /home/stack/virt/nodes_data.yaml \
-e /home/stack/virt/debug.yaml \
-e /home/stack/virt/config_heat.yaml \
--environment-file /usr/share/openstack-tripleo-heat-templates/environments/services-docker/neutron-opendaylight.yaml \
-e /home/stack/virt/docker-images.yaml \
-e /home/stack/bolt.yaml && echo "deployment finished" || exit 1
