-- gaple - android
return {
    srcname         = "gaple";

    style           = "light";
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
        --"remi";
        "fafafa";
        --"fafafa2";
        "big_battle";
        "bandar_ceme";
        "sicbo";
        "domino_bandar";
    };

    android = {

        oldpname 		= "com.zhijian.domino";
        oldpackname		= "com.zhijian.domino.R";

        -- android
        bugly_appid     = "1ca2b7b10f";
        bugly_appkey    = "d156308e-f8f8-4e05-957e-551a752d7dfa";

        share_page = gaple_share_page;
        fans_page		= "https://www.facebook.com/CynKingGaple/";

        chlconfig = {
            ["CynkingD"] = { -- 主版本A
                name = "com.binggo.gaple";
                channel = 0x03001200;
                encrypt_char = "Y";
                visitor_sid = 1;
                template_proj = "proj.studio.androidx.ina";
            };
        }
    }
    ;
    ios = {
        bugly_appid		= "5b35730024";
        bugly_appkey    = "d7b95cec-7a28-4359-ac4e-68ff1bf819c4";

        fans_page		= "https://www.facebook.com/CynKingGaple/";
        plist_group 	= "texaspt";
        share_page = gaple_share_page;

        chlconfig = {
            ["CynkingD"] = {
                name = "com.cynking.gaplenew";
                channel = 0x03005300;
                encrypt_char = "PG";
                visitor_sid = 1;
            }
            ;
        }
    }
}
;


