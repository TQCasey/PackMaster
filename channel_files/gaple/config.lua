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
            ["CynkingA"] = { -- 主版本A
                name = "com.cynking.gaple";
                channel = 0x03001200;
                encrypt_char = "Y";
                visitor_sid = 1;
            }
        ;
            ["CynkingB"] = { -- 主版本B
                name = "com.cynking.gaple1";
                channel = 0x0300D200;
                encrypt_char = "X";
                visitor_sid = 1;
            }
        ;
            ["CynkingC"] = { -- 主版本C
                name = "com.cynking.gaplecasino";
                channel = 0x0300C200;
                encrypt_char = "GC";
                visitor_sid = 1;
            }
        ;
            ["preassemble"] = {
                name = "com.gp.gaple";
                channel = 0x0300E200;
                encrypt_char = "PC";
                visitor_sid = 1;
                copyres = {
                }
            }
        ;
            ["mimopay"] = {
                name = "com.cynking.id.gaple.mimopay";
                channel = 0x0300F200;
                encrypt_char = "MG";
                visitor_sid = 6;
                copyres = {
                }
            }
        ;
            ["CynkingD"] = { -- 主版本A
                name = "com.binggo.gaple";
                channel = 0x03001200;
                encrypt_char = "Y";
                visitor_sid = 1;
                template_proj = "proj.studio.androidx.ina";
            };

            ["Tiktok"] = { -- 抖音渠道包
                name = "com.cynking.tiktok";
                channel = 0x03002200;
                encrypt_char = "PT";
                visitor_sid = 1;
            };

            ["oppo"] = { -- oppp 联运包
                name = "com.binggo.gaple.nearme.gamecenter";
                channel = 0x03033200;
                encrypt_char = "XC";
                visitor_sid = 1;
                template_proj = "proj.studio.androidx.ina";
            };

            ["CynkingVivo"] = { -- 主版本A
                name = "com.cynking.id.gaple.vivo";
                channel = 0x03034200;
                encrypt_char = "XV";
                visitor_sid = 1;
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
            ["CynkingA"] = {
                name = "com.cynking.gaple";
                channel = 0x03003300;
                encrypt_char = "P";
                visitor_sid = 1;
            }
            ;
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


