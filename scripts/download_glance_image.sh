declare -A images
images=(["overcloud-full"]=overcloud-full.qcow2 ["overcloud-full-initrd"]=overcloud-full.initrd ["overcloud-full-vmlinuz"]=overcloud-full.vmlinuz ["bm-deploy-ramdisk"]=ironic-python-agent.initramfs ["bm-deploy-kernel"]=ironic-python-agent.kernel)
for image in $(openstack image list -c Name --format=value)
do
  id=$(openstack image list --name $image -c ID --format value)
  openstack image save $id --file ${images[$image]}
done

