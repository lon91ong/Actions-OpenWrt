#!/bin/bash
#### 照抄https://github.com/zhuxiaole/Build-OpenWrt/blob/main/xwrt/devices/common/diy-part1.sh
function git_sparse_clone() {
branch="$1" rurl="$2" localdir="$3" && shift 3
git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
cd $localdir
git sparse-checkout init --cone
git sparse-checkout set $@
mv -n $@ ../
cd $GITHUB_WORKSPACE/openwrt
rm -rf $localdir
}

mkdir -p $GITHUB_WORKSPACE/xwrt/devices/common/packages/luci-app-natcap
cd $GITHUB_WORKSPACE/xwrt/devices/common
git_sparse_clone main "https://github.com/zhuxiaole/Build-OpenWrt" "xwrt/devices/common/packages/luci-app-natcap" packages/luci-app-natcap
cd $GITHUB_WORKSPACE/xwrt/devices/common
mkdir -p patches/luci-base
git_sparse_clone main "https://github.com/zhuxiaole/Build-OpenWrt" "xwrt/devices/common/patches/luci-base" patches/luci-base
cd $GITHUB_WORKSPACE/xwrt/devices/common
mkdir -p patches/luci-app-wizard
git_sparse_clone main "https://github.com/zhuxiaole/Build-OpenWrt" "xwrt/devices/common/patches/luci-app-wizard" patches/luci-app-wizard

rm -rf feeds/packages/net/frp
git clone --depth 1 https://github.com/kuoruan/openwrt-frp feeds/packages/net/frp

rm -rf feeds/packages/net/*/.git
rm -rf feeds/packages/net/*/.gitattributes
rm -rf feeds/packages/net/*/.svn
rm -rf feeds/packages/net/*/.github
rm -rf feeds/packages/net/*/.gitignore
rm -rf feeds/luci/applications/luci-app-wol

rm -rf feeds/luci/applications/luci-app-nft-qos
git_sparse_clone openwrt-21.02 "https://github.com/immortalwrt/luci" "feeds/luci/applications/nft_qos_luci" applications/luci-app-nft-qos

rm -rf feeds/luci/applications/luci-app-dawn
git_sparse_clone master "https://github.com/coolsnowwolf/luci" "feeds/luci/applications/dawn_luci" applications/luci-app-dawn

rm -rf feeds/luci/applications/luci-app-airplay2
git_sparse_clone openwrt-21.02 "https://github.com/immortalwrt/luci" "feeds/luci/applications/airplay2_luci" applications/luci-app-airplay2

rm -rf feeds/luci/applications/luci-app-frpc
git_sparse_clone master "https://github.com/kiddin9/openwrt-packages" "feeds/luci/applications/frpc_luci" luci-app-frpc

rm -rf feeds/luci/applications/luci-app-opkg
git_sparse_clone openwrt-21.02 "https://github.com/immortalwrt/luci" "feeds/luci/applications/opkg_luci" applications/luci-app-opkg

rm -rf feeds/luci/applications/*/.git
rm -rf feeds/luci/applications/*/.gitattributes
rm -rf feeds/luci/applications/*/.svn
rm -rf feeds/luci/applications/*/.github
rm -rf feeds/luci/applications/*/.gitignore

sed -i 's|entry({ "admin", "dawn" }, firstchild(), "DAWN", 60)|entry({ "admin", "dawn" }, firstchild(), "Configure DAWN", 60)|g' feeds/luci/applications/luci-app-dawn/luasrc/controller/dawn.lua
sed -i 's|Map("dawn", "Network Overview", translate("Network Overview"))|Map("dawn", translate("Network Overview"), translate("View Network Overview"))|' feeds/luci/applications/luci-app-dawn/luasrc/model/cbi/dawn/dawn_network.lua
sed -i 's|Map("dawn", "Hearing Map", translate("Hearing Map"))|Map("dawn", translate("Hearing Map"), translate("View Hearing Map"))|' feeds/luci/applications/luci-app-dawn/luasrc/model/cbi/dawn/dawn_hearing_map.lua

sed -i 's|s:tab("limit", "Limit Rate by IP Address")|s:tab("limit", translate("Limit Rate by IP Address"))|' feeds/luci/applications/luci-app-nft-qos/luasrc/model/cbi/nft-qos/nft-qos.lua
sed -i 's|s:tab("limitmac", "Limit Rate by Mac Address")|s:tab("limitmac", translate("Limit Rate by Mac Address"))|' feeds/luci/applications/luci-app-nft-qos/luasrc/model/cbi/nft-qos/nft-qos.lua
sed -i 's|s:tab("priority", "Traffic Priority")|s:tab("priority", translate("Traffic Priority"))|' feeds/luci/applications/luci-app-nft-qos/luasrc/model/cbi/nft-qos/nft-qos.lua
echo -e '\n#: applications/luci-app-nft-qos/luasrc/model/cbi/nft-qos/nft-qos.lua:33' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hans/nft-qos.po
echo -e 'msgid "Limit Rate by IP Address"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hans/nft-qos.po
echo -e 'msgstr "通过IP地址限速"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hans/nft-qos.po
echo -e '\n#: applications/luci-app-nft-qos/luasrc/model/cbi/nft-qos/nft-qos.lua:34' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hans/nft-qos.po
echo -e 'msgid "Limit Rate by Mac Address"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hans/nft-qos.po
echo -e 'msgstr "通过MAC地址限速"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hans/nft-qos.po
echo -e '\n#: applications/luci-app-nft-qos/luasrc/model/cbi/nft-qos/nft-qos.lua:35' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hans/nft-qos.po
echo -e 'msgid "Traffic Priority"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hans/nft-qos.po
echo -e 'msgstr "流量优先级"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hans/nft-qos.po
echo -e '\n#: applications/luci-app-nft-qos/luasrc/model/cbi/nft-qos/nft-qos.lua:33' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hant/nft-qos.po
echo -e 'msgid "Limit Rate by IP Address"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hant/nft-qos.po
echo -e 'msgstr "通過IP位址限速"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hant/nft-qos.po
echo -e '\n#: applications/luci-app-nft-qos/luasrc/model/cbi/nft-qos/nft-qos.lua:34' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hant/nft-qos.po
echo -e 'msgid "Limit Rate by Mac Address"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hant/nft-qos.po
echo -e 'msgstr "通過MAC位址限速"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hant/nft-qos.po
echo -e '\n#: applications/luci-app-nft-qos/luasrc/model/cbi/nft-qos/nft-qos.lua:35' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hant/nft-qos.po
echo -e 'msgid "Traffic Priority"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hant/nft-qos.po
echo -e 'msgstr "流量優先權"' >>feeds/luci/applications/luci-app-nft-qos/po/zh_Hant/nft-qos.po

mkdir -p feeds/luci/modules/luci-base/patches
cp $GITHUB_WORKSPACE/xwrt/devices/common/patches/luci-base/* feeds/luci/modules/luci-base/patches

sed -i "s|dropbear.@dropbear[0].PasswordAuth='off'|dropbear.@dropbear[0].PasswordAuth='on'|g" feeds/x/base-config-setting/files/uci.defaults
sed -i "s|dropbear.@dropbear[0].RootPasswordAuth='off'|dropbear.@dropbear[0].RootPasswordAuth='on'|g" feeds/x/base-config-setting/files/uci.defaults
sed -i "/net.ipv4.tcp_congestion_control=htcp/d" feeds/x/base-config-setting/files/uci.defaults
sed -i "/net.ipv4.tcp_congestion_control=cubic/d" feeds/x/base-config-setting/files/uci.defaults
sed -i "/net.ipv4.tcp_congestion_control=bbr/a\net.ipv4.tcp_available_congestion_control=bbr htcp cubic" feeds/x/base-config-setting/files/uci.defaults

sed -i "/\$DISTRIB_ID/a\sed -i '/DISTRIB_GITHUB/d' /etc/openwrt_release" feeds/x/base-config-setting/files/uci.defaults
sed -i "/DISTRIB_GITHUB/a\echo \"DISTRIB_GITHUB=\'https://github.com/zhuxiaole/Build-OpenWrt\'\" >> /etc/openwrt_release" feeds/x/base-config-setting/files/uci.defaults
sed -i "/\$DISTRIB_ID/a\sed -i '/DISTRIB_RELEASE_TAG/d' /etc/openwrt_release" feeds/x/base-config-setting/files/uci.defaults
sed -i "/DISTRIB_RELEASE_TAG/a\echo \"DISTRIB_RELEASE_TAG=\'${RELEASE_TAG}\'\" >> /etc/openwrt_release" feeds/x/base-config-setting/files/uci.defaults

rm -rf feeds/x/luci-app-wizard
git_sparse_clone master "https://github.com/kiddin9/openwrt-packages" "feeds/x/wizard_luci" luci-app-wizard
mkdir -p feeds/x/luci-app-wizard/patches
cp $GITHUB_WORKSPACE/xwrt/devices/common/patches/luci-app-wizard/* feeds/x/luci-app-wizard/patches

rm -rf feeds/x/luci-app-natcap/files/luci/controller/natcap.lua
curl -o feeds/x/luci-app-natcap/files/luci/controller/natcap.lua https://github.com/zhuxiaole/Build-OpenWrt/raw/main/xwrt/devices/common/packages/luci-app-natcap/natcap.lua
cp $GITHUB_WORKSPACE/xwrt/devices/common/packages/luci-app-natcap/natcap.lua feeds/x/luci-app-natcap/files/luci/controller/
sed -i 's|Map("natcapd", luci.xml.pcdata(translate("Advanced Options")))|Map("natcapd", luci.xml.pcdata(translate("Fast NAT Forwarding")))|g' feeds/x/luci-app-natcap/files/luci/model/cbi/natcap/natcapd_sys.lua
sed -i 's|s:tab("system", translate("System Settings"))|-- s:tab("system", translate("System Settings"))|g' feeds/x/luci-app-natcap/files/luci/model/cbi/natcap/natcapd_sys.lua
sed -i 's|s:taboption("system", Flag,|s:option(Flag,|g' feeds/x/luci-app-natcap/files/luci/model/cbi/natcap/natcapd_sys.lua
echo -e '\nmsgid "Fast NAT Forwarding"' >>feeds/x/luci-app-natcap/files/luci/i18n/natcap.zh-cn.po
echo -e 'msgstr "NAT转发加速"' >>feeds/x/luci-app-natcap/files/luci/i18n/natcap.zh-cn.po

rm -rf feeds/x/*/.git
rm -rf feeds/x/*/.gitattributes
rm -rf feeds/x/*/.svn
rm -rf feeds/x/*/.github
rm -rf feeds/x/*/.gitignore

curl -o $GITHUB_WORKSPACE/xwrt/devices/common/convert_translation.sh https://github.com/zhuxiaole/Build-OpenWrt/raw/main/xwrt/devices/common/convert_translation.sh
chmod +x $GITHUB_WORKSPACE/xwrt/devices/common/convert_translation.sh
bash $GITHUB_WORKSPACE/xwrt/devices/common/convert_translation.sh -a >/dev/null 2>&1

#### 照抄End

# Modify default IP
sed -i 's/192.168.15.1/192.168.77.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.15.1/192.168.77.1/g' package/feeds/luci/luci-mod-system/htdocs/luci-static/resources/view/system/flash.js

#删除默认密码
sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/lean/default-settings/files/zzz-default-settings
sed -i "s/hostname='OpenWrt'/hostname='X-Wrt'/g" package/base-files/files/bin/config_generate

#设置FAT为utf8编码
find target/linux -path "target/linux/*/config-*" | xargs -i sed -i '$a CONFIG_ACPI=y\nCONFIG_X86_ACPI_CPUFREQ=y\n \
CONFIG_NR_CPUS=128\nCONFIG_FAT_DEFAULT_IOCHARSET="utf8"' {}

#默认主题改为argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b master https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon

#解包ttnode
curl -o ttnode.zip https://raw.githubusercontent.com/lon91ong/Actions-OpenWrt/5.4.x/Others/luci-app-ttnode.zip
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
