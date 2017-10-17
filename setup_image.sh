# start with a centos image
# then log in as centos and sudo su -

# update all packages, set selinux permissive
yum update -y
setenforce 0

# repos to be added
yum install -y wget
wget https://trunk.rdoproject.org/centos7/puppet-passed-ci/delorean.repo -O /etc/yum.repos.d/delorean.repo
wget https://trunk.rdoproject.org/centos7/delorean-deps.repo -O /etc/yum.repos.d/delorean-deps.repo

yum  install -y openstack-puppet-modules git 389-ds-base pki-ca pki-kra openstack-selinux expect crudini openstack-utils wget unzip
mkdir -p /etc/puppet
rmdir /etc/puppet/modules/
ln -s /usr/share/openstack-puppet/modules /etc/puppet/
git clone https://github.com/openstack/puppet-openstack-integration.git /etc/puppet/modules/openstack_integration

# get files
cd ~
wget https://vakwetu.fedorapeople.org/summit_demo_prep/convert_to_dogtag_with_hsm.sh
wget https://vakwetu.fedorapeople.org/summit_demo_prep/convert_to_local_dogtag.sh

# get more files
cd ~
wget https://raw.githubusercontent.com/dave-mccowan/sydney-workshop/master/setup_image_more.sh
wget https://raw.githubusercontent.com/dave-mccowan/sydney-workshop/master/setup_student_vm.sh
wget https://raw.githubusercontent.com/dave-mccowan/sydney-workshop/master/barbican-dogtag-plugin-mode-fix.patch
wget https://raw.githubusercontent.com/dave-mccowan/sydney-workshop/master/barbican-client-file-parameter.patch
wget https://raw.githubusercontent.com/dave-mccowan/sydney-workshop/master/barbican-client-cliff-names.patch

# chmod +x
chmod +x setup_image_more.sh
chmod +x setup_student_vm.sh

# get cirros image
mkdir -p cache/image
wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img -O ~/cache/image/cirros-0.3.4-x86_64-disk.img

# install barbican packages to apply barbican fixes
yum -y install python-barbicanclient
yum -y install python-barbican

# add patches for barbican client
git apply --directory=/usr/lib/python2.7/site-packages/ --exclude "*/functionaltests/*" --exclude "*/doc/*" barbican-client-cliff-names.patch
git apply --directory=/usr/lib/python2.7/site-packages/ --exclude "*/functionaltests/*" --exclude "*/doc/*" barbican-client-file-parameter.patch

# dogtag plugin fix
git apply --directory=/usr/lib/python2.7/site-packages/ barbican-dogtag-plugin-mode-fix.patch

# get the flask app
wget https://vakwetu.fedorapeople.org/summit_demo_prep/flask.tar.gz
cd /root
tar -xzf /root/flask.tar.gz
