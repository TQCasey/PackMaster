return {

    srcname         = "bandar_ceme";
    style           = "dark";
    cmm_style       = "cmm_ina";
    lang            = "ina";
    langid 		    = 2;
    unit 		    = "IDR";
    mm 			    = "mm";

    games           = {
        "bandar_ceme";
        "domino";
        "texas";
        "gaple";
        --"remi";
        "fafafa";
        --"fafafa2";
        "big_battle";
        "sicbo";
        "domino_bandar";
    };


    -- sid
    -- 1 : 游客 1
    -- 2 : FB
    -- 3 : 游客 2
    -- 4 : 游客 3
    -- 5 : 游客 4
    -- 如果账号体系互通的版本，那么都填一样即可
    -- 不互通，就不一样的填，比如都填3 ，那都归�?的账号体系内
    --
    --

    android = {

        oldpname 		= "com.zhijian.domino";
        oldpackname		= "com.zhijian.domino.R";

        fans_page		= "https://www.facebook.com/CynkingCeme/";

        -- android
        bugly_appid     = "ad08686693";
        bugly_appkey    = "c433b852-cf68-4eac-bc87-93951464c3e5";

        share_page      = "https://apps.facebook.com/cksicbo";

        chlconfig = {
            ["cynkingA"] = {   -- 主版本A
                name = "com.cynking.ceme";
                channel = 0x01023240;
                encrypt_char = "CA";
                visitor_sid = 8;
                template_proj = "proj.studio.androidx.ina";
                copyres = {
                }
            }
        }
    }
    ;
    ios = {

    }
};
