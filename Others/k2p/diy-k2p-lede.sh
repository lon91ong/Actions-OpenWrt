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

#删除默认密码, 默认密码 password
sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/lean/default-settings/files/zzz-default-settings

#设置FAT为utf8编码
find target/linux -path "target/linux/*/config-*" | xargs -i sed -i '$a CONFIG_ACPI=y\nCONFIG_X86_ACPI_CPUFREQ=y\n \
CONFIG_NR_CPUS=128\nCONFIG_FAT_DEFAULT_IOCHARSET="utf8"' {}

# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon

# 切换内核版本为5.10
#sed -i 's/5.4/5.10/g' target/linux/ramips/Makefile
# 固件添加内核版本号
sed -i ':a;N;$!ba;s/$(BOARD)/&-$(LINUX_VERSION)/1' include/image.mk

# 修复K2P无线丢失错误配置
#sed -i 's/kmod-mt7615d_dbdc/kmod-mt7615e kmod-mt7615-firmware/g' target/linux/ramips/image/mt7621.mk

# 默认布局 16064k
sed -i 's/15744/16064/g' target/linux/ramips/image/mt7621.mk
sed -i 's/^[ \t]*//g' ./target/linux/ramips/image/mt7621.mk

# custom插件汉化
#mv feeds/custom/luci-app-turboacc/po/zh_Hans feeds/custom/luci-app-turboacc/po/zh-cn

# 修复无线WPA加密
cat >> .config <<EOF
CONFIG_PACKAGE_wpad-openssl=y
EOF
