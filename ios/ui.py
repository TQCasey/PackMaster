import os
import time

from PyQt5.QtCore import QSize
from PyQt5.QtGui import QPixmap
from PyQt5.QtWidgets import QListWidgetItem

from profile import gPMConfig, gLuaPM
from ui import MainWindow
from cmm import *

class MainWindowIOS (MainWindow):
    def __init__(self, parent=None):
        super(MainWindowIOS, self).__init__(parent)

        self.lineEdit_mapping_dir.setEnabled (False);
        self.pushButton_mapping_dir.setEnabled (False);

        platconfig = self.getPlatSettings ();
        # if platconfig == None \
        #         or platconfig.engine_dir == None or platconfig.engine_dir == "" \
        #         or platconfig.project_dir == None or platconfig.project_dir == "":
        #     self.handleMenu("AppProfile");

        if not platconfig \
                or not hasattr(platconfig,"project_dir") \
                or platconfig.project_dir == "" :
            self.handleMenu("AppProfile");
        else:
            if (platconfig and platconfig.ndk_dir == "" and isWin()):
                self.handleMenu("AppProfile");
                pass

    def getPlatSettings(self):
        return gPMConfig.getPlatSettings("ios");

    def isHallExisted(self,hallname):
        platconfig = self.getPlatSettings();
        luadir = os.path.join(platconfig.project_dir, "client", "hall", "src", "type", hallname);
        return  os.path.exists(luadir) ;
        pass

    def onLoadIcon(self):
        try:

            hallName = self.cbox_hall.currentText();
            chanName = self.cbox_ch.currentText();
            arr = hallName.split ("-");

            if chanName == "" or chanName == "":
                return ;

            projdir = os.path.join("channel_files", arr [1], "ios", chanName, "proj.ios_mac");
            projdir = projdir.replace("~", os.environ['HOME']);
            imgpath = projdir + "/ios/icon-114.png";

            if os.path.exists(projdir) and os.path.exists(imgpath):
                self.picview_ico.setPixmap(QPixmap(imgpath));
                self.picview_ico.setScaledContents(True);

        except Exception as err:
            # print (err);
            self.picview_ico.setPixmap(QPixmap(os.path.join(".","ui","icon.png")));


    def loadHallList(self):
        try:
            prev_hallName = gPMConfig.getCurHallName();

            list = [];

            for gtype in gLuaPM.config().game_type:
                curgame = gLuaPM.hallConfig(gtype).srcname;
                arr = gtype.split("-");

                ch_path = os.path.join("channel_files", arr [1], "ios",);
                if self.isHallExisted (curgame) and os.path.exists(ch_path):
                    # print ("add Hall %s " % gtype);
                    self.cbox_hall.addItem(gtype);
                    self.gamelist.append(curgame);
                    list.append(curgame);

            self.onFetchHallList ();

            prev_hallIndex = self.cbox_hall.findText (prev_hallName);

            if prev_hallIndex < 0 or prev_hallIndex >= self.cbox_hall.count ():
                return ;

            self.cbox_hall.setCurrentIndex (prev_hallIndex);

        except Exception as err:
            errmsg(err);

    def getLuaSrcDir(self,hallName):
        platconfig = self.getPlatSettings();
        luadir = os.path.join(platconfig.project_dir,gLuaPM.hallConfig(hallName).srcname);
        luadir = luadir.replace("~", os.environ['HOME']);
        return luadir;

    def loadAppList(self):
        try:
            """
            list all the apk files in current project dir
            """

            hallName = self.cbox_hall.currentText();
            chanName = self.cbox_ch.currentText();

            if chanName == "" or chanName == "":
                return ;

            self.luaHallConfig = gLuaPM.hallConfig (hallName);
            self.luaChConfig = gLuaPM.chConifg(hallName,chanName);

            platconfig = self.getPlatSettings();
            path = os.path.join(platconfig.project_dir,self.luaHallConfig.srcname);
            self.lua_project_dir = os.path.join(path.replace("~", os.environ['HOME']));
            ar = hallName.split ("-");
            archpath = os.path.join(self.lua_project_dir, "publish", ar [1], "ios");

            all = os.walk(archpath);

            self.list_app.clear ();

            for path, dir, filelist in all:
                for filename in filelist:
                    if filename.endswith("ipa"):
                        filepath = os.path.join(path, filename);
                        item = QListWidgetItem(filepath, self.list_app);
                        item.setSizeHint(QSize(0, 20));

            pass
        except Exception as err:
            errmsg(err);

    def onLoadArchList(self):
        try:
            """
            list all the apk files in current project dir
            """

            hallName = self.cbox_hall.currentText();
            chanName = self.cbox_ch.currentText();

            if chanName == "" or chanName == "":
                return ;

            self.luaHallConfig = gLuaPM.hallConfig (hallName);
            self.luaChConfig = gLuaPM.chConifg(hallName,chanName);

            platconfig = self.getPlatSettings();
            path = os.path.join(platconfig.project_dir,self.luaHallConfig.srcname);
            self.lua_project_dir = os.path.join(path.replace("~", os.environ['HOME']));
            archpath = os.path.join(self.lua_project_dir, "publish",self.hallName,"ios");

            all = os.walk(archpath);

            self.listWidget_arch.clear ();

            for path, dirs, filelist in all:
                for dir in dirs:
                    if dir.find("xcarchive") >= 0:
                        filepath = os.path.join(path, dir);
                        item = QListWidgetItem(filepath, self.listWidget_arch);
                        item.setSizeHint(QSize(0, 20));

            pass
        except Exception as err:
            errmsg(err);

    def getDeviceList(self, emulator=None):
        try:
            # rmsgbox("IOS 不支持此操作")
            cmdstr = '''system_profiler SPUSBDataType | grep "Serial Number:.*" | sed s#".*Serial Number: "##''';

            self.cbox_devlist.clear();

            sample_udid     =   '''371caf8916dbc71a039ebd1d5307ea7af4bf17ee''';
            sample_udid1    =   '''000080200004090E0E92002E''';

            deviceInfo = subprocess.check_output(cmdstr,
                                                 shell=True,
                                                 bufsize=0,
                                                 # stdout=subprocess.PIPE,
                                                 # stderr=subprocess.STDOUT,
                                                 # universal_newlines=True,
                                                 ).decode().split('''\n''');

            for i in range(len(deviceInfo)):
                devname = deviceInfo [i].strip();
                if devname != "" and (len(devname) == len (sample_udid) or len (devname) == len(sample_udid1)):
                    self.cbox_devlist.addItem(devname);

            self.cbox_devlist.setCurrentIndex(0);

        except Exception as err:
            errmsg(err);

        pass

    def onInstallApp(self,app_path,devname):
        try:
            # rmsgbox("IOS 不支持此操作")
            cmd = '''ideviceinstaller -i '%s' ''' % (app_path);

            if devname != "":
                cmd += ''' -u '%s' ''' % devname;

            print (cmd);

            # cmd = cmd.replace('\\', '');

            process = subprocess.Popen(cmd,
                                       shell=True,
                                       bufsize=0,
                                       stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT,
                                       universal_newlines=True);
            while True:
                output = process.stdout.readline()
                if output != None:
                    output = output.strip();
                    if output != "":
                        print(output);
                if output == "" and process.poll() != None:
                    break;

                if output.find('''ERROR: Invalid UDID specified''') >= 0:
                    """
                    try again 
                    """
                    self.onInstallApp(app_path,"");
                    break;

                if output.find('''Could not connect to lockdownd''') >= 0:
                    time.sleep(1)
                    process.kill();
                    print ('''ideviceinstaller 错误\n请自行修复 URL : https://github.com/libimobiledevice/ideviceinstaller/issues/48''')
                    break;

                if output.find("error") > 0 or output.find("No iOS device found") > 0:
                    time.sleep(1)
                    process.kill();
                    print ("安装错误,请重新刷新设备列表!")
                    break;

        except Exception as err:
            errmsg(err);
        pass


    def onLogcat (self,devname,isExportTxt,isNox):
        rmsgbox("不支持logcat")
        pass

    def onTerminateLogcat(self):
        rmsgbox("不支持logcat")
        pass
