# Check if the deployment has started. If not, exit gracefully. If yes, check for errors.
if ! openstack stack list | grep -q overcloud; then
    echo "overcloud deployment not started. Check the deploy configurations"
    exit 1

    # We don't always get a useful error code from the openstack deploy command,
    # so check `openstack stack list` for a CREATE_COMPLETE or an UPDATE_COMPLETE
    # status.
elif ! openstack stack list | grep -Eq '(CREATE|UPDATE)_COMPLETE'; then
        # get the failures list
    openstack stack failures list overcloud --long > $1/failed_deployment_list.log || true

    # get any puppet related errors
    for failed in $(openstack stack resource list \
        --nested-depth 5 overcloud | grep FAILED |
        grep 'StructuredDeployment ' | cut -d '|' -f3)
    do
    echo "openstack software deployment show output for deployment: $failed" >> $1/failed_deployments.log
    echo "######################################################" >> $1/failed_deployments.log
    openstack software deployment show $failed >> $1/failed_deployments.log
    echo "######################################################" >> $1/failed_deployments.log
    echo "puppet standard error for deployment: $failed" >> $1/failed_deployments.log
    echo "######################################################" >> $1/failed_deployments.log
    # the sed part removes color codes from the text
    openstack software deployment show $failed -f json |
        jq -r .output_values.deploy_stderr |
        sed -r "s:\x1B\[[0-9;]*[mK]::g" >> $1/failed_deployments.log
    echo "######################################################" >> $1/failed_deployments.log
    # We need to exit with 1 because of the above || true
    done
    exit 1
fi
