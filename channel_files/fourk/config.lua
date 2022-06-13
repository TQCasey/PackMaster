-- fourk - android
return {

    srcname         = "fourk";

    style           = "gold";
    cmm_style       = "cmm_tl";
    lang            = "tl";
    langid 		    = 4;
    unit 		    = "THB";
    mm 			    = "fan_mm";

    games           = {
        "fafafa";
        "Dragon";
        "Volcano";
        "dummy";
        -- "dummy2v2";
        "fourk";
        -- "thai_sicbo";
        -- "pokdeng";
        -- "double_ten";
        -- "sangong";
        -- "sangong_bandar";
        -- "texas_bandar";
    };

    dbg_config 			= {
        hotupdate_cfg 	= "http://172.20.11.248:8989";
        hotupdate_zip 	= "http://172.20.11.248:8989";
        noticeurl 		= "http://172.20.11.248:8989/update/notice.json?r=%d";
        configurl 		= "http://172.20.11.248:8989/update/config.json?r=%d";
        phpurl 			= make_php_url ("192.168.1.129","fan_mm");
        backup 			= "192.168.1.105";
        ipv6			= "cynking.eatuo.com";
    };

    relese_config 		= {
        hotupdate_cfg 	= "http://fg-domino.com:8089/CynkingGame";
        hotupdate_zip 	= "http://hot.fg-domino.com";
        noticeurl 		= "http://init.fg-domino.com/notices.lastest.json?r=%d";
        configurl 		= "http://init.fg-domino.com/configs.network.fan_mm.json?r=%d";
        phpurl 			= "http://ckpokers.com/fan_mm/api.php";
        backup 			= "8.8.8.8";
        ipv6			= "8.8.8.8"; -- ipv6域名暂时缺失
    };

    preonline_config 		= {
		hotupdate_cfg 	= "http://172.20.11.248:8989";
		hotupdate_zip 	= "http://172.20.11.248:8989";
		noticeurl 		= "http://init.fg-domino.com/notices.lastest.json?r=%d";
		configurl 		= "http://init.fg-domino.com/configs.network.json?r=%d";
		phpurl 			= "http://8.129.10.38/fan_mm/api.php";
		backup 			= "8.129.10.38";
		ipv6			= "8.129.10.38";
	};

    slots_config 		= {
		hotupdate_cfg 	= "http://172.20.11.248:8990";
		hotupdate_zip 	= "http://172.20.11.248:8990";
		noticeurl 		= "http://init.fg-domino.com/notices.lastest.json?r=%d";
		configurl 		= "http://init.fg-domino.com/configs.network.json?r=%d";
		phpurl 			= "http://8.129.10.38/fan_mm/api.php";
		backup 			= "8.129.10.38";
		ipv6			= "8.129.10.38";
	};

    android = {

        oldpname 		= "com.zhijian.domino";
        oldpackname		= "com.zhijian.domino.R";
        template_proj   = "proj.studio.androidx.ina";

        -- android
        bugly_appid         = "435da090e9";
        bugly_appkey        = "885422c6-69e2-498d-9c94-64a3c8cd8f78";

        share_page = "https://apps.facebook.com/domino_qiuqiu";

        chlconfig = {
            ["CynkingB"] = {
                name = "com.Uking.thai.fk";
                channel = 0x04008233;
                encrypt_char = "NK";
                visitor_sid = 4;
                fans_page	= "https://www.facebook.com/CynkingThai4K/";
                copyres = {
                }
            };

            ["CynkingVivo"] = {
                name = "com.cynking.th.fk.vivo";
                channel = 0x04013233;
                encrypt_char = "MV";
                visitor_sid = 4;
                fans_page	= "https://www.facebook.com/CynkingThai4K/";
                copyres = {
                }
            }
        }
    }
    ;
    ios = {

        bugly_appid		= "40d3fa78e6";
        bugly_appkey    = "1a18aa84-860e-419f-9595-a79a76d98184";

        fans_page	    = "https://www.facebook.com/CynkingThai4K/";
        plist_group 	= "domino";

        share_page = domino_share_page;

        chlconfig = {
            ["CynkingB"] = {
                name = "com.cynking.th.fk";
                channel = 0x04008333;
                encrypt_char = "NKI";
                visitor_sid = 4;
            }
            ;
        }
    }
};
