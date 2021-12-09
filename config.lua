

require ("functions");

version				= 1.0;

domino_share_page 	= "https://apps.facebook.com/ckdomino";
texas_share_page 	= "https://apps.facebook.com/ckpoker";
gaple_share_page 	= "https://apps.facebook.com/cynkinggaple";
sicbo_share_page 	= "https://apps.facebook.com/cksicbo";
capsa_share_page 	= "https://www.facebook.com/CynkingCapsa";
domain_url			= "192.168.1.129";
svn_root 			= [[https://USER-20210826BI/svn/]];

function make_php_url (ip_url,mm)
 	return string.format ("http://%s/%s/api.php",tostring (ip_url),tostring (mm));
end

string.trim =  function (s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

table.merge = function (dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end


config = {
	version				= version;

	games_svn 			= svn_root .. [[/client/games]];
	tags_svn_root 		= svn_root .. [[/client/tags]];
	svn_root 			= svn_root;
	pvr_key 			= [[99eba1be14761ad8fade4dcb1da2da8a]];

	dbg_config 			= {
		hotupdate_cfg 	= "http://172.20.11.248:8989";
		hotupdate_zip 	= "http://172.20.11.248:8989";
		noticeurl 		= "http://172.20.11.248:8989/update/notice.json?r=%d";
		configurl 		= "http://172.20.11.248:8989/update/config.json?r=%d";
		phpurl 			= make_php_url (domain_url,"mm");
		backup 			= "219.133.160.63";
		ipv6			= "cynking.eatuo.com";
	};

	relese_config 		= {
		hotupdate_cfg 	= "http://fg-domino.com:8089/CynkingGame";
		hotupdate_zip 	= "http://hot.fg-domino.com/CynkingGame";
		noticeurl 		= "http://init.fg-domino.com/notices.lastest.json?r=%d";
		configurl 		= "http://init.fg-domino.com/configs.network.json?r=%d";
		phpurl 			= "http://fg-domino.com/mm/api.php";
		backup 			= "219.133.160.63";
		ipv6			= "http://server.fg-domino.com";
	};

	preonline_config 		= {
		hotupdate_cfg 	= "http://172.20.11.248:8989";
		hotupdate_zip 	= "http://172.20.11.248:8989";
		noticeurl 		= "http://init.fg-domino.com/notices.lastest.json?r=%d";
		configurl 		= "http://init.fg-domino.com/configs.network.json?r=%d";
		phpurl 			= "http://8.129.10.38/mm/api.php";
		backup 			= "8.129.10.38";
		ipv6			= "http://8.129.10.38";
	};

	prefix_url 			= "http://d3bon1cx113mtl.cloudfront.net/mm/i/4/";

	langinfo 			= {

	};

	game_type 			= {
	};

	-- 去除列表,强制去除的热更新文件列表
	files_remove_lists 	= {

	};

	-- 去除列表，强制去除不转化pvr的文件list
	pvrccz_8888_list 	= {
   	};

	-- 保持原始png图片，不知道咋了 pvrccz 在骨骼里始终是失真的
	-- 后面再看
	pnglist 			= {
	};
};

-- merge the android and ios config to main config file
package.path = package.path .. ";channel_files/?.lua;"
local hallList 		= require ("channel_files.requires");
local hallTyleList 	= {};

for _,hallName in pairs (hallList) do
	local flag,cfg = pcall (require,hallName .. ".config");
	if flag then
        if IS_IOS then
            hallTyleList ["ios-" .. hallName] = cfg;
        else
            hallTyleList ["android-" .. hallName] = cfg;
        end
	end
end

table.merge(config.game_type,hallTyleList);

