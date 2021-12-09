import re
import threading
import inspect
import ctypes
import math
import time

from PyQt5.QtWidgets import (QApplication, QDialog, QPushButton, QTextBrowser, QComboBox, QStyle, QLineEdit,
                            QTableWidget, QHeaderView, QAbstractItemView, QTableWidgetItem)
from PyQt5.QtGui import QCursor, QFont, QTextCursor, QTextBlock, QTextCharFormat, QColor
from PyQt5.QtCore import QEvent, pyqtSignal, QPoint
from PyQt5.uic import loadUi
from PyQt5.Qt import Qt

import jsonpickle
from cmm import *
from tools.Logger.main import Logger


'''
Icon 制作
'''
class DebugLogger (QDialog):

    MaxRowCount = 2000;  #切换日志，初始展示最大日志数量
    m_signal = pyqtSignal([list,list]);  #信号槽
    m_signal_logger = pyqtSignal([bool]);  #信号槽
    m_signal_change = pyqtSignal([list]);   #切换IP端口

    def __init__(self, mainobj, luaglobals):
        try:
            super(DebugLogger, self).__init__()
            loadUi(os.path.join("ui", 'logger.ui'), self)
            self.setMinimumWidth(465)

            self.mainobj = mainobj;

            desktop = QApplication.desktop()
            titleBarHeight = self.style().pixelMetric(QStyle.PixelMetric.PM_TitleBarHeight);  #获取标题栏高度
            bottomMargin = self.style().pixelMetric(QStyle.PixelMetric.PM_LayoutBottomMargin);  #获取底部边距
            self.rightMargin = self.style().pixelMetric(QStyle.PixelMetric.PM_LayoutRightMargin);  # 获取右边距
            self.realsize = desktop.screenGeometry()
            self.realsize.setHeight(self.realsize.height() - titleBarHeight - bottomMargin)  # 实际大小
            self.winsize = desktop.screenGeometry();
            self.winsize.setHeight(desktop.availableGeometry().height() - titleBarHeight - bottomMargin)  #实际大小
            self.initsize = self.size()  #初始大小

            self.m_signal.connect(self.signalCallback);
            self.m_signal_logger.connect(self.signalLoggerCallback);
            self.m_signal_change.connect(self.signalChangeAddress);

            '''Widget'''
            self.textBrowser = self.findChild(QTextBrowser, "textBrowser_log");
            self.edit_filter = self.findChild(QLineEdit, "edit_filter");
            self.btn_start = self.findChild(QPushButton, "btn_start");
            self.btn_clear = self.findChild(QPushButton, "btn_clear");
            self.btn_ontop = self.findChild(QPushButton, "btn_ontop");
            self.btn_proxy = self.findChild(QPushButton, "btn_proxy");
            self.btn_subdir = self.findChild(QPushButton, "btn_subdir");
            self.cbo_address = self.findChild(QComboBox, "comboBox_address")
            self.cbo_grade = self.findChild(QComboBox, "comboBox_grade")
            self.cbo_game = self.findChild(QComboBox, "comboBox_game")
            self.cbo_type = self.findChild(QComboBox, "comboBox_search_type")
            self.btn_restart = self.findChild(QPushButton,"btn_restart")
            self.btn_meminfo = self.findChild(QPushButton,"btn_meminfo");

            '''Bind event'''
            self.edit_filter.textChanged.connect(self.onTextChanged)
            self.edit_filter.returnPressed.connect(self.onInputEnter)
            self.btn_start.clicked.connect(self.onStartLogger);
            self.btn_clear.clicked.connect(self.onClearLogs);
            self.btn_subdir.clicked.connect(self.onShowSubDirDialog);
            self.btn_ontop.clicked.connect(self.onSetTop);
            self.btn_proxy.clicked.connect(self.onChangeMode);
            self.cbo_address.currentIndexChanged.connect(self.onAddressChanged);
            self.cbo_grade.currentIndexChanged.connect(self.onGradeChanged);
            self.cbo_game.currentIndexChanged.connect(self.onGameChanged);
            self.cbo_type.currentIndexChanged.connect(self.onTypeChanged);
            self.btn_restart.clicked.connect (self.onRestartGame)
            self.btn_meminfo.clicked.connect (self.onMeminfo);

            self.initUI();

            self.m_thread = None;
            self.m_thread_change = None;
            self.m_state = False;
            self.m_address_changed = False;
            self.m_retry = 0;
            self.m_logs = {};  # 日志数据
            self.m_config = {};
            self.m_logpos = {};

            platconfig = self.mainobj.getPlatSettings();
            self.logger = Logger(self.m_signal, platconfig);

        except Exception as err:
            errmsg(err);

    def closeEvent(self, e):
        try:
            self.onStopLogger();
            self.mainobj.show();

        except Exception as err:
            errmsg(err);

    '''UI初始化'''
    def initUI(self):
        parent = self.textBrowser.parent()
        self.textBrowser.setVisible(False)

        # 主TextBrowser
        browser = TextBrowser(parent)
        browser.setGeometry(0, 86, 1041, 561)
        browser.setFont(QFont("微软雅黑", 9))
        browser.setVisible(True)
        self.textBrowser = browser
        self.textBrowser.rowCount_ = 0

        # 副TextBrowser
        browser = TextBrowser(parent)
        browser.setGeometry(0, 86, 1041, 561)
        browser.setFont(QFont("微软雅黑", 9))
        browser.setVisible(False)
        self.viceBrowser = browser
        self.viceBrowser.rowCount_ = 0

        # 其他
        # browser = TextBrowser(parent)
        # browser.setGeometry(0, 86, 1041, 561)
        # browser.setFont(QFont("微软雅黑", 9))
        # browser.setVisible(False)
        # self.elseBrowser = browser
        # self.elseBrowser.rowCount_ = 0


    '''读取配置表'''
    def readConfig(self):
        curgame = self.cbo_game.currentText();
        filename = os.path.join(os.getcwd(), 'tools', 'Logger', 'config', curgame + 'Config.json')
        configPath = os.path.join(os.getcwd(), 'tools', 'Logger', 'config.json')

        if os.path.exists(filename):
            with open(filename, 'r') as file:
                jsonstr = file.read();
                self.m_config = jsonpickle.loads(jsonstr);
        elif os.path.exists(configPath):
            with open(configPath, 'r') as file:
                jsonstr = file.read();
                self.m_config = jsonpickle.loads(jsonstr);

                platconfig = self.mainobj.getPlatSettings();
                base_dir = 'base_dir' in self.m_config and self.m_config['base_dir'] or ""
                self.m_config['base_dir'] = os.path.join(platconfig.project_dir, curgame, 'client') + "/"
                if not os.path.exists(base_dir):
                    self.saveConfig()
        return self.m_config

    '''保存配置表'''
    def saveConfig(self, *args, **kwargs):
        sub_dirs = [];
        if hasattr(self, 'subdir_dialog'):
            tableView = self.subdir_dialog.findChild(QTableWidget, "tableView")
            rowCount = tableView.rowCount()
            for row in range(rowCount):
                item = tableView.item(row, 0)
                if item and item.text() != "":
                    sub_dirs.append(item.text())

        if len(sub_dirs) > 0:
            self.m_config['sub_dirs'] = sub_dirs;
        if 'side_width' not in self.m_config:
            self.m_config['side_width'] = 670;

        curgame = self.cbo_game.currentText();
        filename = os.path.join(os.getcwd(), 'tools', 'Logger', 'config', curgame + 'Config.json')
        with open(filename, 'w') as file:
            file.write(jsonpickle.encode(self.m_config))

        if 'initConfig' in kwargs:
            self.logger.initConfig()


    '''设置已有玩法'''
    def setExistedGames(self, gamelist=[], default=None):
        self.gamelist = gamelist;
        self.cbo_game.addItems(self.gamelist)
        if default:
            self.cbo_game.setCurrentText(default)


    '''日志刷新信号'''
    def signalCallback(self, info=[], log=[]):
        try:
            cfg = ["0", "", ""]
            if len(log) > 1:
                cfg = log.pop()[:-1].split('|')
                if len(cfg) <= 1:
                    cfg.append("Verbose")

            if cfg[1] != "" and isMacOS():
                cfg[1] += "-lua"

            if cfg[1] != "" and cfg[1] != self.cbo_game.currentText():
                return;

            info = [str(v) for v in info]
            list = [str(v) for v in log]

            # IP端口，将设备端口改成UID
            address = ":".join(info)
            if cfg[0] != "0":
                info[1] = cfg[0];
                address = ":".join(info)
                self.addAddressPort(address)

            input = self.edit_filter.text()
            logstr = "  ".join(list)
            if cfg [0] == "0" or address == self.cbo_address.currentText():
                curGrade = self.cbo_grade.currentText()
                if curGrade != "Verbose" and curGrade == cfg[2]:
                    if self.viceBrowser.isVisible():
                        if input == "":
                            self.viceBrowser.append(logstr)
                            self.viceBrowser.rowCount_ = self.viceBrowser.rowCount_ + 1;
                        elif re.search(input, logstr):
                            self.viceBrowser.append(logstr)
                            self.viceBrowser.rowCount_ = self.viceBrowser.rowCount_ + 1;
                self.textBrowser.append(logstr)
                self.textBrowser.rowCount_ = self.textBrowser.rowCount_ + 1;

            # 保存日志
            logobj = LogObject(cfg[1], cfg[2], logstr)
            if cfg[0] != "0":
                self.m_logs[address].append(logobj)
        except Exception as err:
            print(err)


    '''启动停止信号'''
    def signalLoggerCallback(self, isStop):
        i = 0;
        while (i < 3):
            i = i + 1;
            if isStop:
                self.btn_start.setText("停止"+ str (i))
            else:
                self.btn_start.setText("启动"+ str (i))
            QApplication.processEvents()
            time.sleep(0.01);
        pass

    '''地址切换信号'''
    def signalChangeAddress(self, loglist=[]):
        self.onClearLogs(True);     # 只清除界面，不清除日志数据
        self.textBrowser.rowCount_ = 0;
        self.m_address_changed = True;  # 切换IP端口，正在填充日志

        curGrade = self.cbo_grade.currentText();
        for logobj in loglist:
            if curGrade == "Verbose" or curGrade == logobj.type:
                self.textBrowser.append(logobj.text());
                self.textBrowser.rowCount_ = self.textBrowser.rowCount_ + 1;
        self.m_address_changed = False;  # 切换IP端口，日志填充完成


    '''添加IP端口'''
    def addAddressPort(self, address):
        self.m_signal_change.disconnect(self.signalChangeAddress);

        if address == "":
            self.m_signal_change.connect(self.signalChangeAddress);
            return;
        index = self.cbo_address.findText(address)
        if index < 0:
            self.cbo_address.addItem(address)
        # 新IP端口
        if address not in self.m_logs:
            self.m_logs[address] = []

        self.m_signal_change.connect(self.signalChangeAddress);


    '''
    restart Game 
    '''
    def onRestartGame(self):
        self.onGameCommand ("restart");
        pass

    def onMeminfo(self):
        self.onGameCommand ("meminfo");
        pass

    def onGameCommand(self,cmd,**params):
        self.logger.onGameCommand (cmd,**params);
        pass

    '''切换游戏版本'''
    def onGameChanged(self):
        curgame = self.cbo_game.currentText()
        self.readConfig();
        self.logger.setgame(curgame)
        self.restartLogger();

    '''切换搜索类型'''
    def onTypeChanged(self):
        self.m_type_idx = self.cbo_type.currentIndex();
        self.onTextChanged();

    def getTypeIndex(self):
        if hasattr(self, 'm_type_idx'):
            return self.m_type_idx
        return 0;

    # 是否展示副TextBrowser
    def isVice(self):
        index = self.getTypeIndex();
        input = self.edit_filter.text();
        grade = self.cbo_grade.currentText();

        if grade == "Verbose":
            if index == 0 or input == "":
                return False;
        return True;


    '''切换IP端口'''
    def onAddressChanged(self):
        address = self.cbo_address.currentText();
        if address not in self.m_logs:
            return;

        self.onClearLogs(True);  # 只清除界面，不清除日志数据
        self.textBrowser.rowCount_ = 0;
        self.viceBrowser.rowCount_ = 0;

        logs    = self.m_logs[address]
        off     = len(logs) - self.MaxRowCount
        loglist = (off < 0) and logs or logs[off:]
        self.m_logs[address] = loglist;     # 保留剩余最多MaxRowCount条日志

        curGrade = self.cbo_grade.currentText()
        visible = self.viceBrowser.isVisible()

        for logobj in loglist:
            self.textBrowser.append(logobj.text());
            self.textBrowser.rowCount_ = self.textBrowser.rowCount_ + 1;

            if visible and curGrade == logobj.type:
                self.viceBrowser.append(logobj.text());
                self.viceBrowser.rowCount_ = self.viceBrowser.rowCount_ + 1;

            count = visible and self.viceBrowser.rowCount_ or self.textBrowser.rowCount_
            if count > self.MaxRowCount:
                break;

        input = self.edit_filter.text()
        if self.isVice():
            self.onTextChanged();
            self.viceBrowser.setVisible(True);
        elif input != "":
            self.onTextChanged();

    '''切换日志级别'''
    def onGradeChanged(self):
        curGrade = self.cbo_grade.currentText()
        if not self.isVice():
            self.viceBrowser.setVisible(False)
            self.viceBrowser.rowCount_ = 0;
            self.viceBrowser.clear()

            input = self.edit_filter.text()
            if input != "":
                self.onTextChanged();
            return;
        else:
            self.viceBrowser.clear();
            self.viceBrowser.setVisible(True);

        loglist = []
        address = self.cbo_address.currentText()
        if address in self.m_logs:
            loglist = self.m_logs[address]

        for logobj in loglist:
            if curGrade == logobj.type:
                self.viceBrowser.append(logobj.text())
                self.viceBrowser.rowCount_ = self.viceBrowser.rowCount_ + 1;

        if self.isVice():
            self.onTextChanged();
            self.viceBrowser.setVisible(True);


    '''清空日志'''
    def onClearLogs(self, UnclearData=False):
        self.textBrowser.clear();
        self.viceBrowser.clear();
        if not UnclearData:
            self.cbo_address.clear()
            for key in  self.m_logs.keys():
                self.m_logs[key] = []

        i = 0;
        while (i < 3):
            i = i + 1;
            self.textBrowser.setText("");
            self.viceBrowser.setText("");
            QApplication.processEvents()
            time.sleep(0.01);


    '''置顶设置'''
    def onSetTop(self):
        text = self.btn_ontop.text()
        try:
            if text == "置顶":
                self.setWindowFlags(Qt.WindowMinimizeButtonHint | Qt.WindowCloseButtonHint | Qt.WindowStaysOnTopHint)
                self.btn_ontop.setText("正常")
                self.show()
            else:
                self.setWindowFlags(Qt.WindowMinimizeButtonHint | Qt.WindowCloseButtonHint)
                self.btn_ontop.setText("置顶")
                self.show()
        except Exception as err:
            print(err);

    '''模式切换'''
    def onChangeMode(self):
        text = self.btn_proxy.text()
        try:
            if re.search("代理", text):
                self.btn_proxy.setText("本地模式")
            else:
                self.btn_proxy.setText("代理模式")
            self.restartLogger();
        except Exception as err:
            print(err);


    '''筛选输入框回调'''
    def onTextChanged(self, *args, **kwargs):
        grade = self.cbo_grade.currentText()
        browser = self.isVice() and self.viceBrowser or self.textBrowser
        if browser == self.textBrowser:
            self.viceBrowser.setVisible(False);

        text = self.edit_filter.text()
        if text == "":
            browser.selectAll()
            cursor = browser.textCursor();
            cursor.movePosition(QTextCursor.End)
            browser.setTextCursor(cursor);
            browser.setVisible(True);
            return;

        # 设置可见
        browser.setVisible(True);

        # 过滤模式
        index = self.getTypeIndex();
        if index == 1:
            browser.clear();
            rowCount = self.textBrowser.rowCount_;
            address = self.cbo_address.currentText();
            if address not in self.m_logs:
                return;

            loglist = self.m_logs[address]
            for logobj in loglist:
                if (grade == 'Verbose' or grade == logobj.type) and re.search(text, logobj.text()):
                    browser.append(logobj.text())
                    browser.rowCount_ = 0;
            return;


        # 搜索模式
        if 'isEnter' not in kwargs:
            browser.serachCount_ = 1;
        #    self.edit_filter.setFocus()

        content = browser.toPlainText()
        matchCount = content.count(text)
        if matchCount > 0:
            if browser.serachCount_ == 1:
                st = content.index(text)
                self.jumpTo(st, len(text))
            elif browser.serachCount_ <= matchCount:
                st = content.find(text, browser.textCursor().position())
                if st != -1:
                    self.jumpTo(st, len(text))
            else:
                self.onTextChanged();
        else:
            browser.selectAll()
            cursor = browser.textCursor();
            cursor.movePosition(QTextCursor.End)
            browser.setTextCursor(cursor);


    '''输入框回车'''
    def onInputEnter(self):
        grade = self.cbo_grade.currentText()
        browser = (grade == 'Verbose') and self.textBrowser or self.viceBrowser
        if not hasattr(browser, 'serachCount_'):
            browser.serachCount_ = 0;
        browser.setFocus()
        browser.serachCount_ = browser.serachCount_ + 1
        self.onTextChanged(isEnter=True);



    '''跳转至第X行'''
    def jumpTo(self, st, len):
        '''选中文字,高亮显示'''
        def select(browser, start, length):
            cur = QTextCursor(browser.textCursor())
            cur.setPosition(start)
            cur.setPosition(start + length, QTextCursor.KeepAnchor)
        #    cur.select(QTextCursor.LineUnderCursor)
            browser.setTextCursor(cur)

    #    position = self.textBrowser.document().findBlockByNumber(line-1).position();
        grade = self.cbo_grade.currentText()
        browser = self.isVice() and self.viceBrowser or self.textBrowser
        select(browser, st, len);


    '''设置文字样式'''
    def setTextCharFormat(self, isMark=False):
        tcf = self.textBrowser.currentCharFormat()
        font = tcf.fontFamily()
        if isMark:
            if font != "黑体":
                tcf = QTextCharFormat()
                tcf.setFontFamily("Microsoft YaHei")  # 设置字体
                tcf.setFontPointSize(12)  # 设置字体大小
                tcf.setUnderlineColor(QColor("Red"))  # 设置下划线颜色
                tcf.setUnderlineStyle(QTextCharFormat.WaveUnderline)
                self.textBrowser.setCurrentCharFormat(tcf)
        else:
            if font != "微软雅黑":
                tcf = QTextCharFormat()
                tcf.setFontFamily("微软雅黑")  # 设置字体
                tcf.setFontPointSize(9)  # 设置字体大小
                tcf.setUnderlineColor(QColor("Black"))  # 设置下划线颜色
                tcf.setUnderlineStyle(QTextCharFormat.NoUnderline)
                self.textBrowser.setCurrentCharFormat(tcf)


    '''显示子目录窗口'''
    def onShowSubDirDialog(self):

        if not hasattr(self, 'subdir_dialog'):
            self.subdir_dialog = SubDirDialog(self)
            self.subdir_dialog.resize(300, 500)
            self.subdir_dialog.setWindowTitle("子目录")

            tableview = QTableWidget(self.subdir_dialog)
            tableview.resize(300, 500)
            tableview.setRowCount(16);
            tableview.setColumnCount(1);
            tableview.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch);  # 所有列自动拉伸，充满界面
            tableview.setSelectionMode(QAbstractItemView.SingleSelection);  # 设置只能选中一行
            tableview.setSelectionBehavior(QAbstractItemView.SelectRows);  # 设置只有行选中
            tableview.setShowGrid(True);
            tableview.setFont(QFont("Microsoft YaHei"))
            tableview.setObjectName("tableView")

            tableview.verticalHeader().setVisible(False)    # 隐藏垂直表头
            tableview.horizontalHeader().setVisible(False)  # 隐藏水平表头
            tableview.itemChanged.connect(self.onConfigChanged);

        config = self.m_config;
        dialog = self.subdir_dialog;
        dialog.show();

        sub_dirs = 'sub_dirs' in config and config['sub_dirs'] or []
        tableView = self.subdir_dialog.findChild(QTableWidget, "tableView")
        tableView.clear()
        for row, dir in enumerate(sub_dirs):
            item = QTableWidgetItem(dir)
            item.LastText_ = dir    # 初始text
            tableView.setItem(row, 0, item)
        tableView.hasChanged_ = False;

    '''配置表修改'''
    def onConfigChanged(self, item):
        tableView = self.subdir_dialog.findChild(QTableWidget, "tableView")
        rowCount = tableView.rowCount();
        emptyCount = 0;

        lastText = hasattr(item, 'LastText_') and item.LastText_ or ""
        if lastText != item.text():
            tableView.hasChanged_ = True

        for row in range(rowCount):
            item = tableView.item(row, 0)
            if not item or item.text() == "":
                emptyCount += 1;

        # 始终保持5个可编辑空位
        count = 5 - emptyCount;
        if count > 0:
            tableView.setRowCount(rowCount + count)


    '''是否为代理模式'''
    def isProxy(self):
        text = self.btn_proxy.text()
        if re.search("代理", text):
            return True;
        return False;

    '''重启Logger'''
    def restartLogger(self):
        self.cbo_address.clear()
        self.onClearLogs()
        if self.m_state:
            self.onStartLogger()
            self.onStartLogger()

    # 启动线程Target
    def startLogger(self):
        try:

            self.m_state = True;
            self.m_signal_logger.emit(True);
            mode = self.isProxy() and 1 or None
            self.logger.start(mode);
            print ("Logger end...");

        except Exception as err:
            self.m_state = False;
            self.m_signal_logger.emit(False);
            self.m_signal.emit([], [err]);

            # self.m_retry += 1;
            # if self.m_retry <= 3:   # 重试3次
            #     startLogger();
            # else:
            #     self.m_state = False;
            #     self.m_signal_logger.emit(False);
            #     self.m_retry = 0;

    def onStopLogger(self):
        self.m_retry = 0;
        self.logger.stop();
        self.m_state = False;
        self.m_signal_logger.emit(False);

        '''不需要执行关闭线程操作，因为stop了logger，thread会自动结束自己'''
        # self.m_thread.stop();
        pass

    '''启动Logger'''
    def onStartLogger(self):

        # 已启动，关闭
        if self.m_state:
            self.onStopLogger ();
            return;

        # startLogger ();
        # 线程启动
        self.m_thread = threading.Thread(target=(lambda: self.startLogger()));
        # self.m_thread = threading.Thread(target=startLogger, args=());
        self.m_thread.start();
        self.m_state = True;

    '''键盘事件'''
    def keyPressEvent(self, event):
        eventKey = event.key();
        if eventKey == Qt.Key_Enter or eventKey == Qt.Key_Return:       # Enter / Return
            self.onInputEnter();
        elif QApplication.keyboardModifiers() == Qt.ControlModifier:    # Ctrl + F
            if eventKey == Qt.Key_F:
               self.edit_filter.setFocus();
               self.edit_filter.selectAll();


    '''事件捕获'''
    def event(self, e):

        return super(DebugLogger, self).event(e)

        eventType = e.type()
        if eventType == QEvent.NonClientAreaMouseButtonDblClick:
            pos = QCursor.pos()
            screen_cnt = math.ceil((pos.x() + 1) / self.winsize.width())
            log_height = (screen_cnt <= 1) and self.winsize.height() or self.realsize.height()
            side_width = 'side_width' in self.m_config and self.m_config['side_width'] or 670;
            if self.width() == side_width and self.height() == log_height:
                self.resize(self.initsize)
                if hasattr(self, 'DialogPos'):
                    self.move(self.DialogPos);
            else:
                self.DialogPos = self.pos()
                half_width = (screen_cnt-1)*self.winsize.width() + self.winsize.width()/2
                if pos.x() < half_width:
                    self.resize(side_width, log_height)
                    self.move((screen_cnt-1)*self.winsize.width(), 0)
                elif pos.x() > half_width:
                    self.resize(side_width, log_height)
                    self.move(screen_cnt*self.winsize.width() - side_width - 2*self.rightMargin, 0)
            self.setAutoSize();
            self.ClickedPos = None;
        elif eventType == QEvent.NonClientAreaMouseButtonPress:
            self.ClickedPos = QCursor.pos()
        elif eventType == QEvent.NonClientAreaMouseButtonRelease:
            pos = QCursor.pos()
            side_width = 'side_width' in self.m_config and self.m_config['side_width'] or 670;
            screen_cnt = math.ceil((pos.x()+1) / self.winsize.width())
            log_height = (screen_cnt <= 1) and self.winsize.height() or self.realsize.height()
            hoff_width = pos.x() % self.winsize.width()

            if hoff_width < 150:
                self.resize(side_width, log_height)
                self.move((screen_cnt-1)*self.winsize.width(), 0)

            elif hoff_width > self.winsize.width() - 150:
                self.resize(side_width, log_height)
                self.move(screen_cnt*self.winsize.width() - side_width - 2*self.rightMargin, 0)

            elif hasattr(self,"ClickedPos") and self.ClickedPos and self.ClickedPos != pos:
                if self.height() != log_height or self.pos().y() != 0:
                    self.resize(self.initsize)

            self.setAutoSize();

            # if pos.x() < 150:
            #     self.resize(side_width, self.winsize.height())
            #     self.move(0, 0)
            # elif pos.x() <= self.winsize.width() and pos.x() > self.winsize.width() - 150:
            #     self.resize(side_width, self.winsize.height())
            #     self.move(self.winsize.width() - side_width - 2 * self.rightMargin, 0)
            # elif pos.x() > self.winsize.width() and pos.x() <= self.winsize.width() + 150:
            #
            # elif pos.x() > 2*self.winsize.wi
            #
            # elif self.ClickedPos and self.ClickedPos != pos:
            #     if self.height() != self.winsize.height() or self.pos().y() != 0:
            #         self.resize(self.initsize)
            # self.setAutoSize();
        pass
        return super(DebugLogger, self).event(e)

    def resizeEvent(self, e):

        minWidth = self.minimumWidth();
        if minWidth == self.width():
            self.setAutoSize();

        size = self.size();

        # print ("width = %d , height = %d" % (size.width(),size.height()));

        self.textBrowser.resize(size.width(), size.height() - 86)

        return ;

        if size.height() == self.realsize.height():
            side_width = 'side_width' in self.m_config and self.m_config['side_width'] or 670;
            if side_width != size.width():
                self.m_config['side_width'] = size.width();
                curgame = self.cbo_game.currentText();
                filename = os.path.join(os.getcwd(), 'tools', 'Logger', 'config', curgame + 'Config.json')
                with open(filename, 'w') as file:
                    file.write(jsonpickle.encode(self.m_config))

    '''自适应窗体'''
    def setAutoSize(self):
        size = self.size();
        try:
            self.textBrowser.resize(size.width(), size.height() - 86)
            self.textBrowser.move(0, 86)
            self.viceBrowser.resize(size.width(), size.height() - 86)
            self.viceBrowser.move(0, 86)
        except Exception as err:
            print(err)


    '''终止线程'''
    def stopThread(self, tid, exctype=SystemExit):
        try:
            """raises the exception, performs cleanup if needed"""
            tid = ctypes.c_long(tid)
            if not inspect.isclass(exctype):
                exctype = type(exctype)
            res = ctypes.pythonapi.PyThreadState_SetAsyncExc(tid, ctypes.py_object(exctype))
            if res == 0:
                raise ValueError("invalid thread id")
            elif res != 1:
                # """if it returns a number greater than one, you're in trouble,
                # and you should call it again with exc=NULL to revert the effect"""
                ctypes.pythonapi.PyThreadState_SetAsyncExc(tid, None)
                raise SystemError("PyThreadState_SetAsyncExc failed")
            pass
        except Exception as err:
            pass

    def Qstring2Str(qStr):
        """转换Qstring类型为str类型"""
        return 0;#unicode(qStr.toUtf8(), 'utf-8', 'ignore')


'''自定义TextBrowser'''
class TextBrowser(QTextBrowser):
    def __init__(self, parent):
        super(TextBrowser, self).__init__(parent)
        self.m_parent = parent or None;

    def keyPressEvent(self, event):
        if not self.m_parent:
            return;

        parent = self.m_parent;
        eventKey = event.key();

        if eventKey == Qt.Key_Enter or eventKey == Qt.Key_Return:       # Enter/Return

            parent.onInputEnter();

        elif QApplication.keyboardModifiers() == Qt.ControlModifier:    # Ctrl + F
            if eventKey == Qt.Key_F:
                parent.edit_filter.setFocus();
                parent.edit_filter.selectAll();
            elif eventKey == Qt.Key_C:
                browser = parent.isVice() and parent.viceBrowser or parent.textBrowser;
                content = browser.textCursor().selection().toPlainText();
                if content != "":
                    content = content.replace("\x00", "")
                    clipboard = QApplication.clipboard()
                    clipboard.setText(content)



'''子对话框'''
class SubDirDialog(QDialog):
    def __init__(self, parent):
        super(SubDirDialog, self).__init__(parent)
        self.m_parent = parent or None;

    def closeEvent(self, e):
        if not hasattr(self, 'tableView'):
            self.tableView = self.findChild(QTableWidget, "tableView")
            if not hasattr(self.tableView, 'hasChanged_'):
                self.tableView.hasChanged_ = False

        if self.m_parent and self.tableView:
            if not self.tableView.hasChanged_:  # 未改动
                return;
            self.tableView.hasChanged_ = False  # 重置
            self.m_parent.saveConfig(initConfig=True);
            self.m_parent.restartLogger();

class LogObject():
    def __init__(self, game, type, str, **kwargs):
        self.game = game;
        self.type = type;
        self.str = str;

        if 'section' in kwargs:
            self.section = kwargs['section'];

    def game(self):
        return self.game;

    def text(self):
        return self.str;

    '''对应TexasBrowser的滚动条区间范围值'''
    def section(self):
        return self.section;

    def type(self):
        return self.type;