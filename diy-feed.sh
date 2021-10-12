#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Comment a feed source
#sed -i -r 's/(^src-git packages.*)/#\1/' feeds.conf.default
#sed -i -r 's/(^src-git luci.*)/#\1/' feeds.conf.default

# Uncomment a feed source
#sed -i 's/^#\(.*telephony\)/\1/' feeds.conf.default
#sed -i 's/17.01/19.07/1' feeds.conf.default

# Add a feed source
#sed -i '$a src-git packages https://github.com/Lienol/openwrt-packages.git;main' feeds.conf.default
#sed -i '$a src-git luci https://github.com/Lienol/openwrt-luci.git;18.06-dev' feeds.conf.default
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package.git;main' feeds.conf.default
sed -i '$a src-git custom https://github.com/kiddin9/openwrt-packages' feeds.conf.default
