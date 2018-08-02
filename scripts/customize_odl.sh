# customise ODL image with new rpm and push it to local registry
# /home/stack/virt/docker-images.yaml - This is the docker registry file
# Change it to reflect the file in the system
#

echo "Enter actual path to the docker registry file"
read docker_registry_path

if [ ! -f $docker_registry_path ]; then
  echo "docker registry file not found at" $docker_registry_path
  exit 1
fi

echo "enter the rpm to be installed"
read rpm

echo "enter the tag for the new image"
read new_tag

old_image=$(cat $docker_registry_path | grep Opendaylight | awk -F " " 'NR==1 {print $2}')
old_tag=$(echo $old_image | awk -F ":" '{print $3}')

new_tag=$new_tag
new_image="${old_image/$old_tag/$new_tag}"

if [ -f /home/stack/odl_image/Dockerfile ]; then
rm -rf odl_image
fi

mkdir odl_image
cd odl_image
cat <<EOF >> Dockerfile
FROM $old_image
RUN yum remove opendaylight -y
RUN yum install -y -v $rpm
EOF

echo "building new image and pushing to local registry"
docker build -t $new_image .
if [ $? != 0 ]; then
  echo "image building failed"
else
  echo "new image pused"
  docker push $new_image
  if [ $? !=  0 ]; then
    echo "image not pushed"
  else
    echo "new image pushed successfully"
    sed -i "s,$old_image,$new_image,g" $docker_registry_path
    echo "docker registry updated"
  fi
  cd
fi
