
"""
PackConfig
"""
import os

import re
import jsonpickle
from PyQt5.Qt import Qt

from cmm import *

class GameInfo(object):
    def __init__(self):

        self.base = "";
        self.url = "";
        self.md5 = "";
        self.fromv = 0;
        self.version = "1.0";
        self.minhall = 1;
        self.debug = False;

        pass

    def setBase(self,base):
        self.base = base;

    def getBase(self):
        return self.base;

    def setUrl(self,url):
        self.url = url;

    def getUrl(self):
        return self.url;

    def setMd5(self,md5):
        self.md5 = md5;

    def getMd5(self):
        return self.md5;

    def getFromV(self):
        return self.fromv;

    def setFromV(self,fromv):
        self.fromv = fromv;

    def getVersion(self):
        return self.version;

    def setVersion(self,version):
        self.version = version;

    def getMinHall(self):
        return self.minhall;

    def setMinHall(self,minhall):
        self.minhall = minhall;

    def setDebug(self,bv):
        self.debug = bv;

    def getDebug(self):
        return self.debug;



class PKConfig(object):
    def __init__(self):
        self.use_pop_errbox = False;
        self.use_local_srv = False;
        self.use_switch_srv = False;
        self.use_can_release_log = False;
        self.use_fbinvite = False;
        self.use_no_aes_php = False;
        self.use_no_gzip_php = False;
        self.use_can_log = False;
        self.use_local_srv_ip = False;
        self.use_pvr = False;
        self.use_rgba8888 = False;
        self.use_bones_zip = False;
        self.use_etc2 = False;
        self.use_astc = False;
        self.use_compress_texture  = False;
        self.use_v2030 = True;
        self.use_debug = False;
        self.use_debug_hotupdate = False;
        self.use_no_crypt_zip = False;
        self.use_pngquant = False;
        self.use_logger = False,
        self.use_filelogger = False;
        self.use_test_game_update = False;
        self.use_no_hotupdate = False;
        self.use_slots_update = False;

        self.vname = "";
        self.vcode = 0;
        self.hallnum = 0;
        self.games = [];
        self.langName = "";
        self.pageName = "";     # 配置页名称

        self.lastvname = "";


class ChConfig(object):
    def __init__(self):
        self.chConfig = {};
        self.curChName = "";

class PlatConfig(object):
    def __init__(self):
        self.engine_dir = "";
        self.aapt_dir = "";
        self.project_dir = "";
        self.ndk_dir = "";
        self.exe_dir = "";
        self.imei = "";
        self.macid = "";
        self.srv_ip = "";
        self.quick_dir = "";
        self.ant_dir = "";
        self.sdk_dir = "";
        self.proxy_str = "";
        self.svn_str = "";
        self.beefont_str = "";
        pass

class ProfileConfig(object):
    def __init__(self):
        self.hallChConfigs = {};
        self.platConfigs = {};
        self.curHallName = "";
        self.username = "";
        self.passwd = "";

class PMConfig:

    def __init__(self, filename,mode = 1):
        try:
            self.isMakeConfig = False;
            self.isDebug = False;
            self.isBatch = False;

            self.alllist = None;
            self.hallList = None;

            if mode == 1:
                self.filename = filename;
                if not os.path.exists (filename):
                    self.gmConfig = ProfileConfig ();
                else:
                    file = open (filename,"r");
                    content = file.read();
                    file.close();

                    self.gmConfig = None;
                    jobj = jsonpickle.decode(content);
                    self.gmConfig = jobj;
            else:
                #jsonstr
                self.gmConfig = None;
                jobj = jsonpickle.decode(filename);
                self.gmConfig = jobj;
                self.isBatch = True;
                pass

                # print (jobj.__dict__);

        except Exception as err:
            if self.gmConfig == None:
                self.gmConfig = ProfileConfig ();

        pass

    def checkHallConfig(self,hallName):

        if hallName == "":
            return None;

        if hallName not in self.gmConfig.hallChConfigs:
            self.gmConfig.hallChConfigs [hallName] = ChConfig ();

        return self.gmConfig.hallChConfigs [hallName];

    def checkChConfig(self,hallName,chName):
        if hallName == "" or chName == "":
            return None;

        if hallName not in self.gmConfig.hallChConfigs:
            self.gmConfig.hallChConfigs [hallName] = ChConfig ();

        if chName not in self.gmConfig.hallChConfigs [hallName].chConfig:
            self.gmConfig.hallChConfigs [hallName].chConfig [chName] = PKConfig();

    def getAccInfo(self):
        return [self.gmConfig.username,self.gmConfig.passwd];

    def setAccInfo(self,username,passwd):
        if username and passwd:
            self.gmConfig.username = username;
            self.gmConfig.passwd = passwd;

    def getCurHallConfig(self):
        try:
            HallName = self.gmConfig.curHallName;
            if HallName == "":
                return ;

            self.checkHallConfig (HallName);

            return self.gmConfig.hallChConfigs [HallName];

        except Exception as err:
            errmsg (err);

    def getCurChConfig(self):
        try:

            HallName = self.gmConfig.curHallName;
            if HallName == "":
                return ;

            self.checkHallConfig (HallName);

            ChName = self.gmConfig.hallChConfigs [HallName].curChName;
            if ChName == "":
                return ;

            self.checkChConfig (HallName,ChName);

            return self.gmConfig.hallChConfigs [HallName].chConfig [ChName];

        except Exception as err:
            errmsg (err);

    def setAllGameList(self,list):
        self.all_list = list;

    def getAllGameList(self):
        return self.all_list;

    def setCurGameList(self,list):
        try:
            config = self.getCurChConfig ();
            if config == None or list == None:
                return ;

            HallName = self.gmConfig.curHallName;
            ChName = self.gmConfig.hallChConfigs[HallName].curChName;

            self.gmConfig.hallChConfigs[HallName].chConfig[ChName].games.clear ();
            for i in range(len(list)):
                self.gmConfig.hallChConfigs[HallName].chConfig[ChName].games.append (list [i])

        except Exception as err:
            errmsg (err);

    def getCurGameList(self):
        try:

            config = self.getCurChConfig ();
            if (config == None):
                return ;
            # print (config.games);
            return config.games;

        except Exception as err:
            errmsg (err);

    def getCurGameListFromHallAndCh(self,HallName,chName):
        try:
            if self.gmConfig.hallChConfigs \
                and HallName in self.gmConfig.hallChConfigs \
                and self.gmConfig.hallChConfigs[HallName].chConfig \
                and chName in self.gmConfig.hallChConfigs[HallName].chConfig:
                return self.gmConfig.hallChConfigs[HallName].chConfig[chName].games;
            else:
                return None;
        except Exception as err:
            errmsg(err);


    def setCurLangName(self,LangName):
        try:
            config = self.getCurChConfig ();
            if (config == None):
                return ;

            config.langName = LangName;

        except Exception as err:
            errmsg (err);

    def getCurLangName(self):
        try:
            config = self.getCurChConfig();
            if (config == None):
                return;

            return config.langName;

        except Exception as err:
            errmsg (err);

    def setCurHallName(self,HallName):
        try:

            if HallName == "":
                return ;

            if HallName != self.gmConfig.curHallName:
                self.gmConfig.curHallName = HallName;


        except Exception as err:
            errmsg (err);

    def isHallExist(self,HallName):
        if self.gmConfig.hallChConfigs \
                and HallName in self.gmConfig.hallChConfigs :
            return True;
        else:
            return False;

    def isHallChExist(self,HallName,chName):
        if self.gmConfig.hallChConfigs \
                and HallName in self.gmConfig.hallChConfigs \
                and self.gmConfig.hallChConfigs[HallName].chConfig \
                and chName in self.gmConfig.hallChConfigs[HallName].chConfig:
            return True;
        else:
            return False;

    def getCurHallName(self):
        return self.gmConfig.curHallName;

    def setCurChName(self,chName):
        try:

            HallName = self.gmConfig.curHallName;
            if HallName == "":
                return ;

            self.checkHallConfig(HallName);
            self.gmConfig.hallChConfigs [HallName].curChName = chName;
            self.checkChConfig(HallName,chName);

        except Exception as err:
            errmsg (err);

    def getCurChName(self):
        try :

            HallName = self.gmConfig.curHallName;
            if HallName == "":
                return ;

            self.checkHallConfig(HallName);
            return self.gmConfig.hallChConfigs [HallName].curChName;

        except Exception as err:
            errmsg (err);

    """
    for settings platform 
    """

    def setPlatSettings(self,plat,profile):
        try:
            if plat == None or plat == "":
                return ;

            if plat not in self.gmConfig.platConfigs:
                self.gmConfig.platConfigs[plat] = PlatConfig();

            self.gmConfig.platConfigs[plat] = profile;

        except Exception as err:
            errmsg (err);
        pass

    def getPlatSettings(self,plat):
        try:

            if plat == None or plat == "":
                return ;

            if plat not in self.gmConfig.platConfigs:
                self.gmConfig.platConfigs[plat] = PlatConfig();

            return self.gmConfig.platConfigs[plat];

        except Exception as err:
            errmsg (err);
        pass

    def save(self):
        try:
            file = open (self.filename,"w+");
            if (file != None):
                jstr = jsonpickle.encode (self.gmConfig);
                # print (jstr);
                file.write(jstr);
                file.close ();

        except Exception as err:
            errmsg (err);
        pass

    def configCurrentToString(self):
        try:

            hallName    = self.getCurHallName();
            chName      = self.getCurChName();

            gmconfig = ProfileConfig ();
            gmconfig.curHallName = hallName
            gmconfig.platConfigs = self.gmConfig.platConfigs;
            gmconfig.hallChConfigs = {};
            gmconfig.hallChConfigs[hallName] = ChConfig ();
            gmconfig.hallChConfigs[hallName].curChName = chName;
            gmconfig.hallChConfigs[hallName].chConfig[chName] = self.gmConfig.hallChConfigs[hallName].chConfig [chName];

            return jsonpickle.encode (gmconfig);

        except Exception as err:
            errmsg(err);

    def reset(self):
        pass

    def getDebug(self):
        return self.isDebug;

    def setDebug(self,bv):
        self.isDebug = bv;

    def getHallList(self):
        return self.hallList;

    def setHallList(self,list):
        self.hallList = list;

"""
filter of png pvr.ccz or etc2
"""

class FilterList(object):
    def __init__(self,rgba8888_list_filename,raw_list_filename):

        try:
            self.rgba888_file = rgba8888_list_filename;
            self.rgba888_list = [];
            self.rgba888_dirt = False;
            self.rgba888_cnt = 0;

            self.raw_file = raw_list_filename;
            self.raw_list = [];
            self.raw_dirt = False;
            self.raw_cnt = 0;

            list = [];
            with open (rgba8888_list_filename,"r") as file:
                content = file.read ();
                list = content.strip().split("\n");

            # unique it
            for name in list:
                if name not in self.rgba888_list:
                    self.rgba888_list.append(name);
                    self.rgba888_cnt += 1;

            with open (raw_list_filename,"r") as file:
                content = file.read();
                list = content.strip().split("\n");

            # unique it
            for name in list:
                if name not in self.raw_list:
                    self.raw_list.append(name);
                    self.raw_cnt += 1;

            pass
        except Exception as err:
            print (err);

    def getRGBA888List(self):
        return self.rgba888_list;

    def isInRGBA888List(self,filename):
        return filename in self.rgba888_list;

    def getRawList(self):
        return self.raw_list;

    def isInRawList(self,filename):
        return filename in self.raw_list;

    def addToRGBA888List(self,filename):
        try:
            if filename != None and filename != "":
                self.rgba888_list.append(filename);
                self.rgba888_dirt = True;
                self.rgba888_cnt += 1;
            pass
        except Exception as err:
            print (err);

    def removeRGBA8888(self,filename):
        try:

            if filename != None and filename != "":
                if filename in self.rgba888_list:
                    self.rgba888_list.remove(filename);
                    self.rgba888_dirt = True;
                    self.rgba888_cnt -= 1;

        except Exception as err:
            errmsg(err);

    def getRGBA8888Count(self):
        return self.rgba888_cnt;

    def addToRawList(self,filename):
        try:
            if filename != None and filename != "":
                self.raw_list.append(filename);
                self.raw_dirt = True;
                self.raw_cnt += 1;
            pass
        except Exception as err:
            print (err);

    def removeRaw(self,filename):
        try:
            if filename != None and filename != "":
                if filename in self.raw_list:
                    self.raw_list.remove(filename);
                    self.raw_dirt = True;
                    self.raw_cnt -= 1;
        except Exception as err:
            errmsg(err);

    def getRawCount(self):
        return self.raw_cnt;

    def load(self):
        pass

    def save(self):
        try:
            if self.raw_dirt:
                str = "";
                for name in self.raw_list:
                    str += name + "\n";
                with open (self.raw_file,"w+") as file:
                    file.write(str);

                self.raw_dirt = False;

            if self.rgba888_dirt:
                str = "";
                for name in self.rgba888_list:
                    str += name + "\n";
                with open (self.rgba888_file,"w+") as file:
                    file.write(str);

                self.rgba888_dirt = False;

        except Exception as err:
            print (err);
        pass


'''
Whitelist
'''
class WhiteList(object):
    def __init__(self,white_list_filename):

        try:
            self.white_list_filename = white_list_filename;
            self.white_list = {};
            self.white_list_count = 0;
            self.white_list_enabled = False;

            if os.path.exists(white_list_filename):
                with open (white_list_filename,"r",encoding='utf8') as file:
                    content = file.read ().strip ('\n').strip ('\r').strip ('\t').strip(' ');
                    self.white_list = json.loads(content);

            pass
        except Exception as err:
            print (err);

    def getList(self):
        return self.white_list;

    def getCount(self):
        self.white_list_count = 0;
        for k in self.white_list:
            self.white_list_count += 1;

        return self.white_list_count;

    def isInList(self,devname):
        try:
            return not not self.white_list [devname];
        except Exception as err:
            return False;

    def setWhiteListEnabled(self,bv):
        self.white_list_enabled = bv;
        pass;

    def addToList(self,name,devname):
        try:
            if devname == None or devname == "":
                return False;

            if name == None or name == "":
                name = "未命名";

            self.white_list [devname] = {
                "devname" : devname,
                "name" : name,
            }

            self.save ();

            return True;

            pass
        except Exception as err:
            print (err);

    def removeFromList(self,devname):
        try:

            if devname != None and devname != "":
                del self.white_list [devname];
                self.save ();

        except Exception as err:
            errmsg(err);

    def load(self):
        pass

    def convertToJson(self):
        if self.white_list_enabled != True:
            return "";

        dict = [];
        for devname in self.white_list:
            dict.append(devname);

        return json.dumps(dict);

    def save(self):
        try:
            with open (self.white_list_filename,"w+",encoding='utf8') as file:
                file.write(json.dumps(self.white_list));

        except Exception as err:
            print (err);
        pass


"""
load all 
"""
rgba8888_filepath = os.path.join("common","flist","png8888list.txt");
raw_filepath = os.path.join("common","flist","pngrawlist.txt");
gFilterList = FilterList(rgba8888_filepath,raw_filepath);
gFilterList.load();

white_list_path = os.path.join("common","flist","whitelist.json");
gWhiteList = WhiteList(white_list_path);
gWhiteList.load();


def get_home_dir():
    '''
    获得家目录
    :return:
    '''
    if sys.platform == 'win32':
        homedir = os.environ['USERPROFILE']
    elif sys.platform == 'linux' or sys.platform == 'darwin':
        homedir = os.environ['HOME']
    else:
        raise NotImplemented(f'Error! Not this system. {sys.platform}')
    return homedir

"""
pmconfig 
"""

if os.path.exists("settings.json"):
    shutil.move("settings.json",os.path.join(get_home_dir (),"settings.json"));

gPMConfig = PMConfig(os.path.join(get_home_dir (),"settings.json"));

'''
Page Config about
'''
class PageConfig(object):
    def __init__(self):
        self.cbox_config = None;

        self.m_checkbox = [];   # 打包勾选项
        self.m_subgame = [];    # 子游戏选项
        self.m_other = [];      # 其他(版本号...)

    @staticmethod
    def getInstance():
        if not hasattr(PageConfig, "m_instance"):
            PageConfig.m_instance = PageConfig();
        return PageConfig.m_instance;

    def addWidgets(self, widget, wType=None):
        if widget == None or wType == None:
            return;

        wList = [];
        if isinstance(widget, list):
            wList.extend(widget);
        else:
            wList.append(widget);

        if wType == "option":
            self.m_checkbox.extend(wList);
            self.m_checkbox = list(set(self.m_checkbox));   # 去重
        elif wType == "subgame":
            self.m_subgame.clear();     # 先清空
            for item in widget:
                if item not in self.m_subgame:
                    self.m_subgame.append(item);
        elif wType == "other":
            self.m_other.extend(wList);
            self.m_other = list(set(self.m_other));  # 去重

    def getWidgets(self, wType):
        if wType == "option":
            return self.m_checkbox;
        elif wType == "subgame":
            return self.m_subgame;
        elif wType == "other":
            return self.m_other;


    '''加载数据 lua globals'''
    def loadLuaData(self, luaglobals):
        return ;

    '''获取当前游戏名称'''
    def getHallName(self):
        curGame = None;
        hallName = gPMConfig.getCurHallName();
        channelCfg = gLuaPM.hallConfig (hallName);
        curGame = channelCfg.srcname;

        if curGame == None:
            strs = hallName.split("-");
            curGame = strs[1];
        return curGame;

    '''获取配置页'''
    def getPages(self):
        hallName = self.getHallName();
        path = os.path.join(os.getcwd(), "userdata", "Settings", hallName);
        pagelist = [];

        if not os.path.exists(path):
            return [];

        for name in os.listdir(path):
            pagename = name.replace("_Config.json", "");
            pagelist.append(pagename);
        return pagelist;

    '''读取配置，显示到控件'''
    def read(self, config):
        option = config["Option"];
        for checkbox in self.m_checkbox:
            name = checkbox.objectName();
            if name in option and option[name]:
                checkbox.setCheckState(Qt.Checked);
            else:
                checkbox.setCheckState(Qt.Unchecked);

        subgame = config["Subgame"];
        for item in self.m_subgame:
            name = item.text();
            if not item.isTristate():
                name = "sub" + name;

            if name in subgame and subgame[name]:
                item.setCheckState(Qt.Checked);
            else:
                item.setCheckState(Qt.Unchecked);

        other = config["Other"];
        for widget in self.m_other:
            name = widget.objectName();
            wtyp = type(widget).__name__;

            if wtyp == "QLineEdit":
                widget.setText(other[name]);
            elif wtyp == "QComboBox":
                widget.setCurrentText(other[name]);
            pass

    '''加载配置'''
    def load(self):
        hallName = self.getHallName();
        filename = os.path.join(os.getcwd(), "userdata", "Settings", hallName,
                                self.cbox_config.currentText() + "_Config.json");
        try:
            '''读数据'''
            file = open(filename, 'r');
            if file:
                object = jsonpickle.decode(file.read());
                self.read(object);
                file.close();
            pass
        except Exception as err:
            if not re.search("Errno 2", str(err)):
                print(err);

    '''保存配置'''
    def save(self):
        option = {};
        for checkbox in self.m_checkbox:
            name = checkbox.objectName();
            if checkbox.checkState() == Qt.Checked:
                option[name] = True;

        subgame = {};
        for item in self.m_subgame:
            name = item.text();
            if item.checkState() == Qt.Checked:
                if item.isTristate():
                    subgame[name] = True;
                else:
                    subgame["sub" + name] = True;

        other = {};
        for widget in self.m_other:
            name = widget.objectName();
            wtyp = type(widget).__name__;

            if wtyp == "QLineEdit":
                other[name] = widget.text();
            elif wtyp == "QComboBox":
                other[name] = widget.currentText();
            pass

        hallName = self.getHallName();
        path = os.path.join(os.getcwd(), "userdata", "Settings", hallName);
        if not os.path.exists(path):
            os.makedirs(path);

        config = {"Option": option, "Subgame": subgame, "Other": other}
        filename = os.path.join(path, self.cbox_config.currentText() + "_Config.json");

        with open(filename, "w+") as file:
            file.write(jsonpickle.encode(config));
            file.close();
            print("配置页保存OK，" + self.cbox_config.currentText() + "_Config.json saved successfully..")
        pass

class ReleaseVersion:
    def __init__(self):
        pass

    def load(self,path):
        """
        load lua config
        """
        filename = path;
        try:
            file = open(filename, encoding='utf-8');
            content = file.read();

            lua_func = lua.eval(
                '''function (pyprint) 
                    print = function (...) 
                        local args = {...}; 
                        pyprint (table.unpack (args)); 
                    end  
                end'''
            );
            lua_func(print);
            self.versionTbl = lua.execute(content);

        except Exception as err:
            errmsg(err);

        pass

    def getVersion(self):
        RELEASE_TIME = self.versionTbl.RELEASE_TIME;
        # print (RELEASE_TIME);
        return RELEASE_TIME;
        pass

gReleaseVersion = ReleaseVersion ();


class LuaPM():
    def __init__(self):

        """
        load lua config
        """

        filename = "./config.lua";
        try:
            file = open(filename, encoding='utf-8');
            content = file.read();

            if isMacOS():
                lua.execute("IS_IOS=true");
            elif isWin():
                lua.execute("IS_ANDROID=true");
            else:
                pass

            lua_func = lua.eval(
                '''function (pyprint) 
                    print = function (...) 
                        local args = {...}; 
                        pyprint (table.unpack (args)); 
                    end  
                end'''
            );
            lua_func(print);
            print(lua.execute(content));

            """
            get config global data
            """
            self.luaglobals = lua.globals();

        except Exception as err:
            errmsg(err);

        pass

    def config(self):
        return self.luaglobals.config;

    def hallConfig(self,hallName):
        return self.luaglobals.config.game_type[hallName];

    def chConifg(self,hallName,chName):
        if isMacOS():
            return self.luaglobals.config.game_type[hallName].ios.chlconfig [chName];
        else:
            return self.luaglobals.config.game_type[hallName].android.chlconfig[chName];

    def chConfigs(self,hallName):
        if isMacOS():
            return self.luaglobals.config.game_type[hallName].ios.chlconfig ;
        else:
            return self.luaglobals.config.game_type[hallName].android.chlconfig;

    def platConfig(self,hallName):
        if isMacOS():
            return self.luaglobals.config.game_type[hallName].ios ;
        else:
            return self.luaglobals.config.game_type[hallName].android;

    def gameType(self):
        return self.luaglobals.config.game_type;

gLuaPM = LuaPM ();

