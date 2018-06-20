if [[ ! -e network-environment.yaml ]]; then
echo "creating network-env.yaml"
cat <<EOF >> network-environment.yaml
{
    "parameter_defaults": {
        "ControlPlaneDefaultRoute": "192.168.24.1",
        "ControlPlaneSubnetCidr": "24",
        "DnsServers": [
            "192.168.23.1"
        ],
        "EC2MetadataIp": "192.168.24.1",
        "ExternalAllocationPools": [
            {
                "end": "10.0.0.250",
                "start": "10.0.0.4"
            }
        ],
        "ExternalNetCidr": "10.0.0.1/24",
        "NeutronExternalNetworkBridge": "",
        "PublicVirtualFixedIPs": [
            {
                "ip_address": "10.0.0.5"
            }
        ]
    }
}
EOF
fi

if [[ ! -e inject-trust-anchor.yaml ]]; then
echo "creating inject-trust-anchor.yaml"
cat <<EOF >> inject-trust-anchor.yaml
"parameter_defaults":
  "CAMap":
    "overcloud-ca":
      "content": |
        -----BEGIN CERTIFICATE-----
        MIIDlTCCAn2gAwIBAgIJAK4wBm82dKzMMA0GCSqGSIb3DQEBCwUAMGExCzAJBgNV
        BAYTAlVTMQswCQYDVQQIDAJOQzEQMA4GA1UEBwwHUmFsZWlnaDEQMA4GA1UECgwH
        UmVkIEhhdDENMAsGA1UECwwET09PUTESMBAGA1UEAwwJb3ZlcmNsb3VkMB4XDTE4
        MDEwODA2MTUzOFoXDTE5MDEwODA2MTUzOFowYTELMAkGA1UEBhMCVVMxCzAJBgNV
        BAgMAk5DMRAwDgYDVQQHDAdSYWxlaWdoMRAwDgYDVQQKDAdSZWQgSGF0MQ0wCwYD
        VQQLDARPT09RMRIwEAYDVQQDDAlvdmVyY2xvdWQwggEiMA0GCSqGSIb3DQEBAQUA
        A4IBDwAwggEKAoIBAQDNMryJqUUOmaRGjORZSQdEyaAmcp0vkrX8fphc4iffBbbr
        Xf8j4/L820F/oRE+k3RW5vGDdgJNjBuyKoM2TFZc0S+2TWe5nM9Vs5zMMgnED3kV
        jiWgjHd5NKhlyIlITFSEF54eMVqIHb3C5UXN8paOVEwRVp69vg7N7/vSFqFgFKCC
        O90MuyMDTjr2tLhMfCLpKex8BHOa1s7lkAJ9Ka+SrMKiq9qx9wLEICvL6R/UsG9j
        EU+35n5zDBq6TU2/P85hafpvlIKtvFfdU9tVLYH2Ni2v2snCQY3ct1Q1P5M8HdMO
        KbxWZZDRavZoMKKbD3BKrLZluBUxSGEM3high0gpAgMBAAGjUDBOMB0GA1UdDgQW
        BBQc2mOmDb98ebiocrLfbANihssv0TAfBgNVHSMEGDAWgBQc2mOmDb98ebiocrLf
        bANihssv0TAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQAYrE69iVc4
        NtX1k8aU0xVEPvRMxiA/NfVW06i3Bb383xYzOnrPkfHMCSzHgpr9W085ttafxTlO
        gijFgyJTQEGWEDtOcx2zthW8ntM3y0mXAKeYd7k2iOo4Q8ZwMo9ba+8gioymLDXW
        IPRnhBS+2pBohh1kHqlrk9AKdmKJb8VywFzzyYbgE/xPIsfW2pWZA0eueqO3CUzx
        kJ0h+2qOjltJFMLFt34uY99mb9mTqOfllJ4Q2QHSaLgANpqZjgmMXPN/Hb9xcpT3
        b44m6t2MDWigSSok3/hTMBbh7M0zvo2erghceqqtP0uEVxxaZqCRRFDG04mfNQWg
        zDT5nCqQBJJP
        -----END CERTIFICATE-----
    "undercloud-ca":
      "content": "Bag Attributes\n    localKeyID: D8 78 6E EA CB DB 8C 8B 7E 01 31\
        \ 93 14 0B 1B 39 CD C3 EB 10 \n    friendlyName: Local Signing Authority\n\
        subject=/CN=Local Signing Authority/CN=f45f7a74-d22f4007-9e5b369c-f279c61f\n\
        issuer=/CN=Local Signing Authority/CN=f45f7a74-d22f4007-9e5b369c-f279c61f\n\
        -----BEGIN CERTIFICATE-----\nMIIDjjCCAnagAwIBAgIRAPRfenTSL0AHnls2nPJ5xh8wDQYJKoZIhvcNAQELBQAw\n\
        UDEgMB4GA1UEAwwXTG9jYWwgU2lnbmluZyBBdXRob3JpdHkxLDAqBgNVBAMMI2Y0\nNWY3YTc0LWQyMmY0MDA3LTllNWIzNjljLWYyNzljNjFmMB4XDTE4MDEwODA1MjAw\n\
        NloXDTE5MDEwODA1MjAwNlowUDEgMB4GA1UEAwwXTG9jYWwgU2lnbmluZyBBdXRo\nb3JpdHkxLDAqBgNVBAMMI2Y0NWY3YTc0LWQyMmY0MDA3LTllNWIzNjljLWYyNzlj\n\
        NjFmMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAz1KnQ16HnmZ3rtuW\naaqT4OD1eVIrxFn9wdedPu9G/9SdOV+oJ3PB6qlNKfdP1c88PqqiWBkCaxfzrvqP\n\
        k8E1ma/Ez9+aSxr2uUiOpfHmnBngtcEYH/ce7XhERgEl3BnF4PwvbuIGdd80KoDR\nn3WWSgj2jt+qsWP6fdOGV4Z67192Eq13grfjok4benNLpWKuwUsWJ9b9yahJPdvH\n\
        7ILID+zZr19XE33fzR31lLugMFeBLxoR5YxK2p70AFniP19WNwUB1F9MWoN3NPTJ\n6jfraGSiV5brQKtmA3F4jTbD4TYtaqh8nmd1FlU8wUE1tm1UGvwbydRo1hpL82we\n\
        l8HiiQIDAQABo2MwYTAPBgNVHRMBAf8EBTADAQEBMB0GA1UdDgQWBBRGTazNsflF\nFZ45JRJsjrcvuvDeazAfBgNVHSMEGDAWgBRGTazNsflFFZ45JRJsjrcvuvDeazAO\n\
        BgNVHQ8BAf8EBAMCAYYwDQYJKoZIhvcNAQELBQADggEBAFVZtoV1AC4RD1qmlCWf\niVExJrxXwtzh0V7c9U5D/dQpIht2yJNOGS72caqGj7iJnYbyGLCnVxnp2V24alVK\n\
        VY75n8H7YDrN6wU17l8L1Ulwe36yairosYQhG7ttzW9Kor3PjmWi+HjRhrS2JBIX\nUD5XktvbMk5vAJAhhB6ZwcAGdL99VEKmzAnrSf52BM5v1I070ZGz2boCcOlO6rtn\n\
        tQbNilwOZR+RrWv86OaW96FEPq/9y2r78IKfDWNktAJktblHBr+NgNEHx6EUhJ5H\nPoOOLtHlXipWekMdh1jR05GKd+1iX/M2NvC6lNlgQ9mTXnyTNSZm57/eDK5rQNFG\n\
        u+Q=\n-----END CERTIFICATE-----\n"
  "SSLRootCertificate": |
    The contents of your root CA certificate go her
EOF
fi

if [[ ! -e enable-tls.yaml ]]; then
echo "creating enable-tls.yaml"
cat <<EOF >> enable-tls.yaml
"parameter_defaults":
  "HorizonSecureCookies": !!bool |-
    true
  "SSLCertificate": |
    -----BEGIN CERTIFICATE-----
    MIIDTzCCAjegAwIBAgIBATANBgkqhkiG9w0BAQsFADBhMQswCQYDVQQGEwJVUzEL
    MAkGA1UECAwCTkMxEDAOBgNVBAcMB1JhbGVpZ2gxEDAOBgNVBAoMB1JlZCBIYXQx
    DTALBgNVBAsMBE9PT1ExEjAQBgNVBAMMCW92ZXJjbG91ZDAeFw0xODAxMDgwNjE1
    NDBaFw0xOTAxMDgwNjE1NDBaMGAxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJOQzEQ
    MA4GA1UEBwwHUmFsZWlnaDEQMA4GA1UECgwHUmVkIEhhdDENMAsGA1UECwwET09P
    UTERMA8GA1UEAwwIMTAuMC4wLjUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
    AoIBAQDWyA39gkWZVgYUrypMHicFygxYC2jcvtt/0V6js9JlDEVqByOy3h1GWH1+
    WR0onymGTewJYN5yVroDUOXEBxRDF9JBk/Gcg4mK2GBiI3vJibmWJQb5IwMfhwKj
    vhIEePPL4JMCdrVoLYVL+kuPyhUOVugoKiSGax9jauiL4XUt6IZwvVwpRB1ak9ad
    meYQEw8Me0dGEqy4sOo8ZE8WCudyivOCf65Fq7I0X5V+c964vmnOQHmGLHJDJkza
    rOM+MTYoNxMXP5zG+zdQohfDODB5MCWhCESUN4x87t5aWmGucodGRhbgGuCgXl/p
    A4N+MbiPdpyrPUtgQLOcUfAcrir7AgMBAAGjEzARMA8GA1UdEQQIMAaHBAoAAAUw
    DQYJKoZIhvcNAQELBQADggEBAEkOBVSOPJz3/QwPTj5lc6uH/POE0BB60MPXYa+U
    otqPrXaax0YK7r8bk77PA6mfDn/pf05BXGVj+GX+fL2ZKEpOOzmax+J6z+a/o9v3
    IXpemmYzcUtp3PxwGThIdZmthGAGH4/oXhkHgCs0ba3QbX4Eu3iKeFPBE3znrkL6
    XKfh29yyw/BPOji1zmc7jYCwKS37s1slSUkmF8jjPE5WIzQTqF45JTEutHL4jr4W
    AhGjyAHfyG8hzeL9tEarcfg5Ojm/+MSTyTQCd79709cNzsOfcDl5AkuyfgpVBhya
    UD81tyoLvqcO1IHGkEe/Cb87V69kbWTE3h5u1VG4CaxgHKI=
    -----END CERTIFICATE-----
  "SSLIntermediateCertificate": ""
  "SSLKey": |
    -----BEGIN RSA PRIVATE KEY-----
    MIIEowIBAAKCAQEA1sgN/YJFmVYGFK8qTB4nBcoMWAto3L7bf9Feo7PSZQxFagcj
    st4dRlh9flkdKJ8phk3sCWDecla6A1DlxAcUQxfSQZPxnIOJithgYiN7yYm5liUG
    +SMDH4cCo74SBHjzy+CTAna1aC2FS/pLj8oVDlboKCokhmsfY2roi+F1LeiGcL1c
    KUQdWpPWnZnmEBMPDHtHRhKsuLDqPGRPFgrncorzgn+uRauyNF+VfnPeuL5pzkB5
    hixyQyZM2qzjPjE2KDcTFz+cxvs3UKIXwzgweTAloQhElDeMfO7eWlphrnKHRkYW
    4BrgoF5f6QODfjG4j3acqz1LYECznFHwHK4q+wIDAQABAoIBABAz51pIiZeXtb25
    uSck3yzAoU3DDpYYj9aEpO8Ukbqtwk7NWxQTTYIRCuaNMnXuC+Pl3PiYJi/Z+w5k
    +/Bd2Fl3YpUv4/o6shWXXS4KHzyE90ssX+pLieDG/pv7qsBLn5ixyGVXLzg8tuGU
    cD7Yr931EG53P2okiqmlVwW2bHCaBqJXJ/RC7yZ4RyBcFZF+Chjki4nAnHXeff2P
    4T8fcxSeXbWzPIb08hIYXzibpKLxV8jjA6ArUe8gFaboJqaD9zZYtKQYAyvzLgE+
    /RTlsQ3m3y3vZx1vfUQQJWKdzKXQ2AoRA59RvunoXRh4kE2VDXm9ykhAC1a0HYId
    ZG8AfIECgYEA89zIpgnVvXV5BhRCjXhG4QUtVZH9Zi85XKlgyd4jTaP77fgOsaaI
    7xOHvgh9oVj5RY6tNgaoyuIMMFqYJhP/jW2FBjKQkV/hAKrRiMC4e2lLhoQqwMdq
    r+Mjfxu/bTEL0lkhzH1d7HpTECWcHJSj4z2mZerfvBa23rer9WQiTX0CgYEA4Xi7
    A2iaG3kEkfQMeduLyWxy/wwZ7LnHtzPZVGPHLRDDGGKgGEMZLndK7puCZTbdcMRm
    tNW7DZHgsuvlpGEnAavJgd/i3M2BQgRqvggnlJC5sRcjrI8mnJ+6UDBbM0RdtFyE
    g4iR9tvux9l61MgjNyR9/HH0KDTazfFW708TI9cCgYAlfiBrRr/R7Sm6QYsp7QAY
    wI8DxPpMp54OHQyAfOK4oSmuoKDBt3T+LOaF1RBbqi5I/3KqB8QTzUVKeeNCl3iG
    6fu1xDht4WvaimjEubyjXMD74X4hPYetmyJt/Hol85B5urJzmiLCpNv4c4/Y5RF9
    cpEOwlm7tVJQU7TgeZC8kQKBgQDUT+tJ+mWjGQHErhpRZPrsYMKoh6yhzQ7S5G/x
    l0MmnHIZtEUsk4JSzuIwbR8MT+2VElvkTJ4m2QbNdHR5pUIlwK2vLjNh1+GvWJlq
    +CLNMrqolzFwfBvPwFigyegXDnluLPBbK27HFbJzXcbcNtlyQ1qfLG7MrXicFHXY
    Qo2zYQKBgBozGpkcQs7FAsQahiWg+q0I7t5XNethPWctcJQsH48X0glaWyMfSCP1
    BdGZPeeQP2w7PN8RbT78XpMFFUFk8smNGgXslW1Ej/PGtY4hBOz9NvVJojZU1KW/
    FXGIJvwdt8uSVHZNsXYgYyi4+XgncV9ngA4vT9b5Si7vEHeoULq6
    -----END RSA PRIVATE KEY-----
"resource_registry":
  "OS::TripleO::NodeTLSData": |-
    /usr/share/openstack-tripleo-heat-templates//puppet/extraconfig/tls/tls-cert-inject.yaml
EOF
fi

source stackrc
 
echo "deploying overcloud for" $count
openstack overcloud deploy \
    --templates /usr/share/openstack-tripleo-heat-templates \
    --libvirt-type qemu --control-flavor oooq_control --compute-flavor oooq_compute --ceph-storage-flavor oooq_ceph --block-storage-flavor oooq_blockstorage --swift-storage-flavor oooq_objectstorage --timeout 90  -e /home/stack/cloud-names.yaml      -e /usr/share/openstack-tripleo-heat-templates/environments/docker.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/docker-ha.yaml -e /home/stack/docker_registry.yaml  -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/net-single-nic-with-vlans.yaml -e /home/stack/network-environment.yaml  -e /usr/share/openstack-tripleo-heat-templates/environments/low-memory-usage.yaml  -e /home/stack/enable-tls.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/tls-endpoints-public-ip.yaml -e /home/stack/inject-trust-anchor.yaml   -e /usr/share/openstack-tripleo-heat-templates/environments/disable-telemetry.yaml   --validation-warnings-fatal   --compute-scale 1 --control-scale 3  --ntp-server pool.ntp.org -e /usr/share/openstack-tripleo-heat-templates/environments/services-docker/neutron-opendaylight.yaml   \
    ${DEPLOY_ENV_YAML:+-e $DEPLOY_ENV_YAML} "$@" && status_code=0 || status_code=$?
