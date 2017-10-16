########
# setup
########

# setup cirros image
mkdir -p /tmp/openstack/image/
cp ~/cache/image/cirros* /tmp/openstack/image/

############################################################
#  Install and configure Openstack services through puppet
############################################################

cat > scenario.pp << EOF
include ::openstack_integration
class { '::openstack_integration::config':
  ssl  => true,
  ipv6 => false,
}
include ::openstack_integration::cacert
include ::openstack_integration::memcached
include ::openstack_integration::rabbitmq
include ::openstack_integration::mysql
include ::openstack_integration::keystone
class { '::openstack_integration::glance':
  backend => 'swift',
}
include ::openstack_integration::swift

class { '::openstack_integration::nova':
  volume_encryption => true,
}

class { '::openstack_integration::cinder':
  volume_encryption => true,
  cinder_backup     => 'swift',
}

include ::openstack_integration::barbican
include ::openstack_integration::horizon
class { '::openstack_integration::neutron':
  driver => 'linuxbridge',
}
include ::openstack_integration::provision
EOF

puppet apply --modulepath /etc/puppet/modules:/usr/share/puppet/modules scenario.pp
