
-- texas - android
return {
    srcname         = "texas";

    style           = "dark";
    cmm_style       = "cmm_ina";
    lang            = "ina";
    langid 		    = 2;
    unit 		    = "IDR";
    mm 			    = "mm";

    games           = {
        "domino";
        "texas";
        "gaple";
        "sicbo";
        "bandar_ceme";
        "capsa";
        "domino_bandar";
        "big_battle";
        "fafafa";
    };

    android = {

        oldpname 		= "com.zhijian.domino";
        oldpackname		= "com.zhijian.domino.R";


        fans_page		= "https://www.facebook.com/CKPoker/";
        -- android
        bugly_appid     = "90630ab66c";
        bugly_appkey    = "93dd2389-abf2-4d5d-87ca-acbbb52e8b49";

        share_page = texas_share_page;

        chlconfig = {
            ["texas3"] = {
                name = "com.zhijian.texas3";
                channel = 0x01015210;
                encrypt_char = "U";
                visitor_sid = 5;
                template_proj = "proj.studio.androidx.ina";
                copyres = {
                }
            }
        }
    }
    ;
    ios = {
        fans_page		= "https://www.facebook.com/CKPoker/";
        plist_group 	= "domino";
        share_page = texas_share_page;

        bugly_appid				= "d89b0d5ef1";
        bugly_appkey            = "dedec937-c0cd-48cb-a771-6565070deda8";

        chlconfig = {
            ["texas1"] = {
                name = "com.zhijian.texas";
                channel = 0x01013310;
                encrypt_char = "O";
                visitor_sid = 5;
            }
            ;

        }
    }
}
;
