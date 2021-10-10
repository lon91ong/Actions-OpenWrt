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
sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/default-settings/files/zzz-default-settings

#设置FAT为utf8编码
find target/linux -path "target/linux/*/config-*" | xargs -i sed -i '$a CONFIG_ACPI=y\nCONFIG_X86_ACPI_CPUFREQ=y\n \
CONFIG_NR_CPUS=128\nCONFIG_FAT_DEFAULT_IOCHARSET="utf8"' {}

# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
rm -rf package/feeds/custom/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/feeds/custom/luci-theme-argon

# 修复K2P无线丢失错误配置
#sed -i ':a;N;s/Phicomm K2P\nendef/Phicomm\sK2P\n\tDEVICE_PACKAGES\s:=\s-luci-newapi\s-wpad-openssl\skmod-mt7615d_dbdc\swireless-tools\nendef/g;$!ba' target/linux/ramips/image/mt7621.mk
#sed -i 's/^[ \t]*//g' target/linux/ramips/image/mt7621.mk
sed -i ':a;N;$!ba;s/hc5962/&|\\\n\t&-spi/1' target/linux/ramips/base-files/etc/board.d/02_network
sed -i ':a;N;$!ba;s/asiarf,ap7621-001/phicomm,k2p\)\n\t\tucidef_add_switch\s"switch0"\s\\\n\t\t\t"0:lan"\s"1:lan"\s"2:lan"\s"3:lan"\s"4:wan"\s"6@eth0"\n\t\t\t;;\n\t&/1' target/linux/ramips/base-files/etc/board.d/02_network
sed -i ':a;N;$!ba;s/hiwifi,hc5962)/phicomm,k2p\)\n\t\tlan_mac=$(cat\s/sys/class/net/eth0/address\)\n\t\twan_mac=$(mtd_get_mac_binary factory 0xe006)\n\t\t;;\n\t&/1' target/linux/ramips/base-files/etc/board.d/02_network
cat >> ./target/linux/ramips/image/mt7621.mk <<EOF
define Device/phicomm_k2p
  IMAGE_SIZE := $(ralink_default_fw_size_16M)
  DTS := Phicomm_k2p
  DEVICE_VENDOR := Phicomm
  DEVICE_MODEL := K2P
  SUPPORTED_DEVICES += k2p
  DEVICE_PACKAGES := -luci-newapi -wpad-openssl kmod-mt7615d_dbdc wireless-tools
endef
TARGET_DEVICES += phicomm_k2p
EOF
sed -i 's/^[ \t]*//g' ./target/linux/ramips/image/mt7621.mk

# 修复DHCP服务, 从5.4内核改回4.14内核的resolv.conf路径
sed -i 's|resolv.conf.d/resolv.conf.auto|resolv.conf.auto|g' `grep -l resolv.conf.d package/feeds/custom/*/root/etc/init.d/*`

# custom插件汉化
#mv feeds/custom/luci-app-turboacc/po/zh_Hans feeds/custom/luci-app-turboacc/po/zh-cn

