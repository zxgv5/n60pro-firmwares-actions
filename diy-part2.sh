#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Remove the default apps
sed -i 's/ddns-scripts_aliyun //g' include/target.mk
sed -i 's/ddns-scripts_dnspod //g' include/target.mk
sed -i 's/luci-app-ddns //g' include/target.mk
sed -i 's/luci-app-arpbind //g' include/target.mk
sed -i 's/luci-app-filetransfer //g' include/target.mk
sed -i 's/luci-app-vsftpd //g' include/target.mk
sed -i 's/luci-app-ssr-plus //g' include/target.mk
sed -i 's/luci-app-vlmcsd //g' include/target.mk
sed -i 's/luci-app-accesscontrol //g' include/target.mk
sed -i 's/luci-app-nlbwmon //g' include/target.mk
sed -i 's/luci-app-wol //g' include/target.mk

CFG_FILE="./package/base-files/files/bin/config_generate"
LEDE_IP="192.168.10.1"
LEDE_NAME="n60pro"
#移除luci-app-attendedsysupgrade
sed -i "/attendedsysupgrade/d" $(find ./feeds/luci/collections/ -type f -name "Makefile")
#修改immortalwrt.lan关联IP
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$LEDE_IP/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
#修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$LEDE_IP/g" $CFG_FILE
#修改默认主机名
sed -i "s/hostname='.*'/hostname='$LEDE_NAME'/g" $CFG_FILE

#添加wireguard防火墙规则
cat >> package/network/config/firewall/files/firewall.config <<EOF
config rule
	option name 'Allow-Wireguard-Inbound'
	option src '*'
	list proto 'udp'
	option dest_port '52077'
	option target 'ACCEPT'
EOF

## # 添加组播防火墙规则
## cat >> package/network/config/firewall/files/firewall.config <<EOF
## config rule
##         option name 'Allow-UDP-igmpproxy'
##         option src 'wan'
##         option dest 'lan'
##         option dest_ip '224.0.0.0/4'
##         option proto 'udp'
##         option target 'ACCEPT'        
##         option family 'ipv4'

## config rule
##         option name 'Allow-UDP-udpxy'
##         option src 'wan'
##         option dest_ip '224.0.0.0/4'
##         option proto 'udp'
##         option target 'ACCEPT'
## EOF
