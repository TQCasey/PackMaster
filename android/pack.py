import os
import shutil
import time
from os import path
from xml.dom.minidom import parse

import jsonpickle
import pexpect
import zipfile

from pack import PackCommon, PackH5Common
from cmm import *
from profile import gLuaPM


class PackAndroid(PackCommon):

    def __init__(self,pmconfig,luaglobals,dict,batch_pack = False):
        super().__init__(pmconfig,None,dict,batch_pack);

        platconfig              = self.getPlatSettings();

        self.aab_path           = None;
        self.engine_dir         = os.path.join(platconfig.project_dir);
        self.src_ch_project_dir = os.path.join("channel_files", self.curGameHallName,"android", self.chName);
        
        # 优先使用渠道模板，然后游戏版本
        chlconfig               = gLuaPM.chConifg (self.hallName,self.chName);

        template_proj           = self.luaPlatConfig.template_proj;

        if not template_proj:
            template_proj       = chlconfig.template_proj;
        
        if not template_proj:
            template_proj       = gLuaPM.hallConfig(self.hallName).template_proj;

        if not template_proj:
            template_proj       = "proj.studio.androidx.ina";

        self.src_project_dir    = os.path.join("android","templates",template_proj);

        self.dst_project_dir    = os.path.join(platconfig.project_dir,"frameworks","runtime-src","proj.studio");
        self.lua_project_dir    = os.path.join(platconfig.project_dir);
        self.lua_src_dir        = os.path.join(platconfig.project_dir,"client");
        self.publish_dir        = os.path.join(platconfig.project_dir,"client","publish");
        self.dst_ch_project_dir = os.path.join(self.dst_project_dir,"app");
        self.use_ios            = False;

    def run(self):
        if not os.path.exists(self.dst_project_dir):
            rmsgbox("frameworks文件夹不存在，请运行mklink命令链接domino_engine");
            return ;

        platconfig = self.getPlatSettings();
        if not platconfig or platconfig.ndk_dir == "":
            rmsgbox("请配置ndk目录.");
            return ;

        if not platconfig or platconfig.project_dir == "":
            rmsgbox("请配置项目根目录.");
            return ;

        return super().run();

    def getPlatSettings(self):
        return self.pmconfig.getPlatSettings("android");


    def removeOldProjectDir(self):
        path = self.dst_project_dir
        print("removeOldProjectDir : " + path);

        try:
            """
            remove src res libs 
            """

            list = [];
            list.append(os.path.join(self.dst_project_dir,"app","src"))
            list.append(os.path.join(self.dst_project_dir,"app","res"))
            list.append(os.path.join(self.dst_project_dir,"app","libs"))

            for name in list:
                print ("removing project dir %s " % name)
                shutil.rmtree(name,ignore_errors=True);

            # shutil.rmtree(path,ignore_errors=True);

            pass
        except Exception as err:
            errmsg(err);

        pass

    def buildAAB(self):
        try:
            print("start to build android aab")
            gradlew = os.path.join(self.dst_project_dir, "gradlew.bat")
            cmdstr = '''%s %s''' % (gradlew, "bundleDebug" if self.use_debug else "bundleRelease");
            Commander().do(cmdstr,cwd=self.dst_project_dir);
            self.pack_aab_ok = True
        except Exception as err:
            errmsg("AAB包生成失败")
            errmsg(err)
            self.pack_aab_ok = False

    def doAfterBuildAAB(self):

        if not self.pack_aab_ok:
            return

        if self.use_debug:
            aab_path = os.path.join(self.dst_project_dir,"app","build","outputs","bundle","debug","app-debug.aab");
        else:
            aab_path = os.path.join(self.dst_project_dir,"app","build","outputs","bundle","release","app-release.aab");

        if os.path.exists(aab_path):
            # rename
            mode_name = "-debug-" if self.use_debug else "-release-"
            new_aab_path = os.path.join(self.lua_project_dir,"publish","android",self.curGameHallName,self.curGameHallName + mode_name + self.chName + "-" + self.vname + ".aab");
            if os.path.exists(new_aab_path):
                os.remove(new_aab_path);
            shutil.move(aab_path, new_aab_path);
            print("AAB包已生成：" + new_aab_path)
            self.aab_path = new_aab_path;
        else:
            errmsg("未发现aab包，请确认AAB打包是否OK！")

    def copyNewOldProjectDir(self):
        try:
            super ().copyNewOldProjectDir ();

            print ("Copy channel_files to dest project dir...");
            src = self.src_ch_project_dir;
            dst = self.dst_ch_project_dir;
            print ("Copy %s " %src);
            print ("To %s " % dst)
            recursive_overwrite (src,dst);

            print ("removing start_screen* files...")
            list = [];
            list.append(os.path.join(self.dst_project_dir,"res","drawable","start_screen.jpg"))
            list.append(os.path.join(self.dst_project_dir,"res","drawable","start_screen.9.png"));

            for name in list:
                if os.path.exists(name):
                    print ("removing file %s ... " % name)
                    os.remove(name);
        except Exception as err:
            errmsg (err);

    def copyExtralResource(self):
        try:
            print("copyExtralResource");
        except Exception as err:
            errmsg(err);

        pass

    '''复制新工程后，运行自定义Python脚本'''
    def runCustomPythonScript(self):
        filename = os.path.join(self.dst_ch_project_dir, "custom.py");
        if os.path.exists(filename):
            os.system("python3 " + filename);
            os.remove(filename);
        pass

    def makeAutoConfigFile(self):
        try:
            super().makeAutoConfigFile ();
        except Exception as err:
            errmsg(err);

        pass

    def _modifyAndroidManifestFile (self,filepath,use_local_push = False):
        try:

            domtree = parse(filepath);
            root = domtree.documentElement;
            root.setAttribute("android:versionName", self.vname);
            root.setAttribute("android:versionCode", self.vcode);

            allnodes    = root.getElementsByTagName('service');
            appnode     = root.getElementsByTagName('application');

            if not use_local_push:
                findnode = None;

                for node in allnodes:
                    if node.getAttribute("android:name") == "com.zhijian.common.LocalPushService":
                        findnode = node;
                        break;

                if findnode != None:
                    appnode[0].removeChild(findnode);

            if not self.use_new_act:
                findnode = None;

                for node in allnodes:
                    if node.getAttribute("android:name") == ".act.ActCenterActivity":
                        findnode = node;
                        break;

                if findnode != None:
                    appnode[0].removeChild(findnode);


            pass

            with open(filepath, "w+",encoding='utf-8') as file:
                domtree.writexml(file,encoding="utf-8");

        except Exception as err:
            errmsg (err);

    def prepareNativeResouce(self):
        try:
            print("prepareNativeResouce");
            channeldata = self.luaChConfig;
            full_path = os.path.join(self.dst_project_dir,"app","src");
            print ("make package directory for %s " % channeldata.name);
            packagename = channeldata.name;
            ppath = packagename.replace(".",os.path.sep);
            npath = os.path.join(full_path,ppath);
            oldpname = self.luaPlatConfig.oldpname;
            oldpackname = self.luaPlatConfig.oldpackname;

            if not os.path.exists(npath):
                os.makedirs (npath);

            '''印尼包保留该代码'''
            if not self.isThaiLang:
                print("prepare for FireBase files ...");
                gpath = os.path.join(full_path, "com", "AppFireBaseInstanceIDService.java");
                replaceFileContent(gpath, oldpname, channeldata.name);
                shutil.copy(gpath, npath);
                os.remove(gpath);

            print ("prepare for AppActivity file...")
            gpath = os.path.join(full_path,"org","cocos2dx","lua","AppActivity.java");
            replaceFileContent(gpath,oldpname,channeldata.name);

            print ("Prepare for new act center ...");
            gpath = os.path.join(full_path, "com", "act");
            if os.path.exists(gpath):
                dirs = os.listdir(gpath);
                for dir in dirs:
                    filepath = os.path.join(gpath,dir);
                    replaceFileContent(filepath, oldpname, channeldata.name);

                dst_dir = os.path.join(npath,"act");
                if os.path.exists(dst_dir):
                    shutil.rmtree(dst_dir);

                shutil.copytree(gpath,dst_dir)
                shutil.rmtree(gpath);

            print ("replacing with new package name(%s ==> %s) ..." %(oldpname,channeldata.name));
            gpath = os.path.join(full_path,"com","MyFirebaseMessagingService.java");
            replaceFileContent(gpath, oldpname, channeldata.name);
            shutil.copy(gpath,npath);
            os.remove(gpath);

            print ("WebHandler.java : replacing with new package name(%s ==> %s) ..." %(oldpname,channeldata.name));
            gpath = os.path.join(full_path,"org","cocos2dx","lib","WebHandler.java");
            replaceFileContent(gpath, oldpname, channeldata.name);
            shutil.copy(gpath,npath);
            os.remove(gpath);

            print ("replace all %s.R files to %s.R" % (oldpname,channeldata.name));
            all = os.walk(full_path);
            for path, dir, filelist in all:
                for filename in filelist:
                    if filename.endswith("java"):
                        java_path = os.path.join(path,filename);
                        print ("replacing %s " % java_path);
                        replaceFileContent (java_path,oldpackname,channeldata.name + ".R");

            if self.use_local_push:
                print ("we use local push service here ...");
            else:
                print ("remove local push service...");

            print ("modify the versions etc in AndroidManifest.xml file ....");
            path = os.path.join(self.dst_project_dir,"app","AndroidManifest.xml");
            self._modifyAndroidManifestFile (path,False);

            ## replace again ....
            replaceFileContent(path,oldpackname,channeldata.name + ".R");

            # clean project
            print(" ----------------- gradle clean project ----------------- ")
            Commander().do('gradlew clean', cwd=self.dst_project_dir, env=os.environ.copy());

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

    def zipAllFile(self):
        super().zipAllFile(self.use_v2030 == False);

    def _pvrResFilesImpl(self):
        self._pvrResFiles("1>nul");

    def _etc2ResFiles(self):
        super()._etc2ResFiles(os.path.join("common","etc2"),"1>nul","");
        pass

    def makeVersionFiles (self):
        try:

            print("makeVersionFiles");

            #### config_version file
            print ("make config_version file");
            self._makeConfigVersionFile(os.path.join(self.publish_dir,"base","src","com","config_version.lua"));

            #### appversions file
            print ("make version for engine.appversion.h")
            app_versions_filepath = os.path.join(self.engine_dir,"frameworks","runtime-src","Classes","appversion.h");
            android_bugly_appid = self.luaPlatConfig.bugly_appid
            self._makeAppVersionFile(app_versions_filepath,android_bugly_appid,"");

        except Exception as err:
            errmsg(err);

        pass

    def cryptZipFile(self):
        self._cryptZipFile (precmd="");
        pass

    def doBeforeBuildAction(self):
        try:
            print("doBeforeBuildAction");

            # 自定义脚本运行检查
            self.runCustomPythonScript();

        except Exception as err:
            errmsg(err);
        pass

    def buildAll(self):
        try:
            print("start buildAll");
            isdebug = "debug" if self.use_debug else "release";
            cmdstr = '''cocos compile -m %s -p android --android-studio''' % (isdebug);
            Commander().do(cmdstr,cwd=self.lua_project_dir);
        except Exception as err:
            errmsg(err);

        pass

    def doAfterBuildAction(self):
        try:
            print("doAfterBuildAction");
            if not self.use_debug:
                apk_path = os.path.join(self.lua_project_dir,"publish","android","app-release-signed.apk");
                if os.path.exists(apk_path):

                    # rename
                    apk_dir = os.path.join(self.lua_project_dir,"publish","android",self.curGameHallName);
                    if not os.path.exists(apk_dir):
                        os.makedirs(apk_dir);

                    new_apk_path = os.path.join(apk_dir,self.curGameHallName + "-release-" + self.chName + "-" + self.vname + ".apk");
                    if os.path.exists(new_apk_path):
                        os.remove(new_apk_path);

                    shutil.move(apk_path,new_apk_path);
                    self.app_path = new_apk_path;
                    self.PACK_OK = True;
                else:
                    self.PACK_OK = False;
            else:
                apk_path = os.path.join(self.lua_project_dir,"simulator","android","app-debug.apk");
                if os.path.exists(apk_path):
                    # rename

                    apk_dir = os.path.join(self.lua_project_dir,"publish","android",self.curGameHallName);
                    if not os.path.exists(apk_dir):
                        os.makedirs(apk_dir);

                    new_apk_path = os.path.join(apk_dir,self.curGameHallName + "-debug-" + self.chName + "-" + self.vname + ".apk");
                    if os.path.exists(new_apk_path):
                        os.remove(new_apk_path);

                    shutil.move(apk_path,new_apk_path);
                    self.app_path = new_apk_path;
                    self.PACK_OK = True;
                else:
                    self.PACK_OK = False;
                pass

        except Exception as err:
            errmsg(err);

        pass

    def finallyDone(self):
        return self.app_path;

class PackH5Android(PackH5Common):

    def __init__(self,param):
        super().__init__(param);

        self.creator_exe_path = '''D:\\CocosCreator\\CocosCreator.exe''';
        self.project_path = '''D:\\GapleJS''';

    def pack(self):
        if 'make_res' in self.param and self.param ['make_res'] == True:
            self.dealWithResources();
        else:
            self.prepareResources();
            self.dealWithResources();
            self.buildAll();
        pass

    def prepareResources (self):
        exepath = self.creator_exe_path;
        projpath = self.project_path;

        cmdstr = '''chcp 65001 && %s --path %s --build "platform=android;debug=false;md5Cache=false"''' % (exepath,projpath);
        Commander().do (cmdstr)
        pass

    def _etc2PNGFiles(self):
        assets_path = os.path.join(self.project_path,"build","jsb-link","res","raw-assets");
        precmd = "";
        redirect = "1>nul";
        cwd = os.path.join("common","etc2")

        all = os.walk(assets_path);
        for path, dir, filelist in all:
            for filename in filelist:
                if filename.endswith("png"):
                    filepath = os.path.join(path, filename);
                    print("compress pngres %s to etc2..." % filename);
                    cmdstr = ('''%s %s %s %s -c etc2 -s slow -f RGBA8 -ext PNG %s''' % (precmd, os.path.join(".", "etcpack"), filepath, path, redirect));

                    my_env = {};
                    etc_path = os.path.abspath(os.path.join(os.path.curdir, "common", "etc2"));
                    my_env["PATH"] = etc_path + ":" + my_env["PATH"]

                    Commander().do(cmdstr, cwd, env=my_env);
                    # print ("Done");
                    pkmfilepath = filepath.replace(".png", ".pkm");
                    if os.path.exists(pkmfilepath):
                        os.remove(filepath);
                        shutil.move(pkmfilepath, filepath);
                        ## back up with etc2cache

    def _pngquantPNGFiles(self):
        assets_path = os.path.join(self.project_path,"build","jsb-link","res","raw-assets","Texture");
        cmd = os.path.join(".", "common", "pngquant", "pngquant");
        precmd = "chmod +x %s ; " % cmd;

        if isWin():
            precmd = "";

        all = os.walk(assets_path);
        for path, dir, filelist in all:
            for filename in filelist:
                if filename.endswith("png"):
                    filepath = os.path.join(path, filename);
                    print("compress raw pngfiles %s with pngquant" % (filename));
                    cmdstr = '''%s %s -f --ext .png --speed 1 --skip-if-larger %s ''' % (precmd, cmd, filepath);
                    Commander().do(cmdstr);

    def _removeMediaBase64Files(self):
        assets_path = os.path.join(self.project_path,"build","jsb-link","res","raw-assets","resources");
        all = os.walk(assets_path);
        for path, dir, filelist in all:
            for filename in filelist:
                if filename.endswith("json"):
                    filepath = os.path.join(path, filename);
                    print("removeMediaBase64 Json File %s" % (filename));

                    if os.path.exists(filepath):
                        os.remove(filepath);

                    # obj = None;
                    # with open (filepath,"r") as file:
                    #     obj = jsonpickle.decode(file.read());
                    #     del  obj ['audio'];
                    #     # print ("OK");
                    #
                    # with open (filepath,"w") as file:
                    #     file.write(jsonpickle.encode(obj,unpicklable=True));

    def dealWithResources(self):
        # self._etc2PNGFiles ();
        self._pngquantPNGFiles ();
        self._removeMediaBase64Files();
        pass

    def buildAll(self):
        exepath = self.creator_exe_path;
        projpath = self.project_path;

        bSucc = False;

        """
        use android apk
        """
        cmd = '''chcp 65001 && %s --path %s --compile "platform=android;debug=false;md5Cache=false"''' % (exepath,projpath);
        try:
            process = subprocess.Popen(cmd,
                                       shell=True,
                                       bufsize=0,
                                       stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT,
                                       encoding='utf-8',
                                       universal_newlines=True);
            while True:
                output = process.stdout.readline()
                if output != None:
                    output = output.strip();
                    if output != "":
                        print(output);
                if output == "" and process.poll() != None:
                    break;
                if output.find("Compile native project successfully") > 0:
                    time.sleep(1)
                    process.kill();
                    bSucc = True;
                    break;
        except Exception as err:
            errmsg(err);

        if not bSucc:
            return ;

        if self.param['use_aab'] == True:
            """
            use android app bundle 
            """
            cwd = os.path.join(self.project_path,"build","jsb-link","frameworks","runtime-src","proj.android-studio")
            exepath = os.path.join(".","gradlew")
            cmd = '''%s bundleRelease''' % (exepath);
            try:
                process = subprocess.Popen(cmd,
                                           shell=True,
                                           bufsize=0,
                                           stdout=subprocess.PIPE,
                                           stderr=subprocess.STDOUT,
                                           encoding='utf-8',
                                           cwd=cwd,
                                           universal_newlines=True);
                while True:
                    output = process.stdout.readline()
                    if output != None:
                        output = output.strip();
                        if output != "":
                            print(output);
                    if output == "" and process.poll() != None:
                        break;

                output_dir = os.path.join(self.project_path, "build", "jsb-link", "frameworks", "runtime-src",
                                          "proj.android-studio", "app", "build", "outputs", "bundle", "release");
                files = os.listdir(output_dir);
                for file in files:
                    if file.find("aab"):
                        path = os.path.join(output_dir, file);
                        dst_path = os.path.join(self.project_path, "publish", "android");
                        if not os.path.exists(dst_path):
                            os.makedirs(dst_path);
                        if os.path.exists(os.path.join(dst_path,file)):
                            os.remove(os.path.join(dst_path,file));
                        shutil.move(path, dst_path);
                        aab_path = os.path.join(dst_path,file);
                        if (os.path.exists(aab_path)):
                            rmsgbox("Pack OK\nPath ==> %s" % aab_path);

            except Exception as err:
                errmsg(err);
            pass
        else:

            apk_src_path    = os.path.join(self.project_path, "build", "jsb-link", "publish", "android","gapleJS-release-signed.apk");
            apk_dst_dir     = os.path.join(self.project_path,"publish","android");
            dst_apk_path    = os.path.join(apk_dst_dir,"gapleJS-release-signed.apk");

            if not os.path.exists(apk_dst_dir):
                os.makedirs(apk_dst_dir);

            if os.path.exists(apk_src_path):
                if os.path.exists(dst_apk_path):
                    os.remove(dst_apk_path);
                shutil.move(apk_src_path,apk_dst_dir);
                rmsgbox("Pack OK\nApp Path => %s" % dst_apk_path)
