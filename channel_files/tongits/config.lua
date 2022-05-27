return {

    srcname       = "tongits";

    style           = "cat";
    cmm_style       = "cmm_ina";

    lang            = "en";
    langid 		    = 5;
    unit 		    = "PHP";
    mm 			    = "mm";

    games           = {
        "capsa";
        "slot";
        "texas";
        "tongits";
    };

    dbg_config = {
        backup        = "192.168.1.105";
        configurl     = "http://172.20.11.248:8989/update/config.json?r=%d";
        hotupdate_cfg = "http://172.20.11.248:8989/";
        hotupdate_zip = "http://172.20.11.248:8989/";
        ipv6          = "cynking.eatuo.com";
        noticeurl     = "http://172.20.11.248:8989/update/notice.json?r=%d";
        phpurl        = "http://cynking.eatuo.com:8123/fan_mm/api.php";
    };

    
    relese_config = {
        hotupdate_cfg = "http://hot-update.s3.amazonaws.com";
        hotupdate_zip = "http://hot.fg-domino.com";
        noticeurl     = "http://init.fg-domino.com/notices.lastest.json?r=%d";
        configurl     = "http://init.fg-domino.com/configs.network.fan_mm.json?r=%d";
        phpurl        = "http://ckpokers.com/fan_mm/api.php";
        backup        = "8.8.8.8";
        ipv6          = "8.8.8.8";
    };

    preonline_config        = {
        hotupdate_cfg   = "http://172.20.11.248:8989/";
        hotupdate_zip   = "http://172.20.11.248:8989/";
        noticeurl       = "http://init.fg-domino.com/notices.lastest.json?r=%d";
        configurl       = "http://init.fg-domino.com/configs.network.json?r=%d";
        phpurl          = "http://8.129.10.38/fan_mm/api.php";
        backup          = "8.129.10.38";
        ipv6            = "8.129.10.38";
    };

    slots_config        = {
        hotupdate_cfg   = "http://172.20.11.248:8990/";
        hotupdate_zip   = "http://172.20.11.248:8990/";
        noticeurl       = "http://init.fg-domino.com/notices.lastest.json?r=%d";
        configurl       = "http://init.fg-domino.com/configs.network.json?r=%d";
        phpurl          = "http://8.129.10.38/fan_mm/api.php";
        backup          = "8.129.10.38";
        ipv6            = "8.129.10.38";
    };


    android = {

        oldpname      = "com.zhijian.domino";
        oldpackname   = "com.zhijian.domino.R";

        -- android
        bugly_appid   = "6af50fed0d";
        bugly_appkey  = "52d74808-83d2-49b1-8971-a7bc3f2b06f4";
        share_page    = "https://www.facebook.com/CynkingCapsa";
        fans_page     = "https://www.facebook.com/CynkingCapsa/";


        chlconfig = {
            ["CynkingA"] = {
                channel      = 67183219;
                encrypt_char = "FA";
                name         = "com.cynking.tongits";
                visitor_sid  = 17;
            };
            ["CynkingVivo"] = {
                channel      = 0x04014273;
                encrypt_char = "FV";
                name         = "com.cynking.ph.tongits.vivo";
                visitor_sid  = 17;
            };
            ["CynkingQzly"] = {
                channel      = 0x04015273;
                encrypt_char = "QT";
                name         = "com.qzly.tongits";
                visitor_sid  = 19;
            };
        }
    }
    ;
    ios = {

    }
};

