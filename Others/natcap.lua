-- Copyright (C) 2019 X-WRT <dev@x-wrt.com>

module("luci.controller.natcap", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/natcapd") then
		return
	end

	local ut = require "luci.util"
	local sys  = require "luci.sys"
	local ui = ut.trim(sys.exec("uci get natcapd.default.ui 2>/dev/null"))

	local page

	page = entry({"admin", "services", "natcapd_sys"}, cbi("natcap/natcapd_sys"), _("Fast NAT Forwarding"))
	page.i18n = "natcap"
	page.dependent = true
	page.acl_depends = { "luci-app-natcap" }

end
