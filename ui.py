import hashlib
import time
import re
import jsonpickle

import pexpect as pexpect
from PyQt5 import Qt, QtCore, QtWidgets
from PyQt5.QtCore import QThread
from PyQt5.QtGui import QIntValidator, QIcon
from PyQt5.QtWidgets import *
from PyQt5.uic import loadUi
from android.gameprofile import GameProfileDialogAndroid
from android.pack import PackAndroid, PackH5Android
from changelistdlg import AlertChangeList
from cmm import *
from filterlist import FilterListDialogBase
from inputbox import  inputdlg
from ios.gameprofile import GameProfileDialogIOS
from ios.pack import PackIOS, PackH5IOS
from langman import LangManDialog
from iconmaker import IconMakerDialog
from svnuploader import SvnUploader
from plugins.Logger.logger import DebugLogger
from preference import PreferDialog
from profile import PMConfig, gFilterList, gPMConfig, PageConfig, gWhiteList, gLuaPM,  gReleaseVersion,get_home_dir

from whitelist import WhiteListDialog


'''
线程基类
'''
class ThreadBaseClass(QThread):
    def __init__(self, parent=None, luaglobals=None, dict=None):
        super(ThreadBaseClass, self).__init__();
        self.pmconfig = PMConfig(gPMConfig.configCurrentToString(), 0);
        self.mainObj = parent;
        self.dict = dict;
        self.msgbox_ret = None;

        self.inputInfo = None;

        gsignal.msg_ret_trigger.connect(self.onMsgBoxRet)
        gsignal.input_ret_trigger.connect(self.onInputRet)

        start_pack();

    def onMsgBoxRet(self, ret):
        # print ("ret = %d" % (ret));
        self.msgbox_ret = ret;
        pass

    def onInputRet(self,info):
        self.inputInfo = info;

    def askbox(self, msg):
        raskbox(msg);
        while self.msgbox_ret == None:
            time.sleep(0.3);

        ret = self.msgbox_ret
        self.msgbox_ret = None;
        return ret;

    def inputbox(self,dict):
        rinputbox (dict);
        while self.inputInfo == None:
            time.sleep(0.3);

        info = self.inputInfo
        self.inputInfo = None;
        return info;

    def run(self):
        print("do nothing ...");
        # start_pack();

    def saybye(self):
        done_pack(0);


'''
打包线程
'''
class PMThread(ThreadBaseClass):

    def run(self):

        try:
            pack = None;

            if isMacOS() == True:
                pack = PackIOS(self.pmconfig, None, self.dict);
            elif isWin():
                pack = PackAndroid(self.pmconfig, None, self.dict);

            app_path = pack.run();
            aab_path = None;

            if pack.PACK_OK == True and app_path:

                if isMacOS():
                    msg = "恭喜你，IPA 打包成功了,世界第9大奇迹诞生 !!\nIPA路径 : %s \n弱弱地问下,你需要导出AppStore包么 ?";
                else:
                    msg = "恭喜你，APK 打包成功了,世界第9大奇迹诞生 !!\nAPK路径 : %s \n弱弱地问下,那你需要打AAB包么 ?";

                if 1024 == self.askbox(msg % (app_path)):

                    if isMacOS():
                        pack.exportIpa(pack.arch_path, True);
                        ipa_path = pack.ipa_path;
                        pass
                    else:
                        pack.buildAAB();
                        pack.doAfterBuildAAB();
                        aab_path = pack.aab_path;
                else:
                    msg = "那你需要上传符号表么?";

                if isMacOS():
                    if pack.ipa_path:
                        msg = "恭喜你，AppStore 包导出成功了,世界第10大奇迹诞生 !!\nAppStore包路径 : %s\n那你需要上传符号表么?" % (pack.ipa_path)
                else:
                    if pack.aab_path:
                        msg = "恭喜你，AAB 打包成功了,世界第10大奇迹诞生 !!\nAAB路径 : %s\n那你需要上传符号表么?" % (pack.aab_path)

                if msg and 1024 == self.askbox(msg):
                    print("正在上传符号表....");

                    pmconfig = self.pmconfig;
                    self.hallName = pmconfig.getCurHallName();
                    self.chName = pmconfig.getCurChName();
                    self.curChConfig = pmconfig.getCurChConfig();
                    self.luaConfig = gLuaPM.config();

                    if isMacOS():
                        self.mainObj.onProceedUploadSymTbl(
                            hallName=self.hallName,
                            chName=self.chName,
                            curChConfig=self.curChConfig,
                            isSpecDir=True,
                            objDir=pack.arch_path,
                        );
                    else:
                        self.mainObj.onProceedUploadSymTbl(
                            hallName=self.hallName,
                            chName=self.chName,
                            curChConfig=self.curChConfig,
                            isSpecDir=False,
                        );

                    pass
            else:
                rmsgbox("很遗憾的告诉你，APK/IPA 打包失败了，这个是为啥咧，为啥咧，为啥咧\n先看日志呗...");

        except Exception as err:
            errmsg(err);
        finally:
            super().saybye();


'''
图集重新打包线程
'''
class RepackThread(ThreadBaseClass):

    def __init__(self, parent, inputDir):
        super(RepackThread, self).__init__(parent);
        self.inputDir = inputDir;
        start_pack();

    def run(self):

        try:
            from repack import repackWithDir
            repackWithDir(self.inputDir);
            rmsgbox("Repack Done!")
        except Exception as err:
            errmsg(err);
        finally:
            done_pack(0);


'''
导出签名IPA包线程
'''
class ExportIpaThread(ThreadBaseClass):

    def __init__(self, parent, luaglobals, archPath):
        super(ExportIpaThread, self).__init__(parent);
        self.pmconfig = PMConfig(gPMConfig.configCurrentToString(), 0);
        self.mainObj = parent;
        self.archPath = archPath;

        start_pack();

    def run(self):

        try:
            pack = None;

            if isMacOS() == True:
                pack = PackIOS(self.pmconfig, None);
            elif isWin():
                pack = PackAndroid(self.pmconfig, None);

            pack.exportIpa(self.archPath, exportAppStore=False, needAlert=True);

        except Exception as err:
            errmsg(err);
        finally:
            done_pack(0);


'''
生成自动图集
'''
class SyncAutoTexThread(ThreadBaseClass):

    def __init__(self, parent,luaglobals,dict):
        super(SyncAutoTexThread, self).__init__(parent,luaglobals,dict);
        self.pmconfig = PMConfig(gPMConfig.configCurrentToString(), 0);
        self.mainObj = parent;
        self.dict = dict;

        start_pack();

    def run(self):

        try:
            pack = None;

            if isMacOS() == True:
                pack = PackIOS(self.pmconfig,None, self.dict);
            elif isWin():
                pack = PackAndroid(self.pmconfig,None, self.dict);

            pack.syncAutoTex();

        except Exception as err:
            errmsg(err);
        finally:
            done_pack(0);

'''
生成图集yaml
'''
class MakeYamlThread(ThreadBaseClass):

    def __init__(self, parent,luaglobals,dict):
        super(MakeYamlThread, self).__init__(parent,luaglobals,dict);
        self.pmconfig = PMConfig(gPMConfig.configCurrentToString(), 0);
        self.mainObj = parent;
        self.dict = dict;

        start_pack();

    def run(self):

        try:
            pack = None;

            if isMacOS() == True:
                pack = PackIOS(self.pmconfig,None, self.dict);
            elif isWin():
                pack = PackAndroid(self.pmconfig,None, self.dict);

            pack.makeYaml();

        except Exception as err:
            errmsg(err);
        finally:
            done_pack(0);

"""
检查语法线程
"""
class CheckSyntaxThread(ThreadBaseClass):

    def __init__(self, parent=None, luaglobals=None):
        super(CheckSyntaxThread, self).__init__(parent);

        self.pmconfig = PMConfig(gPMConfig.configCurrentToString(), 0);
        self.mainObj = parent;
        self.dict = dict;
        start_pack();

    def saybye(self):
        done_pack(0);

    def run(self):

        pmconfig = self.pmconfig;

        try:
            pack = None;

            if isMacOS() == True:
                pack = PackIOS(pmconfig, None, self.dict);
            elif isWin():
                pack = PackAndroid(pmconfig, None, self.dict);

            pack.onCheckSyntaxImpl();

        except Exception as err:
            errmsg(err);
        finally:
            self.saybye();
            print("Check Syntax Done!")


"""
上传bugly符号表线程
"""
class UploadThread(ThreadBaseClass):

    def __init__(self, parent, luaglobals, isSpecDir, objDir, mappingFileDir):
        super(UploadThread, self).__init__(parent);
        self.pmconfig = PMConfig(gPMConfig.configCurrentToString(), 0);
        self.mainObj = parent;

        self.isSpecDir = isSpecDir;
        self.objDir = objDir;
        self.mapppingFileDir = mappingFileDir;

        start_pack();

    def run(self):
        try:

            pmconfig = self.pmconfig;
            self.hallName = pmconfig.getCurHallName();
            self.chName = pmconfig.getCurChName();
            self.curChConfig = pmconfig.getCurChConfig();

            self.mainObj.onProceedUploadSymTbl(
                hallName=self.hallName,
                chName=self.chName,
                curChConfig=self.curChConfig,

                isSpecDir=self.isSpecDir,
                objDir=self.objDir,
                mapppingFileDir=self.mapppingFileDir
            );

        except Exception as err:
            errmsg(err);
        finally:
            super().saybye();


"""
生成配置线程
"""
class MakeConfigThread(ThreadBaseClass):
    def run(self):

        pmconfig = self.pmconfig;
        try:

            pack = None;

            if isMacOS() == True:
                pack = PackIOS(pmconfig, None, self.dict);
            else:
                pack = PackAndroid(pmconfig, None, self.dict);

            pack.makeConfigsForDebug();

        except Exception as err:
            errmsg(err);
        finally:
            super().saybye();
            rmsgbox("Make Config OK")


"""
生成assets线程
"""
class MakeAssetsThread(ThreadBaseClass):
    def run(self):

        pmconfig = self.pmconfig;

        try:

            pack = None;

            if isMacOS() == True:
                pack = PackIOS(pmconfig, None, self.dict);
            elif isWin():
                pack = PackAndroid(pmconfig, None, self.dict);

            pack.makeAssets();

        except Exception as err:
            errmsg(err);
        finally:
            super().saybye();


"""
编译线程
"""
class BuildThread(ThreadBaseClass):
    def run(self):

        pmconfig = self.pmconfig;

        try:

            pack = None;

            if isMacOS() == True:
                pack = PackIOS(pmconfig, None, self.dict);
            elif isWin():
                pack = PackAndroid(pmconfig, None, self.dict);

            pack.buildAll();

        except Exception as err:
            errmsg(err);
        finally:
            super().saybye();


"""
生成工程线程
"""
class MakeNativeProjectThread(ThreadBaseClass):
    def run(self):

        pmconfig = self.pmconfig;

        try:

            pack = None;

            if isMacOS() == True:
                pack = PackIOS(pmconfig, None, self.dict);
            elif isWin():
                pack = PackAndroid(pmconfig, None, self.dict);

            pack.onMakeNativeProject();
            rmsgbox("生成原生工程成功!")

        except Exception as err:
            errmsg(err);
        finally:
            super().saybye();



"""
提交svn
"""
class SvnUploadThread(ThreadBaseClass):
    def run(self):

        pmconfig = self.pmconfig;

        try:

            pack = None;

            if isMacOS() == True:
                pack = PackIOS(pmconfig, None, self.dict);
            elif isWin():
                pack = PackAndroid(pmconfig, None, self.dict);

            project_dir = self.dict ["project_dir"]
            hotupdate_dir_root = self.dict ["hotupdate_dir_root"];
            whitelist_path = self.dict ["whitelist_path"];
            delaysubmit_path = self.dict ["delaysubmit_path"];
            cnd_url = self.dict ["cnd_url"];

            isDebugServer = self.dict ["isDebugServer"];
            isWhitelistUpdate = self.dict ["isWhitelistUpdate"];

            svnldr = SvnUploader();
            svnldr.setRepRoot(project_dir);
            svnldr.setDelayConfigFile(delaysubmit_path)
            svnldr.setNetworkUrl(cnd_url);

            # svnldr.update();

            svnldr.makeCDNVerifyFile();

            svnldr.fetchChanges();
            svnldr.removeAllChangeLists();
            svnldr.fetchChanges();
            #
            svnldr.setResListChangeList('resource');
            svnldr.setDelayListChangeList('version');

            info = self.inputbox({
                "title" : "准备提交资源，请务必确认一次，如果ok，请输入此次提交的内容描述:",
            });

            ret = info ["ret"];
            msg = info ["msg"];

            if ret >= 0:
                if msg == "":
                    msg = "自动提交内容 "

                print ("正在提交资源部分....")
                svnldr.uploadChangeList('resource', msg);
                if 1024 == self.askbox("\n开始验证资源可用么?\n\n"):
                    print("正在验证此次提交是否有效....")

                    isLoop = True;
                    while isLoop:
                        if True == svnldr.verifyNetwork():
                            isLoop = False;
                            if 1024 == self.askbox("\n验证OK了，开始提交版本文件么?\n\n"):
                                svnldr.uploadChangeList('version', msg);

                                gReleaseVersion.load(os.path.join(project_dir,"hall","domino_version.lua"));
                                version = gReleaseVersion.getVersion();

                                srvType = "内网";
                                if not isDebugServer:
                                    srvType = "正式服";

                                typmsg = "非白名单";
                                if isWhitelistUpdate:
                                    typmsg = "白名单"

                                # msg = "1.askoashdhasdhasdhk.\n2.ashdfkjahsjkdfhkjasdhfkahfj";
                                text = \
'''
==============================================================================
%s-%s更新,版本号 %s
==============================================================================
%s
                                ''' % (srvType, typmsg, version, msg)

                                self.inputbox({
                                    "title": "恭喜了，恭喜了,提交成功，把下面的信息发布出去给小伙伴们分享吧",
                                    "text": text,
                                    "readonly": True,
                                })
                            pass

                        else:
                            if 1024 == self.askbox("\n验证失败了，重试么?\n\n"):
                                print("验证失败，请排查问题...");
                            else:
                                print ("验证失败，您取消了验证，请排查问题...")
                                isLoop = False;

            pass

        except Exception as err:
            errmsg(err);
        finally:
            super().saybye();

"""
发布
"""
class PublishAllThread(ThreadBaseClass):
    update_version_trigger = pyqtSignal(dict);

    def __init__(self, parent, luaglobals, dict):
        super(PublishAllThread, self).__init__(parent);
        self.pmconfig = PMConfig(gPMConfig.configCurrentToString(), 0);
        self.mainObj = parent;
        self.dict = dict;

        self.changelist_ret = None;

        gsignal.alert_ret_changelist_trigger.connect(self.onChangeListRet)

        start_pack();

    def onChangeListRet(self, ret):
        # print ("ret = %d" % (ret));
        self.changelist_ret = ret;
        pass

    def ask_changeList(self, dict):
        rchangelistbox(dict);
        while self.changelist_ret == None:
            time.sleep(0.3);

        ret = self.changelist_ret
        self.changelist_ret = None;
        return ret;

    def run(self):

        pmconfig = self.pmconfig;
        try:
            pack = None;

            if isMacOS() == True:
                pack = PackIOS(pmconfig, None, self.dict);
            elif isWin():
                pack = PackAndroid(pmconfig, None, self.dict);

            if not isMacOS():
                print("自动同步到最新时间...");
                Commander().do('''w32tm /config /manualpeerlist:"210.72.145.44" /syncfromflags:manual /reliable:yes /update''');

            pack.startPublishAll();

            if 1024 == self.askbox ("是否将 %s 目录更新到最新" % (pack.publish_dir)):
                print("%s 目录更新到最新...." % (pack.publish_dir));
                if isMacOS():
                    cmdstr = '''cd %s && svn up''' % (os.path.join(pack.publish_dir))
                else:
                    cmdstr = '''cd /d %s && svn up''' % (os.path.join(pack.publish_dir))
                # print (cmdstr);
                Commander().do(cmdstr);

            pack.publishBaseAndHall();
            pack.publishGame();

            pack.doLastThing(self.update_version_trigger,None);

            '''
            最终包1
            '''
            pack.doFinalThing1(self.update_version_trigger);

            dict = pack.figureoutChangedInfo();
            self.ask_changeList(dict);

        except Exception as err:
            errmsg(err);
        finally:
            print ("恭喜恭喜，生成大厅热更成功了 !,今天那可以买体彩大乐透");
            rmsgbox("恭喜恭喜，生成大厅热更成功了 !\n今天那可以买体彩大乐透\n");
            self.saybye();

    def saybye(self):
        done_pack(0);


"""
链接adb线程
"""
class DevThread(ThreadBaseClass):
    def __init__(self, parent, luaglobals, emulator=None):
        super(DevThread, self).__init__(parent, None);
        self.m_emulator = emulator;

    def run(self):
        try:
            # print ("connecting device...");
            self.mainObj.getDeviceList(self.m_emulator);
        except Exception as err:
            # print("No device found!")
            errmsg(err);
        finally:
            super().saybye();


"""
安装 apk / ipa 线程
"""
class InstallThread(ThreadBaseClass):

    def __init__(self, parent, app_path, devname):
        super(InstallThread, self).__init__(parent);

        self.app_path = app_path;
        self.devname = devname;
        self.mainObj = parent;

        start_pack();

    def run(self):
        try:
            # print ("connecting device...");
            self.mainObj.onInstallApp(self.app_path, self.devname);
            # print ("OK OK OK")

        except Exception as err:
            # print("No device found!")
            errmsg(err);
        finally:
            done_pack(0);


"""
重启adb 线程
"""
class RestartAdbThread(ThreadBaseClass):

    def __init__(self, parent):
        super(RestartAdbThread, self).__init__(parent);

        self.mainObj = parent;

        start_pack();

    def run(self):
        try:
            # print ("connecting device...");
            # self.mainObj.onInstallApp(self.app_path, self.devname);
            # print ("OK OK OK")
            print("kill nox_adb_server");
            Commander().do("nox_adb kill-server", encoding='utf8');

            print("kill adb_server")
            Commander().do("adb kill-server", encoding='utf8');

            pass

        except Exception as err:
            # print("No device found!")
            errmsg(err);
        finally:
            done_pack(0);


"""
android logcat 线程
"""
class LogCatThread(ThreadBaseClass):

    def __init__(self, parent, devname, isExportTxt, isNox):
        super(LogCatThread, self).__init__(parent);

        self.devname = devname;
        self.mainObj = parent;
        self.isExportTxt = isExportTxt;
        self.isNox = isNox;

        start_pack();

    def stop(self):
        try:
            self.mainObj.onTerminateLogcat();
            pass
        except Exception as err:
            errmsg(err);

        pass

    def run(self):
        try:
            # print ("connecting device...");
            self.mainObj.onLogcat(self.devname, self.isExportTxt, self.isNox);
            # print ("OK OK OK")

        except Exception as err:
            # print("No device found!")
            errmsg(err);
        finally:
            done_pack(0);


class CertPush(object):
    def __init__(self, cert, p12, name, password):
        self.cert = cert;
        self.p12 = p12;
        self.name = name;
        self.password = password;
        self.pem_path = "";

    def run(self):

        try:
            cert = self.cert;
            p12 = self.p12;
            name = self.name;
            password = self.password;

            cer_dir, cer_name = os.path.split(cert);
            key_dir, key_name = os.path.split(p12);

            push_cer_pem = os.path.join(cer_dir, '''%s.push_cer.pem''' % name);
            push_key_pem = os.path.join(key_dir, '''%s.push_key.pem''' % name);
            push_pem = os.path.join(cer_dir, '''%s.push.pem''' % name);
            self.pem_path = push_pem;
            sandbox_url = '''gateway.sandbox.push.apple.com:2195'''

            Commander().do('''openssl x509 -in %s -inform der -out %s''' % (cert, push_cer_pem));

            child = pexpect.spawn('''openssl pkcs12 -nocerts -out %s -in %s''' % (push_key_pem, p12), encoding='utf-8');
            # child.logfile = sys.stdout
            child.expect('''Enter Import Password:''');

            child.sendline(password);
            child.expect('''Enter PEM pass phrase:''');
            child.sendline(password);
            child.expect('''Verifying - Enter PEM pass phrase:''');
            child.sendline(password);
            child.sendline("\n")
            child.close();

            Commander().do('''cat %s %s > %s''' % (push_cer_pem, push_key_pem, push_pem));

            """
            verify 
            """
            child = pexpect.spawn(
                '''openssl s_client -connect %s -cert %s -key %s''' % (sandbox_url, push_cer_pem, push_key_pem),
                encoding='utf-8');
            # child.logfile = sys.stdout
            child.expect('''Enter pass phrase for .*''');
            child.sendline(password);
            child.sendline("\n");
            ret = child.expect('''-----BEGIN CERTIFICATE-----''', timeout=5);
            if ret == 0:
                rmsgbox("Make Succeed\nCerPath : %s" % self.pem_path)
            else:
                rmsgbox("Failed");

            child.close();

        except Exception as err:
            errmsg(err);
        pass

"""
生成ios推送参数线程
"""
class MakePushCertThread(ThreadBaseClass):
    def __init__(self, parent, cer_file, p12_file, name, passwd):
        super(MakePushCertThread, self).__init__(parent);

        self.cer_file = cer_file;
        self.p12_file = p12_file;
        self.name = name;
        self.passwd = passwd;

        start_pack();

    def run(self):
        try:

            print("make push certifications...");
            CertPush(self.cer_file, self.p12_file, self.name, self.passwd).run();

        except Exception as err:
            errmsg(err);
        finally:
            done_pack(0);

"""
清理Xcode Profile 文件缓存
"""
class CleanProfileThread(ThreadBaseClass):
    def run(self):
        try:
            print("clean xcode profile...");
            Commander().do('''cd ~/Library/MobileDevice/Provisioning\ Profiles/ && rm -rf *''');
        except Exception as err:
            errmsg(err);
        finally:
            done_pack(0);
            rmsgbox("清除成功!")
        pass

'''
清除xcode userdata 线程
'''
class CleanXcodeThread(ThreadBaseClass):
    def run(self):
        try:
            print("clean xcode data...");
            path = os.path.join("ios", "channel_files");
            cmdstr = '''find %s -name xcuserdata -exec rm -rf {} \;''' % (path);
            Commander().do(cmdstr);

        except Exception as err:
            errmsg(err);
        finally:
            done_pack(0);
            rmsgbox("清除成功!")
        pass

'''
打包creator 包
'''
class PackCreatorH5(ThreadBaseClass):
    def __init__(self, parent, param):
        super(PackCreatorH5, self).__init__(parent);
        start_pack();
        self.param = param;

    def run(self):
        try:

            pack = None;
            if isMacOS() == True:
                pack = PackH5IOS(self.param);
            elif isWin():
                pack = PackH5Android(self.param);

            pack.pack();

        except Exception as err:
            errmsg(err);
        finally:
            done_pack(0);


"""
MainWindow Class
"""
class MainWindow(QMainWindow):

    def prepareUIFile(self, filepath):
        pass

    def __init__(self, parent=None):
        super(MainWindow, self).__init__(parent)
        ui_path = os.path.join("ui", "main.ui");
        self.prepareUIFile(ui_path)
        loadUi(ui_path, self)
        self.setWindowIcon(QIcon(os.path.join("ui", "app.png")));

        self.setAcceptDrops(True);
        self.expandTaskPanel(False);

        self.change_ch_count = 0;
        self.pack_config_strings = {};
        self.logdict = None;
        self.gamelist = [];
        self.prevTabIndex = -1;

        """
        common ctrls 
        """

        self.btn_pack = self.findChild(QPushButton, "btn_pack");
        self.btn_whitelist = self.findChild(QPushButton, "btn_whitelist");
        self.btn_publish_basehall = self.findChild(QPushButton, "btn_publish_basehall");
        self.btn_svn_submit = self.findChild(QPushButton,"btn_svn_submit")

        self.btn_make_native_project = self.findChild(QPushButton, "btn_make_native_project");
        self.btn_build = self.findChild(QPushButton, "btn_build")

        self.text_panel = self.findChild(QTextBrowser, "text_panel");
        self.text_panel_error = self.findChild(QTextBrowser, "text_panel_error");
        self.cbox_hall = self.findChild(QComboBox, "cbox_hall");
        self.cbox_ch = self.findChild(QComboBox, "cbox_ch");

        self.cbox_config = self.findChild(QComboBox, "cbox_config_page");
        self.edit_config = self.findChild(QLineEdit, "edit_config_page");
        self.btn_connect = self.findChild(QPushButton, "btn_connect");
        self.btn_connect_emulator = self.findChild(QPushButton, "btn_connect_emulator");
        self.list_app = self.findChild(QListWidget, "list_app");
        self.edit_vname = self.findChild(QLineEdit, "edit_vname");
        self.edit_vcode = self.findChild(QLineEdit, "edit_vcode");
        self.picview_ico = self.findChild(QLabel, "picview_ico");
        self.btn_clr = self.findChild(QPushButton, "btn_clear_screen");
        self.btn_check_lua_syntax = self.findChild(QPushButton, "btn_check_lua_syntax");
        self.btn_make_config = self.findChild(QPushButton, "btn_make_config");
        self.btn_make_assets = self.findChild(QPushButton, "btn_make_assets");
        self.ckbox_lock_gamelist = self.findChild(QCheckBox, "checkBox_lock_gamelist");
        self.game_panel = self.findChild(QGroupBox, "groupBox_gamelist");
        self.tasks_panel = self.findChild(QGroupBox, "groupBox_tasks");
        self.succeed_panel = self.findChild(QGroupBox, "groupBox_succeed_list");
        self.btn_add_task = self.findChild(QPushButton, "btn_add_task");
        self.btn_sync_all_version = self.findChild(QPushButton, "btn_sync_all_version");
        self.checkBox_no_hotupdate = self.findChild(QCheckBox, "checkBox_no_hotupdate");
        self.checkBox_slots_update = self.findChild(QCheckBox, "checkBox_slots_update");

        self.ckbox_ignore_err = self.findChild(QCheckBox, "checkBox_igone_error");
        self.ckbox_local_task_list = self.findChild(QCheckBox, "checkBox_lock_tasklist");
        self.btn_logger = self.findChild(QPushButton, "btn_logger");

        self.pushButton_sym_tbl = self.findChild(QPushButton, "pushButton_sym_tbl");
        self.btn_load_publish_games = self.findChild(QPushButton, "btn_load_publish_games");
        self.btn_sync_autotex = self.findChild(QPushButton,"btn_sync_autotex");
        self.btn_make_yaml = self.findChild(QPushButton,"btn_make_yaml");

        self.compress_texture = self.findChild(QGroupBox, "compress_texture")

        self.compress_texture.clicked.connect(self.onCompressTextureClicked)

        self.btn_make_native_project.clicked.connect(self.onMakeNativeProject);
        self.btn_build.clicked.connect(self.onBuildClicked);

        self.btn_whitelist.clicked.connect(self.onMakeWhiteList)
        self.list_app.itemDoubleClicked.connect(self.onListItemDBClicked);
        self.btn_sync_all_version.clicked.connect(self.onSyncAllSubGamesVersion);
        self.btn_load_publish_games.clicked.connect(self.onLoadPublishGames);
        self.checkBox_slots_update.clicked.connect(self.onSlotsUpdate)
        self.btn_svn_submit.clicked.connect (self.onSubmitClicked)
        self.btn_sync_autotex.clicked.connect (self.onSyncAutoTex)

        self.btn_logger.clicked.connect(self.onLogger);
        self.btn_make_yaml.clicked.connect (self.onMakeYaml)
        # self.pushButton_sym_tbl.clicked.connect (self.onUploadSymTbl);

        # 搜索按钮
        # noral_img_src = os.path.join(os.getcwd(), "ui", "search_normal.png");
        # press_img_src = os.path.join(os.getcwd(), "ui", "search_press.png");
        # hover_img_src = os.path.join(os.getcwd(), "ui", "search_hover.png");
        # self.btn_search = PushButton(self);
        # self.btn_search.setButtonStyle(PushButton.NO_BORDER);
        # self.btn_search.setButtonImage(normal = noral_img_src, press = press_img_src, hover = hover_img_src);
        # self.btn_search.setGeometry(845, 28, 28, 28);
        # self.btn_search.setIconSize(QSize(25, 25));

        self.prevLangName = "";

        '''
        install / android logcat 
        '''
        self.cbox_devlist = self.findChild(QComboBox, "cbox_devlist");
        self.btn_refresh_applist = self.findChild(QPushButton, "btn_refresh_app");
        self.btn_logcat = self.findChild(QPushButton, "pushButton_logcat");
        self.checkBox_export_txt = self.findChild(QCheckBox, "checkBox_export_txt");
        self.checkBox_nox = self.findChild(QCheckBox, "checkBox_nox");
        self.pushButton_restart_adb = self.findChild(QPushButton, "pushButton_restart_adb");

        self.btn_logcat.clicked.connect(self.onAndroidLogCat);
        self.pushButton_restart_adb.clicked.connect(self.onRestartAdb);

        self.isLogcatEnd = False;
        self.logcat_process = None;

        """
        Qmenu 
        """
        self.menu_bar = self.findChild(QMenuBar, "menubar");
        self.menu_bar.triggered[QAction].connect(self.processtrigger);

        # 添加一个新的Action Icon制作
        action = QAction(self);
        action.setCheckable(False);
        action.triggered.connect(self.iconMakerClick);
        action.setText("Icon制作");
        self.menu_bar.addAction(action);

        # 添加一个新的Action 语言编辑
        action = QAction(self);
        action.setCheckable(False);
        action.triggered.connect(self.langEditClick);
        action.setText("语言编辑");
        self.menu_bar.addAction(action);

        # 添加一个新的Action DebugLog
        action = QAction(self);
        action.setCheckable(False);
        action.triggered.connect(self.onLogger);
        action.setText("Logger");
        self.menu_bar.addAction(action);

        if isMacOS():
            logger = QAction('Logger', self)
            menubar = self.menuBar()
            fileMenu = menubar.addMenu('Logger')
            logger.triggered.connect(self.onLogger)
            fileMenu.addAction(logger)

        """
        export to appstore
        """
        self.listWidget_arch = self.findChild(QListWidget, "listWidget_arch");
        self.btn_fresh_archlist = self.findChild(QPushButton, "btn_fresh_archlist");
        self.listWidget_arch.itemDoubleClicked.connect(self.onArchDBClicked);
        self.btn_fresh_archlist.clicked.connect(self.onLoadArchList);

        """
        tools 
        """
        self.groupBox_ios_push = self.findChild(QGroupBox, "groupBox_ios_push");
        self.btn_make_pem = self.findChild(QPushButton, "btn_make_pem");
        self.btn_open_cert = self.findChild(QPushButton, "btn_open_cert");
        self.btn_open_p12 = self.findChild(QPushButton, "btn_open_p12");
        self.lineEdit_cert = self.findChild(QLineEdit, "lineEdit_cert");
        self.lineEdit_p12 = self.findChild(QLineEdit, "lineEdit_p12");
        self.lineEdit_name = self.findChild(QLineEdit, "lineEdit_name");
        self.lineEdit_passwd = self.findChild(QLineEdit, "lineEdit_passwd");

        self.btn_clean_profile = self.findChild(QPushButton, "btn_clean_profile");
        self.btn_clean_xcodedata = self.findChild(QPushButton, "btn_clean_xcodedata");

        self.btn_make_pem.clicked.connect(self.onMakePem);
        self.btn_open_cert.clicked.connect(self.onOpenCert);
        self.btn_open_p12.clicked.connect(self.onOpenP12);
        self.btn_clean_xcodedata.clicked.connect(self.onCleanXcodeData);

        self.btn_clean_profile.clicked.connect(self.onCleanProfile);

        if not isMacOS():
            self.groupBox_ios_push.setEnabled(False);

        """
        pack h5
        """
        self.btn_h5_pack = self.findChild(QPushButton, "btn_h5_pack");
        self.checkBox_use_aab = self.findChild(QCheckBox, "checkBox_use_aab");
        self.btn_h5_res_proceed = self.findChild(QPushButton, "btn_h5_res_proceed");

        """
        hot update (tags_svn_root)
        """
        self.btn_svn_link = self.findChild(QPushButton, "btn_svn_link");
        self.lineEdit_svn = self.findChild(QLineEdit, "lineEdit_svn");
        self.comboBox_tagname = self.findChild(QComboBox, "comboBox_tagname");

        self.lineEdit_base_src_v = self.findChild(QLineEdit, "lineEdit_base_src_v");
        self.lineEdit_hall_src_v = self.findChild(QLineEdit, "lineEdit_hall_src_v");
        self.lineEdit_game_src_v = self.findChild(QLineEdit, "lineEdit_game_src_v");
        self.lineEdit_base_dest_v = self.findChild(QLineEdit, "lineEdit_base_dest_v");
        self.lineEdit_hall_dest_v = self.findChild(QLineEdit, "lineEdit_hall_dest_v");
        self.lineEdit_game_dest_v = self.findChild(QLineEdit, "lineEdit_game_dest_v");
        self.lineEdit_game_vname = self.findChild(QLineEdit, "edit_game_vname");

        self.widget_game_version = self.findChild(QWidget, "widget_game_version");
        # self.widget_game_version.setVisible(False);
        # self.lineEdit_game_vname.setInputMask("99.99");
        # self.lineEdit_game_vname.setText("1.0");

        self.btn_make_hotupdate = self.findChild(QPushButton, "btn_make_hotupdate");

        self.checkBox_whitelist = self.findChild(QCheckBox, "checkBox_whitelist");
        self.pushButton_whitelist = self.findChild(QPushButton, "pushButton_whitelist");

        self.btn_svn_link_fresh = self.findChild(QPushButton, "btn_svn_link_fresh");
        self.checkBox_sel_all_game = self.findChild(QCheckBox, "checkBox_sel_all_game");
        self.btn_fresh_game_version = self.findChild(QPushButton, "btn_fresh_game_version");

        self.checkBox_whitelist.clicked.connect(self.onWhiteList);
        self.pushButton_whitelist.clicked.connect(self.onOpenWhiteList);
        self.checkBox_sel_all_game.clicked.connect(self.onSelAllSubGameClicked);
        self.btn_fresh_game_version.clicked.connect(self.onFetchGameList);

        '''
        repack
        '''
        self.pushButton_select = self.findChild(QPushButton, "pushButton_select");
        self.pushButton_repack = self.findChild(QPushButton, "pushButton_repack");
        self.lineEdit_inputdir = self.findChild(QLineEdit, "lineEdit_inputdir");

        '''
        bugly symbol
        '''

        self.groupBox_sym_tbl = self.findChild(QGroupBox, "groupBox_sym_tbl")

        self.lineEdit_so_dir = self.findChild(QLineEdit, "lineEdit_so_dir");
        self.lineEdit_mapping_dir = self.findChild(QLineEdit, "lineEdit_mapping_dir");

        self.pushButton_so_dir = self.findChild(QPushButton, "pushButton_so_dir");
        self.pushButton_mapping_dir = self.findChild(QPushButton, "pushButton_mapping_dir");
        self.checkBox_spec_dir = self.findChild(QCheckBox, "checkBox_spec_dir");
        self.pushButton_upload = self.findChild(QPushButton, "pushButton_upload");

        self.checkBox_spec_dir.clicked.connect(self.onSpecDirClicked);
        self.pushButton_so_dir.clicked.connect(self.onSoDirClicked);
        self.pushButton_mapping_dir.clicked.connect(self.onMappingDirClicked);
        self.pushButton_upload.clicked.connect(self.onUploadSymTbl)

        """
        all kind of checkboxes 
        """
        self.ckbox_use_pop_errbox = self.findChild(QCheckBox, "checkBox_pop_errbox")
        self.ckbox_use_local = self.findChild(QCheckBox, "checkBox_use_local")
        self.ckbox_use_switch_server = self.findChild(QCheckBox, "checkBox_switch_server")
        self.ckbox_use_release_log = self.findChild(QCheckBox, "checkBox_release_log")
        self.ckbox_use_fbinvite = self.findChild(QCheckBox, "checkBox_use_fbinvite")
        self.ckbox_use_no_aes_php = self.findChild(QCheckBox, "checkBox_no_aes_php")
        self.ckbox_use_no_gzip_php = self.findChild(QCheckBox, "checkBox_no_gzip_php")
        self.ckbox_use_can_log = self.findChild(QCheckBox, "checkBox_can_log")
        self.ckbox_use_collect_hall_game = self.findChild(QCheckBox, "checkBox_collect_hall_game")
        self.ckbox_use_ip_local = self.findChild(QCheckBox, "checkBox_use_ip_in_local")

        self.ckbox_use_rgba8888 = self.findChild(QCheckBox, "checkBox_use_rgba8888")
        self.ckbox_use_bone_zip = self.findChild(QCheckBox, "checkBox_bone_zip")

        '''
        compress 
        '''
        self.ckbox_use_pvr = self.findChild(QRadioButton, "checkBox_use_pvr")
        self.ckbox_use_etc2 = self.findChild(QRadioButton, "checkBox_use_etc2")
        self.ckbox_use_astc = self.findChild(QRadioButton, "checkBox_use_astc");

        '''
        callback
        '''
        self.ckbox_use_etc2.toggled.connect(self.onEtc2Clicked);
        self.ckbox_use_astc.toggled.connect(self.onASTCClicked);
        self.ckbox_use_pvr.toggled.connect(self.onPvrClicked);

        self.ckbox_use_debug = self.findChild(QCheckBox, "checkBox_use_debug");
        self.ckbox_use_no_crypt_zip = self.findChild(QCheckBox, "checkBox_use_no_crypt_zip");

        self.ckbox_use_export_appstore = self.findChild(QCheckBox, "checkBox_use_export_appstore");
        self.ckbox_show_error_only = self.findChild(QCheckBox, "checkBox_show_error_only");
        self.ckbox_use_pngquant = self.findChild(QCheckBox, "checkBox_use_pngquant");
        self.ckbox_use_logger = self.findChild(QCheckBox, "checkBox_use_logger");
        self.ckbox_use_filelogger = self.findChild(QCheckBox, "checkBox_use_filelogger");
        self.checkBox_use_debug_hall_hotupdate = self.findChild(QCheckBox, "checkBox_use_debug_hall_hotupdate");
        self.checkBox_use_debug_game_hotupdate = self.findChild(QCheckBox, "checkBox_use_debug_game_hotupdate");

        self.checkBox_hallnum = self.findChild(QCheckBox, "checkBox_hallnum");

        self.ckbox_use_filelogger.clicked.connect(self.onFileLogger);
        self.ckbox_use_logger.clicked.connect(self.onRemoteLogger)
        self.ckbox_use_pngquant.clicked.connect(self.onPngQuantClicked)

        self.ckbox_use_rgba8888.clicked.connect(self.onRGBA8888Clicked);
        self.ckbox_use_debug.clicked.connect(self.onDebugClicked);
        self.ckbox_show_error_only.clicked.connect(self.onShowErrorOnly);
        self.ckbox_use_ip_local.clicked.connect(self.onUseIPLocal);

        self.ckbox_lock_gamelist.clicked.connect(self.onLockGameList);
        self.checkBox_hallnum.clicked.connect(self.onLockHallNum);

        '''
        version 
        '''
        self.edit_vname.setInputMask("9.99.99.99");
        self.edit_vname.setAlignment(Qt.Qt.AlignCenter);
        self.edit_vname.textChanged.connect(self.onVNameChanged);

        '''
        vcode
        '''
        self.edit_vcode.setAlignment(Qt.Qt.AlignCenter);
        self.edit_vcode.setValidator(QIntValidator());
        # self.edit_vcode.setMaxLength(8);
        # self.edit_vname.setClearButtonEnabled (True);
        # self.edit_vname.setPlaceholderText ("0");

        '''
        hall num
        '''
        self.edit_hallnum = self.findChild(QLineEdit, "edit_hallnum");
        self.edit_hallnum.setAlignment(Qt.Qt.AlignCenter);
        self.edit_hallnum.textChanged.connect(self.onHallNumChanged);
        self.hallNum = "";

        '''
        signal 
        '''
        gsignal.msg_trigger.connect(self.putText);
        gsignal.input_trigger.connect(self.onInputBox);
        gsignal.error_msg_trigger.connect(self.putErrorText);
        gsignal.clear_trigger.connect(self.clearText);
        gsignal.done_trigger.connect(self.doneThread);
        gsignal.start_trigger.connect(self.startThread);
        gsignal.msgbox_trigger.connect(self.msgboxMsg)
        gsignal.ask_box_trigger.connect(self.askboxMsg);
        # gsignal.input_ret_trigger.connect(self.inputbox);
        gsignal.alert_changelist_trigger.connect(self.onAlertChangeList)

        self.btn_clr.clicked.connect(self.onClearScreen)
        self.btn_check_lua_syntax.clicked.connect(self.onCheckSyntaxBtnClicked);
        self.btn_make_config.clicked.connect(self.onMakeConfigClicked);
        self.btn_make_assets.clicked.connect(self.onMakeAssetsClicked);
        self.btn_connect.clicked.connect(self.onConnectDevice);
        self.btn_connect_emulator.clicked.connect(self.onConnectEmulator);
        self.btn_refresh_applist.clicked.connect(self.onFreshAppList);

        self.ckbox_use_local.clicked.connect(self.onLocalServerClicked);

        """
        pack h5
        """
        self.btn_h5_pack.clicked.connect(self.onPackH5);
        self.btn_h5_res_proceed.clicked.connect(self.onMakeResH5);

        '''
        repack
        '''
        self.pushButton_select.clicked.connect(self.onSelectDir);
        self.pushButton_repack.clicked.connect(self.onRepack);

        """
        list games 
        """

        self.subgame_tablistview = self.findChild(QTableWidget, "tableWidget_gamelist");
        # self.subgame_tablistview.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        # self.subgame_tablistview.setColumnCount(4)

        # self.subgame_tablistview.setRowCount(13)

        header = self.subgame_tablistview.horizontalHeader()
        header.setSectionResizeMode(0, QtWidgets.QHeaderView.ResizeToContents)
        header.setSectionResizeMode(1, QtWidgets.QHeaderView.Stretch)
        header.setSectionResizeMode(2, QtWidgets.QHeaderView.Stretch);

        width = self.subgame_tablistview.width();
        # self.subgame_tablistview.setColumnWidth(0, 150);
        # self.subgame_tablistview.setColumnWidth(1, 150);
        # self.subgame_tablistview.setColumnWidth(2, width - 150 - 150);

        self.onLockGameList();

        """
        load Hall / Channel / Lang list 
        """
        self.loadHallList();
        self.cbox_hall.currentIndexChanged.connect(self.onHallChanged);
        # self.cbox_ch.currentIndexChanged.connect(self.onChChanged);
        self.cbox_config.currentIndexChanged.connect(self.onPageConfigChanged);
        self.cbox_config.addItem("配置页++");
        self.edit_config.returnPressed.connect(self.onNewPageConfig);
        self.edit_config.setVisible(False);

        '''配置页初始化'''
        pageConfig = PageConfig.getInstance();
        pageConfig.cbox_config = self.cbox_config;
        pageConfig.addWidgets([
            self.ckbox_use_pop_errbox,
            self.ckbox_use_local,
            self.ckbox_use_switch_server,
            self.ckbox_use_release_log,
            self.ckbox_use_fbinvite,
            self.ckbox_use_no_aes_php,
            self.ckbox_use_no_gzip_php,
            self.ckbox_use_can_log,
            self.ckbox_use_collect_hall_game,
            self.ckbox_use_ip_local,
            self.ckbox_use_pvr,
            self.ckbox_use_rgba8888,
            self.ckbox_use_bone_zip,
            self.ckbox_use_etc2,
            self.ckbox_use_astc,
            self.ckbox_use_pngquant,
            self.ckbox_use_logger,
            self.ckbox_use_filelogger,
            self.checkBox_use_debug_hall_hotupdate,
            self.checkBox_use_debug_game_hotupdate,
        ], "option");
        pageConfig.addWidgets([
            self.edit_vname,
            self.edit_vcode
        ], "other");

        self.onHallChanged();

        self.btn_pack.clicked.connect(self.onPackClicked);
        self.btn_publish_basehall.clicked.connect(self.onPublishAll)

        """
        record all the widgets which we need disabled when we are packing 
        """
        self.widgets = [];

        self.bottom_panel = self.findChild(QTabWidget, "bottom_panel");
        self.bottom_panel.currentChanged.connect(self.onTabChanged);
        self.up_panel = self.findChild(QGroupBox, "up_panel");

        self.widgets.insert(0, self.bottom_panel);
        self.widgets.insert(0, self.up_panel);
        self.widgets.insert(0, self.game_panel);
        self.widgets.insert(0, self.btn_check_lua_syntax);
        self.widgets.insert(0, self.menu_bar);
        self.widgets.insert(0, self.tasks_panel);
        self.widgets.insert(0, self.succeed_panel);

        self.threads = {};
        self.onShowErrorOnly();
        self.initLockedList();
        self.onLockHallNum();

    def onMakeYaml(self):
        self.getPMConfig();

        if not self.isThreadEnd("make_yaml"):
            return;

        dict = {};

        thread = MakeYamlThread(self, None, dict);
        thread.start();
        self.threads["make_yaml"] = thread;

    def onSyncAutoTex(self):

        self.getPMConfig();

        if not self.isThreadEnd("auto_tex"):
            return;

        dict = {};

        msg = '''
################## 正在生成自动图集    ##################   

请确保没有文件被占用
请选择生成模式 

Yes)    则刷新自动图集，将会根据散图和配置覆盖生成图集
No )    否则初始化模式，将会兼容现有图集
Cancel) 取消则退出

        '''
        ret = MsgBox().yesno(msg);
        if (QMessageBox.Yes == ret):
            dict ["isSetup"] = False;
        elif (QMessageBox.No == ret):
            dict ["isSetup"] = True;
        else:
            return;

        thread = SyncAutoTexThread(self,None,dict);
        thread.start();
        self.threads["auto_tex"] = thread;
        pass

    def onSubmitClicked(self):

        self.getPMConfig();

        if not self.isThreadEnd("svn_list"):
            return;

        dict = {};

        if (self.checkBox_whitelist.checkState() == QtCore.Qt.Checked):
            preMsg = "##################\n 正在提交白名单热更 \n##################\n";
            distdir = "dev";
        else:
            preMsg = "##################\n    正在提交热更   \n##################\n";
            distdir = "dist";

        if self.checkBox_slots_update.checkState() != Qt.Qt.Checked:
            ret = MsgBox().yesno(
                "%s\n请确保没有文件被占用\n是否是提交正式热更? \n\nYes) 是则提交正式热更\nNo) 否则提交测试热更\nCancel) 取消热更\n" % (preMsg));
        else:
            ret = MsgBox().yesno(
                "%s\n请确保没有文件被占用\n是否是提交正式热更? \n\nYes) 是则提交正式热更\nNo) 否则提交slots热更\nCancel) 取消热更\n" % (preMsg));

        if (QMessageBox.Yes == ret):
            isDebugPublish = True;
        elif (QMessageBox.No == ret):
            isDebugPublish = False;
        else:
            return;

        platconfig = self.getPlatSettings();

        if isDebugPublish:

            dict["project_dir"] = os.path.join(platconfig.project_dir, "client_publish_dis", distdir);
            dict["hotupdate_dir_root"] = os.path.join(platconfig.project_dir, "client_publish_dis");
            dict["whitelist_path"] = os.path.join(platconfig.project_dir, "client_publish_dis", "navigator.json");
            dict["delaysubmit_path"] = os.path.join(platconfig.project_dir, "client_publish_dis", distdir,"delaysubmit.json");
            dict["cnd_url"] = "http://hot.fg-domino.com/CynkingGame/" + distdir;
            dict["isDebugServer"] = False;
            dict["isWhitelistUpdate"] = distdir == "dev";

        else:
            if self.checkBox_slots_update.checkState() == Qt.Qt.Checked:

                dict["project_dir"] = os.path.join(platconfig.project_dir, "client_publish_dev_slots", distdir);
                dict["hotupdate_dir_root"] = os.path.join(platconfig.project_dir, "client_publish_dev_slots");
                dict["whitelist_path"] = os.path.join(platconfig.project_dir, "client_publish_dev_slots","navigator.json");
                dict["delaysubmit_path"] = os.path.join(platconfig.project_dir, "client_publish_dev_slots", distdir,"delaysubmit.json");
                dict["cnd_url"] = "http://172.20.11.248:8992/" + distdir;
                dict["isDebugServer"] = True;
                dict["isWhitelistUpdate"] = distdir == "dev";

            else:
                dict["project_dir"] = os.path.join(platconfig.project_dir, "client_publish_dev", distdir);
                dict["hotupdate_dir_root"] = os.path.join(platconfig.project_dir, "client_publish_dev");
                dict["whitelist_path"] = os.path.join(platconfig.project_dir, "client_publish_dev","navigator.json");
                dict["delaysubmit_path"] = os.path.join(platconfig.project_dir, "client_publish_dev", distdir,"delaysubmit.json");
                dict["cnd_url"] = "http://172.20.11.248:8991/" + distdir
                dict["isDebugServer"] = True;
                dict["isWhitelistUpdate"] = distdir == "dev";

        thread = SvnUploadThread (self, None, dict);
        thread.start();
        self.threads["svn_list"] = thread;
        pass

    def onLocalServerClicked(self):
        if self.ckbox_use_local.checkState() == Qt.Qt.Unchecked:
            self.checkBox_slots_update.setCheckState(Qt.Qt.Unchecked)
        pass

    def onSlotsUpdate(self):
        if self.checkBox_slots_update.checkState() == Qt.Qt.Checked:
            self.ckbox_use_local.setCheckState(Qt.Qt.Checked);
        pass

    def onCompressTextureClicked(self):

        if self.compress_texture.isChecked() == True:
            self.ckbox_use_pngquant.setCheckState(QtCore.Qt.Unchecked);

        pass

    def onPngQuantClicked(self):
        if self.ckbox_use_pngquant.checkState() == Qt.Qt.Checked:
            self.compress_texture.setChecked(False);

    def onMakeNativeProject(self):
        self.getPMConfig();

        if not self.isThreadEnd("mknativeproject"):
            return;

        msg = self.preCheckArgument();
        if msg != None:
            MsgBox().msg(msg);
            return;

        if (QMessageBox.Ok == MsgBox().ask("仅生成原生工程，请确认文件没有被占用!")):
            # self.expandTaskPanel(False);
            dict = {};
            dict["games_info"] = self.getGamesInfo();
            thread = MakeNativeProjectThread(self, None, dict);
            thread.start();
            self.threads["mknativeproject"] = thread;
            pass
        pass

    def onLoadPublishGames(self):
        # self.luaConfig

        self.hallName = gPMConfig.getCurHallName();
        self.chName = gPMConfig.getCurChName();
        self.curChConfig = gPMConfig.getCurChConfig();
        self.luaHallConfig = gLuaPM.hallConfig(self.hallName);
        self.luaChConfig = gLuaPM.chConifg(self.hallName, self.chName);
        self.luaConfig = gLuaPM.config();

        games = self.luaHallConfig.games;
        gameslist = [];
        for k in games:
            # print (name);
            gameslist.append(games[k]);

        for row in range(self.subgame_tablistview.rowCount()):
            gameitem = self.subgame_tablistview.item(row, 0)
            veritem = self.subgame_tablistview.cellWidget(row, 1);
            hallitem = self.subgame_tablistview.cellWidget(row, 2);

            gamename = gameitem.text();
            if gamename != "" and gamename in gameslist:
                gameitem.setCheckState(Qt.Qt.Checked);
            else:
                if gameitem:
                    gameitem.setCheckState(Qt.Qt.Unchecked);

        pass

    def onMakeWhiteList(self):

        if (self.checkBox_whitelist.checkState() == QtCore.Qt.Checked):
            preMsg = "##################\n    生成白名单 \n##################\n";
            distdir = "dev";
        else:
            preMsg = "##################\n    取消白名单  \n##################\n";
            distdir = "dist";

        ret = MsgBox().yesno("%s\n是否修改正式白名单? \n\nYes) 是则修改正式白名单\nNo) 否则修改开发白名单\nCancel) 取消修改\n" % (preMsg));
        if (QMessageBox.Yes == ret):
            isDebugPublish = True;
        elif (QMessageBox.No == ret):
            isDebugPublish = False;
        else:
            return;

        platconfig = self.getPlatSettings();

        if isDebugPublish:
            whitelist_path = os.path.join(platconfig.project_dir, "client_publish_dis", "navigator.json");
        else:
            whitelist_path = os.path.join(platconfig.project_dir, "client_publish_dev", "navigator.json");

        if not os.path.exists(whitelist_path):
            MsgBox().msg("没有找到 %s \n请确保目录存在!!" % (whitelist_path));
            return;

        with open(whitelist_path, "w+") as file:
            file.write(gWhiteList.convertToJson());

        MsgBox().msg("生成白名单成功\n路径 ==> %s!!" % (whitelist_path));
        pass

    def onHallNumChanged(self, text):
        if self.hallNum != "" and self.hallNum != text:
            if (QMessageBox.Ok != MsgBox().ask("确认要修改大厅框架号么 ? \n如果是发布版本，强烈建议不要那么做")):
                self.edit_hallnum.setText(self.hallNum);
                return;

        self.hallNum = text;
        pass

    def onAlertChangeList(self, dict):
        ret = AlertChangeList(self, dict);
        gsignal.alert_ret_changelist_trigger.emit(ret);
        pass

    def onSyncAllSubGamesVersion(self):
        if (QMessageBox.Ok == MsgBox().ask("确认要同步所有子游戏最低支持框架号为大厅框架号么 ? \n如果是发布版本，强烈建议不要那么做")):

            hallnumstr = self.edit_hallnum.text();

            for row in range(self.subgame_tablistview.rowCount()):
                gameitem = self.subgame_tablistview.item(row, 0)
                veritem = self.subgame_tablistview.cellWidget(row, 1);
                hallitem = self.subgame_tablistview.cellWidget(row, 2);
                if hallitem:
                    hallitem.setText(hallnumstr);
                    # hallitem.setEnabled(self.ckbox_lock_gamelist.checkState() != Qt.Qt.Checked)

        pass

    def onLockHallNum(self):
        self.edit_hallnum.setEnabled(self.checkBox_hallnum.checkState() != Qt.Qt.Checked);
        pass

    def onPublishAll(self):

        try:
            self.getPMConfig();

            if not self.isThreadEnd("publishAll"):
                return;

            chConfig = gPMConfig.getCurChConfig();
            if chConfig == None:
                return;

            platconfig = self.getPlatSettings();

            msg = self.preCheckArgument();
            if msg != None:
                MsgBox().msg(msg);
                return;

            if (self.checkBox_whitelist.checkState() == QtCore.Qt.Checked):
                preMsg = "##################\n  正在发布白名单热更 \n##################\n";
                distdir = "dev";
            else:
                preMsg = "##################\n    正在发布热更   \n##################\n";
                distdir = "dist";

            if self.checkBox_slots_update.checkState() != Qt.Qt.Checked:
                ret = MsgBox().yesno(
                    "%s\n请确保没有文件被占用\n是否是发布正式热更? \n\nYes) 是则发布正式热更\nNo) 否则发布测试热更\nCancel) 取消热更\n" % (preMsg));
            else:
                ret = MsgBox().yesno(
                    "%s\n请确保没有文件被占用\n是否是发布正式热更? \n\nYes) 是则发布正式热更\nNo) 否则发布slots热更\nCancel) 则取消热更\n" % (preMsg));

            if (QMessageBox.Yes == ret):
                isDebugPublish = True;
            elif (QMessageBox.No == ret):
                isDebugPublish = False;
            else:
                return;

            dict = {};
            dict["games_info"] = self.getGamesInfo();

            glistInfo = [];

            self.use_debug = self.ckbox_use_debug.checkState() == Qt.Qt.Checked;

            for row in range(self.subgame_tablistview.rowCount()):
                gameitem = self.subgame_tablistview.item(row, 0)
                veritem = self.subgame_tablistview.cellWidget(row, 1);
                hallitem = self.subgame_tablistview.cellWidget(row, 2);

                gname = gameitem.text() or "";
                if gname != "":
                    gversion = veritem.text() or "";
                    hallnum = hallitem.text() or "";

                    tbl = {};
                    tbl["gname"] = gname;
                    tbl["version"] = gversion;
                    tbl["hallnum"] = hallnum;
                    glistInfo.append(tbl);
                pass
            pass

            self.getPMConfig();
            self.luaConfig = gLuaPM.config();

            dict["games_info"] = glistInfo;

            if isDebugPublish:
                dict["project_dir"] = os.path.join(platconfig.project_dir, "client_publish_dis", distdir);
                dict["hotupdate_dir_root"] = os.path.join(platconfig.project_dir, "client_publish_dis");
                dict["whitelist_path"] = os.path.join(platconfig.project_dir, "client_publish_dis", "navigator.json");
            else:
                if self.checkBox_slots_update.checkState() == Qt.Qt.Checked:
                    dict["project_dir"] = os.path.join(platconfig.project_dir, "client_publish_dev_slots", distdir);
                    dict["hotupdate_dir_root"] = os.path.join(platconfig.project_dir, "client_publish_dev_slots");
                    dict["whitelist_path"] = os.path.join(platconfig.project_dir, "client_publish_dev_slots",
                                                          "navigator.json");
                else:
                    dict["project_dir"] = os.path.join(platconfig.project_dir, "client_publish_dev", distdir);
                    dict["hotupdate_dir_root"] = os.path.join(platconfig.project_dir, "client_publish_dev");
                    dict["whitelist_path"] = os.path.join(platconfig.project_dir, "client_publish_dev",
                                                          "navigator.json");

            if not os.path.exists(dict["project_dir"]):
                MsgBox().msg("没有找到 %s \n请确保目录存在!!" % (dict["project_dir"]));
                return;

            thread = PublishAllThread(self, None, dict);
            thread.update_version_trigger.connect(self.onUpdateVersion);
            thread.start();
            self.threads["publishAll"] = thread;
            pass


        except Exception as err:
            errmsg(err);
        pass

    def onSelAllSubGameClicked(self):
        for row in range(self.subgame_tablistview.rowCount()):
            gameitem = self.subgame_tablistview.item(row, 0)
            gameitem.setCheckState(self.checkBox_sel_all_game.checkState())

        pass

    def onSpecDirClicked(self):
        self.groupBox_sym_tbl.setEnabled(self.checkBox_spec_dir.checkState() == QtCore.Qt.Checked)
        pass

    def onSoDirClicked(self):
        try:
            dirname = QFileDialog.getExistingDirectory(self, "选择so目录");
            self.lineEdit_so_dir.setText(dirname);

        except Exception as err:
            errmsg(err);
        pass

    def onMappingDirClicked(self):
        try:
            dirname = QFileDialog.getExistingDirectory(self, "选择mapping目录");
            self.lineEdit_mapping_dir.setText(dirname);

        except Exception as err:
            errmsg(err);
        pass

    def onUploadSymTbl(self):
        try:

            isSpecDir = self.checkBox_spec_dir.checkState() == QtCore.Qt.Checked;
            objDir = self.lineEdit_so_dir.text().strip();
            mappingDir = self.lineEdit_mapping_dir.text().strip();

            if isSpecDir == True:
                if isWin():
                    if objDir == "" or mappingDir == "":
                        MsgBox().msg("请选择so目录，和mapping目录");
                        return;
                else:
                    if objDir == "":
                        MsgBox().msg("请选择含有 dsym 的目录");
                        return;
            else:
                if isMacOS():
                    MsgBox().msg("平台必须要指定 dsym 目录");
                    return;

            # print ("Prepre to upload the symbol table...");

            self.getPMConfig();

            if not self.isThreadEnd("uploadSymtbl"):
                return;

            thread = UploadThread(self, None, isSpecDir, objDir, mappingDir);
            thread.start();
            self.threads["uploadSymtbl"] = thread;
        except Exception as err:
            errmsg(err);
        pass

    def onOpenWhiteList(self):
        try:
            self.whiltelist_dialog = WhiteListDialog(self);
            self.whiltelist_dialog.show();
        except Exception as err:
            errmsg(err);
        pass

    def onWhiteList(self):
        try:

            self.pushButton_whitelist.setEnabled(self.checkBox_whitelist.checkState() == QtCore.Qt.Checked);
            gWhiteList.setWhiteListEnabled(self.checkBox_whitelist.checkState() == QtCore.Qt.Checked);

        except Exception as err:
            errmsg(err);
        pass

    def onFileLogger(self):
        pass

    def onRemoteLogger(self):
        # if (self.ckbox_use_filelogger.)
        # if (self.ckbox_use_filelogger.checkState() == Qt.Qt.Checked):
        #     MsgBox().msg("已经开启了文件日志，开启网络日志会截断");
        pass

    def onSelectDir(self):
        try:
            directory = QtWidgets.QFileDialog.getExistingDirectory(self, "选择文件夹", "./");
            self.lineEdit_inputdir.setText(directory);
        except Exception as err:
            errmsg(err);
        pass

    def onRepack(self):
        try:
            dirstr = self.lineEdit_inputdir.text();
            if (dirstr == ""):
                MsgBox().msg("请选择文件夹");
                return;

            if not self.isThreadEnd("repackthread"):
                return;

            # dirstr = self.lineEdit_inputdir.text ();
            thread = RepackThread(self, dirstr);
            thread.start();
            self.threads["repackthread"] = thread;

        except Exception as err:
            errmsg(err);
        pass

    def onUseTestHotupdate(self):
        pass

    def onZipGames(self):
        pass

    def onLoadArchList(self):
        pass

    def onArchDBClicked(self):
        try:
            str = self.listWidget_arch.currentItem().text();

            self.getPMConfig();

            if not self.isThreadEnd("exportipa"):
                return;

            thread = ExportIpaThread(self, None, str);
            thread.start();
            self.threads["exportipa"] = thread;

        except Exception as err:
            errmsg(err);
        pass

    '''获取格式化时间'''

    def get_time_str(self):
        ltime = time.localtime();
        return str(ltime.tm_year) + str(ltime.tm_mon) + str(ltime.tm_mday) + str(ltime.tm_hour) + str(
            ltime.tm_min) + str(ltime.tm_sec);

    pass

    def getGamesInfo(self):

        try:
            chConfig = gPMConfig.getCurChConfig();
            if chConfig == None:
                return;

            glistInfo = [];

            for row in range(self.subgame_tablistview.rowCount()):
                gameitem = self.subgame_tablistview.item(row, 0)
                veritem = self.subgame_tablistview.cellWidget(row, 1);
                hallitem = self.subgame_tablistview.cellWidget(row, 2);

                gname = gameitem.text() or "";
                if gname != "":
                    gversion = veritem.text() or "";
                    hallnum = hallitem.text() or "";

                    tbl = {};
                    tbl["gname"] = gname;
                    tbl["version"] = gversion;
                    tbl["hallnum"] = hallnum;
                    tbl["selected"] = gameitem.checkState() == Qt.Qt.Checked;
                    glistInfo.append(tbl);

            return glistInfo;

        except Exception as err:
            errmsg(err);
        pass

    def onTabChanged(self):
        self.onTabPageChanged();

    def onFetchGameList(self):

        infos = {};

        infos["subgame"] = {};
        infos["list"] = [];

        try:
            if isMacOS():
                platconfig = gPMConfig.getPlatSettings("ios");
            else:
                platconfig = gPMConfig.getPlatSettings("android");

            game_dir = os.path.join(platconfig.project_dir, "client", "game");

            gameConfigPath = os.path.join(game_dir, "gamesConfig.json");
            gamesConfig = None;

            if os.path.exists(gameConfigPath):
                with open(gameConfigPath, "r") as file:
                    content = file.read();
                    gamesConfig = json.loads(content);
                pass

            if os.path.exists(game_dir):
                for gname in os.listdir(game_dir):
                    game_src_dir = os.path.join(game_dir, gname, "src");
                    game_res_dir = os.path.join(game_dir, gname, "res");

                    if os.path.exists(game_src_dir) and os.path.exists(game_res_dir):
                        infos["list"].append(gname);
                        infos["subgame"][gname] = {};

                        if gamesConfig and gname in gamesConfig:
                            infos["subgame"][gname]["version"] = gamesConfig[gname]["version"];
                            infos["subgame"][gname]["minhall"] = gamesConfig[gname]["minhall"];
                        else:
                            infos["subgame"][gname]["version"] = "1.0";
                            infos["subgame"][gname]["minhall"] = 1;

                self.reloadGameList(infos);

            return list;
        except Exception as err:
            errmsg(err);
        pass

    def onUpdateVersion(self, dict):
        try:
            print("Update versions info ...");
            hallnum = dict["main"]["hallnum"];

            games_info = dict["games_info"];

            self.edit_hallnum.setText(str(hallnum));

            for row in range(self.subgame_tablistview.rowCount()):
                gameitem = self.subgame_tablistview.item(row, 0)
                # veritem = self.subgame_tablistview.cellWidget(row,1);
                hallitem = self.subgame_tablistview.cellWidget(row, 2);

                gamename = gameitem.text() or "";

                if hallitem:
                    for k in range(len(games_info)):
                        info = games_info[k]
                        if info["gname"] == gamename:
                            hallitem.setText(info["hallnum"])
                            break;


        except Exception as err:
            errmsg(err);

        pass;

    def onMakeResH5(self):
        try:
            if not self.isThreadEnd("packh5"):
                return;

            param = {};
            param["make_res"] = True;

            self.threads["packh5"] = PackCreatorH5(self, param);
            self.threads["packh5"].start();
        except Exception as err:
            errmsg(err);

    def onPackH5(self):
        try:
            if not self.isThreadEnd("packh5"):
                return;

            param = {};

            self.threads["packh5"] = PackCreatorH5(self, param);
            self.threads["packh5"].start();
        except Exception as err:
            errmsg(err);

    def onRGBA8888Clicked(self):
        if self.ckbox_use_rgba8888.checkState() == Qt.Qt.Checked:
            self.ckbox_use_etc2.setCheckState(Qt.Qt.Unchecked);
            self.ckbox_use_pvr.setCheckState(Qt.Qt.Checked);
        pass

    def onUseIPLocal(self):
        try:
            platconfig = self.getPlatSettings();
            srv_ip = platconfig.srv_ip;

            if self.ckbox_use_ip_local.checkState() == Qt.Qt.Checked:
                arr = srv_ip.split(".");
                ip = "";
                sum = 0;
                for i in range(len(arr)):
                    arr[i] = arr[i].strip();
                    if arr[i] == "":
                        arr[i] = "0";
                    ip += arr[i];

                if int(ip) == 0:
                    self.ckbox_use_ip_local.setCheckState(Qt.Qt.Unchecked);
                    MsgBox().msg("ip地址不合法!\n请配置ip");
                    self.handleMenu("AppProfile");

                pass

        except Exception as err:
            errmsg(err);

    def onShowErrorOnly(self):
        self.text_panel_error.setHidden(self.ckbox_show_error_only.checkState() != Qt.Qt.Checked);
        self.text_panel.setHidden(self.ckbox_show_error_only.checkState() == Qt.Qt.Checked);

    def onCleanProfile(self):
        if not self.isThreadEnd("clean"):
            return;

        if QMessageBox.Ok == MsgBox().ask("确定清除xcode profiles 么，清除后需要手动打开xcode导入哦！"):
            self.threads["clean"] = CleanProfileThread(self, None);
            self.threads["clean"].start();
        pass

    def onMakePem(self):
        # print("make pem");
        cer_file = self.lineEdit_cert.displayText();
        p12_file = self.lineEdit_p12.displayText();
        name = self.lineEdit_name.displayText();
        passwd = self.lineEdit_passwd.displayText();

        if cer_file == "" or p12_file == "" or name == "" or passwd == "":
            return;

        if not self.isThreadEnd("cert"):
            return;

        thread = MakePushCertThread(self, cer_file, p12_file, name, passwd);
        thread.start();

        self.threads["cert"] = thread;

    def onOpenCert(self):
        try:
            filename, filetype = QFileDialog.getOpenFileName(self, "选择cert文件",
                                                             "/Users/qingtan/Documents/ios_cert/dominoA/",
                                                             "Cer Files (*.cer)");
            self.lineEdit_cert.setText(filename);
        except Exception as err:
            errmsg(err);
        pass

    def onOpenP12(self):
        filename, filetype = QFileDialog.getOpenFileName(self, "选择p12文件", "/Users/qingtan/Documents/ios_cert/dominoA/",
                                                         "Cer Files (*.p12)");
        self.lineEdit_p12.setText(filename);

    def onCleanXcodeData(self):
        if not self.isThreadEnd("cleanXcodeData"):
            return;

        self.threads["cleanXcodeData"] = CleanXcodeThread(self, None);
        self.threads["cleanXcodeData"].start();

    def onVNameChanged(self):
        # print ("vname changed")
        text = self.edit_vname.displayText();

        new_vname = "";

        arr = text.split(".");
        vcode = "";
        for i in range(len(arr)):
            arr[i] = arr[i].strip();
            if arr[i] == "":
                arr[i] = "0";
            vcode += arr[i];
            if (i < len(arr) - 1):
                new_vname = new_vname + arr[i] + ".";
            else:
                new_vname = new_vname + arr[i];

        self.new_vname = new_vname;
        # print (new_vname);

        # new_vname = arr.join (".");

        self.edit_vcode.setText(vcode);
        # print (vcode);

    def isThreadEnd(self, name):

        if not hasattr(self, "threads"):
            return True;

        return (name not in self.threads) or (
                name in self.threads and self.threads[name] and self.threads[name].isFinished())

    def onListItemDBClicked(self):
        try:

            if not self.isThreadEnd("install"):
                return;

            devname = self.cbox_devlist.currentText();
            if devname == None or devname == "":
                MsgBox().msg("没有任何设备被选中!");
                return;

            thread = InstallThread(self, self.list_app.currentItem().text(), devname);
            thread.start();
            self.threads["install"] = thread;
        except Exception as err:
            errmsg(err);

    def onRestartAdb(self):
        try:

            if not self.isThreadEnd("restart_adb"):
                return;

            thread = RestartAdbThread(self);
            thread.start();
            self.threads["restart_adb"] = thread;
        except Exception as err:
            errmsg(err);

    def onAndroidLogCat(self):
        try:

            isExportTxt = self.checkBox_export_txt.checkState() == Qt.Qt.Checked;
            isNox = self.checkBox_nox.checkState() == Qt.Qt.Checked;

            if not self.isThreadEnd("logcat"):
                return;

            devname = self.cbox_devlist.currentText();
            if devname == None or devname == "":
                MsgBox().msg("没有任何设备被选中!");
                return;

            thread = LogCatThread(self, devname, isExportTxt, isNox);
            thread.start();
            self.threads["logcat"] = thread;
        except Exception as err:
            errmsg(err);

    def onTabPageChanged(self):
        try:
            gPMConfig.setDebug(self.ckbox_use_debug.checkState() == Qt.Qt.Checked);

            '''
            tab index changed 
            '''
            if self.bottom_panel.currentIndex() == 0:
                self.onFetchGameList()
            elif self.bottom_panel.currentIndex() == 3:
                self.loadAppList();
            elif self.bottom_panel.currentIndex() == 5:
                self.onLoadArchList();

        except Exception as err:
            errmsg(err);

    def onDebugClicked(self):
        self.onTabPageChanged();

    def onFreshAppList(self):
        self.loadAppList()

    def getDeviceList(self, emulator=None):
        pass

    def onConnectDevice(self, emulator=None):

        if not self.isThreadEnd("connect"):
            return;

        thread = DevThread(self, None, emulator);
        thread.start();
        self.threads["connect"] = thread;
        pass;

    def onConnectEmulator(self):
        try:
            #    process = subprocess.Popen("adb connect 127.0.0.1:62001",
            process = subprocess.Popen("adb connect 127.0.0.1:7555",
                                       shell=True,
                                       bufsize=0,
                                       stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT,
                                       encoding='utf-8',
                                       universal_newlines=True);

        except Exception as err:
            errmsg(err);

        #    os.system("adb connect 127.0.0.1:62001");
        self.onConnectDevice("127.0.0.1:62001");
        pass

    def onAddTask(self):
        self.getPMConfig();

        msg = self.preCheckArgument();
        if msg != None:
            MsgBox().msg(msg);
            return;

        self.expandTaskPanel(True);

        # print ("add Task");
        hallName = gPMConfig.getCurHallName();
        chName = gPMConfig.getCurChName();
        list = gPMConfig.getCurGameList();
        chData = gPMConfig.getCurChConfig();

        config_str = gPMConfig.configCurrentToString();
        md5 = hashlib.md5();
        md5.update(config_str.encode());
        md5str = md5.hexdigest();

        if md5str in self.pack_config_strings:
            MsgBox().msg("已经添加了,无需再次添加");
            return;

        str = '''参数:\n%s\n[大厅 : %s] [渠道 : %s] [版本 : %s] [版本代码 : %s]\n游戏列表: %s''' % (md5str,
                                                                                    hallName, chName,
                                                                                    chData.vname,
                                                                                    chData.vcode, list);
        item = QListWidgetItem(str, self.list_tasks);
        self.pack_config_strings[md5str] = config_str;

    def onLockGameList(self):
        for row in range(self.subgame_tablistview.rowCount()):
            gameitem = self.subgame_tablistview.item(row, 0)
            veritem = self.subgame_tablistview.cellWidget(row, 1);
            hallitem = self.subgame_tablistview.cellWidget(row, 2);
            if hallitem:
                hallitem.setEnabled(self.ckbox_lock_gamelist.checkState() != Qt.Qt.Checked)

        # self.subgame_tablistview.setEnabled(self.ckbox_lock_gamelist.checkState() != Qt.Qt.Checked);
        # self.checkBox_sel_all_game.setEnabled(self.ckbox_lock_gamelist.checkState() != Qt.Qt.Checked);

    def msgboxMsg(self, msg):
        ret = MsgBox().msg(msg);

    def askboxMsg(self, msg):
        ret = MsgBox().ask(msg);
        gsignal.msg_ret_trigger.emit(ret);
        # gsignal.msg_ret_trigger.emit (ret);


    def onInputBox(self,dict):
        info = inputdlg (self,dict);
        msg = info ["msg"];
        ret = info ["ret"];
        gsignal.input_ret_trigger.emit (info);

    def onEtc2Clicked(self):
        # if (self.ckbox_use_etc2.checkState() == Qt.Qt.Checked):
        #     self.ckbox_use_pvr.setCheckState(Qt.Qt.Unchecked);
        #     self.ckbox_use_rgba8888.setCheckState(Qt.Qt.Unchecked);

        pass

    def onPvrClicked(self):
        # if (self.ckbox_use_pvr.checkState() == Qt.Qt.Checked):
        #     self.ckbox_use_etc2.setCheckState(Qt.Qt.Unchecked);
        pass

    def onASTCClicked(self):
        # if self.ckbox_use_astc.checkState ()== Qt.Qt.Checked:
        #     self.ckbox_use_astc.setCheckState(Qt.Qt.Unchecked);

        pass

    def onMakeAssetsClicked(self):
        self.getPMConfig();

        if not self.isThreadEnd("mkassets"):
            return;

        msg = self.preCheckArgument();
        if msg != None:
            MsgBox().msg(msg);
            return;

        if (QMessageBox.Ok != MsgBox().ask("仅生成assets，请确认文件没有被占用!")):
            return;

        # self.expandTaskPanel(False);
        dict = {};
        dict["games_info"] = self.getGamesInfo();
        thread = MakeAssetsThread(self, None, dict);
        thread.start();
        self.threads["mkassets"] = thread;
        pass

    def onBuildClicked(self):
        self.getPMConfig();

        if not self.isThreadEnd("buildaa"):
            return;

        # self.expandTaskPanel(False);
        dict = {};
        dict["games_info"] = self.getGamesInfo();
        thread = BuildThread(self, None, dict);
        thread.start();
        self.threads["buildaa"] = thread;
        pass

    def onFetchHallList(self):
        halllist = [];
        platconfig = self.getPlatSettings();
        hallDir = os.path.join(platconfig.project_dir, "client", "hall", "src", "type");
        if os.path.exists(hallDir):
            for hallName in os.listdir(hallDir):
                halllist.append(hallName)
        gPMConfig.setHallList(halllist);

    def onMakeConfigClicked(self):
        self.getPMConfig();

        if not self.isThreadEnd("mkconfig"):
            return;

        msg = self.preCheckArgument();
        if msg != None:
            MsgBox().msg(msg);
            return;

        dict = {};
        dict["games_info"] = self.getGamesInfo();
        thread = MakeConfigThread(self, None, dict);
        thread.start();
        self.threads["mkconfig"] = thread;

        pass

    def onProceedUploadSymTbl(self, **kwargs):

        try:
            print("Upload Symbol Table...");

            hallName = kwargs.get("hallName");
            chName = kwargs.get("chName");

            if hallName == "" or chName == "":
                rmsgbox("参数错误..");
                return;

            isSpecDir = kwargs.get("isSpecDir");
            objDir = kwargs.get("objDir");
            mapppingFileDir = kwargs.get("mapppingFileDir");

            if isSpecDir == True:
                if isWin():
                    if objDir == "" or mapppingFileDir == "":
                        rmsgbox("请选择so目录，和mapping目录");
                        return;
                else:
                    if objDir == "":
                        rmsgbox("请选择含有 dsym 的目录");
                        return;
                pass

            platConfig = gLuaPM.platConfig(hallName);
            chConfig = gLuaPM.chConifg(hallName, chName)

            bugly_appid = platConfig.bugly_appid;
            bugly_appkey = platConfig.bugly_appkey;

            packagename = chConfig.name;
            vname = self.new_vname;

            jarPath = os.path.join("common", "buglytools", "buglyqq-upload-symbol.jar");

            if isMacOS():
                platName = "IOS";
                mappingDir = "";

                print("搜索 dSYM 目录");
                all = os.walk(objDir);
                for path, dir, filelist in all:
                    for filename in filelist:
                        if "app.dSYM" in path:
                            si = path.find("app.dSYM");
                            slen = len("app.dSYM");
                            path = path[0:(si + slen)];
                            objDir = path

                            break;

                print("dSYM 目录 %s " % objDir);
                # print (mappingDir);

                cmdstr = 'java -jar %s -appid %s -appkey %s -bundleid %s -version %s -platform %s -inputSymbol %s' % (
                    jarPath,
                    bugly_appid,
                    bugly_appkey,
                    packagename,
                    vname,
                    platName,
                    objDir,
                );

            else:
                platName = "Android";
                platconfig = self.getPlatSettings();

                dst_project_dir = os.path.join(platconfig.project_dir, "frameworks", "runtime-src", "proj.studio");
                objDir = os.path.join(dst_project_dir, "app", "obj");

                searchDir = os.path.join(dst_project_dir, "app");
                mappingDir = os.path.join(dst_project_dir, "app", "build", "tmp", "compileReleaseJavaWithJavac");

                print("搜索 source-classes-mapping 文件");
                all = os.walk(searchDir);
                for path, dir, filelist in all:
                    for filename in filelist:
                        if "source-classes-mapping" in filename:
                            mappingDir = path;
                            break;

                if isSpecDir == True:
                    mappingDir = mapppingFileDir;

                cmdstr = 'java -jar %s -appid %s -appkey %s -bundleid %s -version %s -platform %s -inputSymbol %s -inputMapping %s' % (
                    jarPath,
                    bugly_appid,
                    bugly_appkey,
                    packagename,
                    vname,
                    platName,
                    objDir,
                    mappingDir
                );

            Commander().do(cmdstr);

            tmpPath = os.path.join(".", "buglybin");
            if os.path.exists(tmpPath):
                print("remove %s" % tmpPath);
                shutil.rmtree(tmpPath, ignore_errors=True);

            tmpPath = os.path.join(".", "cp_buglySymbolAndroid.jar");
            if os.path.exists(tmpPath):
                print("remove %s" % tmpPath);
                os.remove(tmpPath);

            tmpPath = os.path.join(".", "cp_buglySymboliOS.jar");
            if os.path.exists(tmpPath):
                print("remove %s" % tmpPath);
                os.remove(tmpPath);

            tmpPath = os.path.join(".", "cp_buglyQqUploadSymbolLib.jar");
            if os.path.exists(tmpPath):
                print("remove %s" % tmpPath);
                os.remove(tmpPath);

            rmsgbox("恭喜发财 \n\n符号表上传完成,还不赶紧买了火锅庆祝一下!!");

        except Exception as err:
            errmsg(err);
        pass

    '''导航栏回调'''

    def handleMenu(self, text, object=None):
        # print(qaction.text() + " is triggered!")
        if text == "AppProfile":
            try:
                self.preference_dialog = PreferDialog(self)
                self.preference_dialog.show();
            except Exception as err:
                errmsg(err);

        elif text == "LangManager":
            try:
                self.langman_dialog = LangManDialog(self, None);
                self.langman_dialog.show();
            except Exception as err:
                errmsg(err);

        elif text == "SaveAllSettings":
            self.onSaveSettings();

        elif text == "GameProfile":
            try:
                self.gameprofile_dialog = GameProfileDialog(self, None)
                self.gameprofile_dialog.show();
            except Exception as err:
                errmsg(err);
        elif text == "FilterListManager":
            try:
                self.filter_dialog = FilterListDialogBase(self)
                self.filter_dialog.show();
            except Exception as err:
                print(err);

            pass

        elif text == "WhiteList":

            self.whiltelist_dialog = WhiteListDialog(self);
            self.whiltelist_dialog.show();
            pass

        elif text == "LoadSettings":
            print ("加載配置文件")
            try:
                filename, filetype = QFileDialog.getOpenFileName(self, "选择配置文件",
                                                                 get_home_dir(),
                                                                 "Json Files (*.json)");
                print(filename);
                print(filetype);

            except Exception as err:
                errmsg(err)

            pass

        '''Click对象名称'''
        name = "";
        if object != None:
            name = object.objectName();

        '''视图'''
        if re.search("actioniPhone_", name):
            if isMacOS():
                return;

            # 保持唯一勾选
            if hasattr(self, "m_lastAction"):
                self.m_lastAction.setChecked(False);
            object.setChecked(True);
            self.m_lastAction = object;

            platconfig = self.getPlatSettings();
            if not hasattr(platconfig, "exe_dir") or platconfig.exe_dir == "":
                print("请先配置目标程序路径！ Menu->AppProfile")
                return;

            width, height = None, None;

            if name == "actioniPhone_1":
                width, height = 960, 640;
            elif name == "actioniPhone_2":
                width, height = 1024, 768;
            elif name == "actioniPhone_3":
                width, height = 1136, 640;
            elif name == "actioniPhone_4":
                width, height = 800, 480;
            elif name == "actioniPhone_5":
                width, height = 960, 540;
            elif name == "actioniPhone_6":
                width, height = 1280, 720;
            elif name == "actioniPhone_7":
                width, height = 1600, 900;
            elif name == "actioniPhone_8":
                width, height = 1520, 720;
            elif name == "actioniPhone_9":
                width, height = 1494, 640;
            pass

            if width and height:
                jsonstr = "";
                configFile = os.path.join(platconfig.exe_dir, "config.json");

                try:
                    '''读数据'''
                    file = open(configFile, 'r');
                    if file:
                        configObject = jsonpickle.decode(file.read());
                        configObject["init_cfg"]["width"] = width;
                        configObject["init_cfg"]["height"] = height;

                        jsonstr = jsonpickle.encode(configObject);
                        file.close();

                    '''写数据'''
                    file = open(configFile, 'w');
                    if file and jsonstr != "":
                        file.write(jsonstr);
                        file.close();

                        # 先关闭已有目标程序
                        os.system(r'taskkill /F /IM domino.exe');
                        # 重新打开目标程序
                        hallName = self.cbox_hall.currentText();
                        channelCfg = gLuaPM.hallConfig(hallName);
                        if channelCfg:
                            cmd_dir = platconfig.project_dir + "\\" + channelCfg.srcname + "\\run_win32.cmd";
                            os.system(cmd_dir);
                    pass
                except Exception as err:
                    errmsg(err);

        '''小工具'''
        try:
            # if isMacOS():
            #     return;
            #
            # # 磁盘根目录
            # disk_dir = os.path.dirname(os.getcwd());
            # cmd_str  = "";
            #
            # if name == "":
            #     pass
            # else:
            #     cmd_str = object.iconText();    # 该选项文件夹名称

            # if cmd_str != "":
            # cmd_str = "cd " + os.path.join(os.getcwd(), "tools", cmd_str) + " & %s & StartScript.vbs" % disk_dir;
            # Commander().do(cmd_str);
            pass
        except Exception as err:
            print(err);

        '''模拟器多开'''
        folderName = "simulator";
        if re.search(folderName, name) and len(name) > 9:
            object.setChecked(not object.isChecked());

            platconfig = self.getPlatSettings();
            if not hasattr(platconfig, "exe_dir") or platconfig.exe_dir == "":
                print("请先配置目标程序路径！ Menu->AppProfile")
                return;

            try:
                index = int(name[9:]);
                hallName = self.cbox_hall.currentText();
                channelCfg = gLuaPM.hallConfig(hallName);

                if channelCfg:
                    simulator_dir = os.path.join(platconfig.project_dir, folderName);
                    src_dir = os.path.join(platconfig.project_dir, channelCfg.srcname);
                    cmd_dir = os.path.join(simulator_dir, "." + channelCfg.srcname + name[9:]);

                    if not os.path.exists(simulator_dir):
                        os.mkdir(simulator_dir);
                    if not os.path.exists(cmd_dir):
                        os.system("mklink /j \"" + cmd_dir + "\" \"" + src_dir + "\"");

                    os.system(os.path.join(cmd_dir, "run_win32.cmd"));
                pass
            except Exception as err:
                pass

    def iconMakerClick(self, event):
        try:
            self.icon_dialog = IconMakerDialog(self, None);
            self.icon_dialog.show();
        except Exception as err:
            errmsg(err);

    def langEditClick(self, event):
        try:
            self.langman_dialog = LangManDialog(self, None);
            self.langman_dialog.show();
        except Exception as err:
            errmsg(err);

    def onLogger(self, event):
        try:
            if not hasattr(self, 'logger_dialog'):
                gtype = self.cbox_hall.currentText();
                curgame = gLuaPM.hallConfig(gtype).srcname;
                self.logger_dialog = DebugLogger(self, None);
                self.logger_dialog.setExistedGames(self.gamelist, curgame);
            self.logger_dialog.show();
        except Exception as err:
            errmsg(err);

    def processtrigger(self, qaction):
        self.handleMenu(qaction.text(), qaction);

    def onStateChanged(self):
        pass
        # print ("state changed");

    def onCheckSyntaxBtnClicked(self):
        self.getPMConfig();

        if not self.isThreadEnd("check"):
            return;

        thread = CheckSyntaxThread(self, None);
        thread.start();
        self.threads["check"] = thread;
        pass

    def onSaveSettings(self):
        self.getPMConfig();
        gPMConfig.save();

        print("All Save OK!")

    def onClearScreen(self):
        self.clearText();
        pass

    def getAllGameList(self):
        try:
            game_list = [];

            for row in range(self.subgame_tablistview.rowCount()):
                gameitem = self.subgame_tablistview.item(row, 0);
                game_list.append(gameitem.text());

            # print (game_list);
            return game_list;

        except Exception as err:
            errmsg(err);

    def getSelectedGameList(self):
        try:
            game_list = [];

            for row in range(self.subgame_tablistview.rowCount()):
                gameitem = self.subgame_tablistview.item(row, 0);
                if gameitem.checkState() == Qt.Qt.Checked:
                    game_list.append(gameitem.text());

            # print (game_list);
            return game_list;

        except Exception as err:
            errmsg(err);

    def onLoadIcon(self):
        pass

    def loadHallList(self):
        pass

    def reloadChList(self):

        list = [];
        chName = self.cbox_ch.currentText();
        hallName = self.cbox_hall.currentText();

        self.cbox_ch.clear();
        for ch in gLuaPM.chConfigs(hallName):
            self.cbox_ch.addItem(ch);
            list.append(ch);

        return list;

        pass

    def isHallExisted(self, hallname):
        pass

    def onHallChanged(self):
        try:

            hallName = self.cbox_hall.currentText();
            if hallName == "":
                return;

            print("当前大厅 %s" % (hallName))

            """
            save old chconfig 
            """
            chName = self.cbox_ch.currentText();

            if chName != "":
                gPMConfig.setCurChName(chName);

            """
            set new chconfig 
            """
            gPMConfig.setCurHallName(hallName);
            prev_chName = gPMConfig.getCurChName();

            '''
            reload channel list
            '''
            try:
                self.cbox_ch.currentIndexChanged.disconnect(self.onChChanged);
            except Exception as err:
                pass

            chList = self.reloadChList();

            self.cbox_ch.setCurrentIndex(-1);
            self.cbox_ch.currentIndexChanged.connect(self.onChChanged);

            prev_chIndex = self.cbox_ch.findText(prev_chName);
            if prev_chIndex < 0 or prev_chIndex >= self.cbox_ch.count():
                prev_chIndex = 0;

            self.cbox_ch.setCurrentIndex(prev_chIndex);
            self.refresh_version();

        except Exception as err:
            errmsg(err);

    def onChChanged(self):

        try:
            chName = self.cbox_ch.currentText();
            if chName == "":
                return;

            hallName = self.cbox_hall.currentText();
            if hallName == "":
                return;

            print("当前渠道 %s" % (chName));

            gPMConfig.setCurHallName(hallName);
            gPMConfig.setCurChName(chName);

            self.restorePMConfig();
            self.onLoadIcon();

            if self.bottom_panel.currentIndex() == 0:
                self.onFetchGameList()

            if self.bottom_panel.currentIndex() == 3:
                self.loadAppList();

            self.refresh_version();

        except Exception as err:
            errmsg(err);

    '''设置配置页输入框显示状态'''

    def setPageConfigEditVisible(self, visible):
        self.edit_config.setVisible(visible or False);
        if visible:
            self.edit_config.setText("");
            self.edit_config.setFocus();

    '''配置页输入框回车事件'''

    def onNewPageConfig(self):
        self.setPageConfigEditVisible(False);
        text = self.edit_config.text();
        try:
            if text == "":
                self.refreshPageConfig();
                return;
            index = self.cbox_config.findText(text);
            if index < 0:
                self.cbox_config.insertItem(0, text);
                self.cbox_config.setCurrentText(text);
                PageConfig.getInstance().save();
            pass
        except Exception as err:
            print(err);

    '''配置页更改事件'''

    def onPageConfigChanged(self):
        text = self.cbox_config.currentText();
        if text == "配置页++":
            self.cbox_config.setCurrentIndex(-1);
            self.setPageConfigEditVisible(True);
        elif text != "":
            self.text_panel.setFocus();
            PageConfig.getInstance().load();  # 加载配置
            chConfig = gPMConfig.getCurChConfig();
            chConfig.pageName = text;
        pass

    '''配置页刷新显示'''

    def refreshPageConfig(self):
        # 配置页刷新
        chConfig = gPMConfig.getCurChConfig();
        self.cbox_config.clear();
        self.cbox_config.addItem("配置页++");
        self.cbox_config.insertItems(0, PageConfig.getInstance().getPages());  # 加载配置页
        self.edit_config.setVisible(False);

        pageName = hasattr(chConfig, "pageName") and chConfig.pageName or "";
        if pageName == "" and self.cbox_config.count() > 1:
            self.cbox_config.setCurrentText(self.cbox_config.itemText(0));
        else:
            self.cbox_config.setCurrentText(pageName);

        # if hasattr(chConfig, "pageName"):
        #     if chConfig.pageName == "" and self.cbox_config.count() > 1:
        #         self.cbox_config.setCurrentText(self.cbox_config.itemText(0));
        #     else:
        #         self.cbox_config.setCurrentText(chConfig.pageName);
        # else:

    '''TreeView点击事件'''

    def onTreeItemClicked(self, index):
        #    item = self.list_model.itemFromIndex(index);
        pass

    '''TreeView勾选事件'''

    def onTreeItemChanged(self, item):
        try:
            # item不存在，或者不可选择
            if item == None or not item.isCheckable():
                return;

            if not hasattr(item, 'isCascaded'):
                item.isCascaded = False;

            # 当前条目为三态: 全选 全不选 部分选中
            if item.isTristate():
                if not item.isCascaded:
                    checkState = item.checkState()
                    for row in range(item.rowCount()):
                        child = item.child(row);
                        child.isCascaded = True;
                        child.setCheckState(checkState);
                    pass
                item.isCascaded = False;
            else:
                if not item.isCascaded:
                    parentItem = item.parent();
                    itemCount = parentItem.rowCount();
                    selectedCount = 0;

                    for row in range(itemCount):
                        child = parentItem.child(row);
                        if child and child.checkState() == QtCore.Qt.Checked:
                            selectedCount += 1;

                    parentItem.isCascaded = True;
                    if selectedCount <= 0:
                        parentItem.setCheckState(QtCore.Qt.Unchecked);
                    elif selectedCount >= itemCount:
                        parentItem.setCheckState(QtCore.Qt.Checked);
                    else:
                        parentItem.setCheckState(QtCore.Qt.PartiallyChecked);
                    pass
                item.isCascaded = False;

        except Exception as err:
            errmsg(err)

    '''快捷键响应事件'''

    def keyPressEvent(self, event):
        if QApplication.keyboardModifiers() == Qt.Qt.ControlModifier:
            eventKey = event.key();
            if eventKey == Qt.Qt.Key_S:  # Ctrl + S

                text = self.cbox_config.currentText();
                if text != "":
                    PageConfig.getInstance().save();  # 保存配置页
                    self.onSaveSettings();

            elif eventKey == Qt.Qt.Key_K:

                try:

                    if not self.isThreadEnd("logcat"):
                        print("Trying to terminate android-logcat")
                        thread = self.threads["logcat"];
                        thread.stop();
                    else:
                        print("Logcat Thread is not running...");
                        pass

                except Exception as err:
                    errmsg(err);

                pass
        pass

    def initLockedList(self):
        for row in range(self.subgame_tablistview.rowCount()):
            gameitem = self.subgame_tablistview.item(row, 0)
            veritem = self.subgame_tablistview.cellWidget(row, 1);
            hallitem = self.subgame_tablistview.cellWidget(row, 2);
            if hallitem:
                hallitem.setEnabled(self.ckbox_lock_gamelist.checkState() != Qt.Qt.Checked)

    def loadAppList(self):
        try:

            pass

        except Exception as err:
            errmsg(err);

    def isGameInList(self, game):
        config = gPMConfig.getCurChConfig();
        if config == None:
            return False;

    def saveOldGameList(self):
        try:
            """
            save old game list
            """
            if self.change_ch_count == 0:
                return;
            self.change_ch_count += 1;
            gPMConfig.setCurGameList(self.getSelectedGameList());
            gPMConfig.setAllGameList(self.getAllGameList());

        except Exception as err:
            errmsg(err);

    def reloadGameList(self, dict):

        try:
            gamelist = dict["list"];
            subgame_info = dict["subgame"];

            self.saveOldGameList();

            self.subgame_tablistview.clearContents();

            hallName = self.cbox_hall.currentText();

            if (hallName == ""):
                return;

            luadir = self.getLuaSrcDir(hallName);
            list = gPMConfig.getCurGameList();

            """
            restore the selected/unselected game list
            """
            rowIndex = 0;
            dirs = gamelist;
            self.subgame_tablistview.setRowCount(len(dirs) - 0)

            for gname in dirs:

                gameinfo = subgame_info[gname];

                tlistitem = QTableWidgetItem(gname);
                tlistitem.setFlags(QtCore.Qt.ItemIsUserCheckable |
                                   QtCore.Qt.ItemIsEnabled)
                tlistitem.setCheckState(QtCore.Qt.Unchecked)

                '''game'''
                self.subgame_tablistview.setItem(rowIndex, 0, tlistitem);

                '''
                game version 
                '''
                vlistitem = QLineEdit(self.subgame_tablistview);
                vlistitem.setInputMask("99.99");

                if gameinfo and "version" in gameinfo and gameinfo["version"]:
                    vlistitem.setText(gameinfo["version"]);
                else:
                    vlistitem.setText("1.0");

                vlistitem.setAlignment(Qt.Qt.AlignCenter)
                self.subgame_tablistview.setCellWidget(rowIndex, 1, vlistitem);

                '''
                hall number 
                '''
                hallitem = QLineEdit(self.subgame_tablistview);
                hallitem.setAlignment(Qt.Qt.AlignCenter)
                # hallitem.setEnabled(False);
                self.subgame_tablistview.setCellWidget(rowIndex, 2, hallitem);

                if gameinfo and "minhall" in gameinfo and gameinfo["minhall"]:
                    hallitem.setText(str(gameinfo["minhall"]));
                else:
                    hallitem.setText("1");

                rowIndex = rowIndex + 1;

            self.onSelAllSubGameClicked();

        except Exception as err:
            errmsg(err);

    def putText(self, text):
        if text != None:
            self.text_panel.append(text);

    def putErrorText(self, text):
        if text != None:
            self.text_panel_error.append(text);

    def clearText(self):
        i = 0;
        while (i < 3):
            i = i + 1;
            self.text_panel.setText("");
            self.text_panel_error.setText("");
            QApplication.processEvents()
            time.sleep(0.01);

    def startThread(self):
        self.setWidgetsEnabled(False);

    def doneThread(self, retcode):
        # self.putText("Thread Ended with code " + str(retcode));
        self.setWidgetsEnabled(True);
        self.loadAppList();

    def setWidgetsEnabled(self, bv):
        # self.setEnabled(bv);
        for widget in self.widgets:
            if widget:
                widget.setEnabled(bv);
        pass

    def vname_format(self):
        text = self.edit_vname.displayText().strip();
        return text.replace(' ', "");

    ''''
    groupbox
    '''

    def safeRestoreSinglePMConfigGroupBox(self, chConfig, configName, widgetName):

        if not hasattr(chConfig, configName):
            setattr(chConfig, configName, False);

        if hasattr(self, widgetName):
            getattr(self, widgetName).setChecked(True
                                                 if getattr(chConfig, configName)
                                                 else False);
        pass

    def safeGetSinglePMConfigGroupBox(self, chConfig, configName, widgetName):
        if hasattr(self, widgetName):
            value = getattr(self, widgetName).isChecked() == True;
            setattr(chConfig, configName, value);
        pass

    ''''
    radiobutton
    '''

    def safeRestoreSinglePMConfigRadioButton(self, chConfig, configName, widgetName):

        if not hasattr(chConfig, configName):
            setattr(chConfig, configName, False);

        if hasattr(self, widgetName):
            getattr(self, widgetName).setChecked(True
                                                 if getattr(chConfig, configName)
                                                 else False);
        pass

    def safeGetSinglePMConfigRadioButton(self, chConfig, configName, widgetName):
        if hasattr(self, widgetName):
            value = getattr(self, widgetName).isChecked() == True;
            setattr(chConfig, configName, value);
        pass

    ''''
    checkbox
    '''

    def safeRestoreSinglePMConfig(self, chConfig, configName, widgetName):

        if not hasattr(chConfig, configName):
            setattr(chConfig, configName, False);

        if hasattr(self, widgetName):
            getattr(self, widgetName).setCheckState(Qt.Qt.Checked
                                                    if getattr(chConfig, configName)
                                                    else Qt.Qt.Unchecked);
        pass

    def safeGetSinglePMConfig(self, chConfig, configName, widgetName):
        if hasattr(self, widgetName):
            value = getattr(self, widgetName).checkState() == Qt.Qt.Checked;
            setattr(chConfig, configName, value);
        pass

    def getPMConfig(self):

        try:

            chConfig = gPMConfig.getCurChConfig();
            if chConfig == None:
                return;

            self.safeGetSinglePMConfig(chConfig, "use_pop_errbox", "ckbox_use_pop_errbox");
            self.safeGetSinglePMConfig(chConfig, "use_local_srv", "ckbox_use_local");
            self.safeGetSinglePMConfig(chConfig, "use_switch_srv", "ckbox_use_switch_server");
            self.safeGetSinglePMConfig(chConfig, "use_can_release_log", "ckbox_use_release_log");
            self.safeGetSinglePMConfig(chConfig, "use_fbinvite", "ckbox_use_fbinvite");
            self.safeGetSinglePMConfig(chConfig, "use_no_aes_php", "ckbox_use_no_aes_php");
            self.safeGetSinglePMConfig(chConfig, "use_no_gzip_php", "ckbox_use_no_gzip_php");
            self.safeGetSinglePMConfig(chConfig, "use_can_log", "ckbox_use_can_log");
            self.safeGetSinglePMConfig(chConfig, "use_local_srv_ip", "ckbox_use_ip_local");

            '''
            config 
            '''
            self.safeGetSinglePMConfigGroupBox(chConfig, "use_compress_texture", "compress_texture");
            self.safeGetSinglePMConfigRadioButton(chConfig, "use_pvr", "ckbox_use_pvr");
            self.safeGetSinglePMConfigRadioButton(chConfig, "use_etc2", "ckbox_use_etc2");
            self.safeGetSinglePMConfigRadioButton(chConfig, "use_astc", "ckbox_use_astc");

            '''
            1111
            '''
            self.safeGetSinglePMConfig(chConfig, "use_rgba8888", "ckbox_use_rgba8888");
            self.safeGetSinglePMConfig(chConfig, "use_bones_zip", "ckbox_use_bone_zip");
            self.safeGetSinglePMConfig(chConfig, "use_debug", "ckbox_use_debug");
            self.safeGetSinglePMConfig(chConfig, "use_no_hotupdate", "checkBox_no_hotupdate");
            self.safeGetSinglePMConfig(chConfig, "use_slots_update", "checkBox_slots_update");

            self.safeGetSinglePMConfig(chConfig, "use_no_crypt_zip", "ckbox_use_no_crypt_zip");

            self.safeGetSinglePMConfig(chConfig, "use_pngquant", "ckbox_use_pngquant");
            self.safeGetSinglePMConfig(chConfig, "use_logger", "ckbox_use_logger");
            self.safeGetSinglePMConfig(chConfig, "use_filelogger", "ckbox_use_filelogger");
            self.safeGetSinglePMConfig(chConfig, "use_debug_hall_hotupdate", "checkBox_use_debug_hall_hotupdate")
            self.safeGetSinglePMConfig(chConfig, "use_debug_game_hotupdate", "checkBox_use_debug_game_hotupdate")

            chConfig.vname = self.vname_format();
            chConfig.vcode = self.edit_vcode.displayText().strip();
            chConfig.hallnum = self.edit_hallnum.displayText().strip();
            chConfig.pageName = self.cbox_config.currentText();

            gPMConfig.setCurGameList(self.getSelectedGameList())
            gPMConfig.setAllGameList(self.getAllGameList());

        except Exception as err:
            errmsg(err);

    def restorePMConfig(self):
        try:

            chConfig = gPMConfig.getCurChConfig();
            if chConfig == None:
                return;

            self.safeRestoreSinglePMConfig(chConfig, "use_pop_errbox", "ckbox_use_pop_errbox");
            self.safeRestoreSinglePMConfig(chConfig, "use_local_srv", "ckbox_use_local");
            self.safeRestoreSinglePMConfig(chConfig, "use_switch_srv", "ckbox_use_switch_server");
            self.safeRestoreSinglePMConfig(chConfig, "use_can_release_log", "ckbox_use_release_log");
            self.safeRestoreSinglePMConfig(chConfig, "use_fbinvite", "ckbox_use_fbinvite");
            self.safeRestoreSinglePMConfig(chConfig, "use_no_aes_php", "ckbox_use_no_aes_php");
            self.safeRestoreSinglePMConfig(chConfig, "use_no_gzip_php", "ckbox_use_no_gzip_php");
            self.safeRestoreSinglePMConfig(chConfig, "use_can_log", "ckbox_use_can_log");
            self.safeRestoreSinglePMConfig(chConfig, "use_local_srv_ip", "ckbox_use_ip_local");

            '''
            save config 
            '''
            self.safeRestoreSinglePMConfigGroupBox(chConfig, "use_compress_texture", "compress_texture");
            self.safeRestoreSinglePMConfigRadioButton(chConfig, "use_pvr", "ckbox_use_pvr");
            self.safeRestoreSinglePMConfigRadioButton(chConfig, "use_etc2", "ckbox_use_etc2");
            self.safeRestoreSinglePMConfigRadioButton(chConfig, "use_astc", "ckbox_use_astc");

            '''
            111111
            '''
            self.safeRestoreSinglePMConfig(chConfig, "use_rgba8888", "ckbox_use_rgba8888");
            self.safeRestoreSinglePMConfig(chConfig, "use_bones_zip", "ckbox_use_bone_zip");
            self.safeRestoreSinglePMConfig(chConfig, "use_debug", "ckbox_use_debug");
            self.safeRestoreSinglePMConfig(chConfig, "use_no_hotupdate", "checkBox_no_hotupdate");
            self.safeRestoreSinglePMConfig(chConfig, "use_slots_update", "checkBox_slots_update");

            gPMConfig.setDebug(self.ckbox_use_debug.checkState() == Qt.Qt.Checked);

            self.safeRestoreSinglePMConfig(chConfig, "use_no_crypt_zip", "ckbox_use_no_crypt_zip");

            self.safeRestoreSinglePMConfig(chConfig, "use_pngquant", "ckbox_use_pngquant");
            self.safeRestoreSinglePMConfig(chConfig, "use_logger", "ckbox_use_logger");
            self.safeRestoreSinglePMConfig(chConfig, "use_filelogger", "ckbox_use_filelogger");
            self.safeRestoreSinglePMConfig(chConfig, "use_debug_hall_hotupdate", "checkBox_use_debug_hall_hotupdate")
            self.safeRestoreSinglePMConfig(chConfig, "use_debug_game_hotupdate", "checkBox_use_debug_game_hotupdate")

            try:
                self.refresh_version();
            except Exception as err:

                self.edit_vname.setText(str(chConfig.vname));
                self.edit_vcode.setText(str(chConfig.vcode));
                self.edit_hallnum.setText(str(chConfig.hallnum));

                pass

            pass
        except Exception as err:
            errmsg(err);

    def load_version(self):
        try:
            if isWin():
                platconfig = gPMConfig.getPlatSettings('android');
            else:
                platconfig = gPMConfig.getPlatSettings('ios');

            version_lua_path = os.path.join(platconfig.project_dir, "client", "base", "src", "com",
                                            "config_version.lua");
            with open(version_lua_path, "r") as file:
                content = file.read();
                info = lua.execute(content);

                version = info["CONFIG_VERSION"];
                minhall = info["CONFIG_HALLNUM"];

                # self.edit_vname.setText(str(version));
                # self.edit_vcode.setText(str(chConfig.vcode));
                # self.edit_hallnum.setText(str(minhall));

                return (version, minhall);
            pass
        except Exception as err:

            pass

    def refresh_version(self):
        try:
            info = self.load_version();
            self.edit_vname.setText(str(info[0]));
            # self.edit_vcode.setText(str(chConfig.vcode));
            self.edit_hallnum.setText(str(info[1]));

            pass
        except Exception as err:

            pass

    def preCheckArgument(self):

        config = gPMConfig.getCurChConfig();
        if config == None:
            return "No Config!";

        game_list = gPMConfig.getCurGameList();
        if len(game_list) <= 0:
            # return "None Game is selected!";
            pass

        vname = config.vname;
        arr = vname.split(".");
        vname_r = "";
        for i in range(len(arr)):
            vname_r += arr[i].strip();

        if len(vname_r) < 4:
            return "版本格式错误!"

        if config.vcode == "" or int(config.vcode) <= 0:
            return "vcode 格式错误!";

        if config.hallnum == "" or int(config.hallnum) <= 0:
            return "框架号 格式错误!";

        return None;

    def expandTaskPanel(self, bv):
        # if not bv:
        #     self.setMinimumWidth(1065);
        #     self.setMaximumWidth(1065);
        # else:
        #     self.setMinimumWidth(1460);
        #     self.setMaximumWidth(1460);
        pass

    def onPackClicked(self):
        self.getPMConfig();
        self.setPageConfigEditVisible(False);

        if not self.isThreadEnd("pack"):
            return;

        ### 打包的时候要关掉 刷新器
        try:
            if (hasattr(self, "logger_dialog")):
                MsgBox().msg("正在打包，刷新器将会停止，如果需要开启，请手动打开");
                self.logger_dialog.onStopLogger();
        except Exception as err:
            errmsg(err);

        msg = self.preCheckArgument();
        # if msg != None:
        #     MsgBox().msg(msg);
        #     return;

        if (QMessageBox.Ok == MsgBox().ask("确定要打包么? 请确认参数是否正确")):

            list = self.getSelectedGameList();
            if len(list) <= 0:
                if (QMessageBox.Ok != MsgBox().ask("检测到没有一个游戏勾选，确认继续打包么?")):
                    return;

            dict = {};
            dict["games_info"] = self.getGamesInfo();
            thread = PMThread(self, None, dict);
            thread.start();
            self.threads["pack"] = thread;

    def closeEvent(self, e):
        try:

            try:
                if (hasattr(self, "logger_dialog") and self.logger_dialog.isVisible()):
                    MsgBox().msg("loggger窗口开启,主窗口不会关闭，将会隐藏!");
                    self.hide();
                    e.ignore();
                    return;
            except Exception as err:
                errmsg(err);

            try:
                self.getPMConfig();
                gPMConfig.save();
                gFilterList.save();
            except Exception as err:
                errmsg(err);

            for name in self.threads:
                thread = self.threads[name];
                if (thread != None and False == thread.isFinished()):
                    MsgBox().msg("正在执行操作，请耐心等待操作完成再退出!");
                    e.ignore();

        except Exception as err:
            errmsg(err);

    # 拖拽事件响应
    def dragEnterEvent(self, event):
        try:
            text = event.mimeData().text();
            if text.endswith("apk") or text.endswith('ipa'):
                event.accept();
            else:
                event.ignore();
        except Exception as err:
            errmsg(err);

    def dropEvent(self, event):
        try:
            path = event.mimeData().text();
            if path.endswith("apk") or path.endswith("ipa"):
                event.accept();
                try:
                    if not self.isThreadEnd("install"):
                        return;

                    devname = self.cbox_devlist.currentText();
                    if devname == None or devname == "":
                        isOk = MsgBox().ask("当前无设备，是否刷新连接设备？");
                        if isOk == 1024:
                            self.onConnectDevice();
                        return;

                    path = path[8:];
                    thread = InstallThread(self, path, devname);
                    thread.start();
                    self.threads["install"] = thread;
                except Exception as err:
                    errmsg(err);
            else:
                event.ignore();

        except Exception as err:
            errmsg(err);


"""
GameProfileDialog for base 
"""


def GameProfileDialog(parent, luaglobals):
    w = None;
    if isWin():
        w = GameProfileDialogAndroid(parent, None);
    elif isMacOS():
        w = GameProfileDialogIOS(parent, None);
    return w;

