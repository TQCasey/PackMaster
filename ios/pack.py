import shutil
import struct

from pack import PackCommon, PackH5Common
from cmm import *
from profile import *


class PackIOS(PackCommon):
    def __init__(self, pmconfig, luaglobals,batch_pack = False):
        super().__init__(pmconfig, None,batch_pack);

        platconfig = self.getPlatSettings();
        path = platconfig.engine_dir;
        self.engine_dir = path.replace("~", os.environ['HOME']);

        self.dst_project_dir = os.path.join(self.engine_dir, "frameworks","runtime-src","proj.ios_mac");
        self.publish_dir = os.path.join(self.engine_dir, "client", "publish");

        path = os.path.join("channel_files",self.curGameHallName,"ios",self.chName,"proj.ios_mac"); ##   self.luaChConfig.ios_proj_ios_mac_dir;
        self.src_ch_project_dir = path.replace("~", os.environ['HOME']);

        path    = os.path.join("ios","templates","proj.ios_mac");
        self.src_project_dir = path.replace("~", os.environ['HOME']);

        path = os.path.join(platconfig.project_dir);
        self.lua_project_dir = os.path.join(path.replace("~", os.environ['HOME']));
        self.lua_src_dir = os.path.join(self.lua_project_dir, "client");
        self.ipa_path = "";
        self.arch_path = "";
        self.use_ios    = True;

        self.plist_group = self.luaChConfig.plist_group;
        if not self.plist_group:
            self.plist_group = self.luaPlatConfig.plist_group;

    def run(self):
        platconfig = self.getPlatSettings();
        if not platconfig or not platconfig.engine_dir or platconfig.engine_dir == "":
            rmsgbox("请设置 engine_dir ");
            return ;

        if not self.plist_group:
            rmsgbox("请设置 plist_group ");
            return ;

        return super().run();

    def exportIpa(self,archPath,exportAppStore = False,needAlert = False):
        try:
            scheme = self.getIpaName(archPath);
            print ("Export Scheme (%s)Arch File : %s" %(scheme,archPath));
            archdir = os.path.dirname(archPath);
            self.exportIPALocal(archPath,archdir,scheme,exportAppStore);

            if needAlert == True:
                if self.PACK_OK and os.path.exists(self.ipa_path):
                    rmsgbox("Export OK \nIPA Path => %s" % self.ipa_path);
                else:
                    rmsgbox("Export Failed\nBad Bad Bad!                  ")

        except Exception as err:
            errmsg(err);
        pass

    def getPlatSettings(self):
        return self.pmconfig.getPlatSettings("ios");

    def copyNewOldProjectDir(self):
        try:
            super ().copyNewOldProjectDir ();

            print ("Copy channel_files to dest project dir...");
            src = self.src_ch_project_dir;
            dst = self.dst_project_dir;
            print ("Copy %s " %src);
            print ("To %s " % dst)
            shutil.copytree(src, dst, symlinks=True,dirs_exist_ok=True);

        except Exception as err:
            errmsg (err);

    def copyExtralResource(self):
        try:
            print("copyExtralResource");
        except Exception as err:
            errmsg(err);

        pass

    def makeAutoConfigFile(self):
        try:
            super().makeAutoConfigFile ();
        except Exception as err:
            errmsg(err);

        pass

    def prepareNativeResouce(self):
        try:
            print("prepareNativeResouce");
        except Exception as err:
            errmsg(err);

        pass

    def isInGameList(self, gamename):
        try:
            i = self.game_list.index(gamename);
        except:
            return False;
        else:
            return True;
        pass

    def _pvrResFilesImpl(self):
        self._pvrResFiles();

    def _etc2ResFiles(self):
        super()._etc2ResFiles(os.path.join("common", "etc2"),"1>/dev/null");
        pass

    def makeVersionFiles (self):
        try:

            print("makeVersionFiles");

            """
            config_version file
            """
            print ("make config_version.h")
            self._makeConfigVersionFile(os.path.join(self.publish_dir,"base","src","com","config_version.lua"));

            """
            appversions file
            """
            print("make version for engine.appversion.h")
            app_versions_filepath = os.path.join(self.engine_dir,"frameworks","runtime-src","Classes","appversion.h");
            bugly_appid = self.luaPlatConfig.bugly_appid;
            self._makeAppVersionFile(app_versions_filepath,"",bugly_appid);

            """
            make versions for xcode
            """
            print ("make version for xcode project")
            vname = self.curChConfig.vname ;
            vcode = self.curChConfig.vcode;
            plist_path = os.path.join(self.dst_project_dir,"ios","Info.plist");

            cmd = '''/usr/libexec/PlistBuddy -c 'Set :CFBundleShortVersionString  %s' %s''' % (self.shortVerName,plist_path);
            Commander().do (cmd);

            cmd = '''/usr/libexec/PlistBuddy -c 'Set :CFBundleVersion %s' %s''' % (vcode,plist_path);
            Commander().do (cmd);

        except Exception as err:
            errmsg(err);

        pass

    def cryptZipFile(self):
        self._cryptZipFile ();
        pass

    def doBeforeBuildAction(self):
        try:
            print("doBeforeBuildAction");
        except Exception as err:
            errmsg(err);

        pass

    def exportIPALocal(self,archfilepath,archpath,scheme,exportAppStore = False):
        try:

            plistname = os.path.join("ios","export_plist",self.plist_group,"appstoreExportOptions.plist")
            devname = "_dis";
            if not exportAppStore:
                plistname = os.path.join("ios","export_plist",self.plist_group,"developExportOptions.plist")
                devname = "_dev"
            ipa_path_src = os.path.join(archpath,scheme + ".ipa");
            ipa_path_dst = os.path.join(archpath,self.curGameHallName + devname + ".ipa");

            if (os.path.exists(ipa_path_dst)):
                os.remove(ipa_path_dst);

            if os.path.exists(archfilepath):
                cmdstr = '''xcodebuild -allowProvisioningUpdates -exportArchive -exportOptionsPlist %s -archivePath %s -exportPath %s''' % (plistname,archfilepath,archpath);
                cwd = os.path.join(self.dst_project_dir);
                Commander().do (cmdstr);

                """
                避免空格的路径，重命名一下
                """
                shutil.move(ipa_path_src,ipa_path_dst);

                self.ipa_path = ipa_path_dst;
                if os.path.exists(ipa_path_dst):
                    self.PACK_OK = True;

        except Exception as err:
            errmsg(err);

    def getSchemeName(self):
        try:
            dirs = os.listdir(self.src_ch_project_dir);
            scheme = "";

            for dir in dirs:
                if dir.find("xcodeproj") > 0:
                    filen, fileext = os.path.splitext(dir);
                    scheme = filen;
                    break;

            return scheme;

        except Exception as err:
            errmsg(err);

    def getIpaName(self,archfilepath):
        try:
            dSYMsPath = os.path.join(archfilepath,"dSYMs");

            if not os.path.exists(dSYMsPath):
                return "";

            dirs = os.listdir(dSYMsPath);
            scheme = "";

            for dir in dirs:
                if dir.find("app.dSYM") > 0:
                    filen, fileext = os.path.splitext(dir);
                    filen = filen.replace(".app","");
                    scheme = filen;
                    return scheme;

            return scheme;

        except Exception as err:
            errmsg(err);

    def buildAll(self):
        try:
            print("start buildAll");
            archpath = os.path.join(self.lua_project_dir,"publish","ios",self.curGameHallName,self.chName + "-" + self.vname);
            if os.path.exists(archpath):
                shutil.rmtree(archpath);

            if not os.path.exists(archpath):
                os.makedirs(archpath);

            self.PACK_OK = False;

            archfilepath = os.path.join(archpath,"build.xcarchive")
            scheme = self.getSchemeName ();

            self.arch_path = archfilepath;
            cmdstr = ''' xcodebuild archive -allowProvisioningUpdates -scheme "%s iOS" -archivePath %s''' % (scheme,os.path.join(archpath,"build"));
            cwd = os.path.join(self.dst_project_dir);
            Commander().do (cmdstr,cwd=cwd);

            self.exportIPALocal (archfilepath,archpath,self.getIpaName(archfilepath))

        except Exception as err:
            errmsg(err);

        pass

    def doAfterBuildAction(self):
        try:
            print("doAfterBuildAction");
        except Exception as err:
            errmsg(err);

        pass

    def zipAllFile(self):
        super().zipAllFile(self.use_v2030 == False);

    def finallyDone(self):
        try:
            if self.PACK_OK:
                new_apk_path = self.ipa_path;
                return new_apk_path;

        except Exception as err:
            errmsg(err);

        pass

class PackH5IOS(PackH5Common):
    def pack(self):
        pass
