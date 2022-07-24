-- capsa - android
return {

    srcname         = "hygame";

    style           = "dark";
    cmm_style       = "cmm_ina";
    lang            = "ina";
    langid 		    = 2;
    unit 		    = "IDR";
    mm 			    = "mm";

    games           = {
        "capsa";
        "domino";
        "texas";
        "gaple";
        "remi";
        "fafafa";
        --"fafafa2";
        "big_battle";
        "bandar_ceme";
        "sicbo";
        "domino_bandar";
    };

    relese_config 		= {
        hotupdate_cfg 	= "http://hotupdate.tkhot.club/CynkingGame";
        hotupdate_zip 	= "http://hotupdate.tkhot.club";
        noticeurl 		= "http://init.fg-domino.com/notices.lastest.json?r=%d";
        configurl 		= "http://init.fg-domino.com/configs.network.fan_mm.json?r=%d";
        phpurl 			= "http://api.tkhot.club/api.php";
        backup 			= "8.8.8.8";
        ipv6			= "8.8.8.8"; -- ipv6域名暂时缺失
    };


    android = {

        oldpname 		= "com.zhijian.domino";
        oldpackname		= "com.zhijian.domino.R";

        -- android
        bugly_appid     = "13b66d8b69";
        bugly_appkey    = "7749480e-f303-472b-9e38-fb7f39ba0d72";
        share_page      = capsa_share_page;
        fans_page		= "https://www.facebook.com/CynkingCapsa/";

        chlconfig = {
            ["CynkingA"] = {
                name = "com.cynking.capsa";
                channel = 0x01027250;
                encrypt_char = "CP";
                visitor_sid = 11;
                template_proj = "proj.studio.androidx.hybro";
                copyres = {
                }
            }
        }
    }
    ;
    ios = {

    }
};
