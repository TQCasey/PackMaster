"""
the common pack procedure here
"""
import hashlib
import time
import zipfile
import socket
import yaml

from cmm import *
from profile import gFilterList, PageConfig, gWhiteList, gPMConfig, gLuaPM
from svnuploader import SvnUploader

from plugins.unpacktex.unpacktex import UnpackPngSheet,IsSupportedList

class PackCommon:
    def __init__(self, pmconfig, luaglobals, dict,batch_pack=False):

        self.pmconfig = pmconfig;

        try:
            # print ("Checking argument...");

            self.make_time = time.strftime("%Y%m%d%H%M%S", time.localtime());

            self.PACK_OK = False;
            self.app_path = "";
            self.batch_pack = batch_pack;
            self.dict = dict;

            self.hallName = pmconfig.getCurHallName();
            self.chName = pmconfig.getCurChName();

            self.curChConfig = pmconfig.getCurChConfig();
            self.luaHallConfig = gLuaPM.hallConfig(self.hallName);
            self.luaChConfig = gLuaPM.chConifg(self.hallName,self.chName);
            self.luaConfig = gLuaPM.config();
            self.luaPlatConfig = gLuaPM.platConfig (self.hallName);

            self.game_list = self.pmconfig.getCurGameList();
            self.all_game_list = gPMConfig.getAllGameList ();

            self.isThaiLang = self.luaHallConfig.lang == "tl";

            self.use_debug = self.curChConfig.use_debug;

            self.use_compress_texture = self.curChConfig.use_compress_texture;
            self.use_pvr = self.curChConfig.use_pvr;
            self.use_etc2 = self.curChConfig.use_etc2;
            self.use_astc = self.curChConfig.use_astc;

            self.use_slots_update = self.curChConfig.use_slots_update;

            self.use_rgba8888 = self.curChConfig.use_rgba8888;

            self.use_bones_zip = self.curChConfig.use_bones_zip;
            self.use_no_crypt_zip = self.curChConfig.use_no_crypt_zip;
            self.use_pngquant = self.curChConfig.use_pngquant;
            self.use_logger = self.curChConfig.use_logger;
            self.use_filelogger = self.curChConfig.use_filelogger;
            self.use_local_push = False;
            self.use_new_act = False;
            self.use_v2030 = False;

            arr = self.hallName.split("-");
            self.curGameHallName = arr[1];

            app_version = self.curChConfig.vname;
            app_arr = app_version.split(".");
            self.shortVerName = app_arr[0] + "." + app_arr[1] + "." + app_arr[2];
            self.vname = self.curChConfig.vname;
            self.vcode = self.curChConfig.vcode;

        except Exception as err:
            errmsg(err);

    def _modifyHashRes(self, filepath):
        try:
            # file = open(filepath, "ab");
            # file.write(struct.pack('B', 0x00));
            # file.close();
            pass
        except Exception as err:
            errmsg(err);
        pass

    def _fileMd5(self, filepath,bConvert = False):
        try:

            if not os.path.exists(filepath):
                return "";

            md5 = hashlib.md5();
            file = open(filepath, "rb");
            content = file.read();

            if bConvert:
                content = bytearray (convertToLF (content));

            md5.update(content);
            file.close();
            return md5.hexdigest();
        except Exception as err:
            errmsg(err);

    def _contentMd5(self,content):
        try:
            md5 = hashlib.md5();
            md5.update(content.encode());
            return md5.hexdigest();
        except Exception as err:
            errmsg(err);

    def onMakeNativeProject(self):

        # prepare
        # self.purgePublishDir();
        self.removeOldProjectDir();
        self.copyNewOldProjectDir();

        pass

    def run(self):

        if not isMacOS():
            print ("自动同步到最新时间...");
            Commander ().do('''w32tm /config /manualpeerlist:"210.72.145.44" /syncfromflags:manual /reliable:yes /update''');

        #make auto_config file first
        self.makeConfigs();

        # prepare
        self.purgePublishDir();
        self.removeOldProjectDir();
        self.copyNewOldProjectDir();

        ## prepare publish
        self.preparePublishFiles();

        ## src
        self.prepareSrcDir();
        self.modifyUIFiles();
        self.makeVersionFiles();
        # self.makeAutoConfigFile();
        self.cryptSrcFiles();

        ## res
        self.prepareResDir();
        self.simplifyResDir();
        self.cryptResFiles();

        ## md5files
        self.makeMd5file ();

        ## proceed with src and res
        self.proceedSrcAndRes ();

        ## pack
        self.zipAllFile();
        if not self.use_no_crypt_zip:
            self.cryptZipFile();

        ## native
        self.copyExtralResource();
        self.modifyHashResource();
        self.prepareNativeResouce();
        self.doBeforeBuildAction();
        self.buildAll();
        self.doAfterBuildAction();

        return self.finallyDone();

    def finallyDone(self):
        pass

    def buildAAB(self):
        pass

    def doAfterBuildAAB(self):
        pass

    def exportIpa(self,archPath):
        pass

    def _md5dir(self,path):
        pass

    def repackTex(self,plistfile,pngfile,packdir,ext_args):
        try:

            if isWin():
                cmd = os.path.join("common","texturepacker","windows","TexturePacker")
            else:
                cmd = "TexturePacker"

            cmdstr = ('%s '
                      '--texture-format png '
                      '--format cocos2d '
                      '--data %s '
                      '--sheet %s '
                      '--opt RGBA8888 '
                      '--max-width 2048 '
                      '--max-height 2048 '
                      '--trim-mode Trim '
                      '--size-constraints NPOT '
                      '--algorithm MaxRects '
                      '--maxrects-heuristics Best '
                      '--pack-mode Best '
                      '--scale 1 '
                      '--basic-sort-by Best '
                      '--dither-fs-alpha '
                      ' %s '
                      # ' --png-opt-level 4 '
                      '--padding 0 %s' % (cmd,plistfile, pngfile, ext_args,packdir))

            Commander().do(cmdstr);

        except Exception as err:
            errmsg(err);

    def makeYaml(self):
        try:

            lua_dir = self.lua_src_dir;

            all = os.walk(lua_dir);

            for path, dir, filelist in all:
                for filename in filelist:

                    if not filename.endswith(".plist"):
                        continue;


                    plist_file = os.path.join(lua_dir, path, filename);

                    png_file = plist_file.replace(".plist", ".png");
                    yaml_file = plist_file.replace(".plist", ".yaml");

                    '''
                    已经有yaml
                    '''
                    if os.path.exists(yaml_file):
                        continue;

                    '''
                    检测是否有png
                    '''
                    if not os.path.exists(png_file):
                        continue;


                    '''
                    检测是否是支持的plist 
                    '''
                    filen, filext = os.path.splitext(filename);
                    check_name = os.path.join(lua_dir, path, filen);
                    if not IsSupportedList(check_name):
                        continue;


                    '''
                    创建yaml
                    '''
                    print ("创建 %s " % (yaml_file))
                    with open(yaml_file, "w+",encoding='utf8') as file:
                        pass
            pass

        except Exception as err:
            errmsg(err);

    def syncAutoTex(self,isAll = False):
        try:

            lua_dir = self.lua_src_dir;

            isSetup = self.dict ["isSetup"];
            if isSetup:
                print("正在初始化自动图集...");
            else:
                print("正在刷新自动图集...");

            curHall = gPMConfig.getCurHallName();
            curCh = gPMConfig.getCurChName();
            style = self.luaHallConfig.style;

            style_str = "style/%s" % style;

            all = os.walk(lua_dir);

            for path, dir, filelist in all:
                for filename in filelist:

                    fullPath = os.path.join(lua_dir,path,filename).replace("\\", "/");

                    if not isAll:
                        if "/style/" in fullPath:
                            if style_str not in fullPath:
                                continue;

                    if not filename.endswith(".yaml"):
                        continue;

                    isInit = isSetup;
                    noPngPlist = False;

                    yaml_file = os.path.join(lua_dir,path,filename);

                    if not os.path.exists(yaml_file):
                        continue;

                    with open(yaml_file,'r') as file:
                        content = file.read();

                    datas = yaml.load(content,Loader=yaml.FullLoader)
                    filen,filext = os.path.splitext(filename);
                    auto_dir = os.path.join(lua_dir,path,filen);

                    png_file = yaml_file.replace(".yaml",".png");
                    plist_file = yaml_file.replace(".yaml",".plist");

                    if not os.path.exists(auto_dir):
                        errmsg("存在yaml文件，但散图目录不存在 %s ,自动拆解散图" % auto_dir)

                        if not os.path.exists(plist_file) or not os.path.exists(png_file):
                            errmsg("警告 ==> 拆解散图，没有找到 png 或者 plist 文件，视为无效自动图集");
                            continue;

                        UnpackPngSheet (auto_dir)
                        errmsg("自动拆解完成 %s " % auto_dir)

                    dest_dict = {};

                    if (not os.path.exists(png_file) or not os.path.exists(plist_file)) and isSetup:
                        errmsg("警告 ==> 存在yaml文件，初始化模式下，图集资源不存在 %s ,将会依据散图生成图集" % png_file)
                        isInit = False;
                        noPngPlist = True;
                        # continue;

                    png_md5 = self._fileMd5(png_file);
                    plist_md5 = self._fileMd5(plist_file,True);

                    dest_dict["frames"] = [];

                    print ("生成 %s" % (yaml_file))

                    sub_md5 = "";

                    if datas and "ext_args" in datas:
                        ext_args = datas["ext_args"] or "";
                    else:
                        ext_args = "";

                    sub_all = os.walk(auto_dir);

                    md5_arr = [];

                    for sub_path, sub_dir, sub_filelist in sub_all:
                        for sub_filename in sub_filelist:
                            if not sub_filename.endswith(".png"):
                                continue;

                            fpath = os.path.join(sub_path, sub_filename);
                            fmd5 = self._fileMd5(fpath);
                            md5_arr.append(fmd5);

                            # sub_md5 = sub_md5 + self._fileMd5(fpath);

                            auto_len = len(auto_dir) + 1;
                            pngfile = fpath [auto_len:];
                            pngfile = pngfile.replace("\\", "/");

                            dest_dict["frames"].append (pngfile);

                    '''
                    sort 
                    '''
                    ordered_md5_arr = sorted(md5_arr);
                    for k in range(len(ordered_md5_arr)):
                        sub_md5 += ordered_md5_arr [k];

                    content_md5 = self._contentMd5 (sub_md5)

                    if isInit:
                        dest_dict ["png_md5"] = png_md5
                        dest_dict ["plist_md5"] = plist_md5
                        dest_dict ["dir_md5"] = content_md5;
                        dest_dict ["ext_args"] = ext_args;
                    else:
                        '''
                        检测md5，如果subdir的md5变化了，那么重新生成png和plist
                        '''
                        if not datas or content_md5 != datas ["dir_md5"] or noPngPlist == True:
                            print ("检测到散图变化，将会重新生成图集");

                            self.repackTex(plist_file,png_file,auto_dir,ext_args);

                            png_md5 = self._fileMd5(png_file);
                            plist_md5 = self._fileMd5(plist_file);

                            dest_dict["dir_md5"] = content_md5;
                            dest_dict["plist_md5"] = plist_md5
                            dest_dict["png_md5"] = png_md5;
                            dest_dict["ext_args"] = ext_args;

                            pass
                        else:
                            # print ("散图无变化，忽略");
                            continue;

                    yaml_str = yaml.dump(dest_dict,Dumper=yaml.Dumper);
                    yaml_content = convertToLF(yaml_str.encode('utf8'));

                    with open(yaml_file,"wb+") as file:
                        file.write(bytearray(yaml_content));


            if isSetup:
                print("初始化自动图集完成");
            else:
                print("刷新自动图集完成");
            pass

        except Exception as err:
            errmsg (err);

        pass

    def onCheckSyntaxImpl(self,cmdexe="common\\luac\\luac.exe"):
        try:
            list = ['hall', 'base', 'game'];
            client_dir = self.lua_src_dir;

            if isMacOS():
                cmdexe = "luac";

            for name in list:
                src_dir = os.path.join(client_dir, name)
                print("Checking %s ..." % src_dir);
                all = os.walk(src_dir);

                for path, dir, filelist in all:
                    for filename in filelist:
                        if filename.endswith("lua"):
                            filepath = os.path.join(path, filename);
                            Commander().do("%s -p %s " % (cmdexe, filepath))

        except Exception as err:
            errmsg(err);
        finally:
            print("Check Done");
        pass

    def makeConfigsForDebug(self):

        # config_auto.lua
        print("make config_auto for local ...");
        path = os.path.join("base", "src", "com", "config_auto.lua");
        local_lua_src_dir = os.path.join(self.lua_src_dir, path);
        self._makeConfigAutoFile(local_lua_src_dir);

        # config_version.lua
        print("make config_version for local debug...");

        # config_version.lua
        self._makeConfigVersionFile(os.path.join(self.lua_src_dir, "base", "src", "com", "config_version.lua"));

        self.game_list  = gPMConfig.getAllGameList();
        self.publish_dir = os.path.join(self.lua_src_dir);

        ## game
        # self.makeHallGameMd5 (self.curGameHallName,True);

        ## base && hall
        # self.makeBaseAndHallMd5 (self.curGameHallName,True);

        # self.makeAllGamesConfig(os.path.join(self.publish_dir, "game"),True);

        print("all configs made OK");
        pass


    def makeConfigAuto(self,baseDir = None):
        try:

            if baseDir == None:
                baseDir = self.lua_src_dir;

            # config_auto.lua
            print ("make config_auto for local ...");
            path    = os.path.join("base","src","com","config_auto.lua");
            local_lua_src_dir = os.path.join(baseDir,path);
            self._makeConfigAutoFile(local_lua_src_dir);

            print("Make Base And Hall Configs-auto OK");

        except Exception as err:
            errmsg (err);

    def makeConfigVersion(self,baseDir = None):
        try:

            # config_version.lua
            print("make config_version ...");
            self._makeConfigVersionFile (os.path.join(baseDir, "base", "src","com","config_version.lua"));

            print ("Make Base And Hall Configs-version OK");

        except Exception as err:
            errmsg (err);

    def makeBaseAndHallConfigs(self,baseDir = None):
        try:
            self.makeConfigAuto (baseDir);
            self.makeConfigVersion (baseDir);
        except Exception as err:
            errmsg (err);

    def makeConfigs (self):
        # print ("Yes We have ...")
        try:
            self.makeBaseAndHallConfigs (self.lua_src_dir);

            print ("all configs made OK");

        except Exception as err:
            errmsg (err);

        pass

    def makeGameFileMd5ForHallName(self,hallName,game,isBit64):

        if not isBit64:
            '''
            32bit
            '''
            jsonFileName32 = "%s_32_filemd5.json" % (hallName)
            jsonFilePath = os.path.join(self.publish_dir, "game", game, jsonFileName32);
            b32_md5 = self._fileMd5(jsonFilePath);

            # print ("==> filepath %s ,md5_32 %s" % (jsonFilePath,b32_md5))

            return b32_md5;
        else:
            '''
            64bit
            '''
            jsonFileName32 = "%s_64_filemd5.json" % (hallName)
            jsonFilePath = os.path.join(self.publish_dir, "game", game, jsonFileName32);
            b64_md5 = self._fileMd5(jsonFilePath);

            # print("==> filepath %s ,md5_64 %s" % (jsonFilePath, b64_md5))

            return b64_md5;

    def makeHallGamesConfig(self,baseDir = None,hallName = "",isMakeAssets = False,isMakeGamesConfig = True):

        dict = self.dict;

        if not dict:
            return;

        games_info = dict['games_info'];
        if not games_info:
            return;

        platconfig = self.getPlatSettings();
        project_dir = platconfig.project_dir;  # 工程路径

        if not baseDir:
            baseDir = os.path.join(project_dir, "client", "game");
            pass

        if not os.path.exists(baseDir):
            os.makedirs(baseDir);

        hallinfo32 = {};
        hallinfo64 = {};
        hallinfo = {};

        for info in games_info:

            game = info['gname'];
            version = info['version'];
            hallnum = info['hallnum'];

            if game not in self.game_list:
                continue;

            if isMakeAssets == True:
                hallinfo[game] = {};
                hallinfo[game]['version'] = version;
                hallinfo[game]['minhall'] = str(hallnum);
                hallinfo[game]['md5info'] = "";
            else:
                '''
                32bit 
                '''
                md5str32 = self.makeGameFileMd5ForHallName(hallName, game, False);

                if md5str32 != "":
                    hallinfo32[game] = {};
                    hallinfo32[game]['version'] = version;
                    hallinfo32[game]['minhall'] = str(hallnum);
                    hallinfo32[game]['md5info'] = md5str32;

                '''
                64bit
                '''
                md5str64 = self.makeGameFileMd5ForHallName(hallName, game, True);
                if md5str64 != "":
                    hallinfo64[game] = {};
                    hallinfo64[game]['version'] = version;
                    hallinfo64[game]['minhall'] = str(hallnum);
                    hallinfo64[game]['md5info'] = md5str64;

                '''
                asserts_gamesVesion.json
                '''
                singleGameConfigPath = os.path.join(baseDir, game, "%s_version.lua" % (hallName));
                singlestr = '''
return {
    version = "%s";
    minhall = %s;
    md532 = '%s';
    md564 = '%s';
}                    
'''             % (version, hallnum, md5str32, md5str64);

                with open(singleGameConfigPath, "wb") as file:

                    content = convertToCRLF(bytearray(singlestr.encode('utf8')));
                    file.write(bytearray(content));

                    print("### 生成 Hall %s 游戏 %s 版本配置 ###" % (hallName, game));

        if isMakeGamesConfig == True:
            if isMakeAssets == True:
                filePath = os.path.join(baseDir, "gamesConfig.json");

                with open(filePath, "w+") as file:
                    file.write(JsonEncodeWithOrder(hallinfo));
                    file.close();
                    print("### 生成 Hall 游戏版本总配置 ###");

            else:
                '''
                32bit
                '''
                filePath = os.path.join(baseDir, "%s_32_gamesConfig.json" % (hallName));

                with open(filePath, "w+") as file:
                    file.write(JsonEncodeWithOrder(hallinfo32));
                    file.close();
                    print("### 生成 Hall %s 游戏版本总配置 ###" % (hallName));

                '''
                64bit
                '''
                filePath = os.path.join(baseDir, "%s_64_gamesConfig.json" % (hallName));

                with open(filePath, "w+") as file:
                    file.write(JsonEncodeWithOrder(hallinfo64));
                    file.close();
                    print("### 生成 Hall %s 游戏版本总配置 ###" % (hallName));

        pass

    '''
    make games config for all games 
    '''
    def makeAllGamesConfig(self,baseDir = None,isMakeAssets = False):

        hallList = gPMConfig.getHallList();
        for hallName in hallList:
            self.makeHallGamesConfig (baseDir,hallName,isMakeAssets);
        pass

    def getGameChangeList(self,game,logs,fromrev,torev):

        torev = int (torev);
        fromrev = int (fromrev);

        all_files = [];

        def isInList(all_files,filepath):
            for file in all_files:
                if file and file ["path"] == filepath:
                    return True;
            else:
                return False;
            pass

        for log in logs:
            rev = int (log [2]);      # rev
            if rev >= fromrev and rev <= torev:
                files = log [4];
                for file in files:
                    stat = file [0];

                    statTxt = "deleted";
                    if stat == "M":
                        statTxt = "modified"

                    filepath = file [1];

                    ## strip

                    gindex = filepath.find (game);
                    lastindex = 0;
                    if gindex < 0:
                        continue;

                    lastindex = gindex + len(game) + 1;
                    rfilepath = filepath [lastindex:];

                    if not isInList(all_files,rfilepath):
                        all_files.append({
                            "path" : rfilepath,
                            "item" : statTxt,
                            "kind" : "file",
                            "filepath" : filepath,
                        });
                    pass

                pass

        return all_files;

    def exportSubGameChanges(self,dict):
        pass


    def prepareGameSrcDir(self):
        pass


    def startPublishAll(self):

        dict = self.dict;

        platconfig = self.getPlatSettings();
        project_dir = platconfig.project_dir;  # 工程路径

        '''dest dir'''
        self.publish_dir = dict["project_dir"];
        self.whitelist_path = dict ["whitelist_path"];
        self.hotupdate_dir_root = dict ["hotupdate_dir_root"];

        if not os.path.exists(self.publish_dir):
            os.makedirs(self.publish_dir);


    def publishGame(self):
        try:
            print ("Publish Game....");

            dict                        = self.dict;

            '''dest dir'''
            self.game_list              = self.all_game_list;

            if not os.path.exists(self.publish_dir):
                os.makedirs(self.publish_dir);

            ## prepare publish
            self.preparePublishGameFiles(True);

            ## src
            self.cryptGameSrcFiles();

            ## res
            self.prepareResGameDir();
            self.simplifyResDir();
            self.cryptPublishGameFiles ();

            pass

        except Exception as err:
            errmsg(err);

    def publishBaseAndHall (self):
        print("Publish Base And Hall for debug...");

        # prepare
        self.purgePublishDir(os.path.join(self.publish_dir, "base"));
        self.purgePublishDir(os.path.join(self.publish_dir, "hall"));
        # self.removeOldProjectDir();
        # self.copyNewOldProjectDir();

        ## prepare publish
        # self.preparePublishFiles();
        self.preparePublishBaseFiles(True);
        self.preparePublishHallFiles(True);

        ## src
        # self.prepareSrcDir();
        # self.modifyUIFiles();
        self.makeConfigAuto();
        self.makeVersionFiles();
        # self.makeAutoConfigFile();
        # self.cryptSrcFiles();
        self.cryptBaseFiles();
        self.cryptHallFiles();

        ## res
        # self.prepareResDir();
        self.prepareBaseAndHallResDir ();
        self.simplifyResDir();
        self.cryptResFiles("base");
        self.cryptResFiles("hall");

        pass

    def figureoutChangedInfo(self):


        svnldr = SvnUploader();
        svnldr.setRepRoot(self.publish_dir);
        svnldr.fetchChanges();
        svnldr.setDelayConfigFile(os.path.join(self.publish_dir,"delaysubmit.json"));
        changeslist = svnldr.fetchDevChange();

        hasBaseAndHallChanged = False;
        gamesChangedArr = [];

        # print ("##### Changed Files: ");
        for key in range(len(changeslist)):
            info = changeslist [key];

            file = info ["file"];

            if file.find("base/") == 0:
                hasBaseAndHallChanged = True;

            i = file.find("game/");
            if i == 0:
                glen = len("game/");
                j = file.find("/",glen);
                gameName = file [glen:j];
                gamesChangedArr.append(gameName);
            pass
        pass

        dict = {};
        dict ['gamesChangedArr'] = gamesChangedArr;
        dict ['hasBaseAndHallChanged']  = hasBaseAndHallChanged;
        dict ['changelist'] = changeslist;
        dict ['hallNum'] = self.curChConfig.hallnum;

        return dict;

    def doLastThing(self,update_version_trigger,hallNum):

        if not hallNum:
            hallNum = self.curChConfig.hallnum;

        '''write back '''
        self.curChConfig.hallnum = hallNum;

        filename = "config_version.lua";
        self._makeConfigVersionFile(os.path.join(self.lua_src_dir, "base", "src", "com", filename));

        real_dst_dir    = os.path.join(self.publish_dir, "base", "src", "com", filename);
        real_dst_dir64  = os.path.join(self.publish_dir, "base", "src64", "com", filename);

        tmp_dir = os.path.join(self.publish_dir, "base", "config_version_tmp");
        src_dir = os.path.join(tmp_dir,"src");
        dst_dir = os.path.join(tmp_dir,"src_crypt");

        if not os.path.exists(src_dir):
            os.makedirs(src_dir);

        self._makeConfigVersionFile(os.path.join(src_dir,filename));

        self.cryprSingleLuaFileDir("config_version", src_dir, dst_dir);

        self.renameLuacToLua(os.path.join(tmp_dir));

        ### overwrite config_version
        shutil.copyfile(os.path.join(src_dir,filename),real_dst_dir);
        shutil.copyfile(os.path.join(src_dir + "64",filename),real_dst_dir64);

        ### remove old files
        if os.path.exists(tmp_dir):
            shutil.rmtree(tmp_dir,ignore_errors=True)

        ## md5files for base and hall
        self.makeAllHallsBaseHallMd5 ();

        ## md5files subgames
        self.makeAllHallsGameMd5();

        dict = self.dict;
        if not dict:
            dict = {};
            dict ["games_info"] = {};

        games_info = dict['games_info'];
        if not games_info:
            return;

        ## make configs
        dict ["main"] = {};
        dict ["main"] ["hallnum"] = str(hallNum);

        self.dict = dict;

        if update_version_trigger:
            update_version_trigger.emit (dict);

        self.makeAllGamesConfig (os.path.join(self.publish_dir,"game"));

        ## make source configs
        self.makeAllGamesConfig(os.path.join(self.lua_src_dir, "game"), True);

        ## make whitelist.json
        self.makeWhiteList ();

        pass

    def doFinalThing1(self,update_version_trigger):

        try:

            delaySumitFiles = [];
            renameFileLists = [];

            delaySumitFiles.append("delaysubmit.json");

            hallList = gPMConfig.getHallList();
            for hallName in hallList:
                path = os.path.join(self.publish_dir,"hall","{}_version.lua".format(hallName));
                # print ("Hall version Path => %s" % path);

                path = path.replace("\\", "/");
                delaySumitFiles.append(path);

                gamedir = os.path.join(self.publish_dir, "game");

                gamesConfig32 = os.path.join(gamedir, "{}_{}_gamesConfig.json".format(hallName, "32"));
                gamesConfig32 = gamesConfig32.replace("\\", "/");
                delaySumitFiles.append(gamesConfig32);

                gamesConfig64 = os.path.join(gamedir, "{}_{}_gamesConfig.json".format(hallName, "64"));
                gamesConfig64 = gamesConfig64.replace("\\", "/");
                delaySumitFiles.append(gamesConfig64);

                '''
                games
                '''
                list = self.game_list;
                for i in range(len(list)):
                    gname = list[i];
                    if self.isInGameList(gname):
                        gpath = os.path.join(self.publish_dir,"game",gname,"{}_version.lua".format(hallName));
                        # print ("HallGame %s ,Game %s => %s" % (hallName,gname, gpath));
                        gpath = gpath.replace("\\", "/");
                        delaySumitFiles.append(gpath);
                    pass
                pass
            pass

            all = os.walk(self.publish_dir);

            for path, dir, filelist in all:
                for filename in filelist:
                    native_filepath = os.path.join(path,filename);
                    filepath = native_filepath.replace("\\", "/");
                    # print(filepath);

                    if ".svn" in filepath:
                        continue;

                    if ".DS_Store" in filepath:
                        continue;

                    if "netverify_" in filepath:
                        continue;

                    '''
                    已经打过md5
                    '''
                    file = os.path.splitext(filepath);
                    if len(file[1]) > 20:
                        continue;
                        
                    isIn = False;
                    for dfilepath in delaySumitFiles:
                        if dfilepath == filepath:
                            isIn = True;
                            break;

                    if not isIn:
                        renameFileLists.append(filepath);

                    pass

            remain_old_file = True;

            '''
            重新命名成后缀md5文件
            '''
            print("最后的步骤，稍等 1-2分钟...")

            print("删除旧CDN验证文件...")
            dirs = os.listdir(self.publish_dir);
            for dir in dirs:
                if dir.find("netverify_") >= 0:
                    os.remove(os.path.join(self.publish_dir, dir));
                pass

            print("正在生成md5文件...")
            for filepath in renameFileLists:
                # print("发布文件 %s " % filepath);
                file_md5 = self._fileMd5(filepath);
                new_native_filepath = filepath + "." + file_md5;
                if os.path.exists(filepath) and not os.path.exists(new_native_filepath):
                    if remain_old_file:
                        shutil.copyfile(filepath,new_native_filepath)
                    else:
                        os.rename(filepath, new_native_filepath);

            print("删除旧delaySubmit文件...")
            dirs = os.listdir(self.publish_dir);
            for dir in dirs:
                if dir.find("delaysubmit") >= 0:
                    os.remove(os.path.join(self.publish_dir,dir));
                pass

            '''
            生成delaySubmit.txt文件
            '''
            print("生成延迟提交文件...")
            pub_len = len(self.publish_dir) + 1;
            delayJsonArr = [];
            for filepath in delaySumitFiles:
                sub_path = filepath[pub_len:];
                delayJsonArr.append(sub_path);

            delayConfigPath = os.path.join(self.publish_dir,"delaysubmit.json");
            with open (delayConfigPath,"w+") as f:
                f.write(json.dumps(delayJsonArr));

            print("生成延迟提交文件完成")

        except Exception as err:
            errmsg(err);
        pass

    def makeWhiteList(self):
        # self.whitelist_path
        # if os.path.exists(self.whitelist_path):
        print ("创建 whitelist 文件...")
        with open (self.whitelist_path,"w+") as file:
            file.write(gWhiteList.convertToJson());

        pass

    def syncGameInfo(self):
        pass

    def proceedSrcAndRes(self):

        if isMacOS():
            print ("Need Remove src32 bit src and res Directory for iOS ......");

            dirname = ['base','game','hall'];
            for k in range(len(dirname)):
                name = dirname[k];
                src_dir = os.path.join(self.publish_dir,name,'src');
                if os.path.exists(src_dir):
                    shutil.rmtree(src_dir,ignore_errors=True);
            pass

        pass

    def makeAssets(self):

        if not isMacOS():
            print ("自动同步到最新时间...");
            Commander ().do('''w32tm /config /manualpeerlist:"210.72.145.44" /syncfromflags:manual /reliable:yes /update''');

        print("make assets for debug...");
        self.makeConfigs();

        # prepare
        self.purgePublishDir();
        # self.removeOldProjectDir();
        # self.copyNewOldProjectDir();

        ## prepare publish
        self.preparePublishFiles();

        ## src
        self.prepareSrcDir();
        self.modifyUIFiles();
        self.makeVersionFiles();
        # self.makeAutoConfigFile();
        self.cryptSrcFiles();

        ## res
        self.prepareResDir();
        self.simplifyResDir();
        self.cryptResFiles();

        ## md5files
        self.makeMd5file ();

        ## proceed with src and res
        self.proceedSrcAndRes ();

        ## pack
        self.zipAllFile();
        if not self.use_no_crypt_zip:
            self.cryptZipFile();

        rmsgbox("Make Assets OK");

        pass

    def makeAutoConfigFile(self):
        self._makeConfigAutoFile(None);
        pass

    def purgePublishDir(self,purged_dir = None):

        if not purged_dir:
            purged_dir = self.publish_dir;

        print("purgePublishDir : " + purged_dir);

        try:
            if os.path.exists(purged_dir):
                shutil.rmtree(purged_dir, ignore_errors=True);
        except Exception as err:
            errmsg(err);

        try:
            # os.makedirs(path);
            if not os.path.exists(purged_dir):
                os.makedirs(purged_dir);
        except Exception as err:
            errmsg(err);

        pass

    def removeOldProjectDir(self):
        path = self.dst_project_dir
        print("removeOldProjectDir : " + path);

        try:
            shutil.rmtree(path, ignore_errors=True);

            pass
        except Exception as err:
            errmsg(err);

        pass

    def copyNewOldProjectDir(self):
        try:
            print("copyNewOldProjectDir ");
            src = self.src_project_dir;
            dst = self.dst_project_dir;
            print("Copy " + src);
            print("To " + dst);
            if isMacOS():
                shutil.copytree(src,dst,symlinks=True,dirs_exist_ok=True)
            else:
                recursive_overwrite (src,dst);

        except Exception as err:
            errmsg(err);

        pass


    def preparePublishBaseFiles(self,isPublish = False):

        try:
            src = self.lua_src_dir;
            dst = self.publish_dir;
            print("Copy base src dir...");
            if isPublish:
                recursive_overwrite(os.path.join(src, "base"), os.path.join(dst, "base"),ignore=shutil.ignore_patterns('.svn', '.DS_Store','config.lua','config_auto.lua'),src_root=self.lua_src_dir);
            else:
                recursive_overwrite(os.path.join(src, "base"), os.path.join(dst, "base"),ignore=shutil.ignore_patterns('.svn', '.DS_Store'),src_root=self.lua_src_dir);
        except Exception as err:
            errmsg(err);

    def preparePublishHallFiles(self,isPublish = False):

        try:
            src = self.lua_src_dir;
            dst = self.publish_dir;
            print("Copy hall src dir...");
            if isPublish:
                recursive_overwrite(os.path.join(src, "hall"), os.path.join(dst, "hall"),ignore=shutil.ignore_patterns('.svn', '.DS_Store','config.lua','config_auto.lua'),src_root=self.lua_src_dir);
            else:
                recursive_overwrite(os.path.join(src, "hall"), os.path.join(dst, "hall"),ignore=shutil.ignore_patterns('.svn', '.DS_Store'),src_root=self.lua_src_dir);
        except Exception as err:
            errmsg(err);


    def cryptPublishGameFiles(self):

        try:
            dst = self.publish_dir;
            print("Copy game src dir...");
            list = self.game_list;
            for i in range(len(list)):
                gname = list[i];
                if self.isInGameList(gname):
                    self.cryptResFiles(os.path.join("game", gname));
                pass
            pass

        except Exception as err:
            errmsg(err);


    def preparePublishGameFiles(self,isPublish = False):

        try:
            src = self.lua_src_dir;
            dst = self.publish_dir;
            print("Copy game src dir...");
            list = self.game_list;
            for i in range(len(list)):
                gname = list[i];
                if self.isInGameList(gname):

                    game_src_dir = os.path.join(src, "game", gname);
                    game_dst_dir = os.path.join(dst, "game", gname);
                    '''
                    purge game dir first 
                    '''
                    self.purgePublishDir (game_dst_dir);

                    print("Copy game " + gname);
                    if isPublish:
                        recursive_overwrite(game_src_dir,game_dst_dir,ignore=shutil.ignore_patterns('.svn', '.DS_Store',"filemd5.json","config.lua","config_auto.lua"),src_root=self.lua_src_dir);
                    else:
                        recursive_overwrite(game_src_dir,game_dst_dir,ignore=shutil.ignore_patterns('.svn', '.DS_Store'),src_root=self.lua_src_dir);
                pass
            pass

        except Exception as err:
            errmsg(err);

    def preparePublishFiles(self):
        try:
            print("preparePublishFiles ...");

            self.preparePublishBaseFiles ();
            self.preparePublishHallFiles ();
            self.preparePublishGameFiles ();

        except Exception as err:
            errmsg(err);

        pass

    def modifyHashResource(self):
        try:
            print("modifyHashResource  ... ");
            all = os.walk(self.dst_project_dir);

            for path, dir, filelist in all:
                for filename in filelist:
                    if filename.endswith("png") or filename.endswith("png"):
                        filepath = os.path.join(path, filename);
                        # print ("modifyHash " + filename);
                        self._modifyHashRes(filepath);

        except Exception as err:
            errmsg(err);

        pass

    def _removeUnusedSrcDir(self,dir_path):
        try:
            pass
        except Exception as err:
            errmsg(err);

    def prepareSrcDir(self):
        try:
            print("prepareSrcDir ...");

            gameData = self.luaHallConfig;
            styleName = gameData.style;

            print ("Current Style %s " % (styleName));

            ''''
            proceed base
            '''
            print ("Proceed Base ...");
            baseDir = os.path.join(self.publish_dir,"base","src","app","style");
            if os.path.exists(baseDir):
                for dir in os.listdir(baseDir):
                    if dir != styleName:
                        print ("Remove Style %s.src" % (dir));
                        style_path = os.path.join(baseDir, dir);
                        if os.path.exists(style_path):
                            shutil.rmtree(style_path, ignore_errors=True);

            baseDir = os.path.join(self.publish_dir,"base","res","style");
            if os.path.exists(baseDir):
                for dir in os.listdir(baseDir):
                    if dir != styleName:
                        print ("Remove Style %s.res" % (dir));
                        style_path = os.path.join(baseDir, dir);
                        if os.path.exists(style_path):
                            shutil.rmtree(style_path, ignore_errors=True);

            '''
            proceed hall 
            '''
            hallDir = os.path.join(self.publish_dir,"hall","src","type");
            if os.path.exists(hallDir):
                for dir in os.listdir(hallDir):
                    if dir != self.curGameHallName:
                        print ("Remove type %s.src" % (dir));
                        style_path = os.path.join(hallDir, dir);
                        if os.path.exists(style_path):
                            shutil.rmtree(style_path, ignore_errors=True);

            hallDir = os.path.join(self.publish_dir,"hall","res","type");
            if os.path.exists(hallDir):
                for dir in os.listdir(hallDir):
                    if dir != self.curGameHallName:
                        print ("Remove type %s.res" % (dir));
                        style_path = os.path.join(hallDir, dir);
                        if os.path.exists(style_path):
                            shutil.rmtree(style_path, ignore_errors=True);

            '''
            proceed game
            '''

            # hallConfig =

            """
            load lua config
            """
            hallName = self.curGameHallName;
            hallConfigPath = os.path.join(self.lua_src_dir,"hall","src","type",hallName,"config","HallGameConfig.lua")
            try:
                file = open(hallConfigPath, encoding='utf-8');
                content = file.read();
                hallConfig = lua.execute(content);

            except Exception as err:
                errmsg(err);
                return ;

            for name in self.game_list:
                subgameDir = os.path.join(self.publish_dir,"game",name);

                if not hallConfig [name]:
                    errmsg("==> No hallConfig [%s]" % name);
                    continue;

                cmm_style = hallConfig [name] ["cmm_style"];

                '''
                proceed game style
                '''

                '''
                src style
                '''
                gameDir = os.path.join(self.publish_dir, "game", name,"src", "style");
                if os.path.exists(gameDir):
                    for dir in os.listdir(gameDir):
                        if dir != styleName:
                            print("Remove style %s.src" % (dir));
                            style_path = os.path.join(gameDir, dir);
                            if os.path.exists(style_path):
                                shutil.rmtree(style_path, ignore_errors=True);

                '''
                src cmm
                '''
                src_cmm_dir = os.path.join(subgameDir,"src","cmm");

                if os.path.exists(src_cmm_dir):
                    for dir in os.listdir(src_cmm_dir):
                        if dir != cmm_style:
                            print("Remove src/cmm %s" % (dir));
                            style_path = os.path.join(src_cmm_dir, dir);
                            if os.path.exists(style_path):
                                shutil.rmtree(style_path, ignore_errors=True);

                '''
                res style 
                '''
                gameDir = os.path.join(self.publish_dir, "game", name,"res", "style");
                if os.path.exists(gameDir):
                    for dir in os.listdir(gameDir):
                        if dir != styleName:
                            print("Remove style %s.res" % (dir));
                            style_path = os.path.join(gameDir, dir);
                            if os.path.exists(style_path):
                                shutil.rmtree(style_path, ignore_errors=True);

                '''
                res cmm 
                '''
                res_cmm_path = os.path.join(subgameDir,"res","cmm");
                if os.path.exists(res_cmm_path):
                    for dir in os.listdir(res_cmm_path):
                        if dir != cmm_style:
                            print("Remove res/cmm %s" % (dir));
                            style_path = os.path.join(res_cmm_path, dir);
                            if os.path.exists(style_path):
                                shutil.rmtree(style_path, ignore_errors=True);

            pass
        except Exception as err:
            errmsg(err);

        """
        additional remove for game src / src_xxx 
        """
        try :
            dir_path = os.path.join(self.publish_dir,"game");
            if os.path.exists(dir_path):
                dirs = os.listdir(dir_path);
                for dir in dirs:
                    src_path = os.path.join(dir_path,dir);
                    self._removeUnusedSrcDir (src_path);
                pass
        except Exception as err:
            errmsg(err);

        """
        additional remove for hall src / src_xxx 
        """
        try :
            dir_path = os.path.join(self.publish_dir,"hall");
            if os.path.exists(dir_path):
                self._removeUnusedSrcDir (dir_path);
                pass
        except Exception as err:
            errmsg(err);

        pass

    def copyExtralResource(self):
        pass

    def prepareNativeResouce(self):
        pass

    def prepreSrcDir(self):
        pass

    def modifyUIFiles(self):
        pass

    def renameLuacToLua(self,dst_dir):
        all = os.walk(dst_dir);
        for path, dir, filelist in all:
            for filename in filelist:
                if filename.endswith("luac"):
                    luac = os.path.join(path, filename);
                    filen,fileext = os.path.splitext (filename);
                    luaPath = os.path.join(path,filen + '.lua');
                    os.rename(luac,luaPath);
        pass

    def saveLuacCache(self,src_dir,dst_dir,dst_dir64):

        cache_dir64 = os.path.join(getCacheDir(), "luac","64b");
        cache_dir32 = os.path.join(getCacheDir(), "luac","32b");

        if not os.path.exists(cache_dir32):
            os.makedirs(cache_dir32);

        if not os.path.exists(cache_dir64):
            os.makedirs(cache_dir64);

        all = os.walk(src_dir);
        for path, dir, filelist in all:
            for filename in filelist:
                if filename.endswith("lua"):

                    luac_filename = filename.replace(".lua",".luac");

                    lua_src_file_path = os.path.join(path, filename);
                    luac_src_file_path = lua_src_file_path.replace(".lua",".luac")

                    dst_file_path32 = luac_src_file_path.replace(src_dir,dst_dir);
                    dst_file_path64 = luac_src_file_path.replace(src_dir,dst_dir64);

                    if not os.path.exists(dst_file_path32) or not os.path.exists(dst_file_path64):
                        continue;

                    # print ("Need Save Path ===========>");

                    filemd5 = self._fileMd5(lua_src_file_path);
                    '''
                    cache32
                    '''
                    if not os.path.exists(os.path.join(cache_dir32, filemd5)):
                        # print ("%s => %s (32bit) " %(lua_src_file_path,filemd5));
                        shutil.copy(dst_file_path32, cache_dir32);
                        shutil.move(os.path.join(cache_dir32, luac_filename), os.path.join(cache_dir32, filemd5));

                    '''
                    cache64
                    '''
                    if not os.path.exists(os.path.join(cache_dir64, filemd5)):
                        # print ("%s => %s (64bit) " %(lua_src_file_path,filemd5));
                        shutil.copy(dst_file_path64, cache_dir64);
                        shutil.move(os.path.join(cache_dir64, luac_filename), os.path.join(cache_dir64, filemd5));

                    # pass
                pass
            pass
        pass

    def proceedLuaWithLuacCache(self,src_dir,dst_dir,dst_dir64):

        cache_dir64 = os.path.join(getCacheDir(), "luac","64b");
        cache_dir32 = os.path.join(getCacheDir(), "luac","32b");

        if not os.path.exists(cache_dir32):
            os.makedirs(cache_dir32);

        if not os.path.exists(cache_dir64):
            os.makedirs(cache_dir64);

        all = os.walk(src_dir);
        for path, dir, filelist in all:
            for filename in filelist:
                if filename.endswith("lua"):
                    filepath = os.path.join(path, filename);
                    filemd5 = self._fileMd5(filepath);

                    if os.path.exists(os.path.join(cache_dir32, filemd5)) and os.path.exists(os.path.join(cache_dir64, filemd5)):   ## lua has cache
                        '''
                        remove src_dir file
                        '''
                        if os.path.exists(filepath):
                            os.remove(filepath)

                        '''
                        copy md5file to dst_dir
                        '''

                        dest_file_path = filepath.replace(src_dir,dst_dir);
                        dest_file_path = dest_file_path.replace(".lua",".luac");

                        dest_lua32_path = dest_file_path;

                        dirn,filen = os.path.split(dest_lua32_path);
                        if not os.path.exists(dirn):
                            os.makedirs(dirn);
                        shutil.copy(os.path.join(cache_dir32, filemd5), dest_lua32_path)

                        dest_lua64_path = dest_file_path.replace(dst_dir, dst_dir64);
                        dirn, filen = os.path.split(dest_lua64_path);
                        if not os.path.exists(dirn):
                            os.makedirs(dirn);

                        shutil.copy(os.path.join(cache_dir64, filemd5),dest_lua64_path)

                        print ("use LuacCache %s" % (dest_file_path));
                    pass
                pass
            pass

        print ("Cache ALl Done");

        pass

    def cryprSingleLuaFileDir ( self,
                                    desc = "",
                                    src_dir = None,
                                    dst_dir = None,
                                    key = "cynkingbest!!!",
                                    bname = "zhijianwangluo"
                                    ):

        print("Compiling %s ... " % (desc));

        if not src_dir:
            errmsg("No src_dir");
            return ;

        if not dst_dir:
            errmsg("No dst_dir");
            return ;

        dst_dir64 = src_dir + "64";

        if not os.path.exists(src_dir):
            return ;

        if self.use_debug:

            """
            win32 debug use the 32bit however android may not 
            so need to copy src to src64 
            """
            recursive_overwrite (src_dir,dst_dir64);

            pass
        else:
            '''
            32bit 
            '''
            print("Compiling %s to 32bit ... " % (desc));

            self.proceedLuaWithLuacCache (src_dir,dst_dir,dst_dir64);
            cmdstr = 'cocos luacompile --use-v2103 -s %s -d %s -e -k %s -b %s' % (src_dir, dst_dir, key, bname);
            Commander().do(cmdstr);

            '''
            64bit
            '''
            print("Compiling %s to 64bit ... " % (desc));
            cmdstr = 'cocos luacompile --use-v2103 --use-arm64 -s %s -d %s -e -k %s -b %s' % (src_dir, dst_dir64, key, bname);
            Commander().do(cmdstr);

            ''''
            save the luac cache 
            '''
            self.saveLuacCache (src_dir,dst_dir,dst_dir64);

            pass

        # remove oldname
        if os.path.exists(src_dir) and os.path.exists(dst_dir):
            shutil.rmtree(src_dir,ignore_errors=True);
            shutil.move(dst_dir, src_dir);
        pass

    def cryptHallFiles(self):
        try:
            print ("cryptHallFiles ...");

            src_dir = os.path.join(self.publish_dir,"hall","src");
            dst_dir = os.path.join(self.publish_dir,"hall","src_crypt");

            self.cryprSingleLuaFileDir("hall", src_dir,dst_dir);
            self.renameLuacToLua(os.path.join(self.publish_dir,"hall"));

        except Exception as err:
            errmsg(err);

    def cryptBaseFiles(self):
        try:
            print ("cryptBaseFiles ...");

            src_dir = os.path.join(self.publish_dir,"base","src");
            dst_dir = os.path.join(self.publish_dir,"base","src_crypt");

            self.cryprSingleLuaFileDir("base",src_dir,dst_dir);
            self.renameLuacToLua(os.path.join(self.publish_dir,"base"));

        except Exception as err:
            errmsg(err);

    def cryptGameSrcFiles(self,publish_dir = None):
        try:
            print ("cryptGameSrcFiles ...");

            if not publish_dir:
                publish_dir = self.publish_dir;

            # games
            for name in self.game_list:

                src_dir = os.path.join(publish_dir, "game", name,"src");
                dst_dir = os.path.join(publish_dir, "game", name,"src_crypt");

                self.cryprSingleLuaFileDir("game." + name,src_dir,dst_dir);

            self.renameLuacToLua(os.path.join(publish_dir,"game"));

        except Exception as err:
            errmsg(err);


    def cryptSrcFiles(self):
        self.cryptBaseFiles();
        self.cryptHallFiles ();
        self.cryptGameSrcFiles ();
        pass

    def _cryptZipFile(self, precmd='chmod +x common/DeEncFile/DeEncFile ; '):
        try:
            print("cryptZipFile ... ");

            basedir = os.path.join(self.publish_dir, "base");
            respath = os.path.join(basedir, "res");

            list = ["hall", "game"];
            for name in list:
                print("crypt %s zip ..." % name);
                zippath = os.path.join(respath, name + ".zip");
                cmdexe = os.path.join("common", "DeEncFile", "DeEncFile");
                cmd = "%s %s enc %s 123456 " % (precmd, cmdexe, zippath);
                Commander().do(cmd);

        except Exception as err:
            errmsg(err);

        pass

    def isInRawResList(self, filename):
        return gFilterList.isInRawList(filename);

    def isInRGBA888List(self, filename):
        return gFilterList.isInRGBA888List(filename);

    def _pngquantResFile(self, filepath, redirect):
        try:
            cmd = os.path.join(".", "common", "pngquant", "pngquant");
            precmd = "chmod +x %s ; " % cmd;

            if isWin():
                precmd = "";

            cache_dir = os.path.join(getCacheDir(), "pqt");

            if not os.path.exists(cache_dir) or not os.path.isdir(cache_dir):
                if os.path.exists(cache_dir):
                    os.remove(cache_dir);
                os.makedirs(cache_dir);

            fileMd5 = self._fileMd5(filepath);
            dir, filename = os.path.split (filepath);

            if "shouzhi0.png" in filepath:
                print ("FUCK YOU MAN")

            """
            turbo boost up !!
            """
            bmd5filepath = os.path.join(cache_dir, fileMd5);
            if os.path.exists(bmd5filepath):

                print("compress raw pngfiles %s with pngquant(Cached)" % (filename));
                if os.path.exists(filepath):
                    os.remove(filepath);
                shutil.copy(bmd5filepath, filepath);

            else:
                print("compress raw pngfiles %s with pngquant" % (filename));
                cmdstr = '''%s %s -f --ext .png --speed 1 --skip-if-larger %s ''' % (precmd, cmd, filepath);
                Commander().do(cmdstr);

                shutil.copy(filepath, cache_dir);
                shutil.move(os.path.join(cache_dir, filename), bmd5filepath);

        except Exception as err:
            errmsg(err);

    def _pvrResFiles(self, redirect="1>/dev/null 2>/dev/null"):

        try:

            low_cache_dir = os.path.join(getCacheDir(), "pvr","low");
            high_cache_dir = os.path.join(getCacheDir(), "pvr","high");
            use_rgba = "RGBA4444";
            if self.use_rgba8888:
                use_rgba = "RGBA8888";

            key = gLuaPM.config ().pvr_key ;

            if not os.path.exists(low_cache_dir):
                os.makedirs(low_cache_dir);

            if not os.path.exists(high_cache_dir):
                os.makedirs(high_cache_dir);

            all = os.walk(self.publish_dir);
            for path, dir, filelist in all:
                for filename in filelist:
                    if filename.endswith("png"):

                        if self.isInRawResList(filename):
                            if self.use_pngquant and not self.isInRGBA888List(filename):
                                self._pngquantResFile(os.path.join(path, filename), redirect);
                            else:
                                print("no need to compress,need raw png res %s (rawPNG)" % filename);
                            continue;

                        if self.isInRGBA888List(filename):
                            use_rgba = "RGBA8888";

                        filen, fileext = os.path.splitext(filename);
                        filepath = os.path.join(path, filename);
                        fileMd5 = self._fileMd5(filepath);

                        cache_dir = "";
                        if use_rgba == "RGBA8888":
                            cache_dir = high_cache_dir;
                        else:
                            cache_dir = low_cache_dir;

                        """
                        turbo boost up !!
                        """
                        bmd5filepath = os.path.join(cache_dir, fileMd5);
                        if os.path.exists(bmd5filepath):
                            """
                            already pvrcczed 
                            """
                            print("compress and crypt pngres %s to pvr.ccz(%s,Cached)..." % (filename, use_rgba));
                            if os.path.exists(filepath):
                                os.remove(filepath);
                            shutil.copy(bmd5filepath, filepath);

                        else:
                            png_filename = filename;
                            pvr_filename = filen + ".pvr.ccz"
                            pvr_full_path = os.path.join(path, pvr_filename);

                            print("compress and crypt pngres %s to pvr.ccz(%s)..." % (filename, use_rgba));
                            cmdstr = (
                                        'TexturePacker %s '
                                        '--format cocos2d '
                                        '--sheet %s %s '
                                        '--opt %s '
                                        '--dither-fs-alpha '
                                        '--disable-rotation '
                                        '--content-protection %s '
                                        '--size-constraints AnySize'
                                        '--no-trim '
                                        '--padding 0 %s'
                                      % (
                                            filepath,
                                            pvr_full_path,
                                            filepath,
                                            use_rgba,
                                            key,
                                            redirect
                                        )
                                    )

                            Commander().do(cmdstr);

                            if os.path.exists(pvr_full_path):
                                if os.path.exists(filepath):
                                    os.remove(filepath);
                                shutil.move(pvr_full_path, filepath);
                                shutil.copy(filepath, cache_dir);
                                shutil.move(os.path.join(cache_dir, filename), bmd5filepath);
                            pass

                        pass
                    pass
                pass
            pass

        except Exception as err:
            errmsg(err);
        finally:
            if os.path.exists("out.plist"):
                os.remove("out.plist");

    def _etc2ResFiles(self, cwd=None, redirect="1>/dev/null 2>/dev/null", precmd="chmod +x etcpack ; "):
        try:
            cache_dir = os.path.join(getCacheDir(), "etc2");

            if not os.path.exists(cache_dir) or not os.path.isdir(cache_dir):
                if os.path.exists(cache_dir):
                    os.remove(cache_dir);
                os.makedirs(cache_dir);

            all = os.walk(self.publish_dir);
            for path, dir, filelist in all:
                for filename in filelist:
                    if filename.endswith("png"):
                        if self.isInRawResList(filename) or self.isInRGBA888List(filename):
                            # if self.use_pngquant and not self.isInRGBA888List(filename):
                            #     print("compress raw pngfiles %s with pngquant" % (filename));
                            #     self._pngquantResFile(os.path.join(path, filename), redirect);
                            # else:
                            #     pass
                            print("no need to compress,need raw png res %s (rawPNG)" % filename);
                            continue;

                        filepath = os.path.join(path, filename);
                        fileMd5 = self._fileMd5(filepath);

                        """
                        turbo boost up !!
                        """
                        bmd5filepath = os.path.join(cache_dir, fileMd5);
                        if os.path.exists(bmd5filepath):
                            """
                            already converted 
                            """
                            print("compress pngres %s to etc2(Cached)..." % filename);
                            if os.path.exists(filepath):
                                os.remove(filepath);
                            shutil.copy(bmd5filepath, filepath);

                        else:

                            ## trick , use ./xxx to execute etcpack for that etcpack cwd must locate at the executable file dir
                            print("compress pngres %s to etc2..." % filename);
                            cmdstr = ('''%s %s %s %s -c etc2 -s fast -f RGBA8 -ext PNG %s''' % (
                                precmd, os.path.join(".", "etcpack"), filepath, path, redirect));

                            my_env = os.environ.copy();
                            etc_path = os.path.abspath(os.path.join(os.path.curdir,"common","etc2"));
                            my_env["PATH"] = etc_path + ":" + my_env["PATH"]

                            Commander().do(cmdstr, cwd,env=my_env);
                            # print ("Done");
                            pkmfilepath = filepath.replace(".png", ".pkm");
                            if os.path.exists(pkmfilepath):
                                os.remove(filepath);
                                shutil.move(pkmfilepath, filepath);
                                ## back up with etc2cache
                                shutil.copy(filepath, cache_dir);
                                shutil.move(os.path.join(cache_dir, filename), bmd5filepath);


        except Exception as err:
            errmsg(err);
        pass

    def _astcencResFilesImpl(self):
        try:
            cache_dir = os.path.join(getCacheDir(), "astc");

            if not os.path.exists(cache_dir) or not os.path.isdir(cache_dir):
                if os.path.exists(cache_dir):
                    os.remove(cache_dir);
                os.makedirs(cache_dir);

            if isMacOS():
                precmd = "chmod +x ./mac/astcenc-avx2 ; ";
                redirect = "1>/dev/null 2>/dev/null";
                # redirect = "";
            else:
                precmd = "";
                redirect = "> out.log";
                # redirect = "";

            all = os.walk(self.publish_dir);
            for path, dir, filelist in all:
                for filename in filelist:
                    if filename.endswith("png"):
                        # if self.isInRawResList(filename) or self.isInRGBA888List(filename):
                        #     # if self.use_pngquant and not self.isInRGBA888List(filename):
                        #     #     print("compress raw pngfiles %s with pngquant" % (filename));
                        #     #     self._pngquantResFile(os.path.join(path, filename), redirect);
                        #     # else:
                        #     #     pass
                        #     print("no need to compress,need raw png res %s (rawPNG)" % filename);
                        #     continue;

                        filepath = os.path.join(path, filename);
                        fileMd5 = self._fileMd5(filepath);

                        """
                        turbo boost up !!
                        """
                        bmd5filepath = os.path.join(cache_dir, fileMd5);
                        if os.path.exists(bmd5filepath):
                            """
                            already converted 
                            """
                            print("compress pngres %s to astc(Cached)..." % filename);
                            if os.path.exists(filepath):
                                os.remove(filepath);
                            shutil.copy(bmd5filepath, filepath);

                        else:

                            ## trick , use ./xxx to execute etcpack for that etcpack cwd must locate at the executable file dir
                            print("compress pngres %s to astc." % filename);
                            astcfilepath = filepath.replace(".png", ".astc");

                            cmdstr = ('''%s %s -cl %s %s 5x5 -medium %s''' % (precmd, os.path.join(".", "mac","astcenc-avx2"), filepath,astcfilepath,redirect));

                            my_env = os.environ.copy();
                            astc_path = os.path.abspath(os.path.join(os.path.curdir,"common","astcenc"));
                            my_env["PATH"] = astc_path + ":" + my_env["PATH"]

                            Commander().do(cmdstr, astc_path,env=my_env);
                            # print ("Done");
                            if os.path.exists(astcfilepath):
                                os.remove(filepath);
                                shutil.move(astcfilepath, filepath);
                                ## back up with etc2cache
                                shutil.copy(filepath, cache_dir);
                                shutil.move(os.path.join(cache_dir, filename), bmd5filepath);


        except Exception as err:
            errmsg(err);
        finally:
            if os.path.exists("out.log"):
                os.remove("out.log");

            pass
        pass


    def _astcencResFiles(self,dirpath):
        self._astcencResFilesImpl();

    def _pngquantPathResFiles(self,dirpath):
        try:
            all = os.walk(os.path.join(self.publish_dir,dirpath));
            for path, dir, filelist in all:
                for filename in filelist:
                    if filename.endswith("png"):

                        """
                        if in raw files list , do nothing 
                        """
                        if gFilterList.isInRawList(filename):
                            continue;

                        filepath = os.path.join(path,filename);
                        self._pngquantResFile(filepath,"");
                        pass

        except Exception as err:
            errmsg(err);
        finally:
            if os.path.exists("out.plist"):
                os.remove("out.plist");

    def _pngquantResFiles(self,dirpath):
        self._pngquantPathResFiles (dirpath);


    def makeBaseAndHallMd5(self,hallName,isMakeAssets = False):

        print ("Make BaseAndHall Md5Files.json for Hall %s" % (hallName));

        if isMacOS():
            plat_hallName = 'ios-' + hallName;
        else:
            plat_hallName = 'android-' + hallName;

        luaHallConfig   = gLuaPM.hallConfig (plat_hallName);
        base_style      = luaHallConfig.style;
        cmm_style       = luaHallConfig.cmm_style;

        list32  = {};
        list64  = {};

        '''
        ===========================================================================================
        == base 
        ===========================================================================================
        '''
        baseDir = os.path.join(self.publish_dir, "base");
        baseDirLen = len(self.publish_dir) + 1;

        '''
        32src
        '''
        all = os.walk(os.path.join(baseDir,"src"));
        for path, dir, filelist in all:
            for filename in filelist:

                filepath = os.path.join(path, filename);
                filepathGame = filepath[baseDirLen:];
                filepathGame = filepathGame.replace("\\", "/");

                '''
                src cmm 
                '''
                # if "src/app/cmm" in filepathGame:
                #     if ("src/app/cmm/%s/" % cmm_style) not in filepathGame:
                #         continue;

                '''
                src style 
                '''

                if "src/app/style" in filepathGame:
                    if ("src/app/style/%s" % base_style) not in filepathGame:
                        continue;

                if "com/config.lua" in filepathGame or "com/config_auto.lua" in filepathGame:
                    continue;

                filepathMd5 = self._fileMd5(filepath);
                list32[filepathGame] = filepathMd5;
        '''
        src64
        '''
        all = os.walk(os.path.join(baseDir, "src64"));
        for path, dir, filelist in all:
            for filename in filelist:
                filepath = os.path.join(path, filename);
                filepathGame = filepath[baseDirLen:];
                filepathGame = filepathGame.replace("\\", "/");

                '''
                src64 cmm 
                '''
                # if "src64/app/cmm" in filepathGame:
                #     if ("src64/app/cmm/%s/" % cmm_style) not in filepathGame:
                #         continue;

                if "src64/app/style" in filepathGame:
                    if ("src64/app/style/%s" % base_style) not in filepathGame:
                        continue;

                if "com/config.lua" in filepathGame or "com/config_auto.lua" in filepathGame:
                    continue;

                filepathMd5 = self._fileMd5(filepath);
                list64[filepathGame] = filepathMd5;

        '''
        res
        '''
        all = os.walk(os.path.join(baseDir, "res"));
        for path, dir, filelist in all:
            for filename in filelist:
                filepath = os.path.join(path, filename);
                filepathGame = filepath[baseDirLen:];
                filepathGame = filepathGame.replace("\\", "/");
                filepathMd5 = self._fileMd5(filepath);

                '''
                res cmm 
                '''
                if ("res/cmm/%s/" % cmm_style) in filepathGame:
                    list32[filepathGame] = filepathMd5;
                    list64[filepathGame] = filepathMd5;

                '''
                res style 
                '''
                if ("res/style/%s" % base_style) in filepathGame:
                    list32[filepathGame] = filepathMd5;
                    list64[filepathGame] = filepathMd5;

                '''
                res cmm 
                '''
                if "res/cmm" in filepathGame:
                    list32[filepathGame] = filepathMd5;
                    list64[filepathGame] = filepathMd5;


        '''
        ===========================================================================================
        == hall type
        ===========================================================================================
        '''

        hallDir = os.path.join(self.publish_dir, "hall");
        hallDirLen = len(self.publish_dir) + 1;

        '''
        32src
        '''
        all = os.walk(os.path.join(hallDir,"src"));
        for path, dir, filelist in all:
            for filename in filelist:

                filepath = os.path.join(path, filename);
                filepathGame = filepath[hallDirLen:];
                filepathGame = filepathGame.replace("\\", "/");

                '''
                src type 
                '''

                if "src/type" in filepathGame:
                    if ("src/type/%s" % hallName) not in filepathGame:
                        continue;

                if "hall_filemd5.json" in filepathGame:
                    continue;

                filepathMd5 = self._fileMd5(filepath);
                list32[filepathGame] = filepathMd5;
        '''
        src64
        '''
        all = os.walk(os.path.join(hallDir, "src64"));
        for path, dir, filelist in all:
            for filename in filelist:
                filepath = os.path.join(path, filename);
                filepathGame = filepath[hallDirLen:];
                filepathGame = filepathGame.replace("\\", "/");

                '''
                src64 type
                '''
                if "src64/type" in filepathGame:
                    if ("src64/type/%s" % hallName) not in filepathGame:
                        continue;

                if "hall_filemd5.json" in filepathGame:
                    continue;

                filepathMd5 = self._fileMd5(filepath);
                list64[filepathGame] = filepathMd5;

        '''
        res
        '''
        all = os.walk(os.path.join(hallDir, "res"));
        for path, dir, filelist in all:
            for filename in filelist:
                filepath = os.path.join(path, filename);
                filepathGame = filepath[baseDirLen:];
                filepathGame = filepathGame.replace("\\", "/");
                filepathMd5 = self._fileMd5(filepath);

                '''
                res style 
                '''
                if ("res/type/%s" % hallName) in filepathGame:
                    list32[filepathGame] = filepathMd5;
                    list64[filepathGame] = filepathMd5;


                '''
                res cmm 
                '''
                if "res/cmm" in filepathGame:
                    list32[filepathGame] = filepathMd5;
                    list64[filepathGame] = filepathMd5;

        '''
        ===========================================================================================
        == hall 
        ===========================================================================================
        '''

        filelistJsonStr32   = JsonEncodeWithOrder(list32);
        filelistJsonStr64   = JsonEncodeWithOrder(list64);

        '''
        32
        '''
        jsonFileName32 = "%s_32_filemd5.json" % (hallName)
        jsonFilePath = os.path.join(self.publish_dir, "hall", jsonFileName32);
        with open(jsonFilePath, "w+") as file:
            file.write(filelistJsonStr32);

        md532 = self._fileMd5(jsonFilePath);

        '''
        64
        '''
        jsonFileName64 = "%s_64_filemd5.json" % (hallName)
        jsonFilePath = os.path.join(self.publish_dir, "hall", jsonFileName64);
        with open(jsonFilePath, "w+") as file:
            file.write(filelistJsonStr64);

        md564 = self._fileMd5(jsonFilePath);

        '''
        make a version.file 
        '''
        version_file = os.path.join(self.publish_dir,"hall","%s_version.lua" % (hallName));
        try:
            filecontent = '''
return {
    RELEASE_TIME = "%s";
    version = "%s";
    minhall = %s;
    md532 = '%s';
    md564 = '%s';
    
}
            ''' % (
                self.make_time,
                self.curChConfig.vname,
                self.curChConfig.hallnum,
                md532,
                md564
            )

            with open (version_file,"wb") as file:
                content = convertToCRLF(bytearray(filecontent.encode('utf8')));
                file.write(bytearray(content));

            pass
        except Exception as err:
            errmsg(err);


    def makeHallGameMd5(self,hallName,isMakeAssets = False):
        print ("Make Game Md5Files.json for Hall %s" % (hallName));
        hallConfigPath = os.path.join(self.lua_src_dir, "hall", "src", "type", hallName, "config", "HallGameConfig.lua")
        try:
            file = open(hallConfigPath, encoding='utf-8');
            content = file.read();
            hallConfig = lua.execute(content);

        except Exception as err:
            errmsg(err);
            return;

        for gname in self.game_list:
            subgameDir = os.path.join(self.publish_dir, "game", gname);
            subgameInfo = hallConfig[gname];
            if not subgameInfo:
                continue;

            cmm_style = subgameInfo ["cmm_style"];
            src_style = subgameInfo ["src_style"];

            '''
            proceed game style
            '''
            gameDir = os.path.join(self.publish_dir, "game");
            gameDirLen = len(gameDir) + 1;

            list32  = {};
            list64  = {};

            '''
            32src
            '''
            all = os.walk(os.path.join(gameDir,gname,"src"));
            for path, dir, filelist in all:
                for filename in filelist:

                    filepath = os.path.join(path, filename);
                    filepathGame = filepath[gameDirLen:];
                    filepathGame = filepathGame.replace("\\", "/");

                    '''
                    src cmm 
                    '''
                    if "src/cmm" in filepathGame:
                        if ("src/cmm/%s/" % cmm_style) not in filepathGame:
                            continue;

                    '''
                    src style 
                    '''
                    if "src/style" in filepathGame:
                        if ("src/style/%s" % src_style) not in filepathGame:
                            continue;

                    filepathMd5 = self._fileMd5(filepath);
                    list32[filepathGame] = filepathMd5;
            '''
            src64
            '''
            all = os.walk(os.path.join(gameDir, gname, "src64"));
            for path, dir, filelist in all:
                for filename in filelist:
                    filepath = os.path.join(path, filename);
                    filepathGame = filepath[gameDirLen:];
                    filepathGame = filepathGame.replace("\\", "/");

                    '''
                    src64 cmm 
                    '''
                    if "src64/cmm" in filepathGame:
                        if ("src64/cmm/%s/" % cmm_style) not in filepathGame:
                            continue;

                    '''
                    src64 style 
                    '''
                    if "src64/style" in filepathGame:
                        if ("src64/style/%s" % src_style) not in filepathGame:
                            continue;

                    filepathMd5 = self._fileMd5(filepath);
                    list64[filepathGame] = filepathMd5;

            '''
            res
            '''
            all = os.walk(os.path.join(gameDir, gname, "res"));
            for path, dir, filelist in all:
                for filename in filelist:
                    filepath = os.path.join(path, filename);
                    filepathGame = filepath[gameDirLen:];
                    filepathGame = filepathGame.replace("\\", "/");
                    filepathMd5 = self._fileMd5(filepath);

                    '''
                    res cmm 
                    '''
                    if ("res/cmm/%s/" % cmm_style) in filepathGame:
                        list32[filepathGame] = filepathMd5;
                        list64[filepathGame] = filepathMd5;

                    '''
                    res style
                    '''
                    if ("res/style/%s" % src_style) in filepathGame:
                        list32[filepathGame] = filepathMd5;
                        list64[filepathGame] = filepathMd5;


            filelistJsonStr32   = JsonEncodeWithOrder(list32);
            filelistJsonStr64   = JsonEncodeWithOrder(list64);

            '''
            32
            '''
            jsonFileName32 = "%s_32_filemd5.json" % (hallName)
            jsonFilePath = os.path.join(self.publish_dir, "game", gname, jsonFileName32);
            with open(jsonFilePath, "w+") as file:
                file.write(filelistJsonStr32);

            '''
            64
            '''
            jsonFileName64 = "%s_64_filemd5.json" % (hallName)
            jsonFilePath = os.path.join(self.publish_dir, "game", gname, jsonFileName64);
            with open(jsonFilePath, "w+") as file:
                file.write(filelistJsonStr64);

    def makeAllHallsGameMd5(self):
        try:
            hallList = gPMConfig.getHallList();
            for hallName in hallList:
                self.makeHallGameMd5(hallName,False);
        except Exception as err:
            errmsg(err);

    def makeAllHallsBaseHallMd5(self):
        try:
            hallList = gPMConfig.getHallList();
            for hallName in hallList:
                self.makeBaseAndHallMd5(hallName, False);
        except Exception as err:
            errmsg(err);

    def makeMd5file(self):

        '''
        base and hall 
        '''
        self.makeBaseAndHallMd5 (self.curGameHallName)

        '''
        game
        '''
        self.makeHallGameMd5 (self.curGameHallName);

        '''
        game versions
        '''
        self.makeHallGamesConfig(os.path.join(self.publish_dir, "game"), self.curGameHallName,False,False);

        pass

    def cryptResFiles(self,dirpath = ""):
        try:
            print("cryptResFiles...");

            if self.use_debug:
                print("Is debugMode,will skip this step");
                return;

            if self.use_compress_texture == True:
                if self.use_pvr:
                    self._pvrResFilesImpl(dirpath);
                elif self.use_etc2:
                    self._etc2ResFiles(dirpath);
                elif self.use_astc:
                    self._astcencResFiles (dirpath);
                    pass
            else:
                if self.use_pngquant:
                    self._pngquantResFiles (dirpath);

        except Exception as err:
            errmsg(err);

        pass

    def simplifyResDir(self):
        print("精简资源目录 %s " % self.publish_dir);

        try:
            pubdir = self.publish_dir;
            all = os.walk(pubdir);

            for path, dir, filelist in all:
                for filename in filelist:
                    if not filename.endswith(".yaml"):
                        continue;

                    yaml_file = os.path.join(pubdir,path,filename);

                    if os.path.exists(yaml_file):
                        print ("删除 yaml 文件 %s" % yaml_file)
                        os.remove(yaml_file);

                    filen, filext = os.path.splitext(filename);
                    auto_dir = os.path.join(pubdir,path,filen);

                    if os.path.exists(auto_dir):
                        shutil.rmtree(auto_dir,ignore_errors=True)
                        print ("删除散图子目录 %s" % auto_dir);

        except Exception as err:
            errmsg(err);

        pass

    def _proceedResDir(self, prepath, minfo):

        try:
            pass
        except Exception as err:
            errmsg(err);

    def _zipAllBones(self):

        try:

            print("zip all bones ...")
            all = os.walk(self.publish_dir);
            for path, dir, filelist in all:
                for filename in filelist:
                    if filename.endswith("csb"):

                        filen, fileext = os.path.splitext(filename);
                        zippath = os.path.join(path, filen + ".zip");
                        validate = False;
                        zip = None;

                        print("we are here to compress %s bones info zipfile ... " % filen);

                        for i in range(2):
                            pngname = filen + str(i) + ".png";
                            plistname = filen + str(i) + ".plist";
                            if os.path.exists(os.path.join(path, pngname)) and os.path.exists(os.path.join(path, plistname)):

                                if not zip:
                                    zip = zipfile.ZipFile(zippath, "w", zipfile.ZIP_DEFLATED);

                                validate = True;
                                zip.write(os.path.join(path, pngname), pngname);
                                zip.write(os.path.join(path, plistname), plistname);

                                # remove png && plist
                                os.remove(os.path.join(path, pngname))
                                os.remove(os.path.join(path, plistname))

                        if validate and zip:
                            zip.write(os.path.join(path, filename), filename);
                            zip.close();
                            os.remove(os.path.join(path, filename));
            pass

        except Exception as err:
            errmsg(err);

    def prepareResGameDir(self):
        self._proceedResDir("game", self.game_list);

    def prepareBaseAndHallResDir(self):
        self._proceedResDir("", ["base", "hall"]);

    def prepareResDir(self):
        try:
            print("prepareResDir ...");

            # base && hall
            self.prepareBaseAndHallResDir ();

            # game
            self.prepareResGameDir ();

        except Exception as err:
            errmsg(err);

    def luaBool(self, bv):
        if bv == True:
            return "true";
        return "false"

    def _makeVersionsForGames(self):
        pass

    def get_host_ip(self):
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(('8.8.8.8', 80))
            ip = s.getsockname()[0]
        finally:
            s.close()

        return ip

    def make_php_url(self, ip_url, mm):
        return '''http://%s/%s/api.php''' % (str(ip_url), str(mm));

    def _makeConfigAutoFile(self, filepath):
        try:
            app_version = self.curChConfig.vname;
            if filepath == None:
                filedir = os.path.join(self.publish_dir, "base", "src", "com");
                if not os.path.exists(filedir):
                    os.makedirs(filedir);
                filepath = os.path.join(self.publish_dir, "base", "src", "com", "config_auto.lua");

            luaChConfig = self.luaChConfig;
            luaHallConfig = self.luaHallConfig;
            pmChConfig = self.curChConfig;
            luaPlatConfig = self.luaPlatConfig;
            config = self.luaConfig;

            fans_page_url = luaChConfig.fans_page;
            if fans_page_url == None:
                fans_page_url = luaPlatConfig.fans_page;

            if fans_page_url == None:
                fans_page_url = luaHallConfig.fans_page;

            share_page_url = luaChConfig.share_page;
            if share_page_url == None:
                share_page_url = luaPlatConfig.share_page;

            if share_page_url == None:
                share_page_url = luaHallConfig.share_page_url;

            platconfig = self.getPlatSettings();

            config_str = "-- NewPackMan V%d ;\n" % PackManVersion();
            config_str += '''CONFIG_API                = 0x%08x;\n''' % luaChConfig.channel;
            config_str += '''ENCRYPT_CHAR              = "%s";\n''' % luaChConfig.encrypt_char;
            config_str += '''PACKAGENAME               = "%s";\n''' % luaChConfig.name;
            config_str += '''CONFIG_VISITOR_SID        = %d;\n''' % luaChConfig.visitor_sid;

            config_str += '''CONFIG_GAME_TYPE          = "%s";\n''' % self.curGameHallName;
            config_str += '''CONFIG_DEBUG_HALL_UPDATE  =  %s;\n''' % self.luaBool(pmChConfig.use_debug_hall_hotupdate);
            config_str += '''CONFIG_DEBUG_GAME_UPDATE  =  %s;\n''' % self.luaBool(pmChConfig.use_debug_game_hotupdate);
            config_str += '''CONFIG_STYLE              = "%s";\n''' % luaHallConfig.style;
            config_str += '''CONFIG_CMM_STYLE          = "%s";\n''' % luaHallConfig.cmm_style;
            config_str += '''CHANNEL_NAME              = "%s";\n''' % self.chName;
            config_str += '''APP_VERSION               = "%s";\n''' % self.shortVerName;
            config_str += '''CONFIG_NO_HOTUPDATE       = %s\n'''  % self.luaBool(pmChConfig.use_no_hotupdate)

            config_str += '''USE_AD                    = %s;\n''' % "true";
            config_str += '''CONFIG_GAUSE_BG           = %s;\n''' % "false";
            config_str += '''CONFIG_ERRBOX_ON          = %s;\n''' % self.luaBool(pmChConfig.use_pop_errbox);
            config_str += '''CONFIG_NO_FB              = %s;\n''' % self.luaBool(pmChConfig.use_fbinvite);
            config_str += '''DEBUG_FPS                 = %s;\n''' % "false";
            config_str += '''DEBUG_MEM                 = %s;\n''' % "false";
            config_str += '''CONFIG_USE_NEWBA          = %s;\n''' % "true";
            config_str += '''CONFIG_USE_NEWROOM_INFO   = %s;\n''' % "true";
            config_str += '''CONFIG_USE_WEBSOCKET      = %s;\n''' % "false";
            config_str += '''CONFIG_USE_CYNK_SOCKET    = %s;\n''' % "true";
            config_str += '''USE_LOCAL                 = %s;\n''' % self.luaBool(pmChConfig.use_local_srv);
            config_str += '''CONFIG_FPS                = %s;\n''' % ("60");
            config_str += '''CONFIG_NO_GZIP_PHP        = %s;\n''' % self.luaBool(pmChConfig.use_no_gzip_php);
            config_str += '''CONFIG_RELEASE_LOG        = %s;\n''' % self.luaBool(pmChConfig.use_can_log);
            config_str += '''IMEI                      = "%s";\n''' % platconfig.imei;
            config_str += '''MACID                     = "%s";\n''' % platconfig.macid;
            config_str += '''CONFIG_SHOW_UID           = %s;\n''' % "false";
            config_str += '''CONFIG_SHARE_PAGE         = "%s";\n''' % share_page_url;
            config_str += '''CONFIG_FANS_PAGE          = "%s";\n''' % fans_page_url;
            config_str += '''CONFIG_USE_DBGMSG         = %s;\n''' % "false";
            config_str += '''CONFIG_USE_PROMOTER       = %s;\n''' % "true";
            config_str += '''CONFIG_BACK_URL_PREFIX    = "%s";\n''' % self.luaConfig.prefix_url;
            config_str += '''CONFIG_USE_DOWNLOADER     = %s;\n''' % "true";
            config_str += '''CONFIG_FORCE_PORT         = nil;\n''';
            config_str += '''CONFIG_USE_NEW_ACT        = %s;\n''' % "false";
            config_str += '''CONFIG_USE_FILELOGGER     = %s;\n''' % self.luaBool(pmChConfig.use_filelogger);

            if pmChConfig.use_can_release_log:
                config_str += '''print                     = release_print;\n''';

            if pmChConfig.use_no_aes_php:
                config_str += '''CONFIG_AES_KEY            = nil;\n''';

            # Need to open logger
            if pmChConfig.use_logger:
                config_str += '''METROSERVER_IP        = "%s";\n''' % self.get_host_ip();
                config_str += '''METROSERVER_PORT        = %s;\n''' % 6666;

            ### debug
            luaChConfig = self.luaChConfig
            luaHallConfig = self.luaHallConfig;


            if luaChConfig.dbg_config:
                dbgconfig = luaChConfig.dbg_config;
            elif luaHallConfig.dbg_config:
                dbgconfig = luaHallConfig.dbg_config;
            elif luaPlatConfig.dbg_config:
                dbgconfig = luaPlatConfig.dbg_config;
            else:
                dbgconfig = config.dbg_config;

            ### release
            if luaChConfig.relese_config:
                releaseconfig = luaChConfig.relese_config;
            elif luaHallConfig.relese_config:
                releaseconfig = luaHallConfig.relese_config;
            elif luaPlatConfig.relese_config:
                releaseconfig = luaPlatConfig.relese_config;
            else:
                releaseconfig = config.relese_config;

            ### preonline
            if luaChConfig.preonline_config:
                preonlineconfig = luaChConfig.preonline_config;
            elif luaHallConfig.preonline_config:
                preonlineconfig = luaHallConfig.preonline_config;
            elif luaPlatConfig.preonline_config:
                preonlineconfig = luaPlatConfig.preonline_config;
            else:
                preonlineconfig = config.preonline_config;

            ### slotsconfig
            if luaChConfig.slots_config:
                slots_config = luaChConfig.slots_config;
            elif luaHallConfig.slots_config:
                slots_config = luaHallConfig.slots_config;
            elif luaPlatConfig.slots_config:
                slots_config = luaPlatConfig.slots_config;
            else:
                slots_config = config.slots_config;

            if pmChConfig.use_local_srv:
                if pmChConfig.use_slots_update:
                    cnnconfig = slots_config;
                    if cnnconfig == None:
                        cnnconfig = dbgconfig;
                else:
                    cnnconfig = dbgconfig;
            else:
                cnnconfig = releaseconfig;

            srv_ipv6 = cnnconfig.ipv6;
            config_str += '''CONFIG_HOT_UPDATE         = "%s";\n''' % cnnconfig.hotupdate_cfg;

            if pmChConfig.use_local_srv and pmChConfig.use_local_srv_ip and platconfig.srv_ip and platconfig.srv_ip != "":
                phpurl = self.make_php_url(platconfig.srv_ip, luaHallConfig.mm);
            else:
                phpurl = cnnconfig.phpurl;

            phpurl = phpurl.replace(" ", "")

            config_str += '''CONFIG_PHP_URL            = "%s";\n''' % phpurl;
            config_str += '''CONFIG_SERVER_IP          = "%s";\n''' % cnnconfig.backup;
            config_str += '''CONFIG_IPV6               = "%s";\n''' % srv_ipv6;
            config_str += '''NOTICE_JSON_FILE          = "%s";\n''' % cnnconfig.noticeurl;
            config_str += '''CONFIG_JSON_FILE          = "%s";\n''' % cnnconfig.configurl;
            config_str += '''CONFIG_LANG               = "%s";\n''' % luaHallConfig.lang;
            config_str += '''CONFIG_LANGID             = %d;\n'''   % luaHallConfig.langid;
            config_str += '''CONFIG_CURRENCY           = "%s";\n''' % luaHallConfig.unit;

            if luaHallConfig.lang != "ina":
                if luaHallConfig.lang != "tl":
                    config_str += '''FONT_NAME                 = "";\n'''
                    config_str += '''FONT_BOLD                 = "";\n'''

            if pmChConfig.use_switch_srv:
                config_str += '''
-- 
-- generated by packman 
-- @param env 1:Debug;2:PreOnline;3:Online
get_SRV_CONFIG = function(env) 
    local envs = {
        {"%s","%s","%s"};
        {"%s","%s","%s"};
        {"%s","%s","%s"};
    }
    ENV_TYPE = env
    USE_LOCAL = ENV_TYPE <= 2;

    if set_global_url then
        CONFIG_GLOBAL_URL = set_global_url(ENV_TYPE)
    end
    local cfg = envs[env] or envs[1]
    CONFIG_PHP_URL, CONFIG_SERVER_IP, CONFIG_IPV6 = cfg[1], cfg[2], cfg[3]
    CONFIG_PHP_ENTRY = {
        {URL = CONFIG_PHP_URL, IPV6 = CONFIG_IPV6};
    }
end

get_SRV_CONFIG(USE_LOCAL and 2 or 3)

                ''' % (phpurl, dbgconfig.backup, dbgconfig.ipv6,
                       preonlineconfig.phpurl, preonlineconfig.backup, preonlineconfig.ipv6,
                       releaseconfig.phpurl, releaseconfig.backup, releaseconfig.ipv6);

            # print ("make config filepath : %s " % filepath);
            with open(filepath, "wb") as file:
                content = convertToCRLF (config_str.encode('utf8'));
                file.write(bytearray(content));

        except Exception as err:
            errmsg(err);
        pass

    def syncVersionFile(self,filepath,app_version):
        with open(filepath, "wb") as file:
            config_str = '''--NewPackMan v%d \n''' % PackManVersion();
            config_str += '''return {\n''';
            config_str += '''   CONFIG_VERSION = "%s";\n''' % app_version;
            config_str += '''   CONFIG_HALLNUM = %s;\n''' % str(self.curChConfig.hallnum);
            config_str += '''};''';

            content = convertToCRLF(config_str.encode('utf8'));
            file.write (bytearray(content));

    def _makeConfigVersionFile(self, filepath):
        try:
            app_version = self.curChConfig.vname;
            if filepath == None:
                errmsg("No confif_version file");
                pass;

            self.syncVersionFile(filepath, app_version);

        except Exception as err:
            errmsg(err);
        pass

    def _makeAppVersionFile(self, filepath, android_bugly, ios_bugly):

        new_app_version = self.shortVerName;
        list = self.pmconfig.getCurGameList();

        fmt = '''
#ifndef __APP_VER__
#define __APP_VER__ 

/* this is generated by PackMan ,
 * DO NOT modify it manually 
 * 
 * NewPackMan v%d
 */

const char *APP_VERSION         = "%s";

/* For bugly */
const char *BUGLY_ANDROID_APPID = "%s";
const char *BUGLY_IOS_APPID     = "%s";

#endif
        ''' % (PackManVersion(), new_app_version, android_bugly, ios_bugly);

        try:
            file = open(filepath, "w+", encoding='utf-8');
            file.write(fmt);
            file.close();
        except Exception as err:
            errmsg(err);

        pass

    def makeVersionFiles(self):
        pass

    def zipAllFile(self, useArm64=False):
        try:
            print("zipAllFile...");

            """
            zip all bones if needed
            """
            if self.use_bones_zip:
                self._zipAllBones();
            else:
                print("we don't use bones zip here ...");

            tmpdir = os.path.join(self.publish_dir, "tmpdir");
            if os.path.exists(tmpdir):
                shutil.rmtree(tmpdir, ignore_errors=True);
            os.makedirs(tmpdir);

            """
            base & hall
            """
            print("zip hall/base to hall.zip ... ");
            shutil.move(os.path.join(self.publish_dir, "hall"), tmpdir);
            shutil.move(os.path.join(self.publish_dir, "base"), tmpdir);
            hall_zippath = os.path.join(self.publish_dir, "hall");

            """
            make com and main
            """

            """
            32bit 
            """
            src_com_dir = os.path.join(tmpdir, "base", "src", "com");
            dst_com_dir = os.path.join(self.publish_dir, "base", "src");
            if os.path.exists(src_com_dir):
                if not os.path.exists(dst_com_dir):
                    os.makedirs(dst_com_dir);
                shutil.move(src_com_dir, dst_com_dir);

            """
            64bit
            """
            src_com_dir64 = os.path.join(tmpdir, "base", "src64", "com");
            dst_com_dir64 = os.path.join(self.publish_dir, "base", "src64");
            if os.path.exists(src_com_dir64):
                if not os.path.exists(dst_com_dir64):
                    os.makedirs(dst_com_dir64);
                shutil.move(src_com_dir64, dst_com_dir64);

            """
            32bit 
            """
            src_lua_path = os.path.join(tmpdir, "base", "src", "main.lua");
            dst_lua_path = os.path.join(self.publish_dir, "base", "src");
            if os.path.exists(src_lua_path):
                if not os.path.exists(dst_lua_path):
                    os.makedirs(dst_lua_path);
                shutil.move(src_lua_path, dst_lua_path);

            """
            64bit 
            """
            src_lua_path64 = os.path.join(tmpdir, "base", "src64", "main.lua");
            dst_lua_path64 = os.path.join(self.publish_dir, "base", "src64");
            if os.path.exists(src_lua_path64):
                if not os.path.exists(dst_lua_path64):
                    os.makedirs(dst_lua_path64);
                shutil.move(src_lua_path64, dst_lua_path64);

            """
            fix bug , 2019/10/19 
            need delete the base/src(64)/com dir
            """
            com_src_path = os.path.join(self.publish_dir,tmpdir,"base","src","com");
            com_src_path64 = os.path.join(self.publish_dir,tmpdir,"base","src64","com");
            if os.path.exists(com_src_path):
                shutil.rmtree(com_src_path,ignore_errors=True);

            if os.path.exists(com_src_path64):
                shutil.rmtree(com_src_path64,ignore_errors=True);

            self.renameLuacToLua(tmpdir);
            shutil.make_archive(hall_zippath, 'zip', tmpdir);

            """
            game
            """
            print("zip game to game.zip ... ")
            game_zippath = os.path.join(self.publish_dir, "game");
            srcpath = os.path.join(self.publish_dir, "game");
            if not os.path.exists(game_zippath):
                os.makedirs(game_zippath);

            if not os.path.exists(srcpath):
                os.mkdir(srcpath);

            gametmpdir = os.path.join(self.publish_dir, "game_tmpdir");
            if not os.path.exists(gametmpdir):
                os.makedirs(gametmpdir);

            shutil.move(srcpath, gametmpdir);
            shutil.make_archive(game_zippath, 'zip', gametmpdir);

            """
            remove game
            """
            if os.path.exists(gametmpdir):
                shutil.rmtree(gametmpdir, ignore_errors=True);

            """
            make dir (base{src,res_xxx})
            """
            basedir = os.path.join(self.publish_dir, "base");
            if os.path.exists(basedir):
                pass
                # shutil.rmtree(basedir, ignore_errors=True);
            else:
                os.makedirs(basedir);

            respath = os.path.join(basedir, "res");

            if not os.path.exists(respath):
                os.makedirs(respath);

            print("move game.zip and hall.zip to res dir ...")
            shutil.move(game_zippath + ".zip", os.path.join(respath, "game.zip"))
            shutil.move(hall_zippath + ".zip", os.path.join(respath, "hall.zip"))

            """
            remove hall && base
            """
            if os.path.exists(tmpdir):
                shutil.rmtree(tmpdir, ignore_errors=True);

        except Exception as err:
            errmsg(err);

        pass

    def cryptZipFile(self):
        pass

    def doBeforeBuildAction(self):
        pass

    def buildAll(self):
        pass

    def doAfterBuildAction(self):
        pass

class PackH5Common(object):
    def __init__(self,param):
        self.param = param;
        pass

    def pack (self):
        pass
