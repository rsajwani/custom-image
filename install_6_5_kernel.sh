#!/bin/bash

set -xe

if [[ -z "${KERNEL_VERSION}" ]]; then
    KERNEL_VERSION="6.5.0-1017-azure"
fi

cp /etc/apt/sources.list /etc/apt/sources.list.bk

# Point source.list at the jammy package mirrors. These are all vetted package
# sources from upstream, with all of the normal security backports and bug
# fixes handled by Cannonical. It's fairly common practice to pull kernels
# from Ubuntu LTS N to Ubuntu LTS N-1 (eg 18.04 pulling in a 20.04 kernel
# around the time that 20.04 is released). This practice is part of the Ubuntu
# HWE (Hardware Enablement) kernel flavor, so what we're doing here is not
# particularly out of the ordinary.
cat <<- "EOF" >> /etc/apt/sources.list
deb http://azure.archive.ubuntu.com/ubuntu/ jammy main restricted
deb http://azure.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
deb http://azure.archive.ubuntu.com/ubuntu/ jammy universe
deb http://azure.archive.ubuntu.com/ubuntu/ jammy-updates universe
deb http://azure.archive.ubuntu.com/ubuntu/ jammy multiverse
deb http://azure.archive.ubuntu.com/ubuntu/ jammy-updates multiverse
deb http://azure.archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
deb http://azure.archive.ubuntu.com/ubuntu/ jammy-security main restricted
deb http://azure.archive.ubuntu.com/ubuntu/ jammy-security universe
deb http://azure.archive.ubuntu.com/ubuntu/ jammy-security multiverse
EOF

apt update

# Install all of the aux packages, especially the headers first. If Service
# Fabric has been installed, it also installs LTTng on the host. LTTng has a
# set of kernel modules it has installed through DKMS. The significance is that
# DKMS will recompile the LTTng kernel modules when a new kernel image is
# installed. Therefore, the headers need to be installed first, otherwise DKMS
# will fail to successfully compile the LTTng kernel modules for the new kernel
# image when the image package is installed next.
apt install -y "linux-modules-${KERNEL_VERSION}" "linux-modules-extra-${KERNEL_VERSION}" "linux-buildinfo-${KERNEL_VERSION}" "linux-headers-${KERNEL_VERSION}"

# Now go ahead and install the kernel
apt install -y "linux-image-${KERNEL_VERSION}"

# Finally, restore the original sources.list
cp /etc/apt/sources.list.bk /etc/apt/sources.list
