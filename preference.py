import random

from PyQt5.QtWidgets import QWidget, QDialog, QPushButton, QLineEdit, QFileDialog
from PyQt5.uic import loadUi

from cmm import *
from profile import gPMConfig


class PreferDialogBase(QDialog):
    def __init__(self, parent=None):
        super(PreferDialogBase, self).__init__(parent)
        loadUi(os.path.join("ui",'preference.ui'), self)
        self.loadSettings ();

        self.btn_engine_dir = self.findChild(QPushButton,"btn_engine_dir");
        self.btn_aapt_dir   = self.findChild(QPushButton,"btn_aapt_dir");
        self.btn_project_dir = self.findChild(QPushButton,"btn_project_dir");
        self.btn_ndk_dir    = self.findChild(QPushButton,"btn_ndk_dir");
        self.btn_exe_dir    = self.findChild(QPushButton,"btn_exe_dir");

        self.btn_sdk_dir = self.findChild(QPushButton,"btn_sdk_dir");

        self.lineEdit_engine_dir = self.findChild(QLineEdit,"lineEdit_engine_dir");
        self.lineEdit_imei = self.findChild(QLineEdit,"lineEdit_imei");
        self.lineEdit_macid = self.findChild(QLineEdit,"lineEdit_macid");
        self.lineEdit_aapt_dir = self.findChild(QLineEdit,"lineEdit_aapt_dir");
        self.lineEdit_project_dir = self.findChild(QLineEdit,"lineEdit_project_dir");
        self.lineEdit_local_server_ip = self.findChild(QLineEdit,"lineEdit_local_server_ip");
        self.lineEdit_ndk_dir = self.findChild(QLineEdit,"lineEdit_ndk_dir");
        self.lineEdit_exe_dir = self.findChild(QLineEdit,"lineEdit_exe_dir");
        self.lineEdit_sdk_dir   = self.findChild(QLineEdit,"lineEdit_sdk_dir");
        self.lineEdit_proxy_str = self.findChild(QLineEdit,"lineEdit_proxy_str");
        self.lineEdit_svn_str = self.findChild(QLineEdit,"lineEdit_svn_str");
        self.lineEdit_beefont_str = self.findChild(QLineEdit,"lineEdit_beefont_str");

        self.btn_gen_imei = self.findChild(QPushButton,"btn_gen_imei");
        self.btn_gen_macid = self.findChild(QPushButton,"btn_gen_macid");

        self.btn_ok         = self.findChild(QPushButton,"btn_ok");

        self.btn_sdk_dir.clicked.connect (self.onSDKDir);

        self.btn_engine_dir.clicked.connect (self.onChooseEngineDir);
        self.btn_aapt_dir.clicked.connect (self.onChooseAAPTDir);
        self.btn_project_dir.clicked.connect (self.onChooseProjectDir);
        self.btn_ndk_dir.clicked.connect (self.onChooseNDKDir);
        self.btn_exe_dir.clicked.connect (self.onChooseExeDir);
        self.btn_ok.clicked.connect (self.onExitDialog);

        self.btn_gen_imei.clicked.connect (self.onGenIMEIClicked);
        self.btn_gen_macid.clicked.connect (self.onGenMacIdClicked);



        self.restoreSettings();

    def onSDKDir(self):
        try:
            dirname = QFileDialog.getExistingDirectory(self,"选择Android SDK目录");
            self.lineEdit_sdk_dir.setText (dirname);

        except Exception as err:
            errmsg (err);
        pass

    def onGenIMEIClicked(self):
        rand1 = random.randrange (1111111111,9999999999);
        rand2 = random.randrange (1111111,9999999);
        now_rand = str (rand1) + str (rand2);
        self.lineEdit_imei.setText (now_rand);
        pass

    def onGenMacIdClicked(self):
        macid = "";
        for i in range (6):
            rand = random.randrange (11,99);
            macid += str(rand) + (":" if (i != 5) else "");
        self.lineEdit_macid.setText (macid);

    def onChooseEngineDir(self):
        try:
            dirname = QFileDialog.getExistingDirectory(self,"选择引擎目录");
            self.lineEdit_engine_dir.setText (dirname);

        except Exception as err:
            errmsg (err);
        pass

    def onChooseAAPTDir(self):
        try:
            dirname = QFileDialog.getExistingDirectory(self,"选择aapt.exe目录");
            self.lineEdit_aapt_dir.setText(dirname);
        except Exception as err:
            errmsg(err);
        pass

    def onChooseProjectDir(self):
        try:
            dirname = QFileDialog.getExistingDirectory(self,"选择项目根目录");
            self.lineEdit_project_dir.setText (dirname);
        except Exception as err:
            errmsg(err)
        pass

    def onChooseNDKDir(self):
        try:
            dirname = QFileDialog.getExistingDirectory(self,"选择NDK目录");
            self.lineEdit_ndk_dir.setText (dirname);
        except Exception as err:
            errmsg (err);
        pass

    def onChooseExeDir(self):
        try:
            dirname = QFileDialog.getExistingDirectory(self,"选择目标程序Exe目录");
            self.lineEdit_exe_dir.setText (dirname);
        except Exception as err:
            errmsg (err);
        pass

    def closeEvent(self, e):

        if isWin():
            pass
        else:
            if self.platconfig.engine_dir == "":
                MsgBox().msg ("引擎目录为空!");
                e.ignore ();
                return ;

            pass

        if self.platconfig.project_dir == "":
            MsgBox().msg ("项目目录为空!");
            e.ignore ();
            return ;

        # if self.platconfig.aapt_dir == "":
        #     MsgBox().msg ("AAPT目录为空!");
        #     e.ignore ();
        #     return ;

        if self.platconfig.macid == "":
            MsgBox().msg ("MACID为空!");
            e.ignore ();
            return ;

        if self.platconfig.imei == "":
            MsgBox().msg ("IMEI为空!");
            e.ignore ();
            return ;

        if self.platconfig.macid == "":
            MsgBox().msg ("MACID为空!");
            e.ignore ();
            return ;

        if self.platconfig.ndk_dir == "":
            if isWin():
                MsgBox().msg ("NDK 目录为空!");
                e.ignore ();
                return ;

        # if self.platconfig.exe_dir == "":
        #     MsgBox().msg ("模拟器EXE路径为空!");
        #     e.ignore ();
        #     return ;

        if self.platconfig.srv_ip == "":
            MsgBox().msg ("Server IP为空!");
            e.ignore ();
            return ;

        if isWin() and self.platconfig.sdk_dir == "":
            MsgBox().msg ("SDK目录为空!");
            e.ignore ();
            return ;

        pass

    def onExitDialog(self):

        self.saveSettings ();
        # self.accept();
        self.close();
        pass

    def restoreSettings(self):
        pass

    def loadSettings(self):
        pass

    def safeSetKey(self,config,name):
        if not hasattr(config, name):
            setattr(config, name, "");
        pass

    def getSettings (self):
        self.platconfig.engine_dir = self.lineEdit_engine_dir.displayText ().strip ();
        self.platconfig.project_dir = self.lineEdit_project_dir.displayText ().strip ();
        self.platconfig.aapt_dir = self.lineEdit_aapt_dir.displayText ().strip ();
        self.platconfig.macid = self.lineEdit_macid.displayText ().strip ();
        self.platconfig.imei = self.lineEdit_imei.displayText ().strip ();
        self.platconfig.ndk_dir = self.lineEdit_ndk_dir.displayText ().strip ();
        self.platconfig.exe_dir = self.lineEdit_exe_dir.displayText ().strip ();
        self.platconfig.srv_ip = self.lineEdit_local_server_ip.displayText ().strip ();

        self.platconfig.sdk_dir = self.lineEdit_sdk_dir.displayText ().strip ();

        self.platconfig.proxy_str = self.lineEdit_proxy_str.displayText ().strip ();
        self.platconfig.svn_str = self.lineEdit_svn_str.displayText().strip();
        self.platconfig.beefont_str = self.lineEdit_beefont_str.displayText().strip();

        pass


"""
PreferDialogAndroid for android 
"""

class PreferDialogAndroid(PreferDialogBase):
    def __init__(self, parent=None):
        super(PreferDialogAndroid, self).__init__(parent)

        self.btn_engine_dir.setEnabled (False);
        self.lineEdit_engine_dir.setEnabled (False);




    def restoreSettings(self):
        config = self.platconfig;

        config.quick_dir = os.path.join(os.getcwd(),"quick-3.5");

        self.lineEdit_engine_dir.setText (config.engine_dir.strip ());
        self.lineEdit_imei.setText (config.imei.strip ());
        self.lineEdit_macid.setText (config.macid.strip ());
        self.lineEdit_aapt_dir.setText(config.aapt_dir.strip ());
        self.lineEdit_ndk_dir.setText (config.ndk_dir.strip ());
        self.lineEdit_local_server_ip.setText (config.srv_ip.strip ());
        self.lineEdit_project_dir.setText (config.project_dir.strip ());

        self.safeSetKey (config,"sdk_dir");
        self.safeSetKey (config,"exe_dir");
        self.safeSetKey (config,"proxy_str");
        self.safeSetKey (config, "svn_str");
        self.safeSetKey (config, "beefont_str");

        self.lineEdit_exe_dir.setText(config.exe_dir.strip());
        self.lineEdit_sdk_dir.setText (config.sdk_dir.strip ());
        self.lineEdit_proxy_str.setText (config.proxy_str.strip ());
        self.lineEdit_svn_str.setText(config.svn_str.strip());
        self.lineEdit_beefont_str.setText(config.beefont_str.strip());

    def loadSettings(self):
        self.platconfig = gPMConfig.getPlatSettings("android");
        pass

    def saveSettings(self):
        self.getSettings ();
        gPMConfig.setPlatSettings("android",self.platconfig)
        pass

"""
PreferDialogIOS for IOS 
"""

class PreferDialogIOS(PreferDialogBase):
    def __init__(self, parent=None):
        super(PreferDialogIOS, self).__init__(parent)

        ## special for IOS
        self.btn_aapt_dir.setEnabled (False);
        self.lineEdit_aapt_dir.setEnabled (False);

        self.btn_ndk_dir.setEnabled (False);
        self.lineEdit_ndk_dir.setEnabled (False);
        self.lineEdit_exe_dir.setEnabled (False);
        self.btn_sdk_dir.setEnabled (False);

        # self.btn_project_dir.setEnabled (False);
        # self.lineEdit_project_dir.setEnabled (False);

    def restoreSettings(self):
        config = self.platconfig;

        self.lineEdit_engine_dir.setText (config.engine_dir.strip ());
        self.lineEdit_imei.setText (config.imei.strip ());
        self.lineEdit_macid.setText (config.macid.strip ());
        self.lineEdit_local_server_ip.setText (config.srv_ip.strip ());

        config.quick_dir = os.path.join(os.getcwd(),"quick-3.5");

        self.lineEdit_engine_dir.setText (config.engine_dir.strip ());
        self.lineEdit_imei.setText (config.imei.strip ());
        self.lineEdit_macid.setText (config.macid.strip ());
        self.lineEdit_aapt_dir.setText(config.aapt_dir.strip ());
        self.lineEdit_ndk_dir.setText (config.ndk_dir.strip ());
        self.lineEdit_local_server_ip.setText (config.srv_ip.strip ());
        self.lineEdit_project_dir.setText (config.project_dir.strip ());

        self.safeSetKey (config,"sdk_dir");
        self.safeSetKey (config,"exe_dir");
        self.safeSetKey (config,"proxy_str");

        self.lineEdit_exe_dir.setText(config.exe_dir.strip());
        self.lineEdit_sdk_dir.setText (config.sdk_dir.strip ());
        self.lineEdit_proxy_str.setText (config.proxy_str.strip ());
        # self.lineEdit_svn_str.setText(config.svn_str.strip());
        # self.lineEdit_beefont_str.setText(config.beefont_str.strip());

        pass

    def loadSettings(self):
        self.platconfig = gPMConfig.getPlatSettings("ios");
        pass

    def saveSettings(self):
        self.getSettings ();
        gPMConfig.setPlatSettings("ios",self.platconfig)
        pass



"""
PreferDialog for base 
"""

def PreferDialog(parent):
    w = None;
    if isWin():
        w = PreferDialogAndroid(parent);
    elif isMacOS():
        w = PreferDialogIOS(parent);
    return w;