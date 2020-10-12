################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2018-present Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="fd628-aml"
PKG_VERSION="f8bd53c"
PKG_SHA256="cf117c8512d7ecf624e1fd8c4a72264c17927637d8e9b191c0a611163a0a2b8f"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/tanixbox/tx3mini_linux_fd628"
PKG_URL="https://github.com/tanixbox/tx3mini_linux_fd628/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="tx3mini_linux_fd628-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_SHORTDESC="fd628-aml: Driver for Amlogic FD628 display"
PKG_LONGDESC="fd628-aml: Driver for Amlogic FD628 display"

PKG_TOOLCHAIN="manual"

make_target() {
  make FD628Service

  if [ "$TARGET_KERNEL_ARCH" = "arm64" -a "$TARGET_ARCH" = "arm" ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET gcc-linaro-aarch64-linux-gnu:host"
    export PATH=$TOOLCHAIN/lib/gcc-linaro-aarch64-linux-gnu/bin/:$PATH
    TARGET_PREFIX=aarch64-linux-gnu-
  fi

  KERNELRELEASE=y LDFLAGS=""  make -C $(kernel_path) M=$ROOT/$PKG_BUILD/driver
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/modules/$(get_module_dir)/$PKG_NAME
    find $ROOT/$PKG_BUILD/ -name \*.ko -not -path '*/\.*' -exec cp {} $INSTALL/usr/lib/modules/$(get_module_dir)/$PKG_NAME \;

  mkdir -p $INSTALL/usr/sbin
    cp -P FD628Service $INSTALL/usr/sbin
}

post_install() {
  enable_service fd628.service
}