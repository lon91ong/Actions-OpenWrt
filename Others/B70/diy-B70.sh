#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

#删除默认密码
sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/lean/default-settings/files/zzz-default-settings

#设置FAT为utf8编码
find target/linux -path "target/linux/*/config-*" | xargs -i sed -i '$a CONFIG_ACPI=y\nCONFIG_X86_ACPI_CPUFREQ=y\n \
CONFIG_NR_CPUS=128\nCONFIG_FAT_DEFAULT_IOCHARSET="utf8"' {}

#默认主题改为argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon

#解包ttnode
curl -o ttnode.zip https://github.com/lon91ong/Actions-OpenWrt/raw/5.4.x/Others/luci-app-ttnode.zip
unzip -o ttnode.zip -d feeds/custom/

# 机型名称适配
#sed -i 's/HC5962/&-SPI")\n\t\tname="hc5962-spi"\n\t\t;;\n\t\*"&/1' target/linux/ramips/base-files/lib/ramips.sh

# 固件添加内核版本号
sed -i ':a;N;$!ba;s/$(BOARD)/&-$(LINUX_VERSION)/1' include/image.mk

# 网络接口适配 16m/1, 32m/g
sed -i ':a;N;$!ba;s/hc5962/&|\\\n\thiwifi,&-spi/1' target/linux/ramips/mt7621/base-files/etc/board.d/02_network

cat >> ./target/linux/ramips/image/mt7621.mk <<EOF
define Device/hiwifi_hc5962-spi
  DTS := HIWIFI_HC5962-SPI
  IMAGE_SIZE := 16064k
  DEVICE_VENDOR := HiWiFi
  DEVICE_TITLE := HC5962-SPI
  DEVICE_PACKAGES := kmod-mt7603 kmod-mt76x2 kmod-usb3
endef
TARGET_DEVICES += hiwifi_hc5962-spi
EOF
sed -i 's/^[ \t]*//g' ./target/linux/ramips/image/mt7621.mk

#设置32m闪存
#sed -i 's/0xfb0000/0x1fa0000/g' target/linux/ramips/dts/HC5962-SPI.dts
#sed -i 's/16064k/32384k/g' target/linux/ramips/image/mt7621.mk

# 修复DHCP服务, 从5.4内核改回4.14内核的resolv.conf路径
#sed -i 's|resolv.conf.d/resolv.conf.auto|resolv.conf.auto|g' `grep -l resolv.conf.d package/feeds/custom/*/root/etc/init.d/*`

# custom插件汉化
# mv feeds/custom/luci-app-turboacc/po/zh_Hans feeds/custom/luci-app-turboacc/po/zh-cn
