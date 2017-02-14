#/bin/bash

set -ex

cd /usr/local/src
yum -y install gnupg2
export ARCH_PKG_ID=packages-81847750a7b363940dacf1ed24a7b7266851f833
export GPG_KEY=0E604491
wget --no-check-certificate https://git.archlinux.org/svntogit/packages.git/snapshot/${ARCH_PKG_ID}.tar.gz
tar -xzf ${ARCH_PKG_ID}.tar.gz
cd ${ARCH_PKG_ID}/trunk
sed -i 's;/usr;/opt/python-3.6.0;g' PKGBUILD
sed -i 's;--openssldir=/etc/ssl;;g' PKGBUILD
export srcdir=$PWD
export CARCH=x86_64
source PKGBUILD
wget "https://www.openssl.org/source/${pkgname}-${_ver}.tar.gz"
wget "https://www.openssl.org/source/${pkgname}-${_ver}.tar.gz.asc"
export GNUPGHOME="$(mktemp -d)"
gpg2 --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY"
gpg2 --batch --verify ${pkgname}-${_ver}.tar.gz.asc ${pkgname}-${_ver}.tar.gz
rm -rf ${pkgname}-${_ver}.tar.gz.asc ${GNUPGHOME}
tar -xzf ${pkgname}-${_ver}.tar.gz
rm -f ${pkgname}-${_ver}.tar.gz
prepare
build
check
package
yum -y erase gnupg2
cd && rm -rf /usr/local/src/${ARCH_PKG_ID}
echo 'export PATH=/opt/python-3.6.0/bin:$PATH' > /opt/python-3.6.0.activate.sh
echo 'export LD_LIBRARY_PATH=/opt/python-3.6.0/lib:$LD_LIBRARY_PATH' >> /opt/python-3.6.0.activate.sh
echo 'export PKG_CONFIG_PATH=/opt/python-3.6.0/lib/pkgconfig:$PKG_CONFIG_PATH' >> /opt/python-3.6.0.activate.sh
echo 'export PATH=${PATH/\/opt\/python-3.6.0\/bin:/}' > /opt/python-3.6.0.deactivate.sh
echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH/\/opt\/python-3.6.0\/lib:/}' >> /opt/python-3.6.0.deactivate.sh
echo 'export PKG_CONFIG_PATH=${PKG_CONFIG_PATH\/opt\/python-3.6.0\/lib\/pkgconfig:/}' >> /opt/python-3.6.0.deactivate.sh

