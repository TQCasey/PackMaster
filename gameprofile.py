import time
import re

import jsonpickle
from PyQt5.QtCore import QThread, QSize
from PyQt5.QtWidgets import QApplication, QDialog, QComboBox, QLineEdit, QCheckBox, QGroupBox, QLabel, QTextEdit, QPushButton, \
    QListWidget, QListWidgetItem
from PyQt5.QtGui import QPalette, QColor
from PyQt5.uic import loadUi
from PyQt5.Qt import Qt

from android.makehall import MakeHallChAndroid
from cmm import *
from ios.makehall import MakeHallChIOS
from profile import gPMConfig, gLuaPM


class BaseThread(QThread):

    end_trigger = pyqtSignal (int);

    def __init__(self, parent,**kwargs):
        super(BaseThread, self).__init__(parent);

    def end(self,retcode):
        self.end_trigger.emit (retcode);

class UpdateGamesThread(BaseThread):

    flush_trigger = pyqtSignal (str);

    def run(self):
        try:

            game_list_str = subprocess.check_output('''svn list %s''' % gLuaPM.config ().games_svn,
                                                     shell=True,
                                                     bufsize=0,
                                                     # stdout=subprocess.PIPE,
                                                     # stderr=subprocess.STDOUT,
                                                     # universal_newlines=True,
                                                     ).decode();

            self.flush_trigger.emit (game_list_str);
            self.end(0);

        except Exception as err:
            errmsg(err);
            self.end(-1);

class MakeNewHallChanel(BaseThread):
    def __init__(self,parent,**kwargs):
        super(MakeNewHallChanel, self).__init__(parent,**kwargs);
        self.hallName = kwargs.get ("hallName");
        self.chName = kwargs.get ("chName");

    def run(self):
        try:

            mh = None;
            if isMacOS():
                mh = MakeHallChIOS(luaglobals=None,hallName=self.hallName,chName=self.chName);
            else:
                mh = MakeHallChAndroid(luaglobals=None,hallName=self.hallName,chName=self.chName);

            if mh:
                mh.run ();

            self.end (0);
        except Exception as err:
            errmsg(err);
            self.end (-1);

class GameProfileDialogBase(QDialog):
    def __init__(self, parent,luaglobals):
        super(GameProfileDialogBase, self).__init__(parent)
        loadUi(os.path.join("ui",'gameprofile.ui'), self)

        self.prevHallName = "";
        self.prevChName = "";

        """
        common 
        """
        self.comboBox_hall = self.findChild(QComboBox,"comboBox_hall");
        self.comboBox_ch    = self.findChild(QComboBox,"comboBox_ch");
        self.lineEdit_api = self.findChild(QLineEdit,"lineEdit_api");
        self.lineEdit_package_name  = self.findChild(QLineEdit,"lineEdit_package_name");
        self.lineEdit_crypt_char = self.findChild(QLineEdit,"lineEdit_crypt_char");
        self.lineEdit_visitor_id = self.findChild(QLineEdit,"lineEdit_visitor_id");
        self.lineEdit_visitor_id = self.findChild(QLineEdit,"lineEdit_visitor_id");
        self.lineEdit_share_page = self.findChild(QLineEdit,"lineEdit_share_page");
        self.lineEdit_bugly_id = self.findChild(QLineEdit,"lineEdit_bugly_id");
        self.lineEdit_fb_app_id = self.findChild(QLineEdit,"lineEdit_fb_app_id");
        self.lineEdit_fb_ad_id = self.findChild(QLineEdit,"lineEdit_fb_ad_id");
        self.lineEdit_fb_provider_id = self.findChild(QLineEdit,"lineEdit_fb_provider_id");
        self.lineEdit_appsflyer_id = self.findChild(QLineEdit,"lineEdit_appsflyer_id");
        self.lineEdit_display_name = self.findChild(QLineEdit,"lineEdit_display_name");
        self.lineEdit_hallName = self.findChild(QLineEdit,"lineEdit_hallName");
        self.lineEdit_chName = self.findChild(QLineEdit,"lineEdit_chName");

        self.lineEdit_sender_id = self.findChild(QLineEdit,"lineEdit_sender_id");
        self.lineEdit_min_api = self.findChild(QLineEdit,"lineEdit_min_api");
        self.lineEdit_target_api = self.findChild(QLineEdit,"lineEdit_target_api");
        self.textEdit_google_key = self.findChild(QTextEdit,"textEdit_google_key");

        self.checkBox_lock_common = self.findChild(QCheckBox,"checkBox_lock_common");
        self.groupBox_base_param = self.findChild(QGroupBox,"groupBox_base_param");
        self.groupBox_android = self.findChild(QGroupBox,"groupBox_android");
        self.checkBox_lock_android = self.findChild(QCheckBox,"checkBox_lock_android");

        self.btn_refresh_games = self.findChild(QPushButton,"btn_refresh_games");
        self.list_games             = self.findChild(QListWidget,"list_games");
        self.checkBox_lock_gamelist = self.findChild(QCheckBox,"checkBox_lock_gamelist");
        self.btn_create = self.findChild(QPushButton,"btn_create");
        self.btn_save = self.findChild(QPushButton,"btn_sava");
        self.btn_refresh = self.findChild(QPushButton,"btn_refresh");

        self.picview_ico = self.findChild(QLabel,"label_pic");
        self.label_tip = self.findChild(QLabel, "label_tip");

        self.comboBox_hall.currentIndexChanged.connect(self.onHallChanged);
        self.comboBox_ch.currentIndexChanged.connect(self.onChChanged);
        self.checkBox_lock_common.clicked.connect (self.onCommonLockedClicked);
        self.checkBox_lock_android.clicked.connect (self.onAndroidLockedClicked);
        self.btn_refresh_games.clicked.connect (self.onRefreshGames);
        self.checkBox_lock_gamelist.clicked.connect (self.onLockGameList);
        self.btn_create.clicked.connect (self.onCreateChanel);
        self.btn_save.clicked.connect (self.onSaveConfig);
        self.btn_refresh.clicked.connect (self.onRefreshConfig);

        pa = QPalette();
        pa.setColor(QPalette.WindowText, QColor(60, 185, 26))
        self.label_tip.setPalette(pa);
        self.label_tip.setText("");

        self.threads    = {};
        self.inputs     = {};
        self.objects    = {};   # 每个widget对应的配置object

        self.onLoadHallList();
        self.onCommonLockedClicked ();
        self.onAndroidLockedClicked ();
        self.onLoadGameList (None);
        self.onLockGameList ();


    def trackInput(self, widget, obj=None, attr=None):
        if widget.__class__.__name__ == "QLineEdit":
            text = widget.displayText ();
        else:
            text = widget.toPlainText ();

        # 保留当前信息
        self.inputs [widget] = text;
        self.objects [widget] = None;
        if obj and attr:
            self.objects [widget] = {"obj": obj, "attr": attr};

    '''修改检测遍历'''
    def isChanged(self):
        for widget, prev_text in self.inputs.items():
            text = None;
            if widget.__class__.__name__ == "QLineEdit":
                text = widget.displayText();
            else:
                text = widget.toPlainText();

            if prev_text != text:
                return True;
        return False;

    def onCreateChanel(self):
        try:
            """
            debug 
            """
            self.lineEdit_chName.setText ("texas4");
            self.lineEdit_hallName.setText ("texas");

            hallName = self.lineEdit_hallName.displayText ().strip ();
            chName = self.lineEdit_chName.displayText ().strip ();
            if hallName == "" or chName == "":
                return ;

            if QMessageBox.Ok == MsgBox().ask("确定要创建大厅渠道么?"):

                if not self.isThreadEnd(MakeNewHallChanel):
                    return;

                thread = MakeNewHallChanel(self,luaglobals = None,hallName = hallName,chName = chName);
                self.initThread(thread);
                thread.start();

                self.trackThread(thread);

        except Exception as err:
            errmsg(err);

    '''刷新数据'''
    def onRefreshConfig(self):
        self.onUpdateInfo();
        self.label_tip.setVisible(False);
        pass

    '''保存修改'''
    def onSaveConfig(self):
        if not self.isChanged ():
            self.showMsg("EMMM，当前无修改 ..");
            return;

        if QMessageBox.Ok == MsgBox().ask("数据变更，确定保存么?"):
            self.onSaveInfo();
            pass

    '''快捷键响应事件'''
    def keyPressEvent(self, event):
        if QApplication.keyboardModifiers() == Qt.ControlModifier:
            eventKey = event.key();
            if eventKey == Qt.Key_S:  # Ctrl + S
                self.onSaveConfig();
                pass
        pass

    def closeEvent(self, QCloseEvent):
        for event in self.threads:
            if not self.threads [event].isFinished():
                MsgBox().msg("正在操作，请稍候退出")
                QCloseEvent.ignore ();
                return ;
        if self.isChanged ():
            if QMessageBox.Ok == MsgBox().ask("检测到数据修改，需要保存么?"):
                self.onSaveInfo();
                pass

    def onLockGameList(self):
        try:
            self.list_games.setEnabled (self.checkBox_lock_gamelist.checkState () != Qt.Checked);
        except Exception as err:
            errmsg(err);

    def isThreadEnd(self,ThreadClass):
        name = ThreadClass.__class__.__name__;
        if (name not in self.threads) or (self.threads [name] and self.threads [name].isFished ()):
            """
            thread is end 
            """
            return True;
        else:
            """
            thread is running ...
            """
            return False;

    def initThread(self,thread):
        self.onThredaStart ();
        thread.end_trigger.connect (self.onThreadEnd);

    def trackThread(self,ThreadClass):
        name = ThreadClass.__class__.__name__;
        self.threads [name] = ThreadClass;

    def setWidgetsEnabled(self,bv):
        self.setEnabled (bv);

    def onThredaStart(self):
        # print ("Start Thread");
        self.setWidgetsEnabled (False);
        pass

    def onThreadEnd(self,retcode):
        # print ("End Thread")
        self.setWidgetsEnabled(True);
        pass

    def onLoadGameList(self,list):
        try:
            if list:
                self.list_games.clear ();

                hallName = self.comboBox_hall.currentText();
                chName = self.comboBox_ch.currentText();

                if hallName == "" or chName == "":
                    return;

                game_list = gPMConfig.getCurGameListFromHallAndCh(hallName,chName);
                for game in list:
                    if game == "":
                        continue;
                    item = QListWidgetItem(game, self.list_games);
                    if game_list and game in game_list:
                        item.setCheckState(Qt.Checked);
                    else:
                        item.setCheckState(Qt.Unchecked);
                    item.setSizeHint(QSize(0,25))
            else:
                with open ("games.json","r") as file:
                    list = jsonpickle.decode(file.read());
                    self.onLoadGameList (list);

        except Exception as err:
            errmsg(err);

    def onUpdateGames(self,str):
        # print (str);
        try:
            list = None;
            if isMacOS():
                list = str.replace("/","").split ('''\n''');
            else:
                list = str.replace("/", "").split('''\r\n''');
            jstr = jsonpickle.encode(list,unpicklable=True);
            with open ("games.json","w") as file:
                file.write(jstr);

            self.onLoadGameList (list);

        except Exception as err:
            errmsg(err);
        pass;

    def onRefreshGames(self):
        try:

            if not self.isThreadEnd(UpdateGamesThread):
                return ;

            thread = UpdateGamesThread(self,luaglobals=None);
            self.initThread (thread);

            thread.flush_trigger.connect (self.onUpdateGames);

            thread.start ();

            self.trackThread(thread);

        except Exception as err:
            errmsg(err)
        pass

    def onAndroidLockedClicked(self):

        try:
            self.groupBox_android.setEnabled (self.checkBox_lock_android.checkState () != Qt.Checked);
        except Exception as err:
            errmsg(err);

        pass

    def onCommonLockedClicked(self):

        try:
            self.groupBox_base_param.setEnabled (self.checkBox_lock_common.checkState () != Qt.Checked);
        except Exception as err:
            errmsg(err);

        pass

    def onLoadHallList(self):
        try:
            self.comboBox_hall.clear ();
            game_type = gLuaPM.config().game_type;
            for game in game_type:
                if game != "" and self.isHallChValid (game,""):
                    self.comboBox_hall.addItem (game);

        except Exception as err:
            errmsg (err);
        pass

    def onLoadChList(self):
        try:
            pass
        except Exception as err:
            errmsg (err);

    def onHallChanged(self):
        try:
            if self.isChanged():
                if MsgBox().ask("检测到修改，是否保存?") == QMessageBox.Ok:
                    self.onSaveInfo();
                    pass;

            hallName = self.comboBox_hall.currentText ();
            hallData = gLuaPM.hallConfig (hallName);
            chConfigs = gLuaPM.chConfigs(hallName);

            self.prevHallName = hallName;

            self.comboBox_ch.clear ();
            for ch in chConfigs:
                if ch != "" and self.isHallChValid (hallName,ch):
                    self.comboBox_ch.addItem (ch);

        except Exception as err:
            errmsg (err);

    def onChChanged(self):
        try:
            chName = self.comboBox_ch.currentText();
            self.prevChName = chName;

            self.onUpdateInfo();
        except Exception as err:
            errmsg (err);

    '''正则匹配替换'''
    def updateConfigString(self, content, attr, val):
        check = re.findall(attr + r"([\t=\'\" ]*)", content);
        if len(check) == 1:
            # 其他内容
            pattern = attr + r'([\t=\'\" ]*)([^\'\"]*)(.*)\n';
            result = re.findall(pattern, content);
            if len(result) > 0:
                newstr = "";
                for i, substr in enumerate(result[0]):
                    if i == 1:
                        newstr += val;
                    else:
                        newstr += substr;
                pass
                content = re.sub(pattern, attr + newstr + "\n", content);
        elif len(check) > 1:
            # 渠道内容
            chName = self.prevChName;
            pattern = r'\"%s([^\[]*)%s([\t=\'\" ]*)([^\'\";,]*)(.*)\n' % (chName, attr);
            result = re.findall(pattern, content);
            if len(result) > 0:
                newstr = "";
                for i, substr in enumerate(result[0]):
                    if i == 2:
                        newstr += val;
                    else:
                        if i == 1:
                            newstr += attr;
                        newstr += substr;
                pass
                content = re.sub(pattern, '\"%s%s\n' % (chName, newstr), content);
        return content;

    '''新保存方式'''
    def onNewSaveInfo(self):
        hallName = self.prevHallName;
        chName = self.prevChName;

        if hallName == "" or chName == "":
            return;

        path = self.getConfigPath();
        if os.path.exists(path):
            try:
                file = open(path, encoding='utf-8');
                content = file.read();
                file.close();

                # 更新luaglobals, content
                for widget, value in self.objects.items():
                    text = None;
                    prev_text = self.inputs[widget];

                    if widget.__class__.__name__ == "QLineEdit":
                        text = widget.displayText();
                    else:
                        text = widget.toPlainText();

                    if prev_text != text:
                        if value:
                            obj, attr = value["obj"], value["attr"];
                            valtype = type(getattr(obj, attr));
                            if valtype.__name__ == "int":
                                setattr(obj, attr, int(text));
                            else:
                                setattr(obj, attr, text);
                            content = self.updateConfigString(content, attr, text);

                # 保存native文件
                self.saveNativeParam();

                # 保存config.lua
                with open(path, mode='w+', encoding='utf-8') as file:
                    file.write(content);
                    file.close();
                pass

                # 刷新数据
                self.onUpdateInfo();
                self.showMsg("保存成功，已刷新数据..");

            except Exception as err:
                print(err);


    def onSaveInfo(self, oldSaveWay=False):
        # new save way
        if not oldSaveWay:
            self.onNewSaveInfo();
            return;

        try:
            hallName = self.prevHallName;
            chName = self.prevChName;

            if hallName == "" or chName == "":
                return ;

            gdata                       = gLuaPM.hallConfig (hallName);
            if not gdata:
                return ;

            chanel                      = self.lineEdit_api.displayText ();
            cryptchar                   = self.lineEdit_crypt_char.displayText ();
            name                        = self.lineEdit_package_name.displayText ();
            visitor_sid                 = self.lineEdit_visitor_id.displayText ();

            gdata.chlconfig [chName]    = lua.table(channel=chanel,
                                                    encrypt_char=cryptchar,
                                                    name=name,
                                                    visitor_sid=visitor_sid);

            config_path                 = self.getLuaConfigPath (hallName);

            pass
        except Exception as err:
            errmsg(err);

    def onUpdateInfo(self):
        try:
            hallName = self.comboBox_hall.currentText ();
            chName = self.comboBox_ch.currentText ();

            if hallName == "" or chName == "":
                return ;

            # print ("hallName %s , chName %s" % (hallName,chName))

            hallData = gLuaPM.hallConfig (hallName);
            chData  = gLuaPM.chConifg(hallName,chName);

            self.lineEdit_api.setText (str (chData.channel));
            self.trackInput (self.lineEdit_api, chData, "channel");

            self.lineEdit_package_name.setText (chData.name);
            self.trackInput(self.lineEdit_package_name, chData, "name");

            self.lineEdit_crypt_char.setText (str (chData.encrypt_char));
            self.trackInput(self.lineEdit_crypt_char, chData, "encrypt_char");

            self.lineEdit_visitor_id.setText (str (chData.visitor_sid));
            self.trackInput(self.lineEdit_visitor_id, chData, "visitor_sid");

            if chData.share_page:
                self.lineEdit_share_page.setText (chData.share_page);
            else:
                self.lineEdit_share_page.setText("None");

            self.trackInput(self.lineEdit_share_page, chData, "share_page");

            # bugly_appid
            self.lineEdit_bugly_id.setText (hallData.bugly_appid);
            self.trackInput(self.lineEdit_bugly_id, hallData, "bugly_appid");

            self.updateNativeParam();
            self.updateIcon ();
            self.onLoadGameList(None);

        except Exception as err:
            errmsg(err);

    '''获取当前游戏名称'''
    def getHallName(self):
        curGame = None;
        hallName = self.prevHallName;
        if hallName != "":
            channelCfg = gLuaPM.hallConfig (hallName);
            curGame = channelCfg.srcname;

        if curGame == None:
            strs = hallName.split("-");
            curGame = strs[1];
        return curGame;

    '''获取config文件路径'''
    def getConfigPath(self):
        return os.path.join(os.getcwd(), "channel_files",self.getHallName(), "android", "config.lua");

    def showMsg(self, msg):
        if msg and msg != "":
            self.label_tip.setText(msg);
            self.label_tip.setVisible(True);