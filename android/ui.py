import os
import sys
import time
from threading import Thread

from PyQt5 import Qt
from PyQt5.QtCore import QSize
from PyQt5.QtGui import QPixmap
from PyQt5.QtWidgets import QListWidgetItem

from profile import gPMConfig, gLuaPM
from ui import MainWindow
from cmm import *

from queue import Queue, Empty


def enqueue_output(out, queue):
    for line in iter(out.readline, b''):
        queue.put(line)
    out.close()

class MainWindowAndroid (MainWindow):

    def __init__(self, parent=None):
        super(MainWindowAndroid, self).__init__(parent)
        self.btn_clean_profile.setEnabled (False);
        self.btn_clean_xcodedata.setEnabled (False);

        platconfig = self.getPlatSettings();
        if not platconfig \
                or not hasattr(platconfig,"project_dir")  \
                or platconfig.project_dir == "" \
                or not hasattr(platconfig,"sdk_dir") \
                or platconfig.sdk_dir == "" :
            self.handleMenu("AppProfile");
        else:
            if (platconfig and platconfig.ndk_dir == "" and isWin()):
                self.handleMenu("AppProfile");
                pass

    def getPlatSettings(self):
        return gPMConfig.getPlatSettings("android");

    def isHallExisted(self,hallname):
        platconfig = self.getPlatSettings();
        luadir = os.path.join(platconfig.project_dir, "client", "hall", "src", "type", hallname);
        return  os.path.exists(luadir) ;
        pass

    def onLoadIcon(self):
        try:

            hallName = self.cbox_hall.currentText();
            chanName = self.cbox_ch.currentText();

            if chanName == "" or chanName == "":
                return ;

            arr = hallName.split ("-");
            GameHallName = arr [1];
            platconfig = self.getPlatSettings();

            icon_path = os.path.join("channel_files",GameHallName,arr [0],chanName,"res","drawable-xhdpi","icon.png");
            if os.path.exists(icon_path) and self.isHallExisted (gLuaPM.hallConfig (hallName).srcname):
                self.picview_ico.setPixmap(QPixmap(icon_path));
                self.picview_ico.setScaledContents(True);

        except Exception as err:
            errmsg ("Err : %s , Use default icon " % str (err));
            self.picview_ico.setPixmap(QPixmap(os.path.join(".","ui","icon.png")));

    def loadHallList(self):
        try:
            prev_hallName = gPMConfig.getCurHallName();

            list = [];
            for gtype in gLuaPM.gameType():
                arr = gtype.split ("-");
                curgame = gLuaPM.hallConfig(gtype).srcname;

                ch_path = os.path.join("channel_files",  arr [1],"android");
                if self.isHallExisted (curgame) and os.path.exists(ch_path):
                    # print ("add Hall %s " % gtype);
                    self.cbox_hall.addItem(gtype);
                    self.gamelist.append(curgame);
                    list.append(curgame);

            ##
            self.onFetchHallList ();

            prev_hallIndex = self.cbox_hall.findText (prev_hallName);

            if prev_hallIndex < 0 or prev_hallIndex >= self.cbox_hall.count ():
                return ;

            self.cbox_hall.setCurrentIndex (prev_hallIndex);

        except Exception as err:
            errmsg(err);

    def reloadChList(self):

        list = [];
        chName = self.cbox_ch.currentText();
        hallName = self.cbox_hall.currentText();

        arr = hallName.split("-");
        self.cbox_ch.clear();

        for ch in gLuaPM.chConfigs(hallName):
            # print ("load ch %s " % ch);
            icon_path = os.path.join("channel_files",  arr[1], "android",ch);
            if os.path.exists(icon_path):
                self.cbox_ch.addItem(ch);
                list.append(ch);

        return list;

    def getLuaSrcDir(self,hallName):
        platconfig = self.getPlatSettings();
        luadir = os.path.join(platconfig.project_dir,gLuaPM.hallConfig(hallName).srcname);
        return luadir;

    def loadAppList(self):
        try:
            ## list all the apk files in current project dir
            hallName = self.cbox_hall.currentText();
            chanName = self.cbox_ch.currentText();

            if chanName == "" or chanName == "":
                return ;

            arr = hallName.split ("-");
            GameHallName = arr [1];
            platconfig = self.getPlatSettings();
            app_path = os.path.join(platconfig.project_dir,"publish","android",GameHallName);
            if self.ckbox_use_debug.checkState () == Qt.Qt.Checked:
                app_path = os.path.join(platconfig.project_dir,"runtime","android",GameHallName);

            all = os.walk(app_path);

            self.list_app.clear ();

            for path, dir, filelist in all:
                for filename in filelist:
                    if filename.endswith("apk"):
                        filepath = os.path.join(path, filename);
                        item = QListWidgetItem(filepath, self.list_app);
                        item.setSizeHint(QSize(0, 25));

            pass
        except Exception as err:
            errmsg(err);

    def getDeviceList(self, emulator=None):
        try:

            self.cbox_devlist.clear ();

            outstr = subprocess.check_output('''adb devices''',
                                             shell=True,
                                             bufsize=0,
                                             # stdout=subprocess.PIPE,
                                             # stderr=subprocess.STDOUT,
                                             # universal_newlines=True,
                                             );
            #修改部分机型无法获取到IMEI
            if hasattr(outstr, 'decode'):
                outstr = outstr.decode()

            outstr = outstr.replace('''\n\n''', '')
            deviceInfo = outstr.split('''\r\n''')

            if deviceInfo[0] == outstr:
                deviceInfo = outstr.split('\n')

            showIndex = 0;

            for i in range(len(deviceInfo)):
                if i == 0:
                    continue;

                tmp = deviceInfo [i].split ('\t');
                devname = tmp [0].strip ();

                if devname != "":
                    self.cbox_devlist.addItem(devname);
                    if devname == emulator:
                        showIndex = i - 1;

            if self.cbox_devlist.count() < showIndex + 1:
                showIndex = 0;

            self.cbox_devlist.setCurrentIndex (showIndex);

        except Exception as err:
            errmsg(err);

    def onInstallApp (self,app_path,devname):

        # print ("Install (Device %s, App : %s)" % (devname,app_path));
        # filen,fileext = os.path.splitext(app_path);
        cmd = '''adb -s %s install -r %s ''' % (devname,app_path);
        print (cmd);
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
                if output.find("error") > 0 or output.find("failed") > 0:
                    time.sleep(1)
                    process.kill();
                    print ("安装错误,请重新刷新设备列表!")
                    break;
        except Exception as err:
            errmsg(err);

    def onLogcat (self,devname,isExportTxt,isNox):

        # print ("Install (Device %s, App : %s)" % (devname,app_path));
        # filen,fileext = os.path.splitext(app_path);

        logname = devname.replace (".","_");
        logname = logname.replace (":", "_");

        adbName = "adb";
        if isNox:
            adbName = "nox_adb";

        if isExportTxt == True:
            cmd = '''%s -s %s logcat > log_%s.txt ''' % (adbName,devname, logname);
            pass
        else:
            cmd = '''%s -s %s logcat ''' % (adbName,devname);
            pass

        print (cmd);

        try:

            self.isLogcatEnd = False;
            ON_POSIX = 'posix' in sys.builtin_module_names

            p = subprocess.Popen  (cmd,
                                   shell=True,
                                   bufsize=0,
                                   # stdin=subprocess.STDOUT,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT,
                                   close_fds=ON_POSIX,
                                   encoding='utf-8',
                                   universal_newlines=True);


            self.logcat_process = p;

            # process.stdin.write("HelloWorld");
            q = Queue()
            t = Thread(target=enqueue_output, args=(p.stdout, q))
            t.daemon = True  # thread dies with the program
            t.start();

            while True:

                # output = p.stdout.readline();
                try:
                    output = q.get_nowait()  # or q.get(timeout=.1)
                except Empty:
                    if self.isLogcatEnd == True:
                        break;
                    continue;
                    # print('no output yet')
                # else:  # got line
                    # print(output);

                if output != None:
                    output = output.strip();
                    if output != "":
                        print(output);

                if output == "" and p.poll() != None:
                    break;
                if output.find("waiting for device") > 0:
                    time.sleep(1)
                    p.kill();

                    self.logcat_process = None;

                    print ("LogCat错误,请重新刷新设备列表!")
                    break;

            p.kill();

        except Exception as err:
            errmsg(err);
        finally:

            self.logcat_process = None;

    def onTerminateLogcat(self):
        try:
            self.isLogcatEnd = True;
            print("Terminate process OK");
        except TimeoutError as err:

            self.logcat_process.terminate ();

        except Exception as err:
            errmsg(err);
            pass
        pass