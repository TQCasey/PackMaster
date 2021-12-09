

-- domino - android
return {

    srcname         = "domino";

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
        fans_page		= "https://www.facebook.com/CKDomino99/";

        -- android
        bugly_appid     = "c698d6636d";
        bugly_appkey    = "54c83957-5eb5-4b82-94b8-f2826ba366ba";
        share_page      = domino_share_page;

        chlconfig = {
            ["clickwala1"] = {
                name = "com.zhijian.domino";
                channel = 0x01001200;
                encrypt_char = "Y";
                visitor_sid = 1;
                copyres = {
                }
            }
        ;
            ["clickwala2"] = {
                name = "com.zhijian.domino2";
                channel = 0x0100E200;
                encrypt_char = "W";
                visitor_sid = 1;
                copyres = {
                }
            }
        ;
            ["clickwala3"] = {   -- click 3
                name = "com.zhijian.domino3";
                channel = 0x01019200;
                encrypt_char = "N";
                visitor_sid = 1;
                copyres = {
                }
            }
        ;
            ["cynking1"] = {
                name = "com.zhijian.domino1";
                channel = 0x01002200;
                encrypt_char = "B";
                visitor_sid = 1;
                copyres = {
                }
            }
        ;
            ["cynking2"] = {
                name = "com.cynkingame.domino";
                channel = 0x0100D200;
                encrypt_char = "X";
                visitor_sid = 3;
                copyres = {
                }
            }
        ;
            ["youmi"] = {
                name = "com.zhijian.dominoym";
                channel = 0x01011200;
                encrypt_char = "A";
                visitor_sid = 4;
                copyres = {
                }
            }
        ;
            ["preassemble"] = {
                name = "com.gp.domino99";
                channel = 0x0101F200;
                encrypt_char = "PA";
                visitor_sid = 1;
                copyres = {
                }
            }
        ;
            ["mimopay"] = {
                name = "com.gp.domino99";
                channel = 0x01004200;
                encrypt_char = "AB";
                visitor_sid = 1;
                copyres = {
                }
            }
        ;
            ["CynkingC"] = {
                name = "com.cynking.qiuqiu";
                channel = 0x0102A200;
                encrypt_char = "AC";
                visitor_sid = 1;
                copyres = {
                }
            }
        ;
            ["cynkingD"] = {
                name = "com.binggo.domino";
                channel = 0x01002200;
                encrypt_char = "B";
                visitor_sid = 1;
                template_proj = "proj.studio.androidx.ina";
                copyres = {
                }
            };

            ["oppo"] = {
                name = "com.domino.nearme.gamecenter";
                channel = 0x01031200;
                encrypt_char = "XA";
                visitor_sid = 1;
                copyres = {
                }
            };

            ["Xiamen"] = {--厦门超级链
                name = "com.xiamen.domino";
                channel = 0x01032200;
                encrypt_char = "XB";
                visitor_sid = 1;
                copyres = {
                }
            };

            ["CynkingQzly"] = {     -- 茄子联运
                name = "com.qzly.domino";
                channel = 0x01035200;
                encrypt_char = "QA";
                visitor_sid = 1;
                template_proj = "proj.studio.androidx";
                copyres = {
                }
            };
        }
    }
    ;
    ios = {

        bugly_appid				= "59b00d7cc8";
        bugly_appkey            = "054effd2-5c0d-41d4-9fcf-79e9c6e75331";

        share_page 					= domino_share_page;
        fans_page		= "https://www.facebook.com/CKDomino99/";
        plist_group 	= "domino";

        chlconfig = {
            ["cynking1"] = {
                name = "com.zhijian.domino";
                channel = 0x01003300;
                encrypt_char = "P";
                visitor_sid = 1;
            }
            ;
        }
    }
}
;


