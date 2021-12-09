return {
    srcname         = "sicbo";

    style           = "dark";
    cmm_style       = "cmm_ina";
    lang            = "ina";
    langid 		    = 2;
    unit 		    = "IDR";
    mm 			    = "mm";

    games           = {
        "sicbo";
        "bandar_ceme";
        "domino";
        "texas";
        "gaple";
        --"remi";
        "fafafa";
        --"fafafa2";
        "big_battle";

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

        fans_page		= "https://www.facebook.com/CKSicBo/";

        -- android
        bugly_appid     = "f3fbfc023b";
        bugly_appkey    = "20e7af58-3bd2-4a08-a680-284e25bf1647";
        share_page      = "https://apps.facebook.com/cksicbo";

        chlconfig = {
            ["CynkingA"] = {
                name = "com.cynking.sicbo";
                channel = 0x0101D230;
                encrypt_char = "SA";
                visitor_sid = 7;
                template_proj = "proj.studio.androidx.ina";
                copyres = {
                }
            }
        ;
            ["clickwala1"] = {
                name = "com.zhijian.domino";
                channel = 0x01001200;
                encrypt_char = "Y";
                visitor_sid = 1;
                copyres = {
                }
            }
        }
    }
    ;
    ios = {

    }
};
