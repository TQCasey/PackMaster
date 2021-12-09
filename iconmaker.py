import re
import threading

from PyQt5.QtWidgets import QDialog, QFileDialog, QPushButton, QLabel, QLineEdit, QTextBrowser
from PyQt5.QtGui import QPixmap, QColor, QPalette
from PyQt5.uic import loadUi
from PyQt5.Qt import Qt
from PyQt5.QtCore import pyqtSignal

import shutil
import tempfile
import jsonpickle
from PIL import Image
from cmm import *
from profile import gLuaPM

'''
Icon 制作
'''
class IconMakerDialog (QDialog):
    m_signal = pyqtSignal([str,bool]);  #信号槽

    def __init__(self, parent, luaglobals):
        try:
            super(IconMakerDialog, self).__init__(parent)
            loadUi(os.path.join("ui", 'iconmaker.ui'), self)

            self.mainObj = parent;
            self.m_iconurl  = "";
            self.retry_times = 0;

            self.m_signal.connect(self.signalCallback);
            self.setAcceptDrops(True);

            '''Widget'''
            self.textBrowser = self.findChild(QTextBrowser, "textBrowser");
            self.imageIcon = self.findChild(QLabel, "imageIcon");
            self.image_ios = self.findChild(QLabel, "imageIcon_ios");
            self.image_android = self.findChild(QLabel, "imageIcon_android");
            self.editOutput = self.findChild(QLineEdit, "editOutput");
            self.btnChoose = self.findChild(QPushButton, "btnChoose");
            self.btnFolder = self.findChild(QPushButton, "btnFolder");
            self.btnClear = self.findChild(QPushButton, "btnClear");
            self.btnRefresh = self.findChild(QPushButton, "btnRefresh");
            self.btnOutput = self.findChild(QPushButton, "btnOutput");
            self.btn_save_ios = self.findChild(QPushButton, "btn_save_ios");
            self.btn_save_android = self.findChild(QPushButton, "btn_save_android");

            '''Bind event'''
            self.btnFolder.clicked.connect(self.onClickFolder);
            self.btnClear.clicked.connect(self.onClickClear);
            self.btnRefresh.clicked.connect(self.onClickRefresh);
            self.btnOutput.clicked.connect(self.onClickOutput);
            self.btnChoose.clicked.connect(self.onClickChoose);
            self.btn_save_ios.clicked.connect(self.onSaveToIos);
            self.btn_save_android.clicked.connect(self.onSaveToAndroid);

            '''Init widget'''
        #    palette = QPalette();
        #    palette.setColor(QPalette.WindowText, QColor(70,148,194));
        #    self.textBrowser.setPalette(palette);
            self.editOutput.setText(self.getDesktopPath());
            self.refreshIcons();

            default = self.getDefaultIcon();
            if os.path.exists(default):
                self.imageIcon.setPixmap(QPixmap(default));
                self.imageIcon.setScaledContents(True);

        except Exception as err:
            errmsg(err);

    '''刷新iOS、Android工程Icon'''
    def refreshIcons(self):
        self.showMsg("刷新iOS、Android图标...");

        default = self.getDefaultIcon();
        imgsrc = os.path.join(os.getcwd(),  "channel_files", self.getHallName(),"ios",
                                           self.getChannelName());
        imgsrc = self.getDirectoryByName(imgsrc, "AppIcon.appiconset");
        filename = os.path.join(imgsrc or "", "icon-1024.png");
        filebackup = os.path.join(imgsrc or "", "ItunesArtwork@2x.png");

        if os.path.exists(filename):
            self.image_ios.setPixmap(QPixmap(filename));
            self.image_ios.setScaledContents(True);
        elif os.path.exists(filebackup):
            self.image_ios.setPixmap(QPixmap(filebackup));
            self.image_ios.setScaledContents(True);
        else:
            if os.path.exists(default):
                self.image_ios.setPixmap(QPixmap(default));
                self.image_ios.setScaledContents(True);

        filename = os.path.join(os.getcwd(), "channel_files", self.getHallName(),"android",
                              self.getChannelName(), "res", "drawable-xxhdpi", "icon.png");
        if os.path.exists(filename):
            self.image_android.setPixmap(QPixmap(filename));
            self.image_android.setScaledContents(True);
        else:
            if os.path.exists(default):
                self.image_android.setPixmap(QPixmap(default));
                self.image_android.setScaledContents(True);


    '''初始化json配置'''
    def getIconConfig(self, platform=None):
        configFile = os.path.join(os.getcwd(), "iconConfig.json");

        '''读数据'''
        file = open(configFile, 'r');
        if file:
            configObject = jsonpickle.decode(file.read());
            file.close();

            if configObject:
                if platform == "android":
                    return configObject['Android'];
                elif platform == "ios":
                    return configObject['iOS'];

            return configObject;
        pass

    def onClickRefresh(self):
        self.refreshIcons();

    def onClickChoose(self):
        try:
            dirname = QFileDialog.getExistingDirectory(self,"选择输出目录 ==>>");
            if dirname != "":
                self.editOutput.setText(dirname);
                self.showMsg("输出目录：" + dirname);

        except Exception as err:
            self.showMsg(err, True);
        pass

    def onSaveToIos(self):
        if not os.path.exists(self.m_iconurl):
            self.showMsg("请选择或拖拽一张图片 ==>>");
            return;

        isOk = MsgBox().ask("是否确定保存到iOS工程？？？\n\n这将会覆盖原来的资源，请慎重！\n");
        if isOk == 1024:
            thread = threading.Thread(target=self.save, args=("ios",));
            thread.start();
        pass

    def onSaveToAndroid(self):
        if not os.path.exists(self.m_iconurl):
            self.showMsg("请选择或拖拽一张图片 ==>>");
            return;

        isOk = MsgBox().ask("是否确定保存到Android工程？？？\n\n这将会覆盖原来的资源，请慎重！\n");
        if isOk == 1024:
            thread = threading.Thread(target=self.save, args=("android",));
            thread.start();
        pass

    def onClickFolder(self):
        try:
            imgName, imgType = QFileDialog.getOpenFileName(self, "请选择一张大图，最好是高清图像 ==>>", "", "*.jpg;*.png;*.ico;*.bmp");
            if imgName != "":
                self.imageIcon.setPixmap(QPixmap(imgName));
                self.imageIcon.setScaledContents(True);
                self.showMsg("选择图像：" + imgName);

                # 保存图片路径
                self.m_iconurl = imgName;

        except Exception as err:
            self.showMsg(err, True);
        pass

    '''输出icons'''
    def onClickOutput(self):
        if not os.path.exists(self.m_iconurl):
            self.showMsg("请选择或拖拽一张图片 ==>>");
            return;

        thread = threading.Thread(target=self.save, args=());
        thread.start();

    def save(self, platform=None):
        try:
            if isWin():
                outPath = os.path.join(self.editOutput.text(), "GameIcons");
                if platform != None:
                    outPath = os.path.join(tempfile.gettempdir(), "GameIcons");

                # 不存在即创建
                if not os.path.exists(outPath):
                    os.mkdir(outPath);

                # 删除旧的Iocns
                self.removeDirectory(outPath);

                # 获取指定平台的Icon配置
                config = self.getIconConfig(platform);
                if config == None:
                    return;

                # 复制到iOS工程
                if platform == "ios":
                    dstname = os.path.join(os.getcwd(),  "channel_files", self.getHallName(),"ios",
                                           self.getChannelName());
                    if os.path.exists(dstname):
                        self.createImage(outPath, config);      #生成图片
                        for name in os.listdir(outPath):
                            directory = self.getDirectoryByName(dstname, name);
                            if directory != None:
                                self.copyFiles(os.path.join(outPath, name), directory, name == "AppIcon.appiconset");

                        self.refreshIcons();
                        self.showMsg("保存完成！！！");
                        self.retry_times = 0;  # 重置
                    else:
                        self.showMsg('''iOS不存在该渠道，Channel = "{0}"'''.format(self.getChannelName()));

                # 复制到Android工程
                elif platform == "android":
                    dstname = os.path.join(os.getcwd(), "channel_files",  self.getHallName(),"android",
                                           self.getChannelName(), "res");
                    if os.path.exists(dstname):
                        self.createImage(outPath, config);  # 生成图片
                        self.copyFiles(os.path.join(outPath, "res"), dstname);
                        self.refreshIcons();
                        self.showMsg("保存完成！！！");
                        self.retry_times = 0;  # 重置
                    else:
                        self.showMsg('''Android不存在该渠道，Channel = "{0}"'''.format(self.getChannelName()));

                # 保存输出
                else:
                    self.createImage(outPath, config);
                    self.refreshIcons();
                    self.showMsg("输出完成！！！");
                    self.retry_times = 0;  # 重置

        except Exception as err:
            #异常重试
            if re.search("WinError 145", str(err)) and self.retry_times < 10:
                self.retry_times += 1;
                if platform == "ios":
                    self.onSaveToIos();
                elif platform == "android":
                    self.onSaveToAndroid();
                else:
                    self.onClickOutput();
            else:
                self.showMsg(err, True);


    '''生成图片'''
    def createImage(self, path, config):
        if isinstance(config, dict):
            for key, val in config.items():
                if key == "Contents":
                    continue;
                if key == "Android" or key == "iOS":
                    self.showMsg("正在生成{0}图标...".format(key));

                newPath = os.path.join(path, key);
                if not os.path.exists(newPath):
                    os.mkdir(newPath);
                    if key == "AppIcon.appiconset":
                        self.createJson(newPath);

                self.createImage(newPath, val);

        elif isinstance(config, list):
            for val in config:
                self.convertImage(os.path.join(path, val['filename']), val['width'], val['height']);
        pass

    '''
    转换图片
    quality参数：保存图像的质量，值的范围从1（最差）到95（最佳）。 默认值为75，使用中应尽量避免高于95的值; 
    100会禁用部分JPEG压缩算法，并导致大文件图像质量几乎没有任何增益。
    '''
    def convertImage(self, outPath, width, height):
        if outPath == None or width == None or height == None:
            return;
        try:
            # 源图像
            imgsrc = Image.open(self.m_iconurl);
            new_img = imgsrc.resize((width, height), Image.ANTIALIAS);  #Image.ANTIALIAS是最好的“缩小过滤器”
            new_img.save(outPath, quality=95);
            self.showMsg(">");
        except Exception as err:
            self.showMsg(err, True);
        pass

    '''iOS生成Contents.json'''
    def createJson(self, path):
        try:
            configFile = os.path.join(os.getcwd(), "iconConfig.json");
            file = open(configFile, mode='r', encoding='utf-8');
            content = file.read();
            file.close();

            filename = os.path.join(path, "Contents.json");
            match = re.findall(r'\"Contents\": ([^&]*)}', content);
            if len(match) > 0:
                jsonfile = open(filename, "w+");
                jsonfile.write(match[0]);
                jsonfile.close();
            pass


        except Exception as err:
            print(err);

    '''清除日志'''
    def onClickClear(self):
        self.textBrowser.setText("");

    def showMsg(self, msg, isErr=False):
        self.m_signal.emit(str(msg), isErr);

    '''信号接收函数'''
    def signalCallback(self, signal="", isErr=False):
        if signal != "":
            if isErr:
            #    signal = '''<p style="color:rgb(255,0,0);">%s</p>''' % signal;
            #    self.textBrowser.setStyleSheet("QWidget{color:rgb(255,0,0)}");
                signal = "【异常】 " + signal;
            pass
            self.textBrowser.append(signal);
        pass

    # 拖拽事件响应
    def dragEnterEvent(self, event):
        try:
            path = event.mimeData().text();
            if path.endswith("jpg") or path.endswith("png") or path.endswith("ico") or path.endswith("bmp"):
                event.accept();
            else:
                event.ignore();
        except Exception as err:
            self.showMsg(err, True);

    def dropEvent(self, event):
        try:
            if event.mimeData().hasUrls:
                event.setDropAction(Qt.CopyAction)
                event.accept()

                urls = event.mimeData().urls();
                path = urls[0].toLocalFile();

                self.imageIcon.setPixmap(QPixmap(path));
                self.imageIcon.setScaledContents(True);
                self.showMsg("拖拽图像：" + path);

                # 保存图片路径
                self.m_iconurl = path;
            else:
                event.ignore();

        except Exception as err:
            self.showMsg(err, True);

    '''获取大厅名称'''
    def getHallName(self):
        hallName = self.mainObj.cbox_hall.currentText();
        channelCfg = gLuaPM.hallConfig (hallName);
        return channelCfg.srcname;

    '''获取渠道名称'''
    def getChannelName(self):
        return self.mainObj.cbox_ch.currentText();

    def getDefaultIcon(self):
        return os.path.join(os.getcwd(), "ui", "icon.png");

    '''获取桌面路径'''
    def getDesktopPath(self):
        return os.path.join(os.path.expanduser('~'),"Desktop");

    '''获取指定名称的文件夹路径'''
    def getDirectoryByName(self, src, dstName):
        if not os.path.exists(src):
            return;
        for name in os.listdir(src):
            srcname = os.path.join(src, name);
            if os.path.isdir(srcname):
                if name == dstName:
                    return srcname;
                else:
                    result = self.getDirectoryByName(srcname, dstName);
                    if result:
                        return result;
            pass

    '''Copy指定目录的文件到目标路径'''
    def copyFiles(self, src, dst, rmUnuse=False):
        names = os.listdir(src)
        for name in names:
            srcname = os.path.join(src, name)
            dstname = os.path.join(dst, name)
            try:
                if os.path.isdir(srcname):
                    self.copyFiles(srcname, dstname)
                else:
                    if os.path.exists(dstname):
                        os.remove(dstname);
                    shutil.copy(srcname, dstname);
                pass
            except (IOError, os.error) as err:
                self.showMsg(err, True);
            pass

        if rmUnuse:
            for name in os.listdir(dst):
                if name not in names:
                    os.remove(os.path.join(dst, name));
            pass

    '''
    删除指定目录的子目录和文件
    '''
    def removeDirectory(self, path):
        for name in os.listdir(path):
            shutil.rmtree(os.path.join(path, name));
            self.showMsg("删除目录: " + os.path.join(path, name));